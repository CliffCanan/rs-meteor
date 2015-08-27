class BuildingReview
  constructor: (doc) ->
    _.extend(@, doc)
  displayName: ->
    if @name
      components = @name.split(/\s/)
      parsedComponents = components.map (item, index) -> 
        if index is 0
          return item
        return "#{item.charAt(0)}."
      parsedName = parsedComponents.join(' ')
      if @renterPersona isnt 'Other'
        "#{parsedName}, #{@renterPersona}"
      else
        parsedName
    else
      if @renterPersona isnt 'Other'
        @renterPersona

share.Transformations.BuildingReview = _.partial(share.transform, BuildingReview)

@BuildingReviews = new Mongo.Collection "buildingReviews",
  transform: if Meteor.isClient then share.Transformations.BuildingReview else null