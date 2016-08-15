Future = Npm.require('fibers/future')
querystring = Npm.require('querystring')
_ = Meteor.npmRequire('underscore')

class @TypeformObserver
	constructor: (settings, options) ->
		@settings = settings

		check @settings, Match.ObjectIncluding
			apiKey: String
			url: String

		@responsePerPage = 2 # maximum
		@tries = 5

	execute: (formId) ->
		check formId, String

		now = new Date()
		timestamp = Timestamps.findOne {type: "typeform", key: formId}, {time: 1}

		params =
			completed: true
			limit: @responsePerPage
			key: @settings.apiKey
		params.since = Math.floor(timestamp.time.getTime() / 1000) if timestamp

		@_recoverable(@request) formId, params

		Timestamps.upsert {type: "typeform", key: formId}, {$set: {time: now}}

	_recoverable: (method) ->
		_.wrap method, (func) =>
			args = Array.prototype.slice.call arguments, 1

			attempts = @tries
			while attempts
				future = new Future

				try
					func.apply @, args
					attempts = 0
				catch error
					attempts--
					throw  error if attempts is 0
					console.error "TypeformObserver. Can't execute the method. See details.", error
				finally
					future.return()

				future.wait()

	request: (formId, params) ->
		url = @settings.url + formId
		console.log "Typeform: Call for '#{url}' with params", params
		result = HTTP.get url, {params}

		questions = result.data.questions
		grouped = _.groupBy questions, "field_id"
		grouped = _.mapObject grouped, (items) -> _.pluck items, "id"

		console.log "Typeform: result amount (#{result.data.responses.length})"
		for response in result.data.responses
			do (response) =>
				{token, hidden, answers} = response
				console.log answers

				values = _.mapObject grouped, (fields) -> _.filter _.map(fields, (field) -> answers[field]), (value) -> value not in [undefined, '']

				{fname, lname, email, rent, movein} = hidden

				neighborhoods = values[19135278]
				bedroomTypes = values[19131647]
				hasRoommate = _.first values[19178312]
				roommateEmail = _.first values[19179672]

				# check the date selected earlier, then the second attempt to enter valid date, then the first one
				if movein and movein isnt "0"
					moveInDate = movein
					moveInDateFormat = "MM/DD/YYYY"
				else
					moveInDate = _.first(values[19180712]) or _.first(values[19131590])
					moveInDateFormat = "YYYY-MM-DD"

				moveinDate = moment(moveInDate, moveInDateFormat).toDate() if moveInDate

				reasons = values[19178216].concat values[19194374]
				flexible = _.first values[19194374].concat values[20601321].concat values[20601416]
				requirements = values[19137500]
				rent = _.first values[19143322] or rent
				progress = _.first values[19137569]
				details = _.first values[19189368]
				email = _.first values[19192176] or email
				name = _.first values[25511878] or fname or lname

				console.log "Typeform: result"
				@handleReply {neighborhoods, bedroomTypes, hasRoommate, roommateEmail, moveinDate, reasons, flexible, requirements, rent, progress, details, email, name, token}

	handleReply: (data) ->
		{neighborhoods, bedroomTypes, hasRoommate, roommateEmail, moveinDate, reasons, flexible, requirements, rent, progress, details, email, name, token} = data

		# URL query string
		filters = {}

		query = {}
		query.$and = []

		query.$and.push {neighborhood: {$in: neighborhoods}} if neighborhoods.length

		btypes = {}
		btypes.$or = []
		for bedroomType in bedroomTypes
			switch (bedroomType)
				when 'Studio'
					btypes.$or.push {agroPriceStudioFrom: {$exists: 1}}
					filters['btype'] = 'studio'
				when 'Studio / 1 Bedroom'
					btypes.$or.push {agroPriceStudioFrom: {$exists: 1}}
					btypes.$or.push {agroPriceBedroom1From: {$exists: 1}}
					filters['btype'] = 'studio' # or "bedroom1"
				when '1 Bedroom'
					btypes.$or.push {agroPriceBedroom1From: {$exists: 1}}
					filters['btype'] = 'bedroom1'
				when '2 Bedroom'
					btypes.$or.push {agroPriceBedroom2From: {$exists: 1}}
					filters['btype'] = 'bedroom2'
				when '3 Bedroom'
					btypes.$or.push {agroPriceBedroom3From: {$exists: 1}}
					filters['btype'] = 'bedroom3'
				else # do nothing
		query.$and.push btypes if btypes.$or.length

		available = {}
		available.$and = []
		availableFrom = moment(moveinDate).startOf('day')
		availableTo = moment(moveinDate).endOf('day')
		switch flexible
			when 'Very flexible (+/- 1 month)' then availableFrom.subtract(1, 'month'); availableTo.add(1, 'month')
			when 'Moderately flexible (+/- 2 weeks)' then availableFrom.subtract(2, 'week'); availableTo.add(2, 'week')
			when 'Barely flexible (+/- a few days)' then availableFrom.subtract(4, 'day'); availableTo.add(4, 'day')
			when 'Not flexible at all' then # do nothing
		available.$and.push {availableAt: {$gte: availableFrom.toDate()}}
		available.$and.push {availableAt: {$lte: availableTo.toDate()}}
		query.$and.push available
		filters['available'] = availableTo.format "MM/DD/YYYY"

		features = {}
		features.$and = []
		for requirement in requirements
			switch requirement
				when 'Pet-Friendly'
					features.$and.push {pets: {$in: [1, 2]}}
					filters['pets'] = true
				when 'Parking Available'
					features.$and.push {parking: {$in: [1, 2]}}
					filters['parking'] = true
				when 'Utilities Included'
					features.$and.push {utilities: {$in: [1]}}
					filters['utilities'] = true
				when 'Laundry In-Unit'
					features.$and.push {laundry: 1}
					filters['laundry'] = true
				else # handle the rest options
		query.$and.push features if features.$and.length

		if rent
			rent = parseInt rent
			prices = {}
			prices.$or = []
			for bedroomType in bedroomTypes
				switch (bedroomType)
					when 'Studio' then prices.$or.push {agroPriceStudioFrom: {$lt: rent}}
					when 'Studio / 1 Bedroom' then prices.$or.push {agroPriceStudioFrom: {$lt: rent}}; prices.$or.push {agroPriceBedroom1From: {$lt: rent}}
					when '1 Bedroom' then prices.$or.push {agroPriceBedroom1From: {$lt: rent}}
					when '2 Bedroom' then prices.$or.push {agroPriceBedroom2From: {$lt: rent}}
					when '3 Bedroom' then prices.$or.push {agroPriceBedroom3From: {$lt: rent}}
					else # do nothing
			prices.$or = {agroPriceTotalFrom: {$lt: rent}} if not prices.$or.length
			query.$and.push prices
			filters['to'] = rent

		console.log "Typeform: query for token (#{token})", JSON.stringify query

		buildingIds = _.pluck Buildings.find(query, {limit: 20, fields: {_id: 1}}).fetch(), "_id"

		if not ClientRecommendations.find({token}).count()
			clientId = ClientRecommendations.insert({token, name, email, buildingIds, data, query: querystring.stringify filters})
			console.log "Typeform: new Client Id (#{clientId})"
