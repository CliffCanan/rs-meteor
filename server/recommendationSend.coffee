accounting = Meteor.npmRequire('accounting')
chunk = Meteor.npmRequire('lodash/chunk')

@sendRecommendationsFor = (clientId) ->
	user = Meteor.user()
	throw new Error('Only authorized user may send a recommendation email.') if not user
	
	from = "Rent Scene <team@rentscene.com>" # user.emails?[0]?.address
	throw new Error("Admin User #{user._id} needs an email address before sending this email.") if not from

	client = ClientRecommendations.findOne clientId
	throw new Error("Unable to find client with ID #{clientId}") if not client

	buildingIds = client.buildingIds
	throw new Error("Client #{clientId} has no recommendations to send!") if not (buildingIds and buildingIds.length)

	to = client.email
	throw new Error("Client #{clientId} has no email address yet.") if not to

	limit = Meteor.settings.public.emailRecommendations.limit
	buildings = Buildings.find({_id: {$in: client.buildingIds}}, {limit}).fetch()
	_.each buildings, (building) ->
		imageIds = _.map (building.images or []), (image) -> image._id

		building.image = BuildingImages.findOne({_id: {$in: imageIds}})
		building.imageUrl = Meteor.absoluteUrl() + building.image.url({store: "thumbs"}).substr(1) #can we switch to "thumbsSmall"?

		# CC (6/3/16) - I realize this won't work to resize an image at this point since this won't save a new Store...
		#               There is already supposed to be a "thumbsSmall" store for all listings (see images.coffee), but that hasn't
		#               worked when I attempted to use it on the City page, so not sure if it would work here,
		#               but that Store uses dimensions of 400x300 which would be better than the thumbs Store which are bigger.
		#gm(readStream, fileObj.name()).gravity('Center').resize("250", "250")

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
		building.priceString += " - $" + building.to if building.from isnt building.to
		building.bedrooms = model.getBedrooms()

	# split by pairs for rendering
	pairs = chunk buildings, 2
	pairs = _.map pairs, (pair) -> {left: pair[0], right: pair[1]}

	recommendationsUrl = Router.url 'clientRecommendations', {clientId}, {}

	name = client.name
	[first, last] = name.split " "

	html = Spacebars.toHTML({first, name, pairs, recommendationsUrl}, Assets.getText('requests/aptRecommendationEmail.html'))
	subject = "Apartment matches for " + name
	Email.send {from, to, subject, html}
