getLaundryDescription = (laundry) ->
  switch laundry
    when 0 then "Unknown"
    when 1 then "In-Unit"
    when 2 then "Shared"
    when 3 then "None"

getSecurityDescription = (security) ->
  switch security
    when 0 then "Unknown"
    when 1 then "Doorman"
    when 2 then "No Doorman"

getTextColorByAge = (age) ->
  if age < 3 then "green"
  else if age < 7 then "rgb(100,180,0)"
  else if age < 14 then "orange"
  else if age < 21 then "red"
  else "rgb(130,0,0)"

Template.quickViewBuilding.onRendered ->
  building = @data

  # configure "admin notes" widget
  @$('.js-comments').editable
    value: @data.adminNotes
    type: 'textarea'
    display: (value) ->
      color = if value.length then 'lightgreen' else 'lightgray'
      $(@).html("<i class='fa fa-sticky-note' title='#{value}' style='color: #{color}'</i>")
    showbuttons: 'bottom'
    url: (params) ->
      value = params.value
      deferred = new $.Deferred()
      id = building._id
      Meteor.call 'setComments', id, value, (error) ->
        if error
          console.error error
          deferred.reject("Unable to save comments")
        else
          deferred.resolve()
      deferred.promise()

  # configure "available at" widget
  localDate = moment(moment.utc(@data.availableAt).format("YYYY-MM-DD")).toDate() # clear timezone
  @$('.js-available-at').editable
    value: localDate
    type: 'date'
    display: (value) ->
      if value
        title = "Date added manually (not from MLS)"
        color = 'black'
        if building.modifiedAt
          age = moment().diff(moment(building.modifiedAt), 'days')
          title =  "Last synced with MLS on: #{moment(building.modifiedAt).format("MM/DD/YYYY")} (#{age} days ago)"
          color = getTextColorByAge age

        string = moment(value).format("MM/DD/YYYY")
        $(@).html("<span title='#{title}' style='color:#{color}'>#{string}</span>")
      else
        $(@).html "Not set"
    showbuttons: 'bottom'
    url: (params) ->
      value = params.value
      deferred = new $.Deferred()
      id = building._id
      Meteor.call 'setAvailableAt', id, value, (error) ->
        if error
          console.error error
          deferred.reject("Unable to save availableAt")
        else
          deferred.resolve()
      deferred.promise()


Template.quickViewBuilding.events
  "click .js-images": (event, template) ->
    event.preventDefault()

    # fetch the rest images related to the building
    buildingId = $(event.currentTarget).attr "data-building-id"
    subscribeToBuildingImages template, buildingId

Template.quickViewBuilding.helpers
  bedrooms: ->
    value = @bedroomsFrom
    unless @bedroomsFrom is @bedroomsTo
      value += " - " + @bedroomsTo
    value

  bathrooms: ->
    value = @bathroomsFrom
    unless @bathroomsFrom is @bathroomsTo
      value += " - " + @bathroomsTo
    value

  securityValue: ->
    getSecurityDescription @security

  laundryValue: ->
    getLaundryDescription @laundry

  unitCount: ->
    if @children then @children.length else '-'

  shouldShowRecommendToggle: ->
    Security.canManageClients()

  isRecommended: ->
    if clientRecommendationObject = Session.get('recommendationsClientObject')
      clientRecommendation = ClientRecommendations.findOne(clientRecommendationObject._id)
      if clientRecommendation
        return true if clientRecommendation.buildingIds.indexOf(@_id) > -1
    false

  availableBedroomTypes: ->
    types = (child.bedroomTypesArray() for child in @children)
    types = _.uniq _.flatten types

    # convert to short format
    bedroomTypes = for number in [0..6]
      key = "#{number} Bedroom"
      if _.indexOf(types, key) isnt -1
        types = _.without types, key
        number
    bedroomTypes = _.without bedroomTypes, undefined
    types.push(bedroomTypes.join(", ") + " BR")

    types.join ", "

  availableSecurityValues: ->
    types = (child.security for child in @children)
    types = _.without (_.uniq _.flatten types), undefined
    getSecurityDescription value for value in types

  availableLaundryValues: ->
    types = (child.laundry for child in @children)
    types = _.without (_.uniq _.flatten types), undefined
    getLaundryDescription value for value in types

  overallPriceRange: (type) ->
    ranges = (child.getPriceRange(type) for child in @children)
    min = _.min _.pluck ranges, "from"
    max = _.max _.pluck ranges, "to"
    if min
      "$" + accounting.formatNumber(min) + (if min is max then  "" else "+")

  hasVideo: ->
    if @vimeoId then return true else return false

  hasImages: ->
    if @images and @images.length > 0 then return true else return false

  imgCount: ->
    if @images
      return @images.length
    return 0

  indexedImages: ->
    index = 0
    _.map @images, (image) -> image.index = index++; image
    
  isFirstImage: ->
    @index is 0
    
  thumbnailUrl: ->
    @url {store: "thumbs", auth: false} if @url
