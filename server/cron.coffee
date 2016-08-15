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

	SyncedCron.add
		name: 'Fetch replies from Typeform',
		schedule: (parser) ->
			parser.text(Meteor.settings['typeform']['refresh'])
		job: Meteor.bindEnvironment ->
			observer = new TypeformObserver Meteor.settings['typeform']
			observer.execute Meteor.settings['typeform']['formId']

	SyncedCron.start()
