accounting = Meteor.npmRequire('accounting')

@sendRecommendationsFor = (clientId) ->
	client = ClientRecommendations.findOne clientId

	if client
		if client.buildingIds?.length
			MAX_RECOMMENDATIONS = 6
			buildings = Buildings.find({_id: {$in: client.buildingIds}}, {limit: MAX_RECOMMENDATIONS}).fetch()
			_.each buildings, (building) ->
				imageIds = _.map (building.images or []), (image) -> image._id
				building.image = BuildingImages.findOne({_id: {$in: imageIds}})
				building.imageUrl = Meteor.absoluteUrl() + building.image.url().substr(1)
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

			name = client.name
			[first, last] = name.split " "

			html = Spacebars.toHTML({first, name, buildings}, Assets.getText('requests/aptRecommendationEmail.html'))
			Email.send
				from: "bender-report@rentscene.com"
				to: "ku3menk0@gmail.com"
				subject: 'Rentscene has recommendations for you!'
				html: html
		else
			throw new Error("Client #{id} has no recommendations")
	else
		throw new Error("Unable to find client with ID #{id}")
