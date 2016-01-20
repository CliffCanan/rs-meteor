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
    switch @security
      when 0 then "Unknown"
      when 1 then "Doorman"
      when 2 then "No Doorman"
  laundryValue: ->
    switch @laundry
      when 0 then "Unknown"
      when 1 then "In-unit Laundry"
      when 2 then "Shared Laundry"
      when 3 then "No Laundry"
  unitCount: ->
    if @children then @children.length else '-'
  availableAtFormatted: ->
    if @availableAt then @availableAt.getMonth() + "/" + @availableAt.getDate() + "/" +@availableAt.getFullYear() else '-'
