RETS = Meteor.npmRequire('rets-client')
promiseRetry = Meteor.npmRequire('promise-retry')

class @MLSImporter
	constructor: (settings, options) ->
		@settings = settings or Meteor.settings.trendrets
		@options = _.defaults {}, options,
			retry:
				retries: 100
				factor: 1
				randomize: true
				minTimeout: 2000

		check @settings, Match.ObjectIncluding
			loginUrl: String
			username: String
			password: String

		_.defaults @settings,
			version:'RETS/1.7.2'
			userAgent: "MRIS Conduit/2.0"

	sync: (originalQuery) ->
		console.log "MLSImporter:sync:start"
		timestamp = @getLastUpdatedTimestamp()
		@updateLastUpdatedTimestamp()
		query = originalQuery
		if timestamp
			# TODO CLEAR substract(1, "days")!!!
			formattedTimestamp = moment(timestamp).utc().subtract(0, "days").format('YYYY-MM-DDTHH:mm:ss')
			query += ",(SourceModificationTimestamp=#{formattedTimestamp}+)"

		promiseRetry Meteor.bindEnvironment(@_sync.bind(@, query, originalQuery)), @options.retry

	_sync: (query, originalQuery, retry, number) ->
		RETS.getAutoLogoutClient @settings, Meteor.bindEnvironment (client) =>
			@syncProperties(query, client)
			@unpublishInactiveProperties(originalQuery, client)
		.catch (error) ->
			#console.log "An error occurred during MLS request (getAutoLogoutClient). Retry #{number}", error
			retry()

	getLastUpdatedTimestamp: ->
		Timestamps.findOne({key: "LastUpdated"})?.time

	updateLastUpdatedTimestamp: ->
		Timestamps.upsert({key: "LastUpdated"}, {$set: {time: moment().utc().toDate()}})

	syncProperties: (query, client) ->
		promiseRetry Meteor.bindEnvironment(@_syncProperties.bind(@, query, client)), @options.retry

	_syncProperties: (query, client, retry, number) ->
		client.search.query("Property", "RNT", query,
#			limit: 4
#			offset: 1
			restrictedIndicator: 'HIDDEN'
		)
		.then Meteor.bindEnvironment (searchData) =>
			console.log "MLSImporter:sync:count", searchData.count
			throw new Meteor.Error("MLS:sync:error", "An error occurred during MLS sync", {text: searchData.replyText}) if searchData.replyCode isnt "0"
			counter = 1
			promises = (for item in searchData.results
				console.log "MLSImporter:sync:progress", counter++
				property = MLSTransformer.transformProperty item
				console.log "MLSImporter:sync:property", property.source
				buildingId = Buildings.findOne({mlsNo: property.mlsNo}, {_id: 1})?._id
				if buildingId
					console.log "MLSImporter:sync:update", buildingId
					Buildings.update buildingId, {$set: property}
				else
					buildingId = Buildings.insert property
					console.log "MLSImporter:sync:insert", buildingId
				@syncPhotos client, buildingId, property.source.listingKey)
			P.all promises
		.catch (error) ->
			if error.httpStatus is 400 or error.code is "ETIMEDOUT"
				console.log "An error occurred during MLS request (client.search.query). Retry #{number}", error
				retry()

			console.log "MLS server returns an error. No recover needed", error

	syncPhotos: (client, buildingId, listingKey) ->
		console.log "MLSImporter:sync:photos:start", listingKey
		promiseRetry Meteor.bindEnvironment(@_syncPhotos.bind(@, client, buildingId, listingKey)), @options.retry

	_syncPhotos: (client, buildingId, listingKey, retry, number) ->
		client.objects.getPhotos("Property", "Photo", listingKey)
		.then Meteor.bindEnvironment (photos) =>
			console.log "MLSImporter:sync:photos:count", buildingId, photos.length
			counter = 1
			@_dropPhotos buildingId
			P.map photos, Meteor.bindEnvironment (photo) =>
				if photo.error
					return if photo.error.replyTag is "NO_OBJECT_FOUND"
					console.log "An error occurred during MLS sync", photo
					throw new Meteor.Error("MLS:sync:photo:error", "An error occurred during MLS sync", {data: photo})
				@_savePhoto buildingId, photo
				#console.log "MLSImporter:sync:photos:processed", counter++
		.catch (error) ->
			#console.log "An error occurred during MLS request. Retry #{number}", error
			retry()

	_dropPhotos: (buildingId) ->
		images = Buildings.findOne(buildingId, {images: 1})?.images
		ids = _.pluck images, "_id"
		Promise.await Buildings.update(buildingId, {$unset: {images: 1}})
		Promise.await BuildingImages.remove {_id: {$in: ids}}
		console.log "MLSImporter:sync:photos:drop", buildingId, (ids?.length or 0)

	_savePhoto: (buildingId, photo) ->
		buildingImage = new FS.File()
		Promise.await buildingImage.attachData photo.buffer, type: photo.mime
		extension = photo.mime.split('/')[1]
		fileName = "#{buildingId}_#{photo.objectId}.#{extension}"
		buildingImage.name(fileName)
		buildingImageId = BuildingImages.insert buildingImage
		Buildings.update(_id: buildingId, {$addToSet: {images: buildingImageId}})

	unpublishInactiveProperties: (query, client) ->
		promiseRetry Meteor.bindEnvironment(@_unpublishInactiveProperties.bind(@, query, client)), @options.retry

	_unpublishInactiveProperties: (query, client, retry, number) ->
		client.search.query("Property", "RNT", query, {restrictedIndicator: 'HIDDEN'})
		.then Meteor.bindEnvironment (searchData) =>
			existedNumbers = _.pluck searchData.results, "ListingID"
			affected = Buildings.update({mlsNo: {$nin: existedNumbers}, "source.source": "IDX", isPublished: true}, {$set: {isPublished: false}}, {multi: true})
			console.log "MLSImporter:sync:property:inactive", affected
		.catch (error) ->
			if error.httpStatus is 400 or error.code is "ETIMEDOUT"
				console.log "An error occurred during MLS request (client.search.query). Retry #{number}", error
				retry()

			console.log "MLS server returns an error. No recover needed", error
