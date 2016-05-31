accounting = Meteor.npmRequire('accounting')
chunk = Meteor.npmRequire('lodash/chunk')

@sendRecommendationsFor = (clientId) ->
	user = Meteor.user()
	throw new Error('Only authorized user may call this function') if not user
	
	from = user.emails?[0]?.address
	throw new Error("User #{user._id} should have email set") if not from

	client = ClientRecommendations.findOne clientId
	throw new Error("Unable to find client with ID #{clientId}") if not client

	buildingIds = client.buildingIds
	throw new Error("Client #{clientId} has no recommendations") if not (buildingIds and buildingIds.length)

	to = client.email
	throw new Error("Client #{clientId} has no email") if not to

	limit = Meteor.settings.public.emailRecommendations.limit
	buildings = Buildings.find({_id: {$in: client.buildingIds}}, {limit}).fetch()
	_.each buildings, (building) ->
		imageIds = _.map (building.images or []), (image) -> image._id
		building.image = BuildingImages.findOne({_id: {$in: imageIds}})
		building.imageUrl = Meteor.absoluteUrl() + building.image.url({store: "thumbs"}).substr(1)
		data =
			cityId: building.cityId
			neighborhoodSlug: building.neighborhoodSlug
			buildingSlug: building.slug
		building.url = Router.url 'building', data, {}

		model = share.Transformations.Building(building)
		range = model.getPriceRange()
		building.from = accounting.formatNumber(range.from)
		building.to = accounting.formatNumber(range.to)
		building.priceString = "$" + building.from
		building.priceString += "- $" + building.to if building.from isnt building.to
		building.bedrooms = model.getBedrooms()

	# split by pairs for rendering
	pairs = chunk buildings, 2
	pairs = _.map pairs, (pair) -> {left: pair[0], right: pair[1]}

	name = client.name
	[first, last] = name.split " "

	html = Spacebars.toHTML({first, name, pairs}, Assets.getText('requests/aptRecommendationEmail.html'))
	subject = Meteor.settings.public.emailRecommendations.title
	Email.send {from, to, subject, html}
