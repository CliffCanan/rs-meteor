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

  modifiedAtFormatted: ->
    if @modifiedAt
      daysAgo = moment().diff(moment(@modifiedAt), 'days')
      return "Last synced with MLS on: " + (@modifiedAt.getMonth() + 1) + "/" + @modifiedAt.getDate() + "/" + @modifiedAt.getFullYear() + "(" + daysAgo + " days ago)"
    else
      return "Date added manually (not from MLS)"

  availableAtStyle: ->
    diff = moment().diff(moment(@modifiedAt), 'days')
    style = ""
    if diff < 3 then style = "color: green"
    else if diff < 7 then style = "color: rgb(100,180,0)"
    else if diff < 14 then style = "color: orange"
    else if diff < 21 then style = "color: red"
    else style = "color: rgb(130,0,0)"
    style

  availableAtFormatted: ->
    if @availableAt then (@availableAt.getMonth() + 1) + "/" + @availableAt.getDate() + "/" +@availableAt.getFullYear() else '-'

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

#  displayPriceRange: ->
#    for child in @children
#      queryBtype = (Number.isInteger child.btype) ? "bedroom" + child.btype : child.btype
#      fieldName = "agroPrice" + (if queryBtype then queryBtype.charAt(0).toUpperCase() + queryBtype.slice(1) else "Total")
#      fieldNameFrom = fieldName + "From"
#      fieldNameTo = fieldName + "To"
