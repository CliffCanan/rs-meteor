setGeocode = (building) ->
  address = encodeURIComponent(building.address + ", " + cities[building.cityId].long + ", USA")
  url = "http://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&sensor=false"
  response = HTTP.get(url)
  data = response.data
  if data.status is "OK"
    location = data.results[0].geometry.location
    Buildings.direct.update({_id: building._id}, {$set: {latitude: location.lat, longitude: location.lng}})
  else
    Buildings.direct.update({_id: building._id}, {$set: {isOnMap: false}})

Buildings.after.insert (userId, building) ->
  if building.isOnMap
    setGeocode(building)

Buildings.after.update (userId, building, fieldNames, modifier, options) ->
  if building.isOnMap
    if @previous.isOnMap isnt building.isOnMap or @previous.address isnt building.address or @previous.cityId isnt building.cityId
      setGeocode(building)
