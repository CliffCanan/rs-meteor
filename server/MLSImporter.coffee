RETS = Meteor.npmRequire('rets-client')
promiseRetry = Meteor.npmRequire('promise-retry')
difflet = Meteor.npmRequire('difflet')
ent = Meteor.npmRequire('ent')
Future = Npm.require('fibers/future')

tags =
	inserted : '<span style="color: green">'
	updated : '<span style="color: blue">'
	deleted : '<span style="color: red">'

diff = difflet
	start: (t, s) -> s.write(tags[t])
	stop: (t, s) -> s.write('</span>')
	write: (buf, s) -> s.write(ent.encode(buf))

class @MLSImporter
	constructor: (settings, options) ->
		@settings = settings or Meteor.settings.trendrets
		@options = _.defaults {}, options,
			retry:
				retries: 200
				factor: 1
				randomize: true
				minTimeout: 500

		check @settings, Match.ObjectIncluding
			loginUrl: String
			username: String
			password: String

		_.defaults @settings,
			version:'RETS/1.7.2'
			userAgent: "MRIS Conduit/2.0"

	sync: (originalQuery) ->
		console.log "MLSImporter:sync:start"
		@stats =
			inserted: []
			updated: []
			removed: []

		timestamp = @getLastUpdatedTimestamp()
		query = originalQuery
		if timestamp
			formattedTimestamp = moment(timestamp).utc().format('YYYY-MM-DDTHH:mm:ss')
			query += ",(SourceModificationTimestamp=#{formattedTimestamp}+)"

		@_sync query, originalQuery
		@updateLastUpdatedTimestamp()

	_sync: (query, originalQuery) ->
		console.log "MLSImporter:sync"
		processed = false
		while not processed
			future = new Future

			try
				RETS.getAutoLogoutClient @settings, Meteor.bindEnvironment (client) =>
					@syncProperties(originalQuery, query, client)
					processed = true
					future.return()
			catch e
				#console.log "MLSImporter:sync:error", e
				future.return()

			future.wait()

	getLastUpdatedTimestamp: ->
		Timestamps.findOne({key: "LastUpdated"})?.time

	updateLastUpdatedTimestamp: ->
		Timestamps.upsert({key: "LastUpdated"}, {$set: {time: moment().utc().toDate()}})

	syncProperties: (originalQuery, query, client) ->
		console.log "MLSImporter:sync:properties"
		processed = false
		while not processed
			try
				@_syncProperties originalQuery, query, client
				processed = true
			catch e
				#console.log "MLSImporter:sync:properties:error", e

	_syncProperties: (originalQuery, query, client) ->
		future = new Future

		client.search.query("Property", "RNT", query,
			limit: 1
#			offset: 2
			restrictedIndicator: 'HIDDEN'
		)
		.then Meteor.bindEnvironment (searchData) =>
			console.log "MLSImporter:sync:count", searchData.count
			throw new Meteor.Error("MLS:sync:error", "An error occurred during MLS sync", {text: searchData.replyText}) if searchData.replyCode isnt "0"
			counter = 1
			for item in searchData.results
				property = MLSTransformer.transformProperty item
				console.log "MLSImporter:sync:property", counter++, property.source
				building = Buildings.findOne({mlsNo: property.mlsNo})
				buildingId = building?._id 
				if buildingId
					console.log "MLSImporter:sync:update", buildingId
					clear = _.omit building, "_id", "createdAt", "updatedAt", "slug", "latitude", "longitude", "images"
					diff(clear, property).on("data", (chunk) =>
						@stats.updated.push chunk
					)
					Buildings.update buildingId, {$set: property}
				else
					buildingId = Buildings.insert property
					console.log "MLSImporter:sync:insert", buildingId
					@stats.inserted.push Buildings.findOne buildingId
				@syncPhotos client, buildingId, property.source.listingKey

			@unpublishInactiveProperties originalQuery, client
			future.return()
		.catch (e) ->
			if e.httpStatus is 400 or e.code is "ETIMEDOUT" or e.replyCode is '20036'
				future.throw e
			else
				console.log "MLS server returns an error. No recover needed", e
				future.return()

		future.wait()

	syncPhotos: (client, buildingId, listingKey) ->
		console.log "MLSImporter:sync:photos:start", listingKey
		processed = false
		while not processed
			try
				Promise.await @_syncPhotos client, buildingId, listingKey
				processed = true
			catch e
				#console.log "MLSImporter:sync:photos:error", e

	_syncPhotos: (client, buildingId, listingKey) ->
		future = new Future

		client.objects.getPhotos("Property", "Photo", listingKey)
		.then Meteor.bindEnvironment (photos) =>
			console.log "MLSImporter:sync:photos:count", buildingId, photos.length
			@dropPhotos buildingId
			for photo in photos
				if photo.error
					if photo.error.replyTag isnt "NO_OBJECT_FOUND"
						console.log "An error occurred during MLS sync", photo
						future.throw photo
				else
					@savePhoto buildingId, photo
			future.return()
		.catch (e) ->
			future.throw e

		future.wait()

	dropPhotos: (buildingId) ->
		images = Buildings.findOne(buildingId, {images: 1})?.images
		ids = _.pluck images, "_id"
		Buildings.update(buildingId, {$unset: {images: 1}})
		BuildingImages.remove {_id: {$in: ids}}
		console.log "MLSImporter:sync:photos:drop", buildingId, (ids?.length or 0)

	savePhoto: (buildingId, photo) ->
		buildingImage = new FS.File()
		Promise.await buildingImage.attachData photo.buffer, type: photo.mime
		extension = photo.mime.split('/')[1]
		fileName = "#{buildingId}_#{photo.objectId}.#{extension}"
		buildingImage.name(fileName)
		buildingImageId = BuildingImages.insert buildingImage
		Buildings.update(_id: buildingId, {$addToSet: {images: buildingImageId}})

	unpublishInactiveProperties: (query, client) ->
		console.log "MLSImporter:sync:unpublish:start"
		processed = false
		while not processed
			try
				@_unpublishInactiveProperties query, client
				processed = true
			catch e
				#console.log "MLSImporter:sync:unpublish:error", e

	_unpublishInactiveProperties: (query, client) ->
		future = new Future

		client.search.query("Property", "RNT", query, {restrictedIndicator: 'HIDDEN'})
		.then Meteor.bindEnvironment (searchData) =>
			existedNumbers = _.pluck searchData.results, "ListingID"
			buildinds = Buildings.find({mlsNo: {$nin: existedNumbers}, "source.source": "IDX", isPublished: true}, {_id: 1, neighborhood: 1, address: 1}).fetch()
			Buildings.update({mlsNo: {$nin: existedNumbers}, "source.source": "IDX", isPublished: true}, {$set: {isPublished: false}}, {multi: true})
			for building in buildinds
				@stats.removed.push building
			console.log "MLSImporter:sync:property:inactive", buildinds.length

			@generateReport()
			future.return()
		.catch (e) ->
			if e.httpStatus is 400 or e.code is "ETIMEDOUT"
				future.throw e
			else
				console.log "MLS server returns an error. No recover needed", e
				future.return()

		future.wait()

	generateReport: ->
		html = ""

		if @stats.inserted.length
			html += "<p>Inserted</p>"
			html += "<il>"
			html += "<li>#{property.neighborhood} / #{property.address}</li>" for property in @stats.inserted
			html += "</il>"
		if @stats.updated.length
			html += "<p>Updated</p>"
			html += property for property in @stats.updated
		if @stats.removed.length
			html += "<p>Removed</p>"
			html += "<il>"
			html += "<li>#{property.neighborhood} / #{property.address}</li>" for property in @stats.removed
			html += "</il>"
		Email.send
			from: "bender-report@rentscene.com"
#			to: "team@rentscene.com"
			to: "aleksandr.v.kuzmenko@gmail.com"
#			replyTo: transformedRequest.name + ' <' + transformedRequest.email + '>'
			subject: 'Import from MLS'
			html: html
