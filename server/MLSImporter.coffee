RETS = Meteor.npmRequire('rets-client')
promiseRetry = Meteor.npmRequire('promise-retry')

class @MLSImporter
	constructor: (settings, options) ->
		@settings = settings or Meteor.settings.trendrets
		@options = _.defaults {}, options,
			retries: 30
			factor: 1
			randomize: true

		check @settings, Match.ObjectIncluding
			loginUrl: String
			username: String
			password: String

		_.defaults @settings,
			version:'RETS/1.7.2'
			userAgent: "MRIS Conduit/2.0"

	sync: (query) ->
		console.log "MLSImporter:sync:start"
		promiseRetry Meteor.bindEnvironment(@_sync.bind(@, query)),
			retries: @options.retries
			factor: @options.factor
			randomize: @options.randomize

	_sync: (query, retry, number) ->
		RETS.getAutoLogoutClient @settings, Meteor.bindEnvironment (client) =>
			client.search.query("Property", "RNT", query,
				limit: 1
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
					buildingId = Buildings.insert property
					console.log "MLSImporter:sync:buildingId", buildingId
					@getPhotos client, buildingId, property.source.listingKey)
				P.all promises
			.catch (error) ->
				console.log "An error occurred during MLS request (client.search.query). Retry #{number}"
				retry()
		.catch (error) ->
			console.log "An error occurred during MLS request (getAutoLogoutClient). Retry #{number}"
			retry()

	getPhotos: (client, buildingId, listingKey) ->
		console.log "MLSImporter:sync:photos:start", listingKey
		promiseRetry Meteor.bindEnvironment(@_getPhotos.bind(@, client, buildingId, listingKey)),
			retries: @options.retries
			factor: @options.factor
			randomize: @options.randomize

	_getPhotos: (client, buildingId, listingKey, retry, number) ->
		client.objects.getPhotos("Property", "Photo", listingKey)
		.then Meteor.bindEnvironment (photos) =>
			console.log "MLSImporter:sync:photos:count", photos.length
			counter = 1
			P.map photos, Meteor.bindEnvironment (photo) =>
				throw new Error("MLS:sync:photo:error", "An error occurred during MLS sync", {data: photo}) if photo.error
				@_savePhoto buildingId, photo
				console.log "MLSImporter:sync:photos:processed", counter++
		.catch (error) ->
			console.log "An error occurred during MLS request. Retry #{number}"
			retry()

	_savePhoto: (buildingId, photo) ->
		buildingImage = new FS.File()
		Promise.await buildingImage.attachData photo.buffer, type: photo.mime
		extension = photo.mime.split('/')[1]
		fileName = "#{buildingId}_#{photo.objectId}.#{extension}"
		buildingImage.name(fileName)
		buildingImageId = BuildingImages.insert buildingImage
		Buildings.update(_id: buildingId, {$addToSet: {images: buildingImageId}})
