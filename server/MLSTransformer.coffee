@MLSTransformer =
  transformProperty: (rawProperty) ->
    transformedProperty = {}
    _.each MLSTransformer.transformMethods, (fn, key) ->
      result = fn rawProperty
      if _.isObject(result) and not _.isDate(result)
        _.each result, (value, key) ->
          transformedProperty[key] = value
      else
        transformedProperty[key] = result

    transformedProperty.mlsNo = rawProperty.ListingID
    transformedProperty.source = 
      mlsNo: rawProperty.ListingID
      listingKey: rawProperty.ListingKey
      source: 'IDX'
    transformedProperty

  transformMethods:
#    _id: (obj) ->
#      obj._id
    title: (obj) ->
      obj.BuildingName or s.titleize obj.FullStreetAddress
    cityId: (obj) ->
      s.slugify obj.CityName.toLowerCase()
    address: (obj) -> 
      # "#{obj.StreetNumber} #{obj.StreetDirPrefix} #{s.titleize obj.StreetName} #{s.titleize obj.StreetSuffix}"
      if obj.AddressExportAllowed is 'N'
        'N/A'
      else
        s.titleize obj.FullStreetAddress
    postalCode: (obj) ->
      obj.PostalCode
    sqft: (obj) ->
      sqftFrom: +obj.NetSQFT || +obj.LandSqFt
      sqftTo: +obj.NetSQFT || +obj.LandSqFt
    prices: (obj) ->
      if obj.Beds is 0
        results =
          priceStudioFrom: +obj.ListPrice
          priceStudioTo: +obj.ListPrice
          agroPriceStudioFrom: +obj.ListPrice 
          agroPriceStudioTo: +obj.ListPrice
      else
        results =
          "priceBedroom#{obj.Beds}From": +obj.ListPrice
          "priceBedroom#{obj.Beds}To": +obj.ListPrice
          "agroPriceBedroom#{obj.Beds}From": +obj.ListPrice
          "agroPriceBedroom#{obj.Beds}To": +obj.ListPrice

      results
    adminAppFee: (obj) ->
      # Need to confirm if this is the right field
      +obj.HOAFee
    availableAt: (obj) ->
      moment(obj.DateAvailable).toDate()
    modifiedAt: (obj) ->
      moment(obj.ModificationTimestamp).toDate()
    bedrooms: (obj) ->
      bedroomsFrom: +obj.Beds
      bedroomsTo: +obj.Beds
    bathrooms: (obj) ->
      bathrooms = +obj.BathsFull + 0.5 * +obj.BathsHalf
      bathroomsFrom: bathrooms
      bathroomsTo: bathrooms
    isFurnished: (obj) ->
      obj.Furnished is 'Yes'
    btype: (obj) ->
      if obj.Beds then "bedroom" + obj.Beds else "studio"
    neighborhood: (obj) ->
      # s.titleize(obj.ListingArea)
      NeighborhoodTranslations[s.titleize(obj.Subdivision)] or s.titleize(obj.Subdivision)
    neighborhoodSlug: (obj) ->
      # s.titleize(obj.ListingArea)
      translated = NeighborhoodTranslations[s.titleize(obj.Subdivision)] or s.titleize(obj.Subdivision)
      s(translated).slugify().value()
    description: (obj) ->
      obj.Remarks
    type: (obj) ->
      obj.Type
    design: (obj) ->
      obj.Design
    style: (obj) ->
      obj.Stylesmtho
    unknownFeatures: (obj) ->
      utilities: 0
      fitnessCenter: 0
      security: 0
    laundry: (obj) ->
      inUnit = ["MainFlrLndry", "UpprFlrLndry", "LowFlrLndry", "BsmtLaundry", "Main Floor Laundry", "Basement Laundry"]
      onSite = ["CommonShared", "Common Laundry"]
      noLaundry = ["NoLaundry", "No Laundry"]

      if inUnit.indexOf(obj.LaundryType) > -1 then return 1
      if onSite.indexOf(obj.LaundryType) > -1 then return 2
      if noLaundry.indexOf(obj.LaundryType) > -1 then return 3
      return 0
    pets: (obj) ->
      switch obj.PetsAllowed
        when 'Yes' then return 1
        when 'Restricted' then return 2
        when 'No' then return 3
        else return 0  
    parking: (obj) ->
      available = ["1-CarParking", "2-CarParking", "3+CarParking", "DrivewayPrk", "Asgn/DeedPrk", "ParkingLot", "Private", "Shared", "ParkingGarage", "1-CarGarage", "2-CarGarage", "3-CarGarage", "4+CarGarage", "Att/BuiltInG", "DetachedGar"]
      none = ["StreetParkng", "PermitParkng", "NoGarage", "Street"]

      _.each available, (value) ->
        if obj.Parking.indexOf(value) > -1 then return 2

      if obj.GarageSpaces.indexOf('CarGarage') > -1 then return 2

      _.each none, (value) ->
        if obj.Parking.indexOf(value) > -1 then return 3

      if obj.GarageSpaces.indexOf('NoGarage') > -1 then return 3

      return 0
    features: (obj) ->
      features = []
      # Features here

      if obj.BasementType.indexOf('Unfinished') > -1 then features.push 'Unfinished Basement'
      if obj.TenantPays.indexOf('TenantElec') > -1 then features.push 'Tenant Pays Elec'
      if obj.TenantPays.indexOf('TenantGas') > -1 then features.push 'Tenant Pays Gas'
      if obj.TenantPays.indexOf('TenantHeat') > -1 then features.push 'Tenant Pays Heat'
      if obj.Exterior.indexOf('Brick') > -1 then features.push 'Brick Exterior'
      if obj.CentralAir is 'Y' then features.push 'Central Air Conditioning'
      if obj.Floor.indexOf('Carpet') > -1 then features.push 'Carpeting'
      if obj.Floor.indexOf('Wood') > -1 then features.push 'Wood Floors'
      if obj.DiningKitchen.indexOf('FullKit') > -1 or obj.DiningKitchen.indexOf('Kit&BrksfRm') > -1 then features.push 'Full Kitchen'
      if obj.MainEntrance.indexOf('SecureEntr') > -1 then features.push 'Secure Entrance'
      if obj.Design.indexOf('LoRise') > -1 then features.push 'Low Rise'
      if obj.Design.indexOf('HiRise') > -1 then features.push 'High Rise'
      
      #"Health Fee": "Fitness Club Costs Ext
      #"Hot Wtr Fee": "Hot Water Included",
      #"Heat Fee": "Heating Included",
      #"Elec Fee": "Electricity Included"

      features.join(', ')

    adminContact: (obj) ->
      output = ''
      if obj.ListAgentFirstName then output += "Listing Agent: #{obj.ListAgentFirstName} #{obj.ListAgentLastName}"
      if obj.AppointmentPhone then output += "\r\nAppointment Phone: #{obj.AppointmentPhone}"
      if obj.ListAgentDirectPhone then output += "\r\nAgent Phone: #{obj.ListAgentDirectPhone}"
      if obj.ListOfficeOfficePhone then output += "\r\nOffice Phone: #{obj.ListOfficeOfficePhone}"

      output
    adminNotes: (obj) ->
      output = ''

      if obj.ListDate then output += "Date Listed: #{obj.ListDate}"
      if obj.ModificationTimestamp then output += "\r\nDate Last Modified: #{obj.ModificationTimestamp}"
      if obj.ListOfficeFullOfficeName then output += "\r\nBrokerage: #{obj.ListOfficeFullOfficeName}"

      output

    brokerageName: (obj) ->
      if obj.ListOfficeFullOfficeName then obj.ListOfficeFullOfficeName else ''

    # Default values
    ownerId: ->
      "Admin"
    isPublished: ->
      true
    isOnMap: ->
      true
    securityComment: ->
      ""
    laundryComment: ->
      ""
    propertyType: ->
      0
    position: ->
      0
    agroCanBeSame: ->
      false
    agroIsUnit: ->
      false
    fitnessCenterComment: ->
      ""
    petsComment: ->
      ""
    parkingComment: ->
      ""
    utilitiesComment: ->
      ""
    adminAvailability: ->
      ""
    adminEscorted: ->
      ""
    adminOfficeHours: ->
      ""
    isNotAvailable: ->
      false
