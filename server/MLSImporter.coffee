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

	sync: (query) ->
		console.log "MLSImporter:sync:start"
		promiseRetry Meteor.bindEnvironment(@_sync.bind(@, query)), @options.retry

	_sync: (query, retry, number) ->
		RETS.getAutoLogoutClient @settings, Meteor.bindEnvironment (client) =>
			@syncProperties(query, client)
		.catch (error) ->
			console.log "An error occurred during MLS request (getAutoLogoutClient). Retry #{number}", error
			retry()

	syncProperties: (query, client) ->
		promiseRetry Meteor.bindEnvironment(@_syncProperties.bind(@, query, client)), @options.retry

	_syncProperties: (query, client, retry, number) ->
		client.search.query("Property", "RNT", query,
			limit: 3
			offset: 1
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
			.then Meteor.bindEnvironment(@unpublishInactiveProperties.bind(@, searchData.results))
		.catch (error) ->
			console.log "An error occurred during MLS request (client.search.query). Retry #{number}", error
			retry()

	syncPhotos: (client, buildingId, listingKey) ->
		console.log "MLSImporter:sync:photos:start", listingKey
		promiseRetry Meteor.bindEnvironment(@_syncPhotos.bind(@, client, buildingId, listingKey)), @options.retry

	_syncPhotos: (client, buildingId, listingKey, retry, number) ->
		client.objects.getPhotos("Property", "Photo", listingKey)
		.then Meteor.bindEnvironment (photos) =>
			console.log "MLSImporter:sync:photos:count", photos.length
			counter = 1
			@_dropPhotos buildingId
			P.map photos, Meteor.bindEnvironment (photo) =>
				throw new Error("MLS:sync:photo:error", "An error occurred during MLS sync", {data: photo}) if photo.error
				@_savePhoto buildingId, photo
				console.log "MLSImporter:sync:photos:processed", counter++
		.catch (error) ->
			console.log "An error occurred during MLS request. Retry #{number}", error
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

	unpublishInactiveProperties: (results) ->
		existedNumbers = _.pluck results, "ListingID"
		affected = Buildings.update({mlsNo: {$nin: existedNumbers}}, {$set: {isPublished: false}}, {multi: true})
		console.log "MLSImporter:sync:property:inactive", affected
