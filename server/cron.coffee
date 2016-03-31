Meteor.startup ->
	SyncedCron.config
		log: true
		utc: true

	SyncedCron.add
		name: 'Sync data with MLS',
		schedule: (parser) ->
			parser.text(Meteor.settings.trendrets.syncTime)
		job: Meteor.bindEnvironment ->
			importer = new MLSImporter()
			importer.sync Meteor.settings.trendrets.query

	SyncedCron.start()
