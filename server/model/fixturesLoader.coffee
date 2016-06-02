Meteor.startup ->
	for collection, objects of @fixtures
		console.log "Check collection #{collection}"
		if @[collection].find().count() is 0
			console.log "Loading fixtures for collection #{collection}"
			for key, object of objects
				console.log "Add #{key}"
				object._id = key
				buildingId = @[collection].insert object

				# add image for each building
				if collection is "Buildings"
					buildingImage = new FS.File()
					Promise.await buildingImage.attachData buildingImagesFixtures['6175'][0], type: "image/jpeg"
					extension = "jpeg"
					fileName = "#{buildingId}_#{6175}.#{extension}"
					buildingImage.name(fileName)
					buildingImageId = BuildingImages.insert buildingImage
					Buildings.update(_id: buildingId, {$addToSet: {images: buildingImageId}})
