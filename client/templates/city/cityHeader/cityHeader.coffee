Template.cityHeader.helpers
  currentCity: ->
    cities[@cityId].long
  currentBedroomType: ->
    btypes[@query.btype]?.lower ? "Any"
  arrivalTime: ->
    if Session.get "selectedTime"
      selectedTime = Session.get "selectedTime"
      if selectedTime == "10m"
        "Less than 10min"
      else if selectedTime == "20m"
        "Less than 20min"
      else if selectedTime == "30m"
        "Less than 30min"
    else
      "Less than 10min"
  getDestination: ->
    destination = if Session.get('cityName') then Session.get('cityName') else ''
    

Template.cityHeader.rendered = ->

Template.cityHeader.events
  "click .dropdown button": (event, template) ->
    $(event.currentTarget).parent().toggleClass("open")

  "click .city-select li": (event, template) ->
    data = template.data
    $li = $(event.currentTarget)
    $li.closest(".dropdown").removeClass("open")
    Router.go("city", {cityId: $li.attr("data-value"), query: data.query})

  "click .bedroom-type-select li": (event, template) ->
    data = template.data
    $li = $(event.currentTarget)
    $li.closest(".dropdown").removeClass("open")
    query = data.query
    if btype = $li.attr("data-value")
      query.btype = btype
    else
      delete query.btype
    Router.go("city", {cityId: data.cityId}, {query: query})

  "click .travelMode": (event, template) ->
    $item = $(event.currentTarget)
    setDefaultImages()
    if $item.attr("id") == "walker"
      $item.find('img').attr("src", "/images/walk-active.png")
      Session.set("travelMode", "walking")
    if $item.attr("id") == "car"
      $item.find('img').attr("src", "/images/car-active.png")
      Session.set("travelMode", "driving")
    if $item.attr("id") == "bike"
      $item.find('img').attr("src", "/images/bike-active.png")
      Session.set("travelMode", "bicycling")

  "click .selectTime": (event, template) ->
    $item = $(event.currentTarget)
    $item.closest(".dropdown").removeClass("open")
    Session.set("selectedTime", $item.attr("id"))

  "keyup .building-title-search": _.debounce((event, template) ->
    event.preventDefault()
    data = template.data
    q = encodeURIComponent($(event.currentTarget).val())
    query = data.query
    if q
      query.q = q
    else
      delete query.q
    Router.go("city", {cityId: data.cityId}, {query: query})
  , 300)

  "click #filterAddress": (event, template) ->
    event.preventDefault()
    data = template.data
    query = data.query
    #console.log typeof data
    query.address = $("#address").val() 
    Router.go("city", {cityId: data.cityId}, {query: query}, 300)

  "submit .form-building-filter": (event, template) ->
    event.preventDefault()

    event.preventDefault()
    data = template.data
    query = data.query
    #console.log typeof data
    if $("#address").val() != ""
      query.address = $("#address").val()
      Session.set('enteredAddress', query.address)
    else
      delete query["address"]
      
    $form = $(event.currentTarget)
    $form.closest(".dropdown").removeClass("open")    
    Router.go("city", {cityId: data.cityId}, {query: query}, 300)

  "submit .form-building-features-filter": (event, template) ->
    event.preventDefault()

    fieldNames = ["security", "fitnessCenter", "pets", "laundry", "parking", "utilities"]
    data = template.data
    query = data.query
    $form = $(event.currentTarget)
    $form.closest(".dropdown").removeClass("open")
    values = $form.serializeJSON({parseAll: true})
    for fieldName in fieldNames
      if value = values[fieldName]
        query[fieldName] = value
      else
        delete query[fieldName]
    if values.available
      query.available = encodeURIComponent(values.available)
    else
      delete query.available

    Router.go("city", {cityId: data.cityId}, {query: query})

  "click .form-building-address-filter-reset": (event, template) ->
    Session.set("travelMode", "walking")
    Session.set("selectedTime", "")
    setDefaultImages()
    $("#walker").find("img").attr("src", "/images/walk-active.png")
    $form = $(event.currentTarget).closest("form")
    $form.get(0).reset()
    console.log $form
    $form.trigger("submit")

  "click .form-building-features-filter-reset": (event, template) ->
    $form = $(event.currentTarget).closest("form")
    $form.get(0).reset()
    $form.trigger("submit")


setDefaultImages = ->
  $("#walker").find("img").attr("src", "/images/walk.png")
  $("#car").find("img").attr("src", "/images/car.png")
  $("#bike").find("img").attr("src", "/images/bike.png")