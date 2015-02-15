share.fixtureIds = []

insertData = (data, collection) ->
  for _id of data when _id not in share.fixtureIds
    share.fixtureIds.push(_id)
  if collection.find().count() is 0
    for _id, object of data
      object._id = _id
      object.isNew = false
      object.isFixture = true
      collection.insert(object)
    return true

share.loadFixtures = ->
  now = new Date()
  lastWeek = new Date(now.getTime() - 7 * 24 * 3600 * 1000)

  users =
    FirstAdmin:
      profile:
        name: "First Admin"
    SecondAdmin:
      profile:
        name: "Second Admin"
  for _id, user of users
    _.defaults(user,
      username: _id
      isAliasedByMixpanel: true
      emails: [
        {
          address: _id.toLowerCase() + "@rentscene.com"
          verified: true
        }
      ]
      createdAt: lastWeek
    )

  usersInserted = insertData(users, Meteor.users)
  if usersInserted
    for _id, user of users
      Accounts.setPassword(_id, "123123")
      Meteor.users.update(_id, {$push: {"services.resume.loginTokens": {
        "hashedToken": Accounts._hashLoginToken(_id),
        "when": now
      }}})

  buildings =
    2395:
      name: "Riverloft - 2300 Walnut Street"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 21
      title: "Riverloft - 2300 Walnut Street"
      summary: "Situated right on Walnut St., the Riverloft is close to campus, and perhaps more importantly, Rosies, a perhaps-too-popular Wharton watering hole."
      postal_code: "19103"
      street: "2300 Walnut St"
      price: "$1875"
      bathrooms: "1"
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["24-hour Doorman", "24-hour fitness center", "Business Center", "Garage parking available",
                 "Washer / Dryer", "Loft-style", "Hardwood floors", "Dishwasher", "Gym", "In-unit Laundry"]
      heatingAndCooling: ""
      description: "<p>Choose from varied loft-style pet friendly apartment floor plans in studios, 1-bedroom, 1-bedroom plus den and 3-bedroom options with 16 foot high ceilings and 12-foot windows offering spectacular views of the river and downtown Philly.</p>\r\n\r\n<p>Riverloft is located in Center City Philadelphia, a few blocks from Rittenhouse Square, and right on the Skullykill River. It has a 24 fitness center and front desk service.</p>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: "Available"
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Pet Friendly"
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      bedrooms: ""
      propertyType: "1"
      latitude: 39.9510536
      longitude: -75.1786215
      "3bedroom":
        from: "3579"
        to: "3799"

      "1bedroom":
        from: "2129"
        to: "3489"

      studio:
        from: "1875"
        to: "2302"

    2396:
      name: "1930 Chestnut"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: ["2395", "2399", "2404", "2405", "2417"]
      position: 23
      title: "1930 Chestnut"
      summary: "A premier apartment community near Rittenhouse Square and University City. Sleek, modern and metropolitan."
      postal_code: "19103"
      street: "1930 Chestnut Street"
      price: "$1200"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["24-7 concierge", "Ceramic tile kitchens with granite countertops", "Dishwasher", "Microwave",
                 "Glass Top Stove", "Garbage Disposal", "Marble baths", "Washer and Dryer in unit"]
      heatingAndCooling: ""
      description: "<p>Located near many popular bars and restaurants, 1930 Chestnut offers many apartment styles. Ranging from simple studios to one-bedroom apartments with a den -- this building has a variety of floorplan to suit your needs. </p>\r\n\r\n<p>Every one of the 144 units have been renovated with modern conveniences.</p>\r\n<ul><li>24/7 concierge</li>\r\n<li>Ceramic tile kitchens with granite countertops</li>\r\n<li>Dishwasher, microwave, glass top stove and garbage disposal</li>\r\n<li>Marble baths</li>\r\n<li>Washer / Dryer in unit</li>\r\n<li>Pet friendly</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: ""
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Pet friendly"
      applyAt: ""
      country: "U.S.A."
      city: "Philadelphia"
      mlsNo: "22222222222222"
      bedrooms: ""
      laundry: "0"
      propertyType: "0"
      latitude: 39.9518328
      longitude: -75.1733519
      "1bedroom":
        from: "1300"
        to: "1980"

      studio:
        from: "1200"
        to: "1495"

    2398:
      name: "1700 Walnut"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 24
      title: "1700 Walnut"
      summary: "Situated in the center of Rittenhouse Square, this building is close to the pubs, restaurants, and shops the neighborhood is known for.  This building offers many layout and price points for both 1 and 2 bedroom apartments."
      postal_code: "19102"
      street: "1700 Walnut St"
      price: "1550"
      bathrooms: "1-2"
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Doorman", "Dishwasher", "Shared Laundry", "Microwave", "Glass Top Stove", "Garbage Disposal",
                 "Marble baths"]
      heatingAndCooling: ""
      description: "<p>Each of the 68 units have been renovated with modern conveniences that include the following:</p>\r\n<ul><li>24/7 concierge to greet you</li>\r\n<li>Ceramic tile kitchens with granite countertops</li>\r\n<li>Dishwasher, microwave, glass top stove and garbage disposal</li>\r\n<li>Marble baths</li>\r\n<li>Washer / Dryer in some units or basement</li>\r\n<li>Wall to wall carpeting</li>\r\n<li>Pet friendly</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: ""
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Pet Friendly"
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.9498224
      longitude: -75.1692601
      "2bedroom":
        from: "2700"
        to: "3100"

      "1bedroom":
        from: "1550"
        to: "2075"

    2399:
      name: "Riverwest - 2101 Chestnut St"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 25
      title: "Riverwest - 2101 Chestnut St"
      summary: "Located on the edge of Rittenhouse Square, but near to the river, 2101 Chestnut has a convenient location. It is a bit further out from the square, but has many floorplans to select from. A doorman and some renovated kitchens also are a plus."
      postal_code: "19103"
      street: "2101 Chestnut St"
      price: "1400"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Doorman", "Gym", "Party Room", "Shared Laundry", "On-Site Laundry Facilities",
                 "24 Hour Lobby Attendant"]
      heatingAndCooling: ""
      description: "<p>Studios, one-bedrooms, and two-bedrooms available. Contact us for more information.. </p>\r\n<p>Building Amenities:</p>\r\n<p>Many apartments feature new kitchens with frost-free refrigerator/freezer, self-cleaning range/oven, dishwasher in selected units. Plush wall-to-wall carpeting:</p>\r\n<ul><li>24 Hour Lobby Attendant</li>\r\n<li>State-of-the-Art Fitness Center</li>\r\n<li>Direct TV Equipped</li>\r\n<li>Telephone intercom with pushbutton admittance</li>\r\n<li>Business Center with High Speed internet Access</li>\r\n<li>On-Site Laundry Facilities</li>\r\n<li>Pet Friendly.</li></ul>\r\n<p>A doorman and some renovated kitchens also are a plus..</p>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: ""
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Pet Friendly"
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.9525388
      longitude: -75.1758082
      studio:
        from: 1400

    2401:
      name: "Dorchester - 226 W Rittenhouse Square"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 26
      title: "Dorchester - 226 W Rittenhouse Square"
      summary: "Nice apartments right off of the square. It has a great location and a set of cool amenities like a rooftop pool! Hundreds of apartments with varying floorplans and prices make this an interesting option!"
      postal_code: "19103"
      street: "226 W. Rittenhouse Square"
      price: "1400"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Doorman", "Gym", "Rooftop pool"]
      heatingAndCooling: ""
      description: "<p>It has a great location and a set of cool amenities like a rooftop pool! Hundreds of apartments with varying floorplans and prices make this an interesting option!.</p>\r\n<ul><li>Parking</li>\r\n<li>Doorman</li>\r\n<li>Gym</li>\r\n<li>Rooftop pool</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: "Yes"
      basement: ""
      remarks: ""
      furnished: ""
      pets: ""
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.94889
      longitude: -75.173129
      "1bedroom":
        from: 2000

      "2bedroom":
        from: 2500

      studio:
        from: 1400

    2403:
      name: "The Lofts - 1835 Arch St"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 27
      title: "The Lofts - 1835 Arch St"
      summary: "The Lofts at 1835 Arch offer nice amenities right on the edge of the Rittenhouse neighborhood. A variety of floorplans and upgraded appliances are an added plus!"
      postal_code: "19102"
      street: "1835 Arch street"
      price: "1424"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Doorman", "Dishwasher", "Gym", "In-unit Laundry", "Party Room", "Granite Countertops",
                 "In-Suite Washer and Dryer", "24 Hour Fitness Center", "Conference Room", "24 Hour Attended Lobby",
                 "High Ceilings", "On-Site Restaurant and Convenience Store", "2 Blocks from the trolley",
                 "Walking Distance from Trader Joe's & Whole Foods", "On-Site Parking Available",
                 "Upgraded Whirlpool Stainless Steel Appliances"]
      heatingAndCooling: ""
      description: "<p>A variety of floorplans and upgraded appliances are an added plus!</p>\r\n<p>Building Amenities:</p>\r\n<ul><li>Granite Countertops</li>\r\n<li>In-Suite Washer /Dryer</li>\r\n<li>24 Hour Fitness Center</li>\r\n<li>Conference Room</li>\r\n<li>24 Hour Attended Lobby</li>\r\n<li>High Ceilings</li>\r\n<li>On-Site Restaurant and Convenience Store</li>\r\n<li>2 Blocks from the trolley</li>\r\n<li>Walking Distance from Trader Joe's & Whole Foods</li>\r\n<li>On-Site Parking Available</li>\r\n<li>Upgraded Whirlpool Stainless Steel Appliances</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: "Available"
      basement: ""
      remarks: ""
      furnished: ""
      pets: ""
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.955512
      longitude: -75.1707554
      "2bedroom":
        from: "2400"
        to: "3100"

      "1bedroom":
        from: "1424"
        to: "2400"

    2404:
      name: "1411 Walnut"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 28
      title: "1411 Walnut"
      summary: ""
      postal_code: "19103"
      street: "1411 Walnut St"
      price: "1205"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Dishwasher", "In-unit Laundry"]
      heatingAndCooling: ""
      description: "<ul><li>5 min (0.3min) walk to the 15th street trolley station where trolleys depart every few minutes towards campus (7-12 min ride)</li>\r\n<li>15th Street Trolley station is a hub for many SEPTA trolleys and the subway</li>\r\n<li>~1.8 mile walk to Huntsman</li></ul>\r\nThe original home of the Philadelphia Stock Exchange, 1411 is a historic, mid-rise building centrally located one block off the Avenue of the Arts.\r\n\r\nBeautiful lobby, doorman during business hours."
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: ""
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Pet Friendly"
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: "1111111111"
      bedrooms: ""
      laundry: "0"
      propertyType: "0"
      latitude: 39.949643
      longitude: -75.164937
      "2bedroom":
        from: 1895

      "1bedroom":
        from: 1205

    2405:
      name: "Academy House - 1420 Locust"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 29
      title: "Academy House - 1420 Locust"
      summary: "The Academy House is located in Rittenhouse Square near the bustle of the square and the bars and restaurants of 13th street. This building has many amenities and buildings with many layouts - including apartments with balconies!"
      postal_code: "19102"
      street: "1420 Locust St"
      price: "1250"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Washer and Dryer in unit", "Fitness Center", "Swimming Pool", "24-hour Doorman", "Gym",
                 "In-unit Laundry"]
      heatingAndCooling: ""
      description: "<p>This building has many amenities and buildings with many layouts - including apartments with balconies!</p>\r\n<ul><li>5 min (0.3min) walk to the 15th street trolley station where trolleys depart every few minutes towards campus (7-12 min ride)</li>\r\n<li>15th Street Trolley station is a hub for many SEPTA trolleys and the subway</li>\r\n<li>~1.8 mile walk to Huntsman</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: "Available"
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Pet Friendly"
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.947954
      longitude: -75.165882
      "2bedroom":
        from: 2150

      "1bedroom":
        from: 1250

    2406:
      name: "2040 Market Street"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 50
      title: "2040 Market Street"
      summary: "Be one of the first tenants to live in this brand new luxury high rise building. Take advantage of the slightly below market rents."
      postal_code: "19103"
      street: "2040 Market Street"
      price: "1895"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Doorman", "Dishwasher", "Gym", "In-unit Laundry", "Hardwood Floors",
                 "New energy efficient heat & air systems", "GE stainless steel appliances", "Granite countertops",
                 "24hr front desk services", "Washer and dryer in unit", "State-of-the-art Fitness Center",
                 "High ceilings", "2 blocks from regional rail", "1 block from the subway"]
      heatingAndCooling: ""
      description: "<p>2040 Market Apartments, the ultimate urban living experience! Step out your front door and the city is yours! Blocks of restaurants, entertainment, shopping, culture and parks are right at your fingertips. 2040 Market features an impressive lobby with a 24-hour Front-Desk attendant, valet dry cleaning services, a modern bi-level Fitness Center and an indoor Garage parking (for an additional monthly fee).</p>\r\n<p>Our Ultra modern, contemporary design features floor-to ceiling glass windows, hardwood flooring in the living space, tiled kitchens, high ceilings, amazing natural light, stainless appliances, granite counters, washer/dryer in unit and breathtaking city views.</p>\r\n<ul><li>Hardwood flooring</li>\r\n<li>New energy efficient heat & air systems</li>\r\n<li>GE stainless steel appliances</li>\r\n<li>Granite countertops</li>\r\n<li>Dishwasher</li>\r\n<li>24hr front desk services</li>\r\n<li>Washer/dryer in unit</li>\r\n<li>Pet friendly</li>\r\n<li>State-of-the-art Fitness Center</li>\r\n<li>High ceilings</li>\r\n<li>Indoor garage parking available</li>\r\n<li>2 blocks from regional rail</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: "Indoor garage parking available"
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Pet Friendly"
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.9534033
      longitude: -75.174647
      "4bedroom":
        from: "3900"
        to: "4200"

      "3bedroom":
        from: 3600

      "2bedroom":
        from: 3000

      "1bedroom":
        from: 1895

    2407:
      name: "Locust on the Park"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 51
      title: "Locust on the Park"
      summary: "5 blocks from rittenhouse, quiet neighorhood"
      postal_code: "19103"
      street: "201 S 25th St  Philadelphia, PA 19103"
      price: "1650"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Doorman", "Dishwasher", "Gym", "In-unit Laundry", "Washer and dryer in suite", "Tenant Referral",
                 "Priority Wait-list", "Refundable", "Retail Location"]
      heatingAndCooling: ""
      description: "<p>Building Amenities</p>\r\n<ul><li>Tenant referral</li>\r\n<li>Priority wait-list</li>\r\n<li>Refundable</li>\r\n<li>Retail location</li>\r\n<li>Cats only</li>\r\n<li>Washer Dryer In Suite</li></ul>\r\n<p>.............</p>\r\n<ul><li>1 bed: $1870+</li>\r\n<li>2 bed: $2295+</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: ""
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Cats Only"
      applyAt: ""
      country: "United States"
      city: "Washington DC"
      mlsNo: ""
      latitude: 39.9500718
      longitude: -75.1807253
      studio:
        from: 1650

    2408:
      name: "The Drake"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 52
      title: "The Drake"
      summary: "The Drake, an historic renovation of the 1929 Drake Hotel, is Philadelphia Apartment living at its most original. Discover a truly unique lifestyle at The Drake."
      postal_code: "19102"
      street: "1512 Spruce Street"
      price: "1100"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Doorman", "Dishwasher", "Gym", "Shared Laundry", "Fitness Center",
                 "Refrigerator with Ice Maker in Select Suites", "New Stove and Oven", "Microwave",
                 "Walk-In Closets in Select Suites", "Plush Wall-to-Wall Carpeting", "Stunning Views",
                 "24-Hour Front Desk", "Controlled Access Entry", "Historic Sir Francis Drake Room for Parties",
                 "Wifi Areas", "Central Laundry", "Package Receiving", "Dry Cleaning Receiving", "On-Site Management",
                 "24 Hour Emergency Maintenance"]
      heatingAndCooling: "Individually Controlled Heat and AC"
      description: "<p>In every great city there is an address that best captures the feel of that city. In Philadelphia that address is The Drake. This elegant 32-story beauty has been restored to its original splendor and is home to stylish Philadelphia apartments and the most spectacular penthouses in the city. Each studio, one and two bedroom apartment, and penthouse offers impressive architectural detail, stylish living spaces and a great location to explore the city.</p>\r\n<p>Building Amenities</p>\r\n<ul><li>24-Hour Front Desk</li>\r\n<li>Controlled Access Entry</li>\r\n<li>Historic Sir Francis Drake Room for Parties</li>\r\n<li>Wifi Areas</li>\r\n<li>Central Laundry</li>\r\n<li>Package Receiving</li>\r\n<li>Dry Cleaning Receiving</li>\r\n<li>On-Site Management\r\n<li>24 Hour Emergency Maintenance</li>\r\n<li>Fitness Center</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: ""
      basement: ""
      remarks: ""
      furnished: ""
      pets: ""
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.9471172
      longitude: -75.1671497
      "1bedroom":
        from: 1300

      "2bedroom":
        from: 2100

      studio:
        from: 1100

    2409:
      name: "The Metropolitan"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 53
      title: "The Metropolitan"
      summary: "The Metropolitan is conveniently located at 15th and Arch, just around the corner from City Hall. It is a historic 1926 Art Deco building which has been renovated."
      postal_code: "19102"
      street: "117 N. 15th Street"
      price: "1300"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1926"
      features: ["Doorman", "Dishwasher", "Gym", "Party room", "Hardwood Floors", "24-7 lobby attendant",
                 "Three high-speed passenger elevators", "Outside-vented bathroom exhaust fans",
                 "All new stainless steel appliances", "Granite countertops",
                 "Sound-insulated continuous feed garbage disposal", "Telephone intercom with pushbutton admittance",
                 "Plush wall-to-wall carpeting", "Spacious landscaped roof deck", "Trash chutes on each floor"]
      heatingAndCooling: ""
      description: "<p>In 1926, famous French architect Louis Jallade was commissioned to design a twin-tower hotel at the corner of 15th and Arch streets. The resulting masterwork is the Metropolitan.</p><p>Today, the Metropolitan is a beautifully adapted, 26-story residential tower with a host of contemporary amenities including a new lobby, state-of-the-art fitness center and all-new designer kitchens with stainless steel appliances. </p><p>A stunning luxury residence, the Metropolitan continues to rise above the rest.</p>\r\n\r\n<p>Building Amenities:</p>\r\n<ul><li>24/7-lobby attendant</li>\r\n<li>Nearby parking lots and garages</li>\r\n<li>New conference/study center and community room with flat-screen TV</li>\r\n<li>Pay rent and request maintenance online</li>\r\n<li>Professional 24-hour property management</li>\r\n<li>State-of-the-art, complimentary fitness center</li>\r\n<li>Three high-speed passenger elevators</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: "Available"
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Pet Friendly (Restrictions apply)"
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      bedrooms: ""
      propertyType: "0"
      latitude: 39.9551377
      longitude: -75.1644659
      "2bedroom":
        from: 2100

      "1bedroom":
        from: 1600

      studio:
        from: 1300

    2410:
      name: "1530 Chestnut"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 54
      title: "1530 Chestnut"
      summary: "1530 Chestnut is in the heart of Center City, and is a renovated building from the early 1900s. It is classified as an official historic site by the Preservation Alliance of Greater Philadelphia."
      postal_code: ""
      street: ""
      price: "1200"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1902"
      features: ["Doorman", "Dishwasher", "Shared Laundry", "Air Conditioning", "Cable Ready", "New Renovated Interior",
                 "Oversized Closets", "Some Paid Utilities", "Outside kitchen and bath vents", "Garbage disposal"]
      heatingAndCooling: "Yes"
      description: "<p>Standing nine stories tall, 1530 Chestnut is where modern convenience meets urban excitement. You're a stone's throw away from Rittenhouse Square Park and a quick walk to Philadelphia's hopping Avenue of the Arts.</p>\r\n<p>Building Amenities</p>\r\n<ul><li>Air Conditioning</li>\r\n<li>Cable Ready</li>\r\n<li>New/Renovated Interior</li>\r\n<li>Oversized Closets</li>\r\n<li>Some Paid Utilities</li>\r\n<li>Outside kitchen and bath vents</li>\r\n<li>Garbage disposal</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: ""
      basement: ""
      remarks: ""
      furnished: ""
      pets: ""
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.952335
      longitude: -75.163789
      studio:
        from: 1200

      "1bedroom":
        from: 1350

      "2bedroom":
        from: 1465

    2411:
      name: "1830 Lombard"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 55
      title: "1830 Lombard"
      summary: "This 11-story, Art Deco style high rise is located between 18th and 19th Street on Lombard in the Graduate Hospital neighborhood in Philadelphia.  The Pepper Building features 185 renovated apartment homes with all the modern amenities you desire!"
      postal_code: ""
      street: ""
      price: "1600"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Doorman", "Dishwasher", "Gym", "In-unit Laundry", "Party Room", "Granite Countertops",
                 "Stainless steel appliances", "Wall to wall carpet", "Washer and dryer in every unit",
                 "Ceramic tile flooring in bathrooms", "Spacious Closets", "24 hour fitness center", "Intercom access",
                 "Courtyard", "24 hour emergency maintenance", "On-Site Management and Leasing Office"]
      heatingAndCooling: ""
      description: "<p>The Pepper Building features 185 renovated apartment homes with all the modern amenities you desire!</p>\r\n<p><ul><li>Prime location just blocks away from Rittenhouse Square</li>\r\n<li>Full renovation featuring granite countertops, stainless steel appliances and washer/dryer in every unit.</li>\r\n<li>Breathtaking views of Center City Philadelphia.</li></ul></p>\r\n<p>Building Amenities:</p>\r\n<ul><li>Granite Countertops</li>\r\n<li>Stainless steel appliances</li>\r\n<li>Wall to wall carpet</li>\r\n<li>Washer/dryer in every unit</li>\r\n<li>Ceramic tile flooring in bathrooms</li>\r\n<li>Spacious Closets</li>\r\n<li>24 hour fitness center</li>\r\n<li>Intercom access</li>\r\n<li>Parking available</li>\r\n<li>Courtyard</li>\r\n<li>24 hour emergency maintenance</li>\r\n<li>On-Site Management and Leasing Office</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: "Available"
      basement: ""
      remarks: ""
      furnished: ""
      pets: ""
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.952335
      longitude: -75.163789
      "2bedroom":
        from: 2100

      "1bedroom":
        from: 1600

    2412:
      name: "Old Quaker Building - 3514 Lancaster Ave"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 56
      title: "Old Quaker Building - 3514 Lancaster Ave"
      summary: "Ideally located in the heart of University City, The Old Quaker Building is actually a complex of two architecturally significant 19th century structures that have been completely renovated."
      postal_code: "19104"
      street: "3514 Lancaster Avenue"
      price: "1450"
      bathrooms: ""
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: ["Gym", "In-unit Laundry", "Party Room", "Ceramic tile bathroom floors", "Outside-vented exhaust fans",
                 "Forty-gallon fast recovery hot water heater", "Individual washers and dryers in every apartment",
                 "All new stainless steel kitchen appliances", "Granite countertops",
                 "Sound-insulated continuous feed garbage disposal", "Plush wall-to-wall carpeting"]
      heatingAndCooling: "Individually controlled air conditioning and heat"
      description: "<p>Building Amenities: </p>\r\n<ul><li>Beautifully landscaped courtyard and forecourt</li>\r\n<li>Complimentary fitness center</li>\r\n<li>High-speed passenger elevators and separate freight elevator</li>\r\n<li>On site resident parking available</li>\r\n<li>Pay rent and request maintenance online</li> \r\n<li>PhillyCarShare rental on site</li>\r\n<li>Professional 24-hour property management.</li></ul>"
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      availableAt: ""
      secondDeposit: ""
      minTerm: ""
      other: ""
      parking: "Available"
      basement: ""
      remarks: ""
      furnished: ""
      pets: "Pet Friendly (Restrictions Apply)"
      applyAt: ""
      country: "United States"
      city: "Philadelphia"
      mlsNo: ""
      latitude: 39.9578299
      longitude: -75.1933048
      "1bedroom":
        from: 1750

      "2bedroom":
        from: 2050

      studio:
        from: 1450

    2413:
      name: "1836 Delancey St #3"
      isPublished: true
      createdAt: "2014-02-12T14:09:22.000Z"
      onMap: false
      similar: []
      position: 30
      title: "1836 Delancey St #3"
      summary: ""
      postal_code: "19103 19103"
      street: "1836 Delancey St #3"
      price: "1595"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1915"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantHtWtr", "TenantInsur",
                 "24HrNoticShw", "TenantOcc", "ComboLockBox"]
      heatingAndCooling: "Y"
      description: "Newly renovated 1 bedroom/ bathroom unit on Delancey Street in Rittenhouse Square! This unit features beautiful granite countertops, stainless steel appliances, many windows and original hardwood flooring throughout. Both washer and dryer are located inside of the unit. In walking distance from great restaurants and entertainment in Center City Philadelphia!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: "25"
      availableAt: "11/01/2013"
      secondDeposit: "$1,695"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Newly renovated 1 bedroom/ bathroom unit on Delancey Street in Rittenhouse Square! This unit features beautiful granite countertops, stainless steel appliances, many windows and original hardwood flooring throughout. Both washer and dryer are located inside of the unit. In walking distance from great restaurants and entertainment in Center City Philadelphia!"
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0NzAxNzM7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3Mjg2O30="
      mlsNo: "6283183"
      latitude: 39.9470173
      longitude: -75.17286

    2414:
      name: "1806-18 Rittenhouse Sq 410"
      isPublished: true
      createdAt: "2014-02-12T14:09:33.000Z"
      onMap: false
      similar: []
      position: 31
      title: "1806-18 Rittenhouse Sq 410"
      summary: ""
      postal_code: "19103 19103"
      street: "1806-18 Rittenhouse Sq 410"
      price: "1750"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "622"
      plotArea: ""
      yearOfCompletion: "1914"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: FinishedWood",
                 "CommonLndry", "NoModifs/Unk Other: TenantInsur", "CableTV"]
      heatingAndCooling: "Y"
      description: "This bright 1 bedroom condo is located on Rittenhouse Square at the Rittenhouse Savoy on 18th & Rittenhouse Square. It has recently undergone extensive renovations including a new kitchen & bath and new cherry hardwood floors throughout. There is a large living room with new hardwood floors and a large triple window. Kitchen features new cherry cabinets, granite countertops, and tile backsplash. Bathroom is upscale with contemporary tile and sink. There is a large bedroom with hardwood floors, 4 large windows, and a great walk-in closet. There is central air conditioning and laundry facilities. This building has a beautiful lobby with a front desk. It also has a phenomenal roofdeck overlooking Rittenhouse Square to the north and the city of Philadelphia to the south. Electricity, gas, water, and basic digital cable for tv are included in the rent. Tenant is responsible for internet and additional cable tv services only."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "1Story"
      floor: ""
      fee: ""
      availableAt: "12/01/2013"
      secondDeposit: "$1,795"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "This bright 1 bedroom condo is located on Rittenhouse Square at the Rittenhouse Savoy on 18th & Rittenhouse Square. It has recently undergone extensive renovations including a new kitchen & bath and new cherry hardwood floors throughout. There is a large living room with new hardwood floors and a large triple window. Kitchen features new cherry cabinets, granite countertops, and tile backsplash. Bathroom is upscale with contemporary tile and sink. There is a large bedroom with hardwood floors, 4 large windows, and a great walk-in closet. There is central air conditioning and laundry facilities. This building has a beautiful lobby with a front desk. It also has a phenomenal roofdeck overlooking Rittenhouse Square to the north and the city of Philadelphia to the south. Electricity, gas, water, and basic digital cable for tv are included in the rent. Tenant is responsible for internet and additional cable tv services only."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0NTk3MTI7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3MTYzNDU7fQ=="
      mlsNo: "6311105"
      latitude: 39.9459712
      longitude: -75.1716345

    2417:
      name: "1836 Delancey St 2"
      isPublished: true
      createdAt: "2014-02-12T14:09:58.000Z"
      onMap: false
      similar: []
      position: 32
      title: "1836 Delancey St 2"
      summary: ""
      postal_code: "19103 19103"
      street: "1836 Delancey St 2"
      price: "1850"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantHtWtr", "TenantInsur", "CableTV"]
      heatingAndCooling: "Y"
      description: "Newly renovated 1 bedroom/1 bathroom unit on Delancey Street in Rittenhouse Square! This unit features beautiful granite countertops, stainless steel appliances, many windows and original hardwood flooring throughout. Both washer and dryer are located inside of the unit. In walking distance from great restaurants and entertainment in Center City Philadelphia!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: "25"
      availableAt: "07/25/2013"
      secondDeposit: "$2,050"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Newly renovated 1 bedroom/1 bathroom unit on Delancey Street in Rittenhouse Square! This unit features beautiful granite countertops, stainless steel appliances, many windows and original hardwood flooring throughout. Both washer and dryer are located inside of the unit. In walking distance from great restaurants and entertainment in Center City Philadelphia!"
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0NzAxNzM7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3Mjg2O30="
      mlsNo: "6255109"
      latitude: 39.9470173
      longitude: -75.17286

    2419:
      name: "1903 Spruce St 1B"
      isPublished: true
      createdAt: "2014-02-12T14:10:12.000Z"
      onMap: false
      similar: []
      position: 33
      title: "1903 Spruce St 1B"
      summary: ""
      postal_code: "19103 19103"
      street: "1903 Spruce St 1B"
      price: "1950"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,565"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: PartialBsmnt Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantInsur", "CableTV"]
      heatingAndCooling: "Y"
      description: "Perfectly located one block from Rittenhouse Square. First floor bi-level condo with wall of southern-exposure, oversized windows giving amazing sunlight all day . Fabulous bedroom with 12 ft ceilings, crown moldings and master bath on main floor. Lovely open floor plan with lots of room to entertain. Updated kitchen and bathrooms. Washer/Dryer in unit. Please no pets or smokers. Available immediately, call Rachel at 215.275.1351."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "LoRise"
      floor: ""
      fee: "15"
      availableAt: "10/24/2013"
      secondDeposit: "$1,950"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Perfectly located one block from Rittenhouse Square. First floor bi-level condo with wall of southern-exposure, oversized windows giving amazing sunlight all day . Fabulous bedroom with 12 ft ceilings, crown moldings and master bath on main floor. Lovely open floor plan with lots of room to entertain. Updated kitchen and bathrooms. Washer/Dryer in unit. Please no pets or smokers. Available immediately, call Rachel at 215.275.1351."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODIxNjtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTcyOTI1O30="
      mlsNo: "6297846"
      latitude: 39.948216
      longitude: -75.172925

    2433:
      name: "2026-58 Market St 516"
      isPublished: true
      createdAt: "2014-02-16T12:23:43.000Z"
      onMap: false
      similar: []
      position: 34
      title: "2026-58 Market St 516"
      summary: ""
      postal_code: "19103 19103"
      street: "2026-58 Market St 516"
      price: "1650"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1968"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantInsur", "CableTV", "OtherTenant"]
      heatingAndCooling: "Y"
      description: "Brand new apartments available for rent at 2040 Market Street. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. PARKING AVAILABLE FOR ADDITIONAL COST."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "03/01/2014"
      secondDeposit: "$1,650"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Brand new apartments available for rent at 2040 Market Street. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. PARKING AVAILABLE FOR ADDITIONAL COST."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MzMyNTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDEyNzt9"
      mlsNo: "6327797"
      latitude: 39.9533259
      longitude: -75.174127

    2434:
      name: "224-30 W Rittenhouse Sq 414"
      isPublished: true
      createdAt: "2014-02-16T12:23:45.000Z"
      onMap: false
      similar: []
      position: 35
      title: "224-30 W Rittenhouse Sq 414"
      summary: ""
      postal_code: "19103 19103"
      street: "224-30 W Rittenhouse Sq 414"
      price: "1650"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "740"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: BsmtLaundry",
                 "NoModifs/Unk Building Orient: BldOrientationW Other: NoneTentResp", "SwimExtFee", "CallToShow"]
      heatingAndCooling: "Y"
      description: " Full one bedroom with balcony, sunset view , hardwood floors, available asap. Dorchester is a highrise condominium with 24 hr deskperson, 24 hr maintenance. Gym, Seasonal Pool and parking available at extra charge. Non Smoking Building, $300.00 move in. If interested listing agent will prepare lease"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "4"
      fee: ""
      availableAt: "02/12/2014"
      secondDeposit: "$1,650"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: " Full one bedroom with balcony, sunset view , hardwood floors, available asap. Dorchester is a highrise condominium with 24 hr deskperson, 24 hr maintenance. Gym, Seasonal Pool and parking available at extra charge. Non Smoking Building, $300.00 move in. If interested listing agent will prepare lease"
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTA0NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTczNTk5OTt9"
      mlsNo: "6337455"
      latitude: 39.949045
      longitude: -75.1735999

    2435:
      name: "2107 Spruce St 3R"
      isPublished: true
      createdAt: "2014-02-16T12:23:49.000Z"
      onMap: false
      similar: []
      position: 36
      title: "2107 Spruce St 3R"
      summary: ""
      postal_code: "19103 19103"
      street: "2107 Spruce St 3R"
      price: "1675"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "4,553"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit", "Range",
                 "Refrigerator", "Washer", "Dryer", "Dishwasher", "Microwave Bsmt: NoBasement Interior: FinishedWood",
                 "Cth/VltCeil", "CeilngFan(s)", "CableTVWired", "MainFlrLndry", "NoModifs/Unk Other: TenantElec",
                 "TenantWtr", "CableTV", "OtherTenant", "24HrNoticShw", "TenantOcc", "ComboLockBox"]
      heatingAndCooling: "Y"
      description: "Available early May: 2107 Spruce Street is a 5-unit apartment building that was entirely renovated just a couple of years ago. High ceilings, new energy efficient HVAC system for central air heating/cooling, and luxury finishes throughout. Contemporary finishes include Espresso bamboo hardwood floors, stainless steel appliances, granite counter tops, modern shaker style cabinetry, Mosaic wall tile back splash, and much more! Apartment #3R: This fully renovated one bedroom apartment has hardwood floors throughout and EVERYTHING NEW - it is available for an early May move-in. You'll enter into the living/dining room area, with the kitchen around the corner. Hallway off the living room goes to the full bathroom with stackable washer/dryer inside, another hallway closet and the bedroom in the back of the building. There are an additional two more closets in the hall. Storage rental is optional for an additional $30 monthly. There is parking available in the rear of the building for an additional $250 monthly. Please check before regarding your car type, as this space will only fit a small compact vehicle. For this unit, you will prepay your water for the year ($295) and PECO for common areas for the year ($125). You will be responsible for the remaining PECO bill for your own unit."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "05/03/2014"
      secondDeposit: "$1,675"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Available early May: 2107 Spruce Street is a 5-unit apartment building that was entirely renovated just a couple of years ago. High ceilings, new energy efficient HVAC system for central air heating/cooling, and luxury finishes throughout. Contemporary finishes include Espresso bamboo hardwood floors, stainless steel appliances, granite counter tops, modern shaker style cabinetry, Mosaic wall tile back splash, and much more! Apartment #3R: This fully renovated one bedroom apartment has hardwood floors throughout and EVERYTHING NEW - it is available for an early May move-in. You'll enter into the living/dining room area, with the kitchen around the corner. Hallway off the living room goes to the full bathroom with stackable washer/dryer inside, another hallway closet and the bedroom in the back of the building. There are an additional two more closets in the hall. Storage rental is optional for an additional $30 monthly. There is parking available in the rear of the building for an additional $250 monthly. Please check before regarding your car type, as this space will only fit a small compact vehicle. For this unit, you will prepay your water for the year ($295) and PECO for common areas for the year ($125). You will be responsible for the remaining PECO bill for your own unit."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODY0MzY7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NjU3NjM7fQ=="
      mlsNo: "6338552"
      latitude: 39.9486436
      longitude: -75.1765763

    2436:
      name: "2026-58 Market St 525"
      isPublished: true
      createdAt: "2014-02-16T12:23:53.000Z"
      onMap: false
      similar: []
      position: 37
      title: "2026-58 Market St 525"
      summary: ""
      postal_code: "19103 19103"
      street: "2026-58 Market St 525"
      price: "1675"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1968"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas"]
      heatingAndCooling: "Y"
      description: "Brand new apartments available for rent at 2040 MARKET STREET. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "03/15/2014"
      secondDeposit: "$1,675"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Brand new apartments available for rent at 2040 MARKET STREET. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDgwMjU7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE1MDEyMjY7fQ=="
      mlsNo: "6336010"
      latitude: 39.9508025
      longitude: -75.1501226

    2438:
      name: "1920-22 Chestnut St 8N"
      isPublished: true
      createdAt: "2014-02-16T12:24:02.000Z"
      onMap: false
      similar: []
      position: 38
      title: "1920-22 Chestnut St 8N"
      summary: ""
      postal_code: "19103 19103"
      street: "1920-22 Chestnut St 8N"
      price: "1695"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "725"
      plotArea: ""
      yearOfCompletion: "1914"
      features: ["Heating/Cooling/Utilities: GasHeat", "CentralAir", "ElectricHWt", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage", "StreetParkng",
                 "PermitParkng Kit: KitW/NookBar Bsmt: NoBasement Interior: NoFireplace", "MainFlrLndry",
                 "NoModifs/Unk Exterior: BrickExt Other: Condo/HOAFee", "TenantElec", "ComAreaMaint", "ExtBldgMaint",
                 "SnowRemoval", "TrashRemoval", "WaterFee", "SewerFee", "InsurFee", "AllGroundFee", "ManagmentFee",
                 "Security"]
      heatingAndCooling: "Y"
      description: "This corner Rittenhouse apartment is available for move in January 1st! Located on the 8th floor of a boutique building, the apartment includes hardwood floors throughout, central heating & cooling, washer/dryer. Great closet space. Building is secure to key fob system & elevator. Kitchen includes granite countertops, fridge, microwave, dishwasher. Kitchen opens to living room with 2 large windows / 2 Juliet balconies. Bathroom has granite vanity top and marble flooring. Tenant pays only electric. Move in: 1st, last & security."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "1Story"
      floor: ""
      fee: ""
      availableAt: "01/01/2014"
      secondDeposit: "$3,590"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "This corner Rittenhouse apartment is available for move in January 1st! Located on the 8th floor of a boutique building, the apartment includes hardwood floors throughout, central heating & cooling, washer/dryer. Great closet space. Building is secure to key fob system & elevator. Kitchen includes granite countertops, fridge, microwave, dishwasher. Kitchen opens to living room with 2 large windows / 2 Juliet balconies. Bathroom has granite vanity top and marble flooring. Tenant pays only electric. Move in: 1st, last & security."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTA4Mzc7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NTA1MzQ7fQ=="
      mlsNo: "6316895"
      latitude: 39.9510837
      longitude: -75.1650534

    2439:
      name: "2201 Chestnut St 703"
      isPublished: true
      createdAt: "2014-02-16T12:24:05.000Z"
      onMap: false
      similar: []
      position: 39
      title: "2201 Chestnut St 703"
      summary: ""
      postal_code: "19103 19103"
      street: "2201 Chestnut St 703"
      price: "1700"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "800"
      plotArea: ""
      yearOfCompletion: "2009"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit", "Range",
                 "Refrigerator", "Washer", "Dryer", "Dishwasher", "Freezer", "Microwave",
                 "Disposal Bsmt: NoBasement Interior: MainFlrLndry", "CommonLndry", "NoModifs/Unk Other: TenantElec",
                 "TenantGas"]
      heatingAndCooling: "Y"
      description: "Bright, well kept and new. Great light. Wonderful hardwoods and moldings. Beautifully tiled bath. Kitchen: granite counters, stainless appliances (microwave, too), small washer/dryer. Historic building, with doorman, near Rittenhouse Square. Steps from restaurants, cafes, nightlife and shopping. Near public transportation. Short walk to 30th Street and Suburban Stations. Easy commute to UPENN and Drexel. Near Schuylkill River Walk/Bike path. Central AC. Affordable utilities?heat, A/C and water included (Tenant pays cooking gas an electricity for lighting)."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "LoRise"
      floor: ""
      fee: ""
      availableAt: "01/01/2014"
      secondDeposit: "$1,700"
      minTerm: "7"
      parking: ""
      basement: ""
      other: ""
      remarks: "Bright, well kept and new. Great light. Wonderful hardwoods and moldings. Beautifully tiled bath. Kitchen: granite counters, stainless appliances (microwave, too), small washer/dryer. Historic building, with doorman, near Rittenhouse Square. Steps from restaurants, cafes, nightlife and shopping. Near public transportation. Short walk to 30th Street and Suburban Stations. Easy commute to UPENN and Drexel. Near Schuylkill River Walk/Bike path. Central AC. Affordable utilities?heat, A/C and water included (Tenant pays cooking gas an electricity for lighting)."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjgwOTQ7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NzIzOTU7fQ=="
      mlsNo: "6317604"
      latitude: 39.9528094
      longitude: -75.1772395

    2440:
      name: "37 S 20th St 6C"
      isPublished: true
      createdAt: "2014-02-16T12:24:10.000Z"
      onMap: false
      similar: []
      position: 40
      title: "37 S 20th St 6C"
      summary: ""
      postal_code: "19103 19103"
      street: "37 S 20th St 6C"
      price: "1750"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "521"
      plotArea: ""
      yearOfCompletion: "1964"
      features: ["Heating/Cooling/Utilities: ElectricHeat", "CentralAir", "GasHotWater", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage Kit: FullKit", "Range", "Refrigerator", "Dishwasher",
                 "Microwave Bsmt: UnfinishBsmt Interior: NoFireplace", "FinishedWood", "W/WCarpeting", "SecureEntr",
                 "BsmtLaundry", "NoModifs/Unk Exterior: BrickExt", "CornerLot Other: TenantElec", "TenantInsur",
                 "CableTV", "CallToShow", "ComboLockBox"]
      heatingAndCooling: "Y"
      description: "Chestnut View - just off Rittenhouse Square....FURNISHED... Pet friendly.... Sharp executive completely renovated Condo ... Foyer / hallway leads to spacious living room and corner bedroom with large south and west exposures.... Enjoy excellent city skyline views..... Oak hardwood floors.... Eat in kitchen has stainless appliances, granite counters and sunny window.... Quiet, secure building with intercom access and two elevators..... Live in the heart of the city with reknowned restaurants, services and shopping at your door.... Quick access to all trains, Penn Shuttle and public transportation.... New HVAC provides energy efficient comfort.... You pay only electric. (3 washers + 3 dryers shared by owners in lower level.)"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "LoRise"
      floor: "6"
      fee: ""
      availableAt: "01/01/2014"
      secondDeposit: "$1,750"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Chestnut View - just off Rittenhouse Square....FURNISHED... Pet friendly.... Sharp executive completely renovated Condo ... Foyer / hallway leads to spacious living room and corner bedroom with large south and west exposures.... Enjoy excellent city skyline views..... Oak hardwood floors.... Eat in kitchen has stainless appliances, granite counters and sunny window.... Quiet, secure building with intercom access and two elevators..... Live in the heart of the city with reknowned restaurants, services and shopping at your door.... Quick access to all trains, Penn Shuttle and public transportation.... New HVAC provides energy efficient comfort.... You pay only electric. (3 washers + 3 dryers shared by owners in lower level.)"
      furnished: "Y"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjMyMzg7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3MzM2MDI7fQ=="
      mlsNo: "6318736"
      latitude: 39.9523238
      longitude: -75.1733602

    2446:
      name: "1930-34 Chestnut St 2C"
      isPublished: true
      createdAt: "2014-02-16T13:26:15.000Z"
      onMap: false
      similar: []
      position: 41
      title: "1930-34 Chestnut St 2C"
      summary: ""
      postal_code: "19103 19103"
      street: "1930-34 Chestnut St 2C"
      price: "1765"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1930"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "CableTV"]
      heatingAndCooling: "Y"
      description: "Fantastic 1 bedroom, 1 1/2 bath loft apartment for rent JUST STEPS OFF OF RITTENHOUSE SQUARE. Open living and dining space, well proportioned bedroom. Great space and value. A MUST SEE!!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "LoRise"
      floor: ""
      fee: ""
      availableAt: "09/18/2013"
      secondDeposit: "$1,795"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Fantastic 1 bedroom, 1 1/2 bath loft apartment for rent JUST STEPS OFF OF RITTENHOUSE SQUARE. Open living and dining space, well proportioned bedroom. Great space and value. A MUST SEE!!"
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTY4ODg7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3MjU1NjI7fQ=="
      mlsNo: "6257879"
      latitude: 39.9516888
      longitude: -75.1725562

    2447:
      name: "2026-58 Market St 903"
      isPublished: true
      createdAt: "2014-02-16T13:26:17.000Z"
      onMap: false
      similar: []
      position: 42
      title: "2026-58 Market St 903"
      summary: ""
      postal_code: "19103 19103"
      street: "2026-58 Market St 903"
      price: "1794"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1969"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "CableTV", "OtherTenant"]
      heatingAndCooling: "Y"
      description: "Brand new apartments available for rent at 2040 MARKET STREET. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. PARKING AVAILABLE FOR ADDITIONAL COST."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "12/01/2013"
      secondDeposit: "$1,794"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Brand new apartments available for rent at 2040 MARKET STREET. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. PARKING AVAILABLE FOR ADDITIONAL COST."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MzMyNTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDEyNzt9"
      mlsNo: "6304395"
      latitude: 39.9533259
      longitude: -75.174127

    2448:
      name: "2033 Spruce St #3"
      isPublished: true
      createdAt: "2014-02-17T07:54:23.000Z"
      onMap: false
      similar: []
      position: 43
      title: "2033 Spruce St #3"
      summary: ""
      postal_code: "19103 19103"
      street: "2033 Spruce St #3"
      price: "1450"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "4,243"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: FullBasement",
                 "UnfinishBsmt Interior: NoLaundry", "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas",
                 "TenantHtWtr", "TenantInsur", "CableTV", "OtherTenant"]
      heatingAndCooling: "Y"
      description: "This beautiful building is steps from Rittenhouse Square. No details has been spared in restoring this grand brownstone!! Enter into the grand foyer and feel the original old world charm of this breathtaking building. The restored unit is one of eight. The 1 bedroom, 1 bathroom apartment contains all the amenities and quality finishes usually reserved for new condominium restorations; but these are available for rent!! White Granite Countertops, Solid Wood cabinetry, Stainless Steel Appliance, Newly renovated bathrooms with modern tile, original refinished hardwood floors throughout, central air and built in speakers with ipod docking station!! Laundry Room in the building."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: "3"
      fee: "30"
      availableAt: "11/01/2013"
      secondDeposit: "$1,450"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "This beautiful building is steps from Rittenhouse Square. No details has been spared in restoring this grand brownstone!! Enter into the grand foyer and feel the original old world charm of this breathtaking building. The restored unit is one of eight. The 1 bedroom, 1 bathroom apartment contains all the amenities and quality finishes usually reserved for new condominium restorations; but these are available for rent!! White Granite Countertops, Solid Wood cabinetry, Stainless Steel Appliance, Newly renovated bathrooms with modern tile, original refinished hardwood floors throughout, central air and built in speakers with ipod docking station!! Laundry Room in the building."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODU0NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTc1NjA3O30="
      mlsNo: "6300136"
      latitude: 39.948545
      longitude: -75.175607

    2449:
      name: "2033 Spruce St 6"
      isPublished: true
      createdAt: "2014-02-17T07:54:25.000Z"
      onMap: false
      similar: []
      position: 44
      title: "2033 Spruce St 6"
      summary: ""
      postal_code: "19103 19103"
      street: "2033 Spruce St 6"
      price: "1450"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: FullBasement Interior: CommonLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantHtWtr", "TenantInsur",
                 "TenantSnow", "TenantTrash", "CableTV", "CallToShow", "24HrNoticShw", "TenantOcc", "ComboLockBox"]
      heatingAndCooling: "Y"
      description: "This beautiful building is steps from Rittenhouse Square. No details has been spared in restoring this grand brownstone!! Enter into the grand foyer and feel the original old world charm of this breathtaking building. The restored unit is one of eight. The 1 bedroom, 1 bathroom apartment contains all the amenities and quality finishes usually reserved for new condominium restorations; but these are available for rent!! White Granite Countertops, Solid Wood cabinetry, Stainless Steel Appliance, Newly renovated bathrooms with modern tile, original refinished hardwood floors throughout, central air and built in speakers with ipod docking station!! Laundry Room in the building. Inclusions: Custom made window treatments& 20\" Samsung HDTV mounted to wall."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: "30"
      availableAt: "04/01/2014"
      secondDeposit: "$1,450"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "This beautiful building is steps from Rittenhouse Square. No details has been spared in restoring this grand brownstone!! Enter into the grand foyer and feel the original old world charm of this breathtaking building. The restored unit is one of eight. The 1 bedroom, 1 bathroom apartment contains all the amenities and quality finishes usually reserved for new condominium restorations; but these are available for rent!! White Granite Countertops, Solid Wood cabinetry, Stainless Steel Appliance, Newly renovated bathrooms with modern tile, original refinished hardwood floors throughout, central air and built in speakers with ipod docking station!! Laundry Room in the building. Inclusions: Custom made window treatments& 20\" Samsung HDTV mounted to wall."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODU0NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTc1NjA3O30="
      mlsNo: "6326887"
      latitude: 39.948545
      longitude: -75.175607

    2453:
      name: "2006 Walnut St 10"
      isPublished: true
      createdAt: "2014-02-18T15:09:27.000Z"
      onMap: false
      similar: []
      position: 45
      title: "2006 Walnut St 10"
      summary: ""
      postal_code: "19103 19103"
      street: "2006 Walnut St 10"
      price: "1899"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "600"
      plotArea: ""
      yearOfCompletion: "1889"
      features: ["Heating/Cooling/Utilities: CentralAir", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage Kit: EatInKitchen", "Range", "Refrigerator", "Washer", "Dryer",
                 "Dishwasher", "Freezer", "Disposal Bsmt: FullBasement", "NoBasement Interior: NoFireplace",
                 "FinishedWood", "TileFlr", "SecureEntr", "MainFlrLndry", "NoModifs/Unk Exterior: Sidewalks",
                 "StreetLights", "Other: TenantElec", "TenantHeat", "TenantGas", "TenantWtr", "CableTV"]
      heatingAndCooling: "Y"
      description: "Be the first residents of the latest boutique building just steps off legendary Rittenhouse Square. The apartments are spacious, modern & tastefully appointed for the discerning resident. A seamless blend of old & new, each unit boasts recessed lighting, white oak hardwood floors, & modern square trim package. Gorgeous chef's kitchen brimming with the latest in kitchen design offer quartz countertops, sleek cabinetry & brand new appliances. Decadent full bathrooms with porcelain tile floors & shower surround as well as wetbed shower floors. The \"Port\" unit offers a comfortable bedroom with ample closet space. All units include a washer & dryer. Moving in will be a breeze as the building is serviced by a high speed commercial elevator. Residents can escape to the shared roof deck to enjoy the outdoors, fresh air & center city skyline views. Ideal location near the Rittenhouse Garage, easy access to 76 & steps away from all the city has to offer. Occupancy beginning February 2014!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "02/01/2014"
      secondDeposit: "$1,899"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Be the first residents of the latest boutique building just steps off legendary Rittenhouse Square. The apartments are spacious, modern & tastefully appointed for the discerning resident. A seamless blend of old & new, each unit boasts recessed lighting, white oak hardwood floors, & modern square trim package. Gorgeous chef's kitchen brimming with the latest in kitchen design offer quartz countertops, sleek cabinetry & brand new appliances. Decadent full bathrooms with porcelain tile floors & shower surround as well as wetbed shower floors. The \"Port\" unit offers a comfortable bedroom with ample closet space. All units include a washer & dryer. Moving in will be a breeze as the building is serviced by a high speed commercial elevator. Residents can escape to the shared roof deck to enjoy the outdoors, fresh air & center city skyline views. Ideal location near the Rittenhouse Garage, easy access to 76 & steps away from all the city has to offer. Occupancy beginning February 2014!"
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDMxMTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDIzOTt9"
      mlsNo: "6302943"
      latitude: 39.9503119
      longitude: -75.174239

    2454:
      name: "2013 Spruce St 9"
      isPublished: true
      createdAt: "2014-02-18T15:09:31.000Z"
      onMap: false
      similar: []
      position: 46
      title: "2013 Spruce St 9"
      summary: ""
      postal_code: "19103 19103"
      street: "2013 Spruce St 9"
      price: "1995"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "7,363"
      plotArea: ""
      yearOfCompletion: "1880"
      features: ["Heating/Cooling/Utilities: CentralAir", "GasHotWater", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage",
                 "StreetParkng Kit: EatInKitchen Bsmt: NoBasement Interior: Three+FPs", "MainFlrLndry",
                 "NoModifs/Unk Exterior: Sidewalks", "StreetLights", "Other: TenantElec", "TenantWtr", "TenantSwr",
                 "TenantHtWtr", "CableTV", "CallToShow", "LAMustAccShw", "24HrNoticShw"]
      heatingAndCooling: "Y"
      description: " Come See What We've Been Sprucing Up! Pre-Leasing 2013 Spruce For February 2014. At 2013 Spruce, be swept away by the elegance of living in a beautifully restored, grand historic brownstone that's fully loaded with condominium-grade, premier luxury amenities. Modern apartments in a meticulously restored, grand historic brownstone. Built in 1868 and located on the 2000 block of Spruce Street, this building is quintessentially Rittenhouse. Once the home to a prominent builder of Rittenhouse Sq. brownstones, 2013 Spruce is significantly larger than neighboring residences, and each apartment features lovingly restored historic details, high ceilings and decorative moldings. 2013 Spruce Street retains the elegant splendor of its day, while seamlessly incorporating the modern luxuries and amenities of today, in these spacious, well designed apartments. We invite you to come admire them for yourself. Hardwood Floors throughout. Kitchen in each unit is equipped with stainless steel appliances, granite counter tops, maple shaker style cabinetry, ceramic back splash and tile floors. Bathrooms have glass tile tub surround and tile floors. Front loading washer and dryer in each unit. This unit has a beautiful ornamental fireplace in the living area. Want to be up-to-date and in the know? Like us on Facebook. Just look up 2013 Spruce FB page!Please see attached floor plan. *Interior photo depicts comparable renovation at another AMC Delancey property. Heat is paid by the landlord."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "3+Story"
      floor: "9"
      fee: ""
      availableAt: "03/15/2014"
      secondDeposit: "$1,995"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: " Come See What We've Been Sprucing Up! Pre-Leasing 2013 Spruce For February 2014. At 2013 Spruce, be swept away by the elegance of living in a beautifully restored, grand historic brownstone that's fully loaded with condominium-grade, premier luxury amenities. Modern apartments in a meticulously restored, grand historic brownstone. Built in 1868 and located on the 2000 block of Spruce Street, this building is quintessentially Rittenhouse. Once the home to a prominent builder of Rittenhouse Sq. brownstones, 2013 Spruce is significantly larger than neighboring residences, and each apartment features lovingly restored historic details, high ceilings and decorative moldings. 2013 Spruce Street retains the elegant splendor of its day, while seamlessly incorporating the modern luxuries and amenities of today, in these spacious, well designed apartments. We invite you to come admire them for yourself. Hardwood Floors throughout. Kitchen in each unit is equipped with stainless steel appliances, granite counter tops, maple shaker style cabinetry, ceramic back splash and tile floors. Bathrooms have glass tile tub surround and tile floors. Front loading washer and dryer in each unit. This unit has a beautiful ornamental fireplace in the living area. Want to be up-to-date and in the know? Like us on Facebook. Just look up 2013 Spruce FB page!Please see attached floor plan. *Interior photo depicts comparable renovation at another AMC Delancey property. Heat is paid by the landlord."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODUwOTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTc0ODUyO30="
      mlsNo: "6323284"
      latitude: 39.948509
      longitude: -75.174852

    2455:
      name: "1612 South St 4"
      isPublished: true
      createdAt: "2014-02-18T15:09:35.000Z"
      onMap: false
      similar: []
      position: 47
      title: "1612 South St 4"
      summary: ""
      postal_code: "19146 19146"
      street: "1612 South St 4"
      price: "1650"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "2014"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantWtr", "TenantHtWtr"]
      heatingAndCooling: "Y"
      description: "Available January 1 - Brand new construction right on South Street within walking distance to several restaurants, bars, and public transportation. This unit has top-of-the-line finishes that include central air, washer/dryer in the unit, dishwasher, new stainless steel kitchen appliances, granite counter tops, and hardwood floors throughout. Each unit also includes a video intercom system. 12 month lease minimum - 15 Month lease preferred."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "1.5Story"
      floor: ""
      fee: ""
      availableAt: "01/01/2014"
      secondDeposit: "$3,300"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Available January 1 - Brand new construction right on South Street within walking distance to several restaurants, bars, and public transportation. This unit has top-of-the-line finishes that include central air, washer/dryer in the unit, dishwasher, new stainless steel kitchen appliances, granite counter tops, and hardwood floors throughout. Each unit also includes a video intercom system. 12 month lease minimum - 15 Month lease preferred."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5LjkyODAxNDY7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE1MjQwNzQ7fQ=="
      mlsNo: "6321689"
      latitude: 39.9280146
      longitude: -75.1524074

    2456:
      name: "1425 Locust St 4A"
      isPublished: true
      createdAt: "2014-02-23T09:59:44.000Z"
      onMap: false
      similar: []
      position: 48
      title: "1425 Locust St 4A"
      summary: ""
      postal_code: "19102 19102"
      street: "1425 Locust St 4A"
      price: "2695"
      bedrooms: "2"
      bathrooms: "2"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,272"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAir", "PublicWater", "PublicSewerGarages & Parking: NoGarage",
                 "StreetParkng", "ParkingLot", "PermitParkng Kit: KitW/NookBar Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantInsur", "CableTV", "OtherTenant", "CallToShow",
                 "TenantOcc"]
      heatingAndCooling: "Y"
      description: "Enjoy space, luxury and convenience at the ARIA! The living and dining areas offer soaring ceiling heights, gleaming hardwood floors and oversized windows which fill your space with light. The open plan kitchen is large and boasts a breakfast bar, all stainless steel appliances, and rich granite countertops. The spa-like bath features marble flooring, chrome fixtures and a ceramic sink with storage vanity. A 24 hour concierge, club room, pet spa, and on-site fitness center complete this deluxe apartment at the ARIA. Parking is available at a nearby public garage. Perfectly situated in the Rittenhouse/Avenue of the Arts area, this home is steps away from fine dining, one-of-a kind shopping, world-renowned cultural destinations and exciting nightlife."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "4"
      fee: ""
      availableAt: "01/01/2014"
      secondDeposit: "$2,695"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Enjoy space, luxury and convenience at the ARIA! The living and dining areas offer soaring ceiling heights, gleaming hardwood floors and oversized windows which fill your space with light. The open plan kitchen is large and boasts a breakfast bar, all stainless steel appliances, and rich granite countertops. The spa-like bath features marble flooring, chrome fixtures and a ceramic sink with storage vanity. A 24 hour concierge, club room, pet spa, and on-site fitness center complete this deluxe apartment at the ARIA. Parking is available at a nearby public garage. Perfectly situated in the Rittenhouse/Avenue of the Arts area, this home is steps away from fine dining, one-of-a kind shopping, world-renowned cultural destinations and exciting nightlife."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODU5NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1ODk4O30="
      mlsNo: "6303809"
      latitude: 39.948595
      longitude: -75.165898

    2457:
      name: "2018-32 Walnut St 16E"
      isPublished: true
      createdAt: "2014-02-23T09:59:49.000Z"
      onMap: false
      similar: []
      position: 49
      title: "2018-32 Walnut St 16E"
      summary: ""
      postal_code: "19103 19103"
      street: "2018-32 Walnut St 16E"
      price: "2800"
      bedrooms: "2"
      bathrooms: "2"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,198"
      plotArea: ""
      yearOfCompletion: "1984"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: 1-CarGarage Kit: EatInKitchen", "Range",
                 "Refrigerator", "Washer", "Dryer", "Dishwasher", "Microwave",
                 "Disposal Bsmt: NoBasement Interior: MainFlrLndry", "NoModifs/Unk Other: TenantElec", "TenantHeat",
                 "TenantInsur", "CableTV", "CallToShow"]
      heatingAndCooling: "Y"
      description: "Sun filled two bedroom, two bathroom condominium with garage parking in The Wanamaker House, one block off of Rittenhouse Square. This rental has floor to ceiling corner windows, eat in kitchen, great closet space and a washer/dryer. The Wanamaker House is a 24 hour doorman building with a rooftop pool and fitness room. First month's rent, last month's rent and one month security deposit required at the signing of the lease. There is a $15 fee for a credit check and tenant is responsible for any move in or move out fees. Electric and cable are separate."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "16"
      fee: "15"
      availableAt: "02/05/2014"
      secondDeposit: "$2,800"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Sun filled two bedroom, two bathroom condominium with garage parking in The Wanamaker House, one block off of Rittenhouse Square. This rental has floor to ceiling corner windows, eat in kitchen, great closet space and a washer/dryer. The Wanamaker House is a 24 hour doorman building with a rooftop pool and fitness room. First month's rent, last month's rent and one month security deposit required at the signing of the lease. There is a $15 fee for a credit check and tenant is responsible for any move in or move out fees. Electric and cable are separate."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDU0MDQ7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDcwNDI7fQ=="
      mlsNo: "6334516"
      latitude: 39.9505404
      longitude: -75.1747042
      "3bedroom":
        from: 2800

      "2bedroom":
        from: 2000

      "1bedroom":
        from: 1400

      studio:
        from: 1200

    2459:
      name: "1820 Cecil B Moore Ave"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 57
      title: "1820 Cecil B Moore Ave"
      summary: ""
      postal_code: "19121 19121"
      street: "1820 Cecil B Moore Ave"
      price: "550"
      bedrooms: ""
      bathrooms: ""
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "2014"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: FinishedBsmt Interior: CommonLndry",
                 "NoModifs/Unk Other: TenantElec"]
      heatingAndCooling: "Y"
      description: "New Construction. Well Priced. Ready to Move Right in. There are Four Studio Apartments Available At This Location. Studio Apartments Include Small Kitchenette & Full Bathroom. 2 Lower Level Studio Apartments With Windows Available at this Price. It is a very Convenient Location for Temple University Students."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "2.5 Story"
      floor: ""
      fee: ""
      availableAt: "10/28/2013"
      secondDeposit: "$550"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "New Construction. Well Priced. Ready to Move Right in. There are Four Studio Apartments Available At This Location. Studio Apartments Include Small Kitchenette & Full Bathroom. 2 Lower Level Studio Apartments With Windows Available at this Price. It is a very Convenient Location for Temple University Students."
      furnished: "Y"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk3OTM4NDg7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NTAxNzY7fQ=="
      mlsNo: "6299521"
      latitude: 39.9793848
      longitude: -75.1650176

    2460:
      name: "1634 N Gratz St"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 58
      title: "1634 N Gratz St"
      summary: ""
      postal_code: "19121 19121"
      street: "1634 N Gratz St"
      price: "595"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,680"
      plotArea: ""
      yearOfCompletion: "1920"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: FullBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: NoneTentResp"]
      heatingAndCooling: "Y"
      description: "Student Housing Rooms for Rent - Unit B1, 2nd Floor & Unit B4, 3rd Floor - each room - $595/mo. including all utilities, cable and flat screen TV - convenient to Temple University, Center City & shopping - hardwood floors - each room shares modern bath and kitchen with SS appliances - laundry in building - central air - security system (cost shared by tenants)."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "02/13/2014"
      secondDeposit: "$595"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Student Housing Rooms for Rent - Unit B1, 2nd Floor & Unit B4, 3rd Floor - each room - $595/mo. including all utilities, cable and flat screen TV - convenient to Temple University, Center City & shopping - hardwood floors - each room shares modern bath and kitchen with SS appliances - laundry in building - central air - security system (cost shared by tenants)."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk3OTA3OTY7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NTM5NzI7fQ=="
      mlsNo: "6338058"
      latitude: 39.9790796
      longitude: -75.1653972

    2461:
      name: "2321 N 25th St"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 59
      title: "2321 N 25th St"
      summary: ""
      postal_code: "19132 19132"
      street: "2321 N 25th St"
      price: "550"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,800"
      plotArea: ""
      yearOfCompletion: "1915"
      features: ["Heating/Cooling/Utilities: NoA/CGarages & Parking: NoGarage Kit: FullKit Bsmt: FullBasement Interior: NoLaundry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantHtWtr", "TenantInsur",
                 "TenantSnow", "TenantTrash", "CableTV", "OtherTenant"]
      heatingAndCooling: "N"
      description: "Welcome to this spacious 3rd floor one bedroom apartment that features laminate hardwood floors in the living room, ceramic tile floors in the kitchen and bathroom, and wall to wall carpet in the bedroom. Housing Choice Vouchers are welcome. Schedule to see now and submit an application today. Need copies of ID, Social, and Proof of Income along with application to process. Last 4 pay stubs or award letters."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "3+Story"
      floor: ""
      fee: "60"
      availableAt: "02/18/2014"
      secondDeposit: "$1,100"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Welcome to this spacious 3rd floor one bedroom apartment that features laminate hardwood floors in the living room, ceramic tile floors in the kitchen and bathroom, and wall to wall carpet in the bedroom. Housing Choice Vouchers are welcome. Schedule to see now and submit an application today. Need copies of ID, Social, and Proof of Income along with application to process. Last 4 pay stubs or award letters."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk5MDU4MztzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTczMzA1O30="
      mlsNo: "6339567"
      latitude: 39.990583
      longitude: -75.173305

    2462:
      name: "2305-7 N Broad St"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 60
      title: "2305-7 N Broad St"
      summary: ""
      postal_code: "19132 19132"
      street: "2305-7 N Broad St"
      price: "600"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "13,306"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: 4+CarGarage Kit: FullKit Bsmt: NoBasement Interior: KeyedEntr",
                 "NoLaundry", "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantHtWtr", "TenantInsur",
                 "CableTV"]
      heatingAndCooling: "N"
      description: "Great location! Close to temple and transportation. Nice size one bedroom apartments for rent we have 2 units left Apt 2 and 3 freshly painted, wood floors both unit are on the 2nd floor, lots floor of windows, Fire escape. No elevator. Please call to schedule an appointment. Very EZ to show M-F 9-4 weekend are a must confirm."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "02/01/2014"
      secondDeposit: "$600"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Great location! Close to temple and transportation. Nice size one bedroom apartments for rent we have 2 units left Apt 2 and 3 freshly painted, wood floors both unit are on the 2nd floor, lots floor of windows, Fire escape. No elevator. Please call to schedule an appointment. Very EZ to show M-F 9-4 weekend are a must confirm."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MzcxOTQ7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2MzIyMDE7fQ=="
      mlsNo: "6331856"
      latitude: 39.9537194
      longitude: -75.1632201

    2463:
      name: "2459 N 6th St 2R"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 61
      title: "2459 N 6th St 2R"
      summary: ""
      postal_code: "19133 19133"
      street: "2459 N 6th St 2R"
      price: "500"
      bedrooms: "0"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "2,320"
      plotArea: ""
      yearOfCompletion: "1959"
      features: ["Heating/Cooling/Utilities: ElectricHeat", "NoA/C", "ElectricHWt", "PublicWater",
                 "PrivateWatrGarages & Parking: NoGarage", "StreetParkng Kit: FullKit", "Range",
                 "Refrigerator Bsmt: NoBasement Interior: FinishedWood", "TileFlr", "CeilngFan(s)", "KeyedEntr",
                 "NoLaundry", "NoModifs/Unk Exterior: Sidewalks", "StreetLights", "BrickExt",
                 "CornerLot Other: TenantElec", "TenantHeat", "TenantHtWtr", "TenantSnow", "TenantTrash", "CableTV",
                 "CallToShow", "LAMustAccShw"]
      heatingAndCooling: "N"
      description: "This is a comfortable & clean studio apartment on second floor laid with hardwood floors and ceramic tile. Roomy kitchen/living space. High ceilings and ceiling fan. Separate modern bathroom. Fridge and stove included. Tenant responsible electric use."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "3+Story"
      floor: "2"
      fee: "45"
      availableAt: "10/09/2013"
      secondDeposit: "$550"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "This is a comfortable & clean studio apartment on second floor laid with hardwood floors and ceramic tile. Roomy kitchen/living space. High ceilings and ceiling fan. Separate modern bathroom. Fridge and stove included. Tenant responsible electric use."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk4OTE0MjtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTQyNjUxO30="
      mlsNo: "6294156"
      latitude: 39.989142
      longitude: -75.142651

    2464:
      name: "1307 E Moyamensing Ave"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 62
      title: "1307 E Moyamensing Ave"
      summary: ""
      postal_code: "19147 19147"
      street: "1307 E Moyamensing Ave"
      price: "550"
      bedrooms: "0"
      bathrooms: "0"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "2,025"
      plotArea: ""
      yearOfCompletion: "1914"
      features: ["Heating/Cooling/Utilities: NoA/CGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: NoLaundry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantWtr", "TenantSwr", "TenantHtWtr",
                 "TenantInsur", "TenantLawn", "TenantSnow", "TenantTrash", "CableTV", "OtherTenant"]
      heatingAndCooling: "N"
      description: "Large garage, with electricity and a steel door. Main opening is: 8 feet wide, 7 foot high, inside:21feet deep, 17 feet wide, 8 feet high ceilings."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "1Story"
      floor: ""
      fee: ""
      availableAt: "09/01/2013"
      secondDeposit: "$1,700"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Large garage, with electricity and a steel door. Main opening is: 8 feet wide, 7 foot high, inside:21feet deep, 17 feet wide, 8 feet high ceilings."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5LjkzMTQ3MjtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTQ5MTI7fQ=="
      mlsNo: "6272429"
      latitude: 39.931472
      longitude: -75.14912

    2465:
      name: "1534 S 4th St"
      isPublished: true
      createdAt: "2014-02-25T11:00:00.000Z"
      onMap: true
      similar: []
      position: 63
      title: "1534 S 4th St"
      summary: ""
      postal_code: "19147 19147"
      street: "1534 S 4th St"
      price: "600"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,576"
      plotArea: ""
      yearOfCompletion: "1915"
      features: ["Heating/Cooling/Utilities: NoA/CGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: NoBasement Interior: NoLaundry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantInsur", "TenantSnow",
                 "TenantTrash", "CableTV", "OtherTenant", "CallToShow", "24HrNoticShw", "TenantOcc"]
      heatingAndCooling: "N"
      description: "1 bedroom apt for rent on the 3rd Fl. The bedroom is very big and well lighted. Very nice condition. Apt is available after March 1st."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "3+Story"
      floor: ""
      fee: "50"
      availableAt: "02/21/2014"
      secondDeposit: "$600"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "1 bedroom apt for rent on the 3rd Fl. The bedroom is very big and well lighted. Very nice condition. Apt is available after March 1st."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5LjkyODU4ODI7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE1MjE2MTg7fQ=="
      mlsNo: "6341306"
      latitude: 39.9285882
      longitude: -75.1521618

    2492:
      name: "1425 Locust St 15D"
      isPublished: true
      createdAt: "2014-02-27T17:26:32.000Z"
      onMap: false
      similar: []
      position: 64
      heatingAndCooling: "Y"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "883"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAir", "PublicWater", "PublicSewerGarages & Parking: NoGarage",
                 "StreetParkng", "PermitParkng",
                 "ParkingGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: FinishedWood", "MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantInsur", "CableTV", "OtherTenant", "ClubFee",
                 "HealthFee", "Security", "CallToShow"]
      bedrooms: "1"
      price: "2275"
      street: "1425 Locust St 15D"
      summary: ""
      postal_code: "19102 19102"
      title: "1425 Locust St 15D"
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "15"
      fee: ""
      availableAt: "02/15/2014"
      secondDeposit: "$2,295"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Enjoy space, luxury and convenience at the ARIA! The living and dining areas offer soaring ceiling heights, gleaming hardwood floors and oversized windows which flood your space with an abundance of light. The open plan kitchen is large and boasts a breakfast bar, all stainless steel appliances, and rich granite countertops. The spa-like bathroom features marble flooring, chrome fixtures and a ceramic sink with storage vanity. A 24 hour concierge, club room, pet spa, and on-site fitness center complete this beautiful apartment at the ARIA. Parking is available at a nearby public garage. Perfectly situated in the Rittenhouse / Avenue of the Arts area, this home is steps away from fine dining, one-of-a kind shopping, world-renowned cultural destinations and exciting nightlife."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODU5NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1ODk4O30="
      mlsNo: "6313417"
      specialOffer: ""
      description: "Enjoy space, luxury and convenience at the ARIA! The living and dining areas offer soaring ceiling heights, gleaming hardwood floors and oversized windows which flood your space with an abundance of light. The open plan kitchen is large and boasts a breakfast bar, all stainless steel appliances, and rich granite countertops. The spa-like bathroom features marble flooring, chrome fixtures and a ceramic sink with storage vanity. A 24 hour concierge, club room, pet spa, and on-site fitness center complete this beautiful apartment at the ARIA. Parking is available at a nearby public garage. Perfectly situated in the Rittenhouse / Avenue of the Arts area, this home is steps away from fine dining, one-of-a kind shopping, world-renowned cultural destinations and exciting nightlife."
      latitude: 39.948595
      longitude: -75.165898

    2493:
      name: "1425 Locust St 17B"
      isPublished: true
      createdAt: "2014-02-27T17:26:39.000Z"
      onMap: false
      similar: []
      position: 65
      mlsNo: "6306621"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODU5NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1ODk4O30="
      city: "Philadelphia"
      country: "U.S.A"
      pets: "R"
      applyAt: ""
      furnished: "N"
      other: ""
      remarks: "Beautiful one bedroom complete with an extra half bath and two closets in foyer. Dark Cherry hardwood floors in common areas, carpet in the bedroom, maximum closet space. South/East exposure with lots of windows lining the entire condo. Light granite countertops with over head breakfast bar lighting. GE profile stainless steel appliances, bosch washer/dryer, and more. The Aria is a full service, concierge building, with 24 hour security, fitness center, owner's lounge, guest suite, pet spa, and more. This condo comes with an extra storage cage in the basement."
      minTerm: "12"
      parking: ""
      basement: ""
      secondDeposit: "$2,350"
      fee: "50"
      availableAt: "11/13/2013"
      floor: ""
      design: "HiRise"
      type: "UnitFlat"
      special: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      specialOffer: ""
      description: "Beautiful one bedroom complete with an extra half bath and two closets in foyer. Dark Cherry hardwood floors in common areas, carpet in the bedroom, maximum closet space. South/East exposure with lots of windows lining the entire condo. Light granite countertops with over head breakfast bar lighting. GE profile stainless steel appliances, bosch washer/dryer, and more. The Aria is a full service, concierge building, with 24 hour security, fitness center, owner's lounge, guest suite, pet spa, and more. This condo comes with an extra storage cage in the basement."
      title: "1425 Locust St 17B"
      summary: ""
      postal_code: "19102 19102"
      street: "1425 Locust St 17B"
      price: "2275"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "962"
      plotArea: ""
      yearOfCompletion: "2009"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: FullBasement Interior: Foyer/VestEn",
                 "MainFlrLndry", "NoModifs/Unk Other: TenantElec", "CableTV", "CallToShow"]
      heatingAndCooling: "Y"
      latitude: 39.948595
      longitude: -75.165898

    2494:
      name: "1425 Locust St 8B"
      isPublished: true
      createdAt: "2014-02-27T17:26:47.000Z"
      onMap: false
      similar: []
      position: 66
      mlsNo: "6342733"
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODU5NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1ODk4O30="
      applyAt: ""
      description: "Enjoy space, luxury and convenience at the ARIA which is a full service, concierge building with 24 hour security, fitness center, owner's lounge and conference room, pet spa, business center, guest suite for $130.00 per night and dog walk area(75 lb. pet restriction). The living and dining areas offer soaring ceiling heights, hardwood floors and oversized windows providing an abundance of light. The open kitchen is large with a breakfast bar, all stainless steel appliances, and rich granite countertops. Plenty of closet space with custom built in shelves and in unit washer and dryer. Parking is available at a nearby public garages. Perfectly situated in the Rittenhouse Square/Avenue of the Arts neighborhood, this home is steps away from fine dining, shopping, world-renowned cultural destinations and exciting nightlife."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "8"
      fee: ""
      availableAt: "03/01/2014"
      secondDeposit: "$2,000"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Enjoy space, luxury and convenience at the ARIA which is a full service, concierge building with 24 hour security, fitness center, owner's lounge and conference room, pet spa, business center, guest suite for $130.00 per night and dog walk area(75 lb. pet restriction). The living and dining areas offer soaring ceiling heights, hardwood floors and oversized windows providing an abundance of light. The open kitchen is large with a breakfast bar, all stainless steel appliances, and rich granite countertops. Plenty of closet space with custom built in shelves and in unit washer and dryer. Parking is available at a nearby public garages. Perfectly situated in the Rittenhouse Square/Avenue of the Arts neighborhood, this home is steps away from fine dining, shopping, world-renowned cultural destinations and exciting nightlife."
      furnished: "N"
      pets: "R"
      heatingAndCooling: "Y"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: FinishedWood",
                 "FullBath-MBR", "Foyer/VestEn", "MainFlrLndry", "MoblImprMods", "VislImprMods Other: TenantElec",
                 "TenantHeat", "TenantGas", "TenantInsur", "CableTV"]
      yearOfCompletion: "2009"
      plotArea: ""
      sqft: "932"
      phone: ""
      price: "2375"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      street: "1425 Locust St 8B"
      postal_code: "19102 19102"
      summary: ""
      title: "1425 Locust St 8B"
      latitude: 39.948595
      longitude: -75.165898

    2495:
      name: "1411-19 Walnut St"
      isPublished: true
      createdAt: "2014-02-27T17:26:49.000Z"
      onMap: false
      similar: []
      position: 67
      type: "Single/Dtchd"
      special: ""
      specialOffer: ""
      design: "HiRise"
      floor: ""
      fee: ""
      minTerm: "1"
      availableAt: "10/01/2013"
      secondDeposit: "$2,750"
      mlsNo: "6291738"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTY0MztzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY0OTM3O30="
      city: "Philadelphia"
      country: "U.S.A"
      applyAt: ""
      pets: "Y"
      furnished: "Y"
      remarks: " Fully furnished, luxury apt, min 1 month, by Rittenhouse sq, all linens, towels, stocked kitchen, houseware items, access to the sporting clb at the bellevue hotel, part time doorman, etc"
      other: ""
      basement: ""
      parking: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      description: " Fully furnished, luxury apt, min 1 month, by Rittenhouse sq, all linens, towels, stocked kitchen, houseware items, access to the sporting clb at the bellevue hotel, part time doorman, etc"
      heatingAndCooling: "Y"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: NoneTentResp"]
      yearOfCompletion: "1953"
      plotArea: ""
      phone: ""
      sqft: "750"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      bathrooms: "1"
      bedrooms: "1"
      price: "2450"
      summary: ""
      postal_code: "19102 19102"
      street: "1411-19 Walnut St"
      title: "1411-19 Walnut St"
      latitude: 39.949643
      longitude: -75.164937

    2496:
      name: "1425 Locust St 14F"
      isPublished: true
      createdAt: "2014-02-27T17:26:56.000Z"
      onMap: false
      similar: []
      position: 68
      title: "1425 Locust St 14F"
      summary: ""
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "969"
      plotArea: ""
      yearOfCompletion: "2009"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: FullBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV"]
      heatingAndCooling: "Y"
      street: "1425 Locust St 14F"
      price: "2500"
      bedrooms: "1"
      postal_code: "19102 19102"
      mlsNo: "6314861"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: "250"
      availableAt: "12/05/2013"
      secondDeposit: "$2,550"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Largest layout one bedroom in the Aria. Perfect corner unit with den, outfitted with dark cherry hardwood floors, open kitchen, light granite countertops, upgraded lighting, stainless steel appliances. The bedroom has large walk in closet, windows on both sides facing north/west. The bathroom is oversized with light marble countertops, floors, and backsplash. High ceilings and the unit has been meticulously maintained. The Aria is a full service, concierge building, with 24 hour security, fitness center, owner's lounge, pet spa, business center, dog walk area, and more. Comes with storage cage in the basement."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODU5NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1ODk4O30="
      description: "Largest layout one bedroom in the Aria. Perfect corner unit with den, outfitted with dark cherry hardwood floors, open kitchen, light granite countertops, upgraded lighting, stainless steel appliances. The bedroom has large walk in closet, windows on both sides facing north/west. The bathroom is oversized with light marble countertops, floors, and backsplash. High ceilings and the unit has been meticulously maintained. The Aria is a full service, concierge building, with 24 hour security, fitness center, owner's lounge, pet spa, business center, dog walk area, and more. Comes with storage cage in the basement."
      latitude: 39.948595
      longitude: -75.165898

    2497:
      name: "1530-32 Spruce St 822"
      isPublished: true
      createdAt: "2014-02-28T14:55:10.000Z"
      onMap: false
      similar: []
      position: 69
      heatingAndCooling: "Y"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: NoBasement Interior: CommonLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantInsur", "OtherTenant", "CallToShow",
                 "24HrNoticShw"]
      description: "Small studio with New kitchen, hardwood floors. Great location. Amazing views of the city!!! This unit is located in the heart of the city. Rittenhouse is 3 blocks away, Kimmel Center is 2 blocks away. Needless to say, it is a fantastic location. There is a FREE GYM in the basement."
      other: ""
      remarks: "Small studio with New kitchen, hardwood floors. Great location. Amazing views of the city!!! This unit is located in the heart of the city. Rittenhouse is 3 blocks away, Kimmel Center is 2 blocks away. Needless to say, it is a fantastic location. There is a FREE GYM in the basement."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0NTQ5MzE7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE1NTUzMDg7fQ=="
      mlsNo: "6305727"
      basement: ""
      availableAt: "11/11/2013"
      secondDeposit: "$1,250"
      minTerm: "12"
      parking: ""
      fee: ""
      floor: ""
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "1Story"
      sqft: "35,244"
      phone: ""
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      bedrooms: "0"
      price: "1050"
      street: "1530-32 Spruce St 822"
      title: "1530-32 Spruce St 822"
      summary: ""
      postal_code: "19102 19102"
      latitude: 39.9454931
      longitude: -75.1555308

    2498:
      name: "235 S 15th St 405"
      isPublished: true
      createdAt: "2014-02-28T14:55:13.000Z"
      onMap: false
      similar: []
      position: 70
      description: "Light filled studio at THE VIDA centrally located in the Arts and Entertainment district of CENTER CITY, The Vida is a historically preserved mid rise building that combines old world charm with modern convenience. from the original sculpted ceilings to the beautifully preserved butler kitchens and French doors, many of the original building features have been retained. The building is located within walking distance of Rittenhouse Square, numerous performing art colleges and surrounded by all forms of public transportation. original hardwood flooring, porcelain bath fixtures, on site laundry facilities"
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODQwNTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NjEzMzY7fQ=="
      mlsNo: "6341355"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "Other"
      floor: ""
      fee: ""
      availableAt: "03/30/2014"
      secondDeposit: "$1,050"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Light filled studio at THE VIDA centrally located in the Arts and Entertainment district of CENTER CITY, The Vida is a historically preserved mid rise building that combines old world charm with modern convenience. from the original sculpted ceilings to the beautifully preserved butler kitchens and French doors, many of the original building features have been retained. The building is located within walking distance of Rittenhouse Square, numerous performing art colleges and surrounded by all forms of public transportation. original hardwood flooring, porcelain bath fixtures, on site laundry facilities"
      title: "235 S 15th St 405"
      summary: ""
      postal_code: "19102 19102"
      street: "235 S 15th St 405"
      price: "1050"
      bedrooms: "0"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1927"
      heatingAndCooling: "N"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: BsmtLaundry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantInsur", "CableTV", "OtherTenant"]
      phone: ""
      latitude: 39.9484059
      longitude: -75.1661336

    2499:
      name: "1411-19 Walnut St 1002"
      isPublished: true
      createdAt: "2014-02-28T14:55:15.000Z"
      onMap: false
      similar: []
      position: 71
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTY0MztzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY0OTM3O30="
      mlsNo: "6320883"
      city: "Philadelphia"
      country: "U.S.A"
      applyAt: ""
      pets: "Y"
      furnished: "N"
      floor: ""
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV", "OtherTenant"]
      heatingAndCooling: "Y"
      description: "Fabulous 1 bedroom apartment available at this beautifully maintained mid-rise building 1411 Walnut, centrally located one block off the Avenue of the Arts. Steps from your front door, you will find a wide array of dining, shopping, and entertainment options. Just minutes from Rittenhouse Square Park, numerous performing arts colleges, and all forms of public transportation."
      street: "1411-19 Walnut St 1002"
      price: "1375"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      title: "1411-19 Walnut St 1002"
      summary: ""
      postal_code: "19102 19102"
      availableAt: "04/15/2014"
      secondDeposit: "$1,375"
      minTerm: "12"
      parking: ""
      basement: ""
      fee: ""
      remarks: "Fabulous 1 bedroom apartment available at this beautifully maintained mid-rise building 1411 Walnut, centrally located one block off the Avenue of the Arts. Steps from your front door, you will find a wide array of dining, shopping, and entertainment options. Just minutes from Rittenhouse Square Park, numerous performing arts colleges, and all forms of public transportation."
      other: ""
      latitude: 39.949643
      longitude: -75.164937

    2500:
      name: "218 S 16th St B"
      isPublished: true
      createdAt: "2014-02-28T14:55:16.000Z"
      onMap: false
      similar: []
      position: 72
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "CableTV"]
      sqft: ""
      phone: ""
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      bathrooms: "1"
      bedrooms: "1"
      price: "1400"
      street: "218 S 16th St B"
      postal_code: "19102 19102"
      summary: ""
      title: "218 S 16th St B"
      furnished: "N"
      plotArea: ""
      yearOfCompletion: "1984"
      parking: ""
      basement: ""
      other: ""
      remarks: "Location Location Location!!!! Offering at an amazing discounted price. In the heart of Center City, just a block away from Rittnhouse Square. Owners extremely motivated! Cozy, beautiful 1 bedroom (Could be used as 2 Bedroom). Walking distance to downtown, numerous restaurants, shopping, retail, Apple Store etc. Must SEE!!! Easy to show. Parking available at discounted price in the adjoining garage."
      special: ""
      type: "UnitFlat"
      design: "LoRise"
      floor: ""
      fee: ""
      availableAt: "01/15/2014"
      secondDeposit: "$1,400"
      minTerm: "12"
      description: "Location Location Location!!!! Offering at an amazing discounted price. In the heart of Center City, just a block away from Rittnhouse Square. Owners extremely motivated! Cozy, beautiful 1 bedroom (Could be used as 2 Bedroom). Walking distance to downtown, numerous restaurants, shopping, retail, Apple Store etc. Must SEE!!! Easy to show. Parking available at discounted price in the adjoining garage."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      mlsNo: "6323404"
      pets: "N"
      heatingAndCooling: "Y"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTE4MTY7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NzgzNTg7fQ=="
      applyAt: ""
      country: "U.S.A"
      latitude: 39.9491816
      longitude: -75.1678358

    2501:
      name: "1411-19 Walnut St 309"
      isPublished: true
      createdAt: "2014-02-28T14:55:18.000Z"
      onMap: false
      similar: []
      position: 73
      title: "1411-19 Walnut St 309"
      summary: ""
      phone: ""
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      price: "1410"
      bedrooms: "1"
      bathrooms: "1"
      street: "1411-19 Walnut St 309"
      postal_code: "19102 19102"
      plotArea: ""
      heatingAndCooling: "Y"
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV", "OtherTenant"]
      sqft: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      description: "Fabulous 1 bedroom available at this beautifully maintained mid-rise building 1411 Walnut, centrally located one block off the Avenue of the Arts. Steps from your front door, you will find a wide array of dining, shopping, and entertainment options. Just minutes from Rittenhouse Square Park, numerous performing arts colleges, and all forms of public transportation."
      specialOffer: ""
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      availableAt: "11/12/2013"
      secondDeposit: "$1,410"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Fabulous 1 bedroom available at this beautifully maintained mid-rise building 1411 Walnut, centrally located one block off the Avenue of the Arts. Steps from your front door, you will find a wide array of dining, shopping, and entertainment options. Just minutes from Rittenhouse Square Park, numerous performing arts colleges, and all forms of public transportation."
      mlsNo: "6306194"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0NzI1NTM7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE0Njg1MzI7fQ=="
      city: "Philadelphia"
      design: "HiRise"
      floor: ""
      fee: ""
      latitude: 39.9472553
      longitude: -75.1468532

    2502:
      name: "1420 Locust St 10G"
      isPublished: true
      createdAt: "2014-02-28T14:55:24.000Z"
      onMap: false
      similar: []
      position: 74
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0Nzk1NDtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1ODgyO30="
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "12/04/2013"
      secondDeposit: "$1,595"
      minTerm: "12"
      special: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      specialOffer: ""
      description: "Spacious one bedroom one bath condominium facing east with early morning sun. Tile Floor thru-out entry, kitchen and living room. Good closet space, washer dryer in unit. Rent includes all utilities and basic cable Avail asap. Building also has a pool and gym area available at no charge. Parking onsite for an extra monthly fee. Building requires a move in, criminal background and credit and an additional $35.00 fee for credit . Owner prefers a lease to end 3/31/15 or 4/31/15. If interested listing agent will prepare lease."
      mlsNo: "6313812"
      parking: ""
      basement: ""
      other: ""
      remarks: "Spacious one bedroom one bath condominium facing east with early morning sun. Tile Floor thru-out entry, kitchen and living room. Good closet space, washer dryer in unit. Rent includes all utilities and basic cable Avail asap. Building also has a pool and gym area available at no charge. Parking onsite for an extra monthly fee. Building requires a move in, criminal background and credit and an additional $35.00 fee for credit . Owner prefers a lease to end 3/31/15 or 4/31/15. If interested listing agent will prepare lease."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      phone: ""
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      yearOfCompletion: "1978"
      plotArea: ""
      sqft: "789"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: 4+CarGarage",
                 "ParkingGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: NoneTentResp", "CallToShow"]
      heatingAndCooling: "Y"
      bathrooms: "1"
      bedrooms: "1"
      price: "1595"
      street: "1420 Locust St 10G"
      summary: ""
      postal_code: "19102 19102"
      title: "1420 Locust St 10G"
      latitude: 39.947954
      longitude: -75.165882

    2503:
      name: "220-24 S 16th St 1002"
      isPublished: true
      createdAt: "2014-02-28T14:55:26.000Z"
      onMap: false
      similar: []
      position: 75
      price: "1875"
      bedrooms: "2"
      street: "220-24 S 16th St 1002"
      postal_code: "19102 19102"
      title: "220-24 S 16th St 1002"
      summary: ""
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      bathrooms: "1"
      mlsNo: "6307843"
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjIxOTg7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NzAwMDQ7fQ=="
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "Other"
      floor: ""
      fee: ""
      availableAt: "11/15/2013"
      secondDeposit: "$1,875"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "In the heart of center City, just 2 blocks from RITTENHOUSE SQUARE, this well priced 2 BEDROOM apartment has all open kitchen, good sized living and dining area, and great natural sunlight. Elevator building. A must see!!"
      description: "In the heart of center City, just 2 blocks from RITTENHOUSE SQUARE, this well priced 2 BEDROOM apartment has all open kitchen, good sized living and dining area, and great natural sunlight. Elevator building. A must see!!"
      heatingAndCooling: "Y"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: NoLaundry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantWtr", "TenantInsur", "TenantTrash",
                 "CableTV"]
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1015"
      phone: ""
      latitude: 39.9522198
      longitude: -75.1670004

    2504:
      name: "235 S 15th St 1104"
      isPublished: true
      createdAt: "2014-02-28T14:55:29.000Z"
      onMap: false
      similar: []
      position: 76
      price: "1875"
      street: "235 S 15th St 1104"
      postal_code: "19102 19102"
      summary: ""
      title: "235 S 15th St 1104"
      mlsNo: "6291503"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODQwNTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NjEzMzY7fQ=="
      city: "Philadelphia"
      country: "U.S.A"
      applyAt: ""
      furnished: "N"
      pets: "N"
      description: "Centrally located n the Arts and Entertainment district of Center City, The Vida is a historically preserved mid rise building that combines old world charm with modern convenience. from the original sculpted ceilings to the beautifully preserved butler kitchens and French doors, many of the original building features have been retained. The building is located within walking distance of Rittenhouse Square, numerous performing art colleges and surrounded by all forms of public transportation. original hardwood flooring, porcelain bath fixtures, on site laundry facilities"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "10/09/2013"
      secondDeposit: "$1,875"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Centrally located n the Arts and Entertainment district of Center City, The Vida is a historically preserved mid rise building that combines old world charm with modern convenience. from the original sculpted ceilings to the beautifully preserved butler kitchens and French doors, many of the original building features have been retained. The building is located within walking distance of Rittenhouse Square, numerous performing art colleges and surrounded by all forms of public transportation. original hardwood flooring, porcelain bath fixtures, on site laundry facilities"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: BsmtLaundry",
                 "NoModifs/Unk Other: TenantElec", "OtherTenant"]
      heatingAndCooling: "N"
      yearOfCompletion: "1928"
      plotArea: ""
      sqft: ""
      phone: ""
      bedrooms: "2"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      latitude: 39.9484059
      longitude: -75.1661336

    2505:
      name: "1411-19 Walnut St 808"
      isPublished: true
      createdAt: "2014-02-28T14:55:30.000Z"
      onMap: false
      similar: []
      position: 77
      remarks: "Fabulous 2 bedroom apartment available at this beautifully maintained mid-rise building 1411 Walnut, centrally located one block off the Avenue of the Arts. Steps from your front door, you will find a wide array of dining, shopping, and entertainment options. Just minutes from Rittenhouse Square Park, numerous performing arts colleges, and all forms of public transportation."
      other: ""
      parking: ""
      basement: ""
      minTerm: "12"
      secondDeposit: "$1,895"
      availableAt: "01/15/2014"
      design: "HiRise"
      floor: ""
      fee: ""
      type: "UnitFlat"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      description: "Fabulous 2 bedroom apartment available at this beautifully maintained mid-rise building 1411 Walnut, centrally located one block off the Avenue of the Arts. Steps from your front door, you will find a wide array of dining, shopping, and entertainment options. Just minutes from Rittenhouse Square Park, numerous performing arts colleges, and all forms of public transportation."
      heatingAndCooling: "Y"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV", "OtherTenant"]
      yearOfCompletion: "1015"
      plotArea: ""
      sqft: ""
      phone: ""
      street: "1411-19 Walnut St 808"
      price: "1895"
      bedrooms: "2"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      postal_code: "19102 19102"
      summary: ""
      title: "1411-19 Walnut St 808"
      mlsNo: "6320867"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTY0MztzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY0OTM3O30="
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      furnished: "N"
      latitude: 39.949643
      longitude: -75.164937

    2506:
      name: "235 S 15th St 801"
      isPublished: true
      createdAt: "2014-02-28T14:55:33.000Z"
      onMap: false
      similar: []
      position: 78
      city: "Philadelphia"
      country: "U.S.A"
      applyAt: ""
      pets: "N"
      furnished: "N"
      mlsNo: "6341398"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODQwNTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NjEzMzY7fQ=="
      heatingAndCooling: "N"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: BsmtLaundry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantInsur", "CableTV", "OtherTenant"]
      yearOfCompletion: "1927"
      phone: ""
      sqft: ""
      plotArea: ""
      bedrooms: "2"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      price: "1950"
      postal_code: "19102 19102"
      street: "235 S 15th St 801"
      summary: ""
      title: "235 S 15th St 801"
      remarks: "Light filled 2 bedroom at THE VIDA centrally located in the Arts and Entertainment district of CENTER CITY, The Vida is a historically preserved mid rise building that combines old world charm with modern convenience. from the original sculpted ceilings to the beautifully preserved butler kitchens and French doors, many of the original building features have been retained. The building is located within walking distance of Rittenhouse Square, numerous performing art colleges and surrounded by all forms of public transportation. original hardwood flooring, porcelain bath fixtures, on site laundry facilities"
      other: ""
      basement: ""
      parking: ""
      floor: ""
      fee: ""
      availableAt: "04/15/2014"
      secondDeposit: "$1,950"
      minTerm: "12"
      design: "Other"
      description: "Light filled 2 bedroom at THE VIDA centrally located in the Arts and Entertainment district of CENTER CITY, The Vida is a historically preserved mid rise building that combines old world charm with modern convenience. from the original sculpted ceilings to the beautifully preserved butler kitchens and French doors, many of the original building features have been retained. The building is located within walking distance of Rittenhouse Square, numerous performing art colleges and surrounded by all forms of public transportation. original hardwood flooring, porcelain bath fixtures, on site laundry facilities"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      latitude: 39.9484059
      longitude: -75.1661336

    2507:
      name: "1420 Locust St 32L"
      isPublished: true
      createdAt: "2014-02-28T14:55:40.000Z"
      onMap: false
      similar: []
      position: 79
      title: "1420 Locust St 32L"
      postal_code: "19102 19102"
      street: "1420 Locust St 32L"
      price: "1950"
      bedrooms: "1"
      bathrooms: "1"
      summary: ""
      heatingAndCooling: "Y"
      features: ["Heating/Cooling/Utilities: CentralAir", "PublicWater", "PublicSewerGarages & Parking: NoGarage",
                 "ParkingLot Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry", "NoModifs/Unk Other: CableTV",
                 "OtherTenant", "CallToShow"]
      yearOfCompletion: "1976"
      plotArea: ""
      phone: ""
      sqft: "706"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      description: "Very high floor rental at Academy House with a totally unobstructed southern panorama and floor to ceiling windows leading to your own balcony from which to enjoy it. This sun filled one bedroom home has been completely renovated with gleaming wood floors, a new kitchen (with a window) featuring granite counters and wooden cabinetry, beautifully renovated bathroom with large vanity, recessed lighting, and custom tile work. There is a washer/dryer in the bathroom. Rent includes utilities. Academy House has a front desk with 24 hour security, and there is a small indoor pool and fitness area included in the rent. First month's rent, last month's rent and one month security required at the signing of the lease. $15 credit check plus $35 check to Academy House is due as well. Move in fees are paid by tenant. Agent remarks: Listing agents will prepare the lease."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "32"
      fee: "15"
      availableAt: "04/01/2014"
      secondDeposit: "$1,950"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Very high floor rental at Academy House with a totally unobstructed southern panorama and floor to ceiling windows leading to your own balcony from which to enjoy it. This sun filled one bedroom home has been completely renovated with gleaming wood floors, a new kitchen (with a window) featuring granite counters and wooden cabinetry, beautifully renovated bathroom with large vanity, recessed lighting, and custom tile work. There is a washer/dryer in the bathroom. Rent includes utilities. Academy House has a front desk with 24 hour security, and there is a small indoor pool and fitness area included in the rent. First month's rent, last month's rent and one month security required at the signing of the lease. $15 credit check plus $35 check to Academy House is due as well. Move in fees are paid by tenant. Agent remarks: Listing agents will prepare the lease."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0Nzk1NDtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1ODgyO30="
      mlsNo: "6340106"
      latitude: 39.947954
      longitude: -75.165882

    2508:
      name: "220-24 S 16th St 1202"
      isPublished: true
      createdAt: "2014-02-28T14:55:41.000Z"
      onMap: false
      similar: []
      position: 80
      title: "220-24 S 16th St 1202"
      summary: ""
      postal_code: "19102 19102"
      street: "220-24 S 16th St 1202"
      price: "2200"
      bedrooms: "2"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: NoLaundry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantWtr", "TenantInsur", "CableTV"]
      heatingAndCooling: "Y"
      description: "In the heart of center City, just 2 blocks from RITTENHOUSE SQUARE, this well priced 2 BEDROOM apartment has all open kitchen, good sized living and dining area, and great natural sunlight. Elevator building. A must see!!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "12/27/2013"
      secondDeposit: "$2,200"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "In the heart of center City, just 2 blocks from RITTENHOUSE SQUARE, this well priced 2 BEDROOM apartment has all open kitchen, good sized living and dining area, and great natural sunlight. Elevator building. A must see!!"
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjIxOTg7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NzAwMDQ7fQ=="
      mlsNo: "6320104"
      latitude: 39.9522198
      longitude: -75.1670004

    2512:
      name: "1500 Chestnut St 9F"
      isPublished: true
      createdAt: "2014-02-28T14:56:13.000Z"
      onMap: false
      similar: []
      position: 81
      title: "1500 Chestnut St 9F"
      summary: ""
      postal_code: "19102 19102"
      street: "1500 Chestnut St 9F"
      price: "2395"
      bedrooms: "2"
      bathrooms: "2"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "918"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: OthFuel/Unkn", "CentralAir", "ElectricHWt", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage", "StreetParkng", "PermitParkng", "ParkingGarage Kit: FullKit",
                 "Range", "Refrigerator", "Washer", "Dryer", "Dishwasher", "Microwave",
                 "Disposal Bsmt: NoBasement Interior: FinishedWood", "MarbleFlr", "MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHtWtr", "TenantInsur", "CableTV", "OtherTenant",
                 "ComAreaMaint", "ExtBldgMaint", "LawnMaint", "SnowRemoval", "TrashRemoval", "HeatFee", "WaterFee",
                 "ClubFee", "HealthFee", "ManagmentFee", "Security", "CallToShow", "24HrNoticShw", "TenantOcc"]
      heatingAndCooling: "Y"
      description: "This deluxe two bedroom, two bath residence at the award winning Ellington is not to be missed! The elegant living and dining areas offer ten foot high ceilings, gleaming hardwood floors and a wall of windows which flood your space with an abundance of light. The gourmet kitchen boasts POGGENPOHL cabinets, all stainless steel appliances and rich granite countertops. The corner master bedroom is generously proportioned and features oversized windows. The large spa-like marble bathrooms feature chrome fixtures and ceramic sinks with storage vanities. Included in the rent are central air and heating, water and sewer, a 24 hour concierge, on-site fitness center and resident lounge. Convenient secured parking is available adjacent to the building in a public garage at a discounted resident's rate. Perfectly situated in the Rittenhouse and Avenue of the Arts area, this home is steps away from fine dining, one-of-a kind shopping, world-renowned cultural destinations and exciting nightlife. *Photos are from another unit with identical layout and similar finishes."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "9"
      fee: ""
      availableAt: "04/01/2014"
      secondDeposit: "$2,395"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "This deluxe two bedroom, two bath residence at the award winning Ellington is not to be missed! The elegant living and dining areas offer ten foot high ceilings, gleaming hardwood floors and a wall of windows which flood your space with an abundance of light. The gourmet kitchen boasts POGGENPOHL cabinets, all stainless steel appliances and rich granite countertops. The corner master bedroom is generously proportioned and features oversized windows. The large spa-like marble bathrooms feature chrome fixtures and ceramic sinks with storage vanities. Included in the rent are central air and heating, water and sewer, a 24 hour concierge, on-site fitness center and resident lounge. Convenient secured parking is available adjacent to the building in a public garage at a discounted resident's rate. Perfectly situated in the Rittenhouse and Avenue of the Arts area, this home is steps away from fine dining, one-of-a kind shopping, world-renowned cultural destinations and exciting nightlife. *Photos are from another unit with identical layout and similar finishes."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDgzNjtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1OTEyO30="
      mlsNo: "6340043"
      latitude: 39.950836
      longitude: -75.165912

    2516:
      name: "1530-32 Chestnut St U"
      isPublished: true
      createdAt: "2014-02-28T14:56:30.000Z"
      onMap: false
      similar: []
      position: 82
      title: "1530-32 Chestnut St U"
      summary: ""
      postal_code: "19102 19102"
      street: "1530-32 Chestnut St U"
      price: "2850"
      bedrooms: "2"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "51,550"
      plotArea: ""
      yearOfCompletion: "1954"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: NoneTentResp"]
      heatingAndCooling: "Y"
      description: "min 1 month, fully furnished, everything included, all utilities, internet, linens, towels, access to the sporting clb at the bellevue hotel"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "Single/Dtchd"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "10/01/2013"
      secondDeposit: "$3,250"
      minTerm: "1"
      parking: ""
      basement: ""
      other: ""
      remarks: "min 1 month, fully furnished, everything included, all utilities, internet, linens, towels, access to the sporting clb at the bellevue hotel"
      furnished: "Y"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTA5NTE7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NzA5NjM7fQ=="
      mlsNo: "6291741"
      latitude: 39.9510951
      longitude: -75.1670963

    2517:
      name: "1500 Chestnut St 7E"
      isPublished: true
      createdAt: "2014-02-28T14:56:32.000Z"
      onMap: false
      similar: []
      position: 83
      title: "1500 Chestnut St 7E"
      summary: ""
      postal_code: "19102 19102"
      street: "1500 Chestnut St 7E"
      price: "2850"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "759"
      plotArea: ""
      yearOfCompletion: "2004"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: NoneTentResp"]
      heatingAndCooling: "Y"
      description: "Fully furnished large 1br available for long term rental Everything included as well as access to the sporting clb at the bellevue hotel"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "Single/Dtchd"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "10/01/2013"
      secondDeposit: "$2,850"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Fully furnished large 1br available for long term rental Everything included as well as access to the sporting clb at the bellevue hotel"
      furnished: "Y"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDgzNjtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1OTEyO30="
      mlsNo: "6291736"
      latitude: 39.950836
      longitude: -75.165912

    2518:
      name: "111 S 15th St P315"
      isPublished: true
      createdAt: "2014-02-28T14:56:37.000Z"
      onMap: false
      similar: []
      position: 84
      title: "111 S 15th St P315"
      summary: ""
      postal_code: "19102 19102"
      street: "111 S 15th St P315"
      price: "3295"
      bedrooms: "2"
      bathrooms: "2"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,368"
      plotArea: ""
      yearOfCompletion: "2007"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "CableTV"]
      heatingAndCooling: "Y"
      description: "111 S. 15th 2 BEDROOM 2 1/2 BATHRO0MS BI LEVEL Penthouse for Rent with Private Balcony at The Packard Grande at 15th & Samson street! Enjoy living in this elevator doorman building with gym. Step into almost 1400 SQUARE FEET. Your living room and dining areas boast hardwood floors and sweeping city views and a PRIVATE terrace. Open and spacious kitchen with granite counter tops,and stainless steel appliances. 1/2 bath is also located on this level. Two bedrooms are very spacious with huge closets and each with their own marble BATH. Incredible light and SPECTACULAR VIEWS! A MUST SEE!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "12/20/2013"
      secondDeposit: "$3,595"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "111 S. 15th 2 BEDROOM 2 1/2 BATHRO0MS BI LEVEL Penthouse for Rent with Private Balcony at The Packard Grande at 15th & Samson street! Enjoy living in this elevator doorman building with gym. Step into almost 1400 SQUARE FEET. Your living room and dining areas boast hardwood floors and sweeping city views and a PRIVATE terrace. Open and spacious kitchen with granite counter tops,and stainless steel appliances. 1/2 bath is also located on this level. Two bedrooms are very spacious with huge closets and each with their own marble BATH. Incredible light and SPECTACULAR VIEWS! A MUST SEE!"
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDYwMDk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NTg3MTE7fQ=="
      mlsNo: "6294130"
      latitude: 39.9506009
      longitude: -75.1658711

    2519:
      name: "1425 Locust St 6C"
      isPublished: true
      createdAt: "2014-02-28T14:56:39.000Z"
      onMap: false
      similar: []
      position: 85
      title: "1425 Locust St 6C"
      summary: ""
      postal_code: "19102 19102"
      street: "1425 Locust St 6C"
      price: "3500"
      bedrooms: "2"
      bathrooms: "2"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,560"
      plotArea: ""
      yearOfCompletion: "2009"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV", "CookFee", "ManagmentFee"]
      heatingAndCooling: "Y"
      description: "Spacious layout two bedroom with two and a half baths. Enter through large foyer with coat closet and washer/dryer room. Continue into kitchen with granite countertops, overhead and under cabinet lighting, stainless steel appliances, breakfast bar, eat in dining room/living room combo. Hardwood floors throughout. Master bedroom has in suite bath with dual sinks, separate seamless glass shower/ tub. Guest room has large walk in closet and many windows. The Aria is a full service concierge building with 24 hour security, fitness center, owner's lounge, guest suite, business center, and more."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: "250"
      availableAt: "01/24/2014"
      secondDeposit: "$3,500"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Spacious layout two bedroom with two and a half baths. Enter through large foyer with coat closet and washer/dryer room. Continue into kitchen with granite countertops, overhead and under cabinet lighting, stainless steel appliances, breakfast bar, eat in dining room/living room combo. Hardwood floors throughout. Master bedroom has in suite bath with dual sinks, separate seamless glass shower/ tub. Guest room has large walk in closet and many windows. The Aria is a full service concierge building with 24 hour security, fitness center, owner's lounge, guest suite, business center, and more."
      furnished: "B"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODU5NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY1ODk4O30="
      mlsNo: "6330294"
      latitude: 39.948595
      longitude: -75.165898

    2520:
      name: "50 S 16th St 4204"
      isPublished: true
      createdAt: "2014-02-28T14:56:43.000Z"
      onMap: false
      similar: []
      position: 86
      title: "50 S 16th St 4204"
      summary: ""
      postal_code: "19102 19102"
      street: "50 S 16th St 4204"
      price: "4500"
      bedrooms: "2"
      bathrooms: "2"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,150"
      plotArea: ""
      yearOfCompletion: "1991"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: 4+CarGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantInsur", "CableTV"]
      heatingAndCooling: "Y"
      description: "FABULOUS CONDO IN THE SKY!!! Corner unit on the 42nd floor of 2 Liberty with Spectacular Views from every window! THIS CONDO IS 1 BED PLUS DEN. Den has no window but is adjacent to its own full bath. Five Star Amenities available: Full Concierge Services, Chauffeur-Driven Mercedes, Fitness Center, Media Room, Message Room, Yoga Studio, Pool,Resident's Entrance to Daniel Stern's R2L Restaurant and Lounge Bar. Pet Friendly with Pet Care Facility. 1 Bed with Den/Office. AVAILABLE IMMEDIATELY!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "01/15/2014"
      secondDeposit: "$4,500"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "FABULOUS CONDO IN THE SKY!!! Corner unit on the 42nd floor of 2 Liberty with Spectacular Views from every window! THIS CONDO IS 1 BED PLUS DEN. Den has no window but is adjacent to its own full bath. Five Star Amenities available: Full Concierge Services, Chauffeur-Driven Mercedes, Fitness Center, Media Room, Message Room, Yoga Studio, Pool,Resident's Entrance to Daniel Stern's R2L Restaurant and Lounge Bar. Pet Friendly with Pet Care Facility. 1 Bed with Den/Office. AVAILABLE IMMEDIATELY!"
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTk3MzY7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NzEyMjk7fQ=="
      mlsNo: "6302952"
      latitude: 39.9519736
      longitude: -75.1671229

    2521:
      name: "50 S 16th St 4005"
      isPublished: true
      createdAt: "2014-02-28T14:56:47.000Z"
      onMap: false
      similar: []
      position: 87
      title: "50 S 16th St 4005"
      summary: ""
      postal_code: "19102 19102"
      street: "50 S 16th St 4005"
      price: "5300"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,275"
      plotArea: ""
      yearOfCompletion: "1991"
      features: ["Heating/Cooling/Utilities: ElectricHeat", "CentralAir", "ElectricHWt", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage Kit: KitW/NookBar", "Range", "Refrigerator", "Washer", "Dryer",
                 "Dishwasher", "Microwave", "Disposal Bsmt: NoBasement Interior: NoFireplace", "FinishedWood",
                 "W/WCarpeting", "SecuritySys", "CableTVWired", "WhPoolHotTub", "FullBath-MBR", "SitArea-MBR",
                 "WICloset-MBR", "Foyer/VestEn", "Util/MudRoom", "MainFlrLndry", "NoModifs/Unk Exterior: Sidewalks",
                 "StreetLights", "CornerLot Other: TenantElec", "TenantInsur", "ComAreaMaint", "ExtBldgMaint",
                 "SnowRemoval", "TrashRemoval", "WaterFee", "SewerFee", "SwimFee", "ClubFee", "HealthFee",
                 "ManagmentFee", "Security", "LAMustAccShw"]
      heatingAndCooling: "Y"
      description: "Absolutely fantastic corporate fully furnished condo in Philadelphia's premier residences at Two Liberty. This is the largest and only design of its type. For a one bedroom, 1 1/2 bath condo. Oversized open living and dining room with beautiful Italian cabinetry in the kitchen. Sub-zero Miele appliances. Large breakfast bar, powder room, separate laundry room with storage and tons of windows. Master bedroom with walk-in closet and sitting area, desk area and oversized master bath with double vanity, large glass shower and jetted tub. All this with custom furniture. Just bring your clothes and toothbrush! Rental includes use of Two Liberty towncar, spa, gym and residences club. Parking is additional"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "02/18/2014"
      secondDeposit: "$5,300"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Absolutely fantastic corporate fully furnished condo in Philadelphia's premier residences at Two Liberty. This is the largest and only design of its type. For a one bedroom, 1 1/2 bath condo. Oversized open living and dining room with beautiful Italian cabinetry in the kitchen. Sub-zero Miele appliances. Large breakfast bar, powder room, separate laundry room with storage and tons of windows. Master bedroom with walk-in closet and sitting area, desk area and oversized master bath with double vanity, large glass shower and jetted tub. All this with custom furniture. Just bring your clothes and toothbrush! Rental includes use of Two Liberty towncar, spa, gym and residences club. Parking is additional"
      furnished: "Y"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTk3MzY7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NzEyMjk7fQ=="
      mlsNo: "6278074"
      latitude: 39.9519736
      longitude: -75.1671229

    2522:
      name: "50 S 16th St 4701"
      isPublished: true
      createdAt: "2014-02-28T14:56:56.000Z"
      onMap: false
      similar: []
      position: 88
      title: "50 S 16th St 4701"
      summary: ""
      postal_code: "19102 19102"
      street: "50 S 16th St 4701"
      price: "10000"
      bedrooms: "3"
      bathrooms: "3"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "2,600"
      plotArea: ""
      yearOfCompletion: "1991"
      features: ["Heating/Cooling/Utilities: ElectricHeat", "CentralAir", "ElectricHWt", "PublicWater", "PublicSewer",
                 "200-300AmpElGarages & Parking: NoGarage", "1-CarParking", "2-CarParking", "3+CarParking Kit: FullKit",
                 "Range", "Refrigerator", "Washer", "Dryer", "Dishwasher Bsmt: NoBasement Interior: FinishedWood",
                 "W/WCarpeting", "MainFlrLndry", "NoModifs/Unk Other: TenantElec", "CableTV", "CallToShow"]
      heatingAndCooling: "Y"
      description: " Exclusive Residences Located at Two Liberty Place, 3 bedroom, 3.5 bath condominium with features unparalleled views of Philadelphia to the South, East and North and views can be enjoyed from all rooms. This spectacular residence includes an entry hallway, powder room, open kitchen and open living and dining space. Features include Italian Snaidero cabinetry in the gourmet kitchen complete with espresso bar. Custom lighting and mill-work throughout and wide plank wood floors. The Master suite has a walk-in closet, sitting area and a glamorous marble bath. Two additional bedrooms with en-suite baths. A den/office/media room and laundry room with storage. Amenities include Owner's Club, Fitness Center, Endless Pool, Steam room and Sauna, Massage rooms, Pet Spa, Yoga/Pilate's Studio, 24/7 Concierge Staff, Chauffeur driven Mercedes S500, Valet Parking. Amazing access and convenience ? all just a private elevator ride away ? to Center City's urban renaissance of arts, culture, dining and shopping."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: "15"
      availableAt: "02/18/2014"
      secondDeposit: "$10,000"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: " Exclusive Residences Located at Two Liberty Place, 3 bedroom, 3.5 bath condominium with features unparalleled views of Philadelphia to the South, East and North and views can be enjoyed from all rooms. This spectacular residence includes an entry hallway, powder room, open kitchen and open living and dining space. Features include Italian Snaidero cabinetry in the gourmet kitchen complete with espresso bar. Custom lighting and mill-work throughout and wide plank wood floors. The Master suite has a walk-in closet, sitting area and a glamorous marble bath. Two additional bedrooms with en-suite baths. A den/office/media room and laundry room with storage. Amenities include Owner's Club, Fitness Center, Endless Pool, Steam room and Sauna, Massage rooms, Pet Spa, Yoga/Pilate's Studio, 24/7 Concierge Staff, Chauffeur driven Mercedes S500, Valet Parking. Amazing access and convenience ? all just a private elevator ride away ? to Center City's urban renaissance of arts, culture, dining and shopping."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTk3MzY7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NzEyMjk7fQ=="
      mlsNo: "6302859"
      latitude: 39.9519736
      longitude: -75.1671229

    2523:
      name: "2026 Chestnut St 3F"
      isPublished: true
      createdAt: "2014-02-28T14:56:57.000Z"
      onMap: false
      similar: []
      position: 89
      title: "2026 Chestnut St 3F"
      summary: ""
      postal_code: "19103 19103"
      street: "2026 Chestnut St 3F"
      price: "1250"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "3,650"
      plotArea: ""
      yearOfCompletion: "1945"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: BsmtLaundry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantWtr", "TenantSwr", "TenantHtWtr",
                 "TenantInsur"]
      heatingAndCooling: "N"
      description: "Large one bedroom with hardwood floors throughout unit and great natural light in Rittenhouse Square! Lovely unit in a terrific Brownstone building in the heart of the city! Walking distance to EVERYTHING! Shopping, night life, parks, museums, restaurants, transportation, Etc!!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "08/01/2013"
      secondDeposit: "$4,050"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Large one bedroom with hardwood floors throughout unit and great natural light in Rittenhouse Square! Lovely unit in a terrific Brownstone building in the heart of the city! Walking distance to EVERYTHING! Shopping, night life, parks, museums, restaurants, transportation, Etc!!"
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjA3Njc7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDU4NTc7fQ=="
      mlsNo: "6253620"
      latitude: 39.9520767
      longitude: -75.1745857

    2524:
      name: "2032 Chestnut St 2F"
      isPublished: true
      createdAt: "2014-02-28T14:57:01.000Z"
      onMap: false
      similar: []
      position: 90
      title: "2032 Chestnut St 2F"
      summary: ""
      postal_code: "19103 19103"
      street: "2032 Chestnut St 2F"
      price: "1250"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1881"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV", "CallToShow"]
      heatingAndCooling: "N"
      description: "Recently renovated 1 Bedroom Apartment. Great Location, just a few blocks from Rittenhouse Square. Priced right! Washer/Dryer located in the unit. Terrific space. This charming apartment won't be on the market long so come take a look!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "01/07/2014"
      secondDeposit: "$1,350"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Recently renovated 1 Bedroom Apartment. Great Location, just a few blocks from Rittenhouse Square. Priced right! Washer/Dryer located in the unit. Terrific space. This charming apartment won't be on the market long so come take a look!"
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTk3Nzk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDg1MTt9"
      mlsNo: "6323073"
      latitude: 39.9519779
      longitude: -75.174851

    2525:
      name: "2100-2 Walnut St"
      isPublished: true
      createdAt: "2014-02-28T14:57:05.000Z"
      onMap: false
      similar: []
      position: 91
      title: "2100-2 Walnut St"
      summary: ""
      postal_code: "19103 19103"
      street: "2100-2 Walnut St"
      price: "1270"
      bedrooms: "0"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "470"
      plotArea: ""
      yearOfCompletion: "1914"
      features: ["Heating/Cooling/Utilities: NoA/CGarages & Parking: NoGarage Kit: Kit&BrksfRm", "Range",
                 "Refrigerator Bsmt: NoBasement Interior: Elevator", "CommonLndry", "NoModifs/Unk Other: TenantElec",
                 "CableTV"]
      heatingAndCooling: "N"
      description: "The Embassy building is situated in the heart of Rittenhouse Square. Footsteps from amazing restaurants and boutique shopping and a quick walk to University City. These Executive Studios are 470 square feet with a separate sleeping area. Units offer large windows, hardwood floors, and great charm. Additional amenities include concierge, Heat, Water, and cooking gas included in rent, as well as being pet friendly. Available Units: 11B $1,270. Unit 13B $1,270. Unit 9B $1,260 (Available 2/1/13)."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "07/15/2013"
      secondDeposit: "$1,270"
      minTerm: "6"
      parking: ""
      basement: ""
      other: ""
      remarks: "The Embassy building is situated in the heart of Rittenhouse Square. Footsteps from amazing restaurants and boutique shopping and a quick walk to University City. These Executive Studios are 470 square feet with a separate sleeping area. Units offer large windows, hardwood floors, and great charm. Additional amenities include concierge, Heat, Water, and cooking gas included in rent, as well as being pet friendly. Available Units: 11B $1,270. Unit 13B $1,270. Unit 9B $1,260 (Available 2/1/13)."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDUyODQ7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NTk3NTM7fQ=="
      mlsNo: "6320655"
      latitude: 39.9505284
      longitude: -75.1759753

    2526:
      name: "2135 Walnut St 201"
      isPublished: true
      createdAt: "2014-02-28T14:57:10.000Z"
      onMap: false
      similar: []
      position: 92
      title: "2135 Walnut St 201"
      summary: ""
      postal_code: "19103 19103"
      street: "2135 Walnut St 201"
      price: "1295"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "500"
      plotArea: ""
      yearOfCompletion: "1929"
      features: ["Heating/Cooling/Utilities: GasHeat", "CentralAir", "GasHotWater",
                 "CircBreakersGarages & Parking: NoGarage", "StreetParkng", "ParkingLot Kit: KitW/NookBar", "Range",
                 "Refrigerator", "Dishwasher", "Microwave Bsmt: FullBasement Interior: StorBasemnt", "NoFireplace",
                 "FinishedWood", "SecuritySys", "CableTVWired", "Elevator", "SecureEntr", "BsmtLaundry",
                 "NoModifs/Unk Exterior: BrickExt Other: TenantElec", "TenantHeat", "TenantGas", "CableTV",
                 "ComAreaMaint", "ExtBldgMaint", "CallToShow", "ComboLockBox"]
      heatingAndCooling: "Y"
      description: "Jr. One Bedroom in the Walnut Plaza Building at 22nd/Walnut. Hardwood Flrs,Galley Kitchen, Bathroom and Bedroom. Unit is on the second flr and owner is flexible. Clean, ready to move-in."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "2"
      fee: "35"
      availableAt: "02/01/2014"
      secondDeposit: "$1,295"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Jr. One Bedroom in the Walnut Plaza Building at 22nd/Walnut. Hardwood Flrs,Galley Kitchen, Bathroom and Bedroom. Unit is on the second flr and owner is flexible. Clean, ready to move-in."
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTEyODtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTc3MTI7fQ=="
      mlsNo: "6334003"
      latitude: 39.951128
      longitude: -75.17712

    2527:
      name: "2101-17 Chestnut St 1509"
      isPublished: true
      createdAt: "2014-02-28T14:57:11.000Z"
      onMap: false
      similar: []
      position: 93
      title: "2101-17 Chestnut St 1509"
      summary: ""
      postal_code: "19103 19103"
      street: "2101-17 Chestnut St 1509"
      price: "1300"
      bedrooms: "0"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "465"
      plotArea: ""
      yearOfCompletion: "1954"
      features: ["Heating/Cooling/Utilities: ElectricHeat", "CentralAir", "ElectricHWt", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage", "StreetParkng", "ParkingGarage Kit: EatInKitchen", "Range",
                 "Refrigerator Bsmt: NoBasement Interior: FinishedWood", "CableTVWired", "Elevator", "NoLaundry",
                 "NoModifs/Unk Other: NoneTentResp", "SnowRemoval", "TrashRemoval", "HeatFee", "WaterFee", "SewerFee",
                 "HotWtrFee", "HealthFee", "CallToShow", "ComboLockBox"]
      heatingAndCooling: "Y"
      description: "Location location, enjoy city skyline view from this cozy efficency apartment, w/plenty of storage space. All utilities are included (gas, wtr, elec, basic cable TV,fitness center and 24 hr lobby attendant), parking in attached garage for an additional 75.00 weekly amt. Conveniently located to transportation, fine dining,shopping and adventuous nite life. College campuses of Penn and Drexel nearby."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "02/01/2014"
      secondDeposit: "$1,300"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Location location, enjoy city skyline view from this cozy efficency apartment, w/plenty of storage space. All utilities are included (gas, wtr, elec, basic cable TV,fitness center and 24 hr lobby attendant), parking in attached garage for an additional 75.00 weekly amt. Conveniently located to transportation, fine dining,shopping and adventuous nite life. College campuses of Penn and Drexel nearby."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTMzNzU7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NTgzMjt9"
      mlsNo: "6330507"
      latitude: 39.9513375
      longitude: -75.165832

    2528:
      name: "2101-17 Chestnut St 1513"
      isPublished: true
      createdAt: "2014-02-28T14:57:15.000Z"
      onMap: false
      similar: []
      position: 94
      title: "2101-17 Chestnut St 1513"
      summary: ""
      postal_code: "19103 19103"
      street: "2101-17 Chestnut St 1513"
      price: "1325"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "538"
      plotArea: ""
      yearOfCompletion: "1954"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: 1-CarGarage Kit: KitW/NookBar", "Range",
                 "Refrigerator Bsmt: NoBasement Interior: BsmtLaundry", "NoModifs/Unk Other: NoneTentResp"]
      heatingAndCooling: "Y"
      description: "Spacious 15th floor one bedroom condo available in sought after Riverwest Condominium Building. All Utilities included in monthly rent! (gas, electric, water and basic cable). Building features a 24 hour front desk attendant, beautiful lobby, business center and fitness center. Condo features large windows, large closets and amazing city views. Carpets will be replaced throughout and a new oven is being installed. AVAILABLE 3/2/14. Parking available at an additional cost in building."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "03/02/2014"
      secondDeposit: "$1,325"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Spacious 15th floor one bedroom condo available in sought after Riverwest Condominium Building. All Utilities included in monthly rent! (gas, electric, water and basic cable). Building features a 24 hour front desk attendant, beautiful lobby, business center and fitness center. Condo features large windows, large closets and amazing city views. Carpets will be replaced throughout and a new oven is being installed. AVAILABLE 3/2/14. Parking available at an additional cost in building."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjUzODg7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NTgwODI7fQ=="
      mlsNo: "6334952"
      latitude: 39.9525388
      longitude: -75.1758082

    2529:
      name: "2101-17 Chestnut St 1621"
      isPublished: true
      createdAt: "2014-02-28T14:57:21.000Z"
      onMap: false
      similar: []
      position: 95
      title: "2101-17 Chestnut St 1621"
      summary: ""
      postal_code: "19103 19103"
      street: "2101-17 Chestnut St 1621"
      price: "1395"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "545"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: NoGarage Kit: FullKit", "Range",
                 "Refrigerator Bsmt: NoBasement Interior: LaminateFl", "CommonEntr", "SecureEntr", "CommonLndry",
                 "NoModifs/Unk Other: TenantInsur", "OtherTenant", "24HrNoticShw", "TenantOcc", "ComboLockBox"]
      heatingAndCooling: "N"
      description: "Available early March: Amazing deal at the Riverwest Condominium. All utilities and cable TV are included in the rent - tenant is responsible for internet charges. This 16th floor unit is bright, sunny, and located just off of Rittenhouse Square. Building features include a 24/7 front desk attendant , onsite gym, onsite laundry facilities, and adjacent parking garage (spots available for additional fee - contact building directly for rate details). First month, last month, one month security deposit due at lease signing. $45 application fee per applicant. Building also has a one time move-in/ move-out fee which varies depending on which day you schedule your move - around $200-$300 range. (Note: Since these photos were taken, laminate wood flooring has been installed throughout, no more carpet!)"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "03/03/2014"
      secondDeposit: "$1,395"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Available early March: Amazing deal at the Riverwest Condominium. All utilities and cable TV are included in the rent - tenant is responsible for internet charges. This 16th floor unit is bright, sunny, and located just off of Rittenhouse Square. Building features include a 24/7 front desk attendant , onsite gym, onsite laundry facilities, and adjacent parking garage (spots available for additional fee - contact building directly for rate details). First month, last month, one month security deposit due at lease signing. $45 application fee per applicant. Building also has a one time move-in/ move-out fee which varies depending on which day you schedule your move - around $200-$300 range. (Note: Since these photos were taken, laminate wood flooring has been installed throughout, no more carpet!)"
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjUzODg7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NTgwODI7fQ=="
      mlsNo: "6337313"
      latitude: 39.9525388
      longitude: -75.1758082

    2530:
      name: "1600-2 Walnut St 1001"
      isPublished: true
      createdAt: "2014-02-28T14:57:24.000Z"
      onMap: false
      similar: []
      position: 96
      title: "1600-2 Walnut St 1001"
      summary: ""
      postal_code: "19103 19103"
      street: "1600-2 Walnut St 1001"
      price: "1395"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: CommonLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV", "OtherTenant"]
      heatingAndCooling: "Y"
      description: "Located steps away from the Rittenhouse in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. Individual monitored alarm systems."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "LoRise"
      floor: ""
      fee: ""
      availableAt: "11/12/2013"
      secondDeposit: "$1,395"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Located steps away from the Rittenhouse in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. Individual monitored alarm systems."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTc5MTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY3NTYyNjt9"
      mlsNo: "6306175"
      latitude: 39.949791
      longitude: -75.1675626

    2531:
      name: "2109 Spruce St 2F"
      isPublished: true
      createdAt: "2014-02-28T14:57:29.000Z"
      onMap: false
      similar: []
      position: 97
      title: "2109 Spruce St 2F"
      summary: ""
      postal_code: "19103 19103"
      street: "2109 Spruce St 2F"
      price: "1400"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "4,553"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: NoA/CGarages & Parking: NoGarage Kit: FullKit", "Range",
                 "Refrigerator Bsmt: NoBasement Interior: FinishedWood", "CableTVWired", "BsmtLaundry", "CommonLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantGas", "TenantWtr", "CableTV", "OtherTenant", "24HrNoticShw",
                 "TenantOcc", "ComboLockBox"]
      heatingAndCooling: "N"
      description: "vailable early May: Just a few blocks from Rittenhouse Square, this beautiful one bedroom, one bathroom, second floor apartment will NOT last long! As you enter, the first things you'll notice are the beautiful hardwood floors throughout and the high ceilings. The living room is spacious and there is even enough room for dining table right in front of the tall windows overlooking the tree-lined Spruce Street. The kitchen features stainless steel appliances, gas cooking, lots of cabinets and extra space for additional storage or a small breakfast nook. Hardwood floors continue into the bedroom, which has two separate closets and an entrance into the full bathroom with built-in wall shelving and modern fixtures. This apartment is in great condition in a beautiful brownstone in one of the most sought after neighborhoods in Center City. Optional storage cage rental in the building for an additional $30/month. There is parking available in the rear of the building for $250 monthly - this is a space for a compact car. Tenant's will be responsible for prepaying their heat for the year ($795) and water for the year ($295). Additionally, they will be responsible for their electric and gas utility (for stove)."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "05/03/2014"
      secondDeposit: "$1,400"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "vailable early May: Just a few blocks from Rittenhouse Square, this beautiful one bedroom, one bathroom, second floor apartment will NOT last long! As you enter, the first things you'll notice are the beautiful hardwood floors throughout and the high ceilings. The living room is spacious and there is even enough room for dining table right in front of the tall windows overlooking the tree-lined Spruce Street. The kitchen features stainless steel appliances, gas cooking, lots of cabinets and extra space for additional storage or a small breakfast nook. Hardwood floors continue into the bedroom, which has two separate closets and an entrance into the full bathroom with built-in wall shelving and modern fixtures. This apartment is in great condition in a beautiful brownstone in one of the most sought after neighborhoods in Center City. Optional storage cage rental in the building for an additional $30/month. There is parking available in the rear of the building for $250 monthly - this is a space for a compact car. Tenant's will be responsible for prepaying their heat for the year ($795) and water for the year ($295). Additionally, they will be responsible for their electric and gas utility (for stove)."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODY1MTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTc2NjQ0Nzt9"
      mlsNo: "6338540"
      latitude: 39.948651
      longitude: -75.1766447

    2532:
      name: "1600-2 Walnut St 405"
      isPublished: true
      createdAt: "2014-02-28T14:57:31.000Z"
      onMap: false
      similar: []
      position: 98
      title: "1600-2 Walnut St 405"
      summary: ""
      postal_code: "19103 19103"
      street: "1600-2 Walnut St 405"
      price: "1440"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1914"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: CommonLndry",
                 "NoModifs/Unk Other: TenantElec"]
      heatingAndCooling: "Y"
      description: "Located steps away from the Rittenhouse in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. Individual monitored alarm systems."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "4"
      fee: ""
      availableAt: "02/11/2013"
      secondDeposit: "$1,440"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Located steps away from the Rittenhouse in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. Individual monitored alarm systems."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTc5MTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY3NTYyNjt9"
      mlsNo: "6167898"
      latitude: 39.949791
      longitude: -75.1675626

    2534:
      name: "2013 Spruce St 1"
      isPublished: true
      createdAt: "2014-02-28T14:57:36.000Z"
      onMap: false
      similar: []
      position: 99
      title: "2013 Spruce St 1"
      summary: ""
      postal_code: "19103 19103"
      street: "2013 Spruce St 1"
      price: "1495"
      bedrooms: "0"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "7,363"
      plotArea: ""
      yearOfCompletion: "1880"
      features: ["Heating/Cooling/Utilities: CentralAir", "GasHotWater", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage",
                 "StreetParkng Kit: EatInKitchen Bsmt: NoBasement Interior: Three+FPs", "MainFlrLndry",
                 "NoModifs/Unk Exterior: Sidewalks", "StreetLights", "Other: TenantElec", "TenantWtr", "TenantSwr",
                 "TenantHtWtr", "CableTV", "CallToShow", "LAMustAccShw", "24HrNoticShw"]
      heatingAndCooling: "Y"
      description: "Come See What We've Been Sprucing Up! Pre-Leasing 2013 Spruce For February 2014. At 2013 Spruce, be swept away by the elegance of living in a beautifully restored, grand historic brownstone that's fully loaded with condominium-grade, premier luxury amenities. Modern apartments in a meticulously restored, grand historic brownstone. Built in 1868 and located on the 2000 block of Spruce Street, this building is quintessentially Rittenhouse. Once the home to a prominent builder of Rittenhouse Sq. brownstones, 2013 Spruce is significantly larger than neighboring residences, and each apartment features lovingly restored historic details, high ceilings and decorative moldings. 2013 Spruce Street retains the elegant splendor of its day, while seamlessly incorporating the modern luxuries and amenities of today, in these spacious, well designed apartments. We invite you to come admire them for yourself. Hardwood Floors throughout. Kitchen in each unit is equipped with stainless steel appliances, granite counter tops, maple shaker style cabinetry, ceramic back splash and tile floors. Bathrooms have glass tile tub surround and tile floors. Front loading washer and dryer in each unit Want to be up-to-date and in the know? Like us on Facebook. Just look up 2013 Spruce FB page! This unit is a studio with a loft. Please see attached floor plan. *Interior photo depicts comparable renovation at another AMC Delancey property. Heat is paid by the landlord."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "3+Story"
      floor: "1"
      fee: ""
      availableAt: "03/15/2014"
      secondDeposit: "$1,495"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Come See What We've Been Sprucing Up! Pre-Leasing 2013 Spruce For February 2014. At 2013 Spruce, be swept away by the elegance of living in a beautifully restored, grand historic brownstone that's fully loaded with condominium-grade, premier luxury amenities. Modern apartments in a meticulously restored, grand historic brownstone. Built in 1868 and located on the 2000 block of Spruce Street, this building is quintessentially Rittenhouse. Once the home to a prominent builder of Rittenhouse Sq. brownstones, 2013 Spruce is significantly larger than neighboring residences, and each apartment features lovingly restored historic details, high ceilings and decorative moldings. 2013 Spruce Street retains the elegant splendor of its day, while seamlessly incorporating the modern luxuries and amenities of today, in these spacious, well designed apartments. We invite you to come admire them for yourself. Hardwood Floors throughout. Kitchen in each unit is equipped with stainless steel appliances, granite counter tops, maple shaker style cabinetry, ceramic back splash and tile floors. Bathrooms have glass tile tub surround and tile floors. Front loading washer and dryer in each unit Want to be up-to-date and in the know? Like us on Facebook. Just look up 2013 Spruce FB page! This unit is a studio with a loft. Please see attached floor plan. *Interior photo depicts comparable renovation at another AMC Delancey property. Heat is paid by the landlord."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODUwOTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTc0ODUyO30="
      mlsNo: "6323164"
      latitude: 39.948509
      longitude: -75.174852

    2535:
      name: "2014 Sansom St A"
      isPublished: true
      createdAt: "2014-02-28T14:57:40.000Z"
      onMap: false
      similar: []
      position: 93
      title: "2014 Sansom St A"
      summary: ""
      postal_code: "19103 19103"
      street: "2014 Sansom St A"
      price: "1495"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,389"
      plotArea: ""
      yearOfCompletion: "2014"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: NoGarage Kit: FullKit", "Range",
                 "Refrigerator", "Washer", "Dryer", "Dishwasher", "Freezer", "Microwave",
                 "Disposal Bsmt: NoBasement Interior: PrivateEntr", "MainFlrLndry",
                 "NoModifs/Unk Exterior: Deck Other: CableTV", "ComAreaMaint", "ApplianMaint", "SnowRemoval",
                 "TrashRemoval", "ElecFee", "HeatFee", "WaterFee", "CallToShow"]
      heatingAndCooling: "N"
      description: "Move in now! Huge Bi-level, one bedroom and den apartment in the heart of Rittenhouse Sq. with all Utilities included!!!! Tenant only pays for cable and internet. Gas, electric, and water included in the monthly rent. This wonderful unit features two floors of living space, tons of windows, a very large bedroom and a separate den perfect for an office or additional living area . There is a free, private washer and dryer in the bathroom, a private deck with city views off the living room, and a nice size kitchen with all appliances included. There is also a window AC included with rent. Enter this unit through a secured private entrance off Sansom Street. Do not worry about missing a delivery, the downstairs Architecture office will accept all packages. When you first walk into this beautiful apartment you have a small sitting area with access to a large private deck, nice size kitchen, and gigantic living room with tons of natural light. Walk up the stairs of the apartment and you have the den, full bathroom, and enormous bedroom with large windows. Shake Shack is on the corner and tons of restaurants and bars all within minutes walk. Apartment located within Greenfield Elementary School District!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "2Story"
      floor: ""
      fee: "40"
      availableAt: "12/01/2013"
      secondDeposit: "$1,495"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Move in now! Huge Bi-level, one bedroom and den apartment in the heart of Rittenhouse Sq. with all Utilities included!!!! Tenant only pays for cable and internet. Gas, electric, and water included in the monthly rent. This wonderful unit features two floors of living space, tons of windows, a very large bedroom and a separate den perfect for an office or additional living area . There is a free, private washer and dryer in the bathroom, a private deck with city views off the living room, and a nice size kitchen with all appliances included. There is also a window AC included with rent. Enter this unit through a secured private entrance off Sansom Street. Do not worry about missing a delivery, the downstairs Architecture office will accept all packages. When you first walk into this beautiful apartment you have a small sitting area with access to a large private deck, nice size kitchen, and gigantic living room with tons of natural light. Walk up the stairs of the apartment and you have the den, full bathroom, and enormous bedroom with large windows. Shake Shack is on the corner and tons of restaurants and bars all within minutes walk. Apartment located within Greenfield Elementary School District!"
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTIzO3M6OToibG9uZ2l0dWRlIjtkOi03NS4xNzQxODY7fQ=="
      mlsNo: "6294059"
      latitude: 39.95123
      longitude: -75.174186

    2536:
      name: "2032 Chestnut St 3F"
      isPublished: true
      createdAt: "2014-02-28T14:57:45.000Z"
      onMap: false
      similar: []
      position: 94
      title: "2032 Chestnut St 3F"
      summary: ""
      postal_code: "19103 19103"
      street: "2032 Chestnut St 3F"
      price: "1500"
      bedrooms: "2"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "5,040"
      plotArea: ""
      yearOfCompletion: "1881"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV"]
      heatingAndCooling: "N"
      description: "Recently renovated 2 Bedroom Apartment. Great Location, just a few blocks from Rittenhouse Square. Priced right! Washer/Dryer located in the unit. Terrific space. This charming apartment won't be on the market long so come take a look!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "12/16/2013"
      secondDeposit: "$1,600"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Recently renovated 2 Bedroom Apartment. Great Location, just a few blocks from Rittenhouse Square. Priced right! Washer/Dryer located in the unit. Terrific space. This charming apartment won't be on the market long so come take a look!"
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTk3Nzk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDg1MTt9"
      mlsNo: "6323789"
      latitude: 39.9519779
      longitude: -75.174851

    2537:
      name: "1600-2 Walnut St 701"
      isPublished: true
      createdAt: "2014-02-28T14:57:48.000Z"
      onMap: false
      similar: []
      position: 95
      title: "1600-2 Walnut St 701"
      summary: ""
      postal_code: "19103 19103"
      street: "1600-2 Walnut St 701"
      price: "1525"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1914"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: CommonLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV", "OtherTenant"]
      heatingAndCooling: "Y"
      description: "Located steps away from the Rittenhouse in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. Individual monitored alarm systems."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "10/15/2013"
      secondDeposit: "$1,525"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Located steps away from the Rittenhouse in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. Individual monitored alarm systems."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTc5MTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY3NTYyNjt9"
      mlsNo: "6262162"
      latitude: 39.949791
      longitude: -75.1675626

    2538:
      name: "1600-2 Walnut St 1106"
      isPublished: true
      createdAt: "2014-02-28T14:58:03.000Z"
      onMap: false
      similar: []
      position: 6
      title: "1600-2 Walnut St 1106"
      summary: ""
      postal_code: "19103 19103"
      street: "1600-2 Walnut St 1106"
      price: "1535"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: CommonLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "TenantWtr", "CableTV", "OtherTenant"]
      heatingAndCooling: "Y"
      description: "Fabulous 1 bedroom, 1 bathroom apartment FOR RENT, located steps away from the RITTENHOUSE SQUARE in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. INDIVIDUAL MONITORED ALARM SYSTEMS."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "LoRise"
      floor: ""
      fee: ""
      availableAt: "11/25/2013"
      secondDeposit: "$1,535"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Fabulous 1 bedroom, 1 bathroom apartment FOR RENT, located steps away from the RITTENHOUSE SQUARE in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. INDIVIDUAL MONITORED ALARM SYSTEMS."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTc5MTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY3NTYyNjt9"
      mlsNo: "6311503"
      latitude: 39.949791
      longitude: -75.1675626

    2539:
      name: "2100-2 Walnut St I"
      isPublished: true
      createdAt: "2014-02-28T14:58:06.000Z"
      onMap: false
      similar: []
      position: 8
      title: "2100-2 Walnut St I"
      summary: ""
      postal_code: "19103 19103"
      street: "2100-2 Walnut St I"
      price: "1540"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "900"
      plotArea: ""
      yearOfCompletion: "1914"
      features: ["Heating/Cooling/Utilities: NoA/CGarages & Parking: NoGarage Kit: Kit&BrksfRm", "Range",
                 "Refrigerator Bsmt: NoBasement Interior: Elevator", "CommonLndry", "NoModifs/Unk Other: TenantElec",
                 "CableTV"]
      heatingAndCooling: "N"
      description: "The Embassy building is situated in the heart of Rittenhouse Square. Footsteps from amazing restaurants and boutique shopping and a quick walk to University City. These 1 bedroom units offer large windows, hardwood floors, and great charm. Additional amenities include concierge, Heat, Water, and cooking gas included in rent, as well as being pet friendly. Available Units: 4I $1,540. 14I $1,565."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "07/15/2013"
      secondDeposit: "$1,540"
      minTerm: "6"
      parking: ""
      basement: ""
      other: ""
      remarks: "The Embassy building is situated in the heart of Rittenhouse Square. Footsteps from amazing restaurants and boutique shopping and a quick walk to University City. These 1 bedroom units offer large windows, hardwood floors, and great charm. Additional amenities include concierge, Heat, Water, and cooking gas included in rent, as well as being pet friendly. Available Units: 4I $1,540. 14I $1,565."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDUyODQ7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NTk3NTM7fQ=="
      mlsNo: "6320660"
      latitude: 39.9505284
      longitude: -75.1759753

    2542:
      name: "1600-2 Walnut St 307"
      isPublished: true
      createdAt: "2014-02-28T14:58:15.000Z"
      onMap: false
      similar: []
      position: 10
      title: "1600-2 Walnut St 307"
      summary: ""
      postal_code: "19103 19103"
      street: "1600-2 Walnut St 307"
      price: "1650"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: CommonLndry",
                 "NoModifs/Unk Other: TenantElec"]
      heatingAndCooling: "Y"
      description: "Located steps away from the Rittenhouse in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. Individual monitored alarm systems."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "10/10/2013"
      secondDeposit: "$1,650"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Located steps away from the Rittenhouse in Center City, 1600 Walnut is a beautifully restored mid rise building surrounded by the performing arts and numerous cultural venues. Along Walnut Street you can experience Philadelphia's premier shopping, dining and nightlife. The building is located within walking distance of numerous performing colleges and surrounded by all forms of public transportation. Individual monitored alarm systems."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTc5MTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY3NTYyNjt9"
      mlsNo: "6291984"
      latitude: 39.949791
      longitude: -75.1675626

    2545:
      name: "2026-58 Market St 1016"
      isPublished: true
      createdAt: "2014-02-28T14:58:36.000Z"
      onMap: false
      similar: []
      position: 13
      title: "2026-58 Market St 1016"
      summary: ""
      postal_code: "19103 19103"
      street: "2026-58 Market St 1016"
      price: "1695"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1968"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas"]
      heatingAndCooling: "Y"
      description: "Brand new apartments available for rent at 2040 MARKET STREET. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. PARKING AVAILABLE FOR ADDITIONAL COST."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "03/01/2014"
      secondDeposit: "$1,695"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Brand new apartments available for rent at 2040 MARKET STREET. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. PARKING AVAILABLE FOR ADDITIONAL COST."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MzMyNTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDEyNzt9"
      mlsNo: "6336928"
      latitude: 39.9533259
      longitude: -75.174127

    2655:
      name: "2006 Walnut St 11"
      isPublished: true
      createdAt: "2014-02-28T15:47:29.000Z"
      onMap: false
      similar: []
      position: 93
      title: "2006 Walnut St 11"
      summary: ""
      postal_code: "19103 19103"
      street: "2006 Walnut St 11"
      price: "1799"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "500"
      plotArea: ""
      yearOfCompletion: "1889"
      features: ["Heating/Cooling/Utilities: CentralAir", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage Kit: EatInKitchen", "Range", "Refrigerator", "Washer", "Dryer",
                 "Freezer", "Microwave Bsmt: NoBasement Interior: FinishedWood", "TileFlr", "SecureEntr",
                 "MainFlrLndry", "NoModifs/Unk Exterior: StoneExt Other: TenantElec", "TenantHeat", "TenantGas",
                 "TenantWtr", "CableTV"]
      heatingAndCooling: "Y"
      description: "Be the first residents of the latest boutique building just steps off legendary Rittenhouse Square. The apartments are spacious, modern & tastefully appointed for the discerning resident. A seamless blend of old & new, each unit boasts recessed lighting, white oak hardwood floors, & modern square trim package. Gorgeous chef's kitchen brimming with the latest in kitchen design offer quartz countertops, sleek cabinetry & brand new appliances. Decadent full bathrooms with porcelain tile floors & shower surround as well as wetbed shower floors. The \"Bordeaux\" unit features a bright bedroom with lots of closet space and natural light. All units include a washer & dryer. Moving in will be a breeze as the building is serviced by a high speed commercial elevator. Residents can escape to the shared roof deck to enjoy the outdoors, fresh air & center city skyline views. Ideal location near the Rittenhouse Garage, easy access to 76 & steps away from all the city has to offer. Occupancy beginning in February 2014!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "02/01/2014"
      secondDeposit: "$1,799"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Be the first residents of the latest boutique building just steps off legendary Rittenhouse Square. The apartments are spacious, modern & tastefully appointed for the discerning resident. A seamless blend of old & new, each unit boasts recessed lighting, white oak hardwood floors, & modern square trim package. Gorgeous chef's kitchen brimming with the latest in kitchen design offer quartz countertops, sleek cabinetry & brand new appliances. Decadent full bathrooms with porcelain tile floors & shower surround as well as wetbed shower floors. The \"Bordeaux\" unit features a bright bedroom with lots of closet space and natural light. All units include a washer & dryer. Moving in will be a breeze as the building is serviced by a high speed commercial elevator. Residents can escape to the shared roof deck to enjoy the outdoors, fresh air & center city skyline views. Ideal location near the Rittenhouse Garage, easy access to 76 & steps away from all the city has to offer. Occupancy beginning in February 2014!"
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDMxMTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDIzOTt9"
      mlsNo: "6302950"
      latitude: 39.9503119
      longitude: -75.174239

    2661:
      name: "2026-58 Market St 614"
      isPublished: true
      createdAt: "2014-03-02T05:28:04.000Z"
      onMap: false
      similar: []
      position: 94
      title: "2026-58 Market St 614"
      summary: ""
      postal_code: "19103 19103"
      street: "2026-58 Market St 614"
      price: "2850"
      bedrooms: "2"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "950"
      plotArea: ""
      yearOfCompletion: "1969"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas"]
      heatingAndCooling: "Y"
      description: "Brand new apartments available for rent at 2040 Market Street. This 2 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. Parking available for additional costs."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "05/07/2013"
      secondDeposit: "$2,850"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Brand new apartments available for rent at 2040 Market Street. This 2 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. Parking available for additional costs."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MzMyNTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDEyNzt9"
      mlsNo: "6214432"
      latitude: 39.9533259
      longitude: -75.174127

    2662:
      name: "219-29 S 18th St 1215"
      isPublished: true
      createdAt: "2014-03-02T05:28:08.000Z"
      onMap: false
      similar: []
      position: 3
      title: "219-29 S 18th St 1215"
      summary: ""
      postal_code: "19103 19103"
      street: "219-29 S 18th St 1215"
      price: "2875"
      bedrooms: "2"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "821"
      plotArea: ""
      yearOfCompletion: "2014"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHtWtr", "CableTV"]
      heatingAndCooling: "Y"
      description: "Rent in one of the most fabulous Condominium Buildings Rittenhouse Square has to offer! Frequently referred to as \"Beach Front Property\" This is a corner unit at Parc. This is a doorman building.. Beautiful Hardwood floors throughout, spacious kitchen an conveniently located to the most trendy hot spots in the City! Both shopping and restaurants! Enjoy full access to all common areas. Sizable media room perfect for working at home,holding business meetings,or watching the games with friends! Beautiful pools&hot tub, state of the art 24 hour gym all included in your rent!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "1Story"
      floor: ""
      fee: "100"
      availableAt: "02/28/2014"
      secondDeposit: "$50"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Rent in one of the most fabulous Condominium Buildings Rittenhouse Square has to offer! Frequently referred to as \"Beach Front Property\" This is a corner unit at Parc. This is a doorman building.. Beautiful Hardwood floors throughout, spacious kitchen an conveniently located to the most trendy hot spots in the City! Both shopping and restaurants! Enjoy full access to all common areas. Sizable media room perfect for working at home,holding business meetings,or watching the games with friends! Beautiful pools&hot tub, state of the art 24 hour gym all included in your rent!"
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjE1NzM7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3MDIxNDM7fQ=="
      mlsNo: "6326496"
      latitude: 39.9521573
      longitude: -75.1702143

    2663:
      name: "201 S 18th St"
      isPublished: true
      createdAt: "2014-03-02T05:28:13.000Z"
      onMap: false
      similar: []
      position: 8
      title: "201 S 18th St"
      summary: ""
      postal_code: "19103 19103"
      street: "201 S 18th St"
      price: "2950"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "800"
      plotArea: ""
      yearOfCompletion: "1953"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: 4+CarGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: NoneTentResp"]
      heatingAndCooling: "Y"
      description: "all utilities, internet, cable, linens, towels, stocked kitchen, houseware items, access to the sporting clb at the bellevue hotel. fully furnished, minimum 1 month, full service building with doorman and concierge, furnished rooftop, fitness center, business center,"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "Single/Dtchd"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "10/01/2013"
      secondDeposit: "$2,375"
      minTerm: "1"
      parking: ""
      basement: ""
      other: ""
      remarks: "all utilities, internet, cable, linens, towels, stocked kitchen, houseware items, access to the sporting clb at the bellevue hotel. fully furnished, minimum 1 month, full service building with doorman and concierge, furnished rooftop, fitness center, business center,"
      furnished: "Y"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTk0Njk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3MDQ0Mzt9"
      mlsNo: "6291726"
      latitude: 39.9499469
      longitude: -75.170443

    2666:
      name: "2026-58 Market St 1022"
      isPublished: true
      createdAt: "2014-03-02T05:58:50.000Z"
      onMap: false
      similar: []
      position: 5
      title: "2026-58 Market St 1022"
      summary: ""
      postal_code: "19103 19103"
      street: "2026-58 Market St 1022"
      price: "1745"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1969"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: FullBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas"]
      heatingAndCooling: "Y"
      description: "Brand new apartments available for rent at 2040 MARKET STREET. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. PARKING AVAILABLE FOR ADDITIONAL COST."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "01/01/2014"
      secondDeposit: "$1,885"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Brand new apartments available for rent at 2040 MARKET STREET. This 1 bedroom apartment includes large living area with open kitchen and breakfast bar, granite counter tops and stainless steel appliances. Enjoy living in this elevator doorman building with a gym. PARKING AVAILABLE FOR ADDITIONAL COST."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MzMyNTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDEyNzt9"
      mlsNo: "6280794"
      latitude: 39.9533259
      longitude: -75.174127

    2669:
      name: "2224 Manning St"
      isPublished: true
      createdAt: "2014-03-02T05:59:09.000Z"
      onMap: false
      similar: []
      position: 14
      title: "2224 Manning St"
      summary: ""
      postal_code: "19103 19103"
      street: "2224 Manning St"
      price: "1800"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "612"
      plotArea: ""
      yearOfCompletion: "1904"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen", "Range",
                 "Refrigerator", "Washer", "Dryer", "Dishwasher", "Microwave",
                 "Disposal Bsmt: FinishedBsmt Interior: LowFlrLndry", "NoModifs/Unk Other: TenantElec", "TenantHeat",
                 "TenantGas", "TenantWtr", "TenantSwr", "TenantInsur", "ComboLockBox"]
      heatingAndCooling: "Y"
      description: "Best location in the City - close to everything, Rittenhouse, Downtown, U of Penn, Drexel, Schuylkill River Park - yet tucked away on a almost no traffic, tree-lined street. Enter into a spacious living room with a kitchen / dining room combination, followed by a half bath and small patio. Located on the second floor is the bedroom / bathroom, den / office, spacious closet and access to a lovely rear deck. The basement is fully finished with built in bookcases and a separate laundry / storage room. There are hardwood floors throughout. This home has all the amenities: Central Air, Dishwasher, Microwave and a built-in wine cooler."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "2Story"
      floor: ""
      fee: ""
      availableAt: "12/01/2013"
      secondDeposit: "$1,800"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Best location in the City - close to everything, Rittenhouse, Downtown, U of Penn, Drexel, Schuylkill River Park - yet tucked away on a almost no traffic, tree-lined street. Enter into a spacious living room with a kitchen / dining room combination, followed by a half bath and small patio. Located on the second floor is the bedroom / bathroom, den / office, spacious closet and access to a lovely rear deck. The basement is fully finished with built in bookcases and a separate laundry / storage room. There are hardwood floors throughout. This home has all the amenities: Central Air, Dishwasher, Microwave and a built-in wine cooler."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODk3MjtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTc4NDQ3O30="
      mlsNo: "6304842"
      latitude: 39.948972
      longitude: -75.178447

    2671:
      name: "2018-32 Walnut St 19D"
      isPublished: true
      createdAt: "2014-03-02T05:59:17.000Z"
      onMap: false
      similar: []
      position: 20
      title: "2018-32 Walnut St 19D"
      summary: ""
      postal_code: "19103 19103"
      street: "2018-32 Walnut St 19D"
      price: "1875"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "700"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "CableTV", "CallToShow", "24HrNoticShw"]
      heatingAndCooling: "Y"
      description: " Bright one bedroom, high floor views of Rittenhouse Square and The Skyline. Wanamaker House is a doorman building, with 24 Hour maintenance, rooftop pool and health club included. Electric and cable ($17.30 mo) is extra."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "06/07/2014"
      secondDeposit: "$1,875"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: " Bright one bedroom, high floor views of Rittenhouse Square and The Skyline. Wanamaker House is a doorman building, with 24 Hour maintenance, rooftop pool and health club included. Electric and cable ($17.30 mo) is extra."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDU0MDQ7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDcwNDI7fQ=="
      mlsNo: "6342965"
      latitude: 39.9505404
      longitude: -75.1747042

    2683:
      name: "115 S 21st St 302"
      isPublished: true
      createdAt: "2014-03-02T12:40:47.000Z"
      onMap: false
      similar: []
      position: 93
      title: "115 S 21st St 302"
      summary: ""
      postal_code: "19103 19103"
      street: "115 S 21st St 302"
      price: "1750"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "2013"
      features: ["Heating/Cooling/Utilities: ElectricHeat", "CentralAir", "ElectricHWt",
                 "400+AmpElecSGarages & Parking: NoGarage", "ParkingLot Kit: FullKit", "Range", "Refrigerator",
                 "Washer", "Dryer", "Dishwasher", "Freezer", "Microwave",
                 "Disposal Bsmt: NoBasement Interior: FinishedWood", "TileFlr", "SecuritySys", "Cth/VltCeil",
                 "CableTVWired", "Elevator", "CommonEntr", "SecureEntr", "KeyedEntr", "Intercom", "MainFlrLndry",
                 "CommonLndry", "NoModifs/Unk Building Orient: BldOrientationW Other: TenantElec", "TenantHeat",
                 "TenantHtWtr", "TenantInsur", "CableTV", "CallToShow", "LAMustAccShw"]
      heatingAndCooling: "Y"
      description: "With luxury renovations against a backdrop of carefully & beautifully preserved historic architecture, this brand new, 19-unit building offers the best of both worlds. Along with the prime location of 21 & Walnut, 115 S. 21 Street is truly the height of living in Philadelphia's Rittenhouse Square. Each apartment is uniquely charming, offering varying features such as high ceilings, bay windows, outdoor space, ornamental fireplaces, spectacular views of the Center City skyline -- but all offer brand new, premier finishes for a high-end lifestyle & the ultimate in convenience. Finely-crafted features include hardwood floors throughout; a modern kitchen w/ elegant granite countertops & stainless steel appliances, including a dishwasher, garbage disposal, electric stove & built-in microwave; central air & heat; & an efficient European-style washer/dryer combo. Building features include an elevator, newly-renovated common areas, 24/7 maintenance service, front-door video surveillance, intercom & cable ready units."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: "40"
      availableAt: "10/01/2013"
      secondDeposit: "$1,595"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "With luxury renovations against a backdrop of carefully & beautifully preserved historic architecture, this brand new, 19-unit building offers the best of both worlds. Along with the prime location of 21 & Walnut, 115 S. 21 Street is truly the height of living in Philadelphia's Rittenhouse Square. Each apartment is uniquely charming, offering varying features such as high ceilings, bay windows, outdoor space, ornamental fireplaces, spectacular views of the Center City skyline -- but all offer brand new, premier finishes for a high-end lifestyle & the ultimate in convenience. Finely-crafted features include hardwood floors throughout; a modern kitchen w/ elegant granite countertops & stainless steel appliances, including a dishwasher, garbage disposal, electric stove & built-in microwave; central air & heat; & an efficient European-style washer/dryer combo. Building features include an elevator, newly-renovated common areas, 24/7 maintenance service, front-door video surveillance, intercom & cable ready units."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTI0O3M6OToibG9uZ2l0dWRlIjtkOi03NS4xNzUzNjU7fQ=="
      mlsNo: "6342943"
      latitude: 39.95124
      longitude: -75.175365

    2684:
      name: "2101-17 Chestnut St 415"
      isPublished: true
      createdAt: "2014-03-02T12:41:04.000Z"
      onMap: false
      similar: []
      position: 94
      title: "2101-17 Chestnut St 415"
      summary: ""
      postal_code: "19103 19103"
      street: "2101-17 Chestnut St 415"
      price: "1795"
      bedrooms: "2"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "863"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: Wall/WndowACGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: CommonLndry",
                 "NoModifs/Unk Other: TenantInsur"]
      heatingAndCooling: "N"
      description: "Beautiful Two bedroom end unit with Great Views of the City. Centrally located in Rittenhouse Square area, close to Restaurants , shopping, and Public transportation, Lot's of windows and Hardwood Floors, Upgraded Kitchen with Granite tops, Stainless Steel appliances and Tile Floor, Move Right in and Enjoy !! Monthly fee Includes All utilities, heat, cable, water, trash, gym,24 hr security and condo fee,,,"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "1Story"
      floor: ""
      fee: "35"
      availableAt: "11/01/2013"
      secondDeposit: "$1,795"
      minTerm: "6"
      parking: ""
      basement: ""
      other: ""
      remarks: "Beautiful Two bedroom end unit with Great Views of the City. Centrally located in Rittenhouse Square area, close to Restaurants , shopping, and Public transportation, Lot's of windows and Hardwood Floors, Upgraded Kitchen with Granite tops, Stainless Steel appliances and Tile Floor, Move Right in and Enjoy !! Monthly fee Includes All utilities, heat, cable, water, trash, gym,24 hr security and condo fee,,,"
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjUzODg7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NTgwODI7fQ=="
      mlsNo: "6299848"
      latitude: 39.9525388
      longitude: -75.1758082

    2686:
      name: "1924 Lombard St 1ST FL"
      isPublished: true
      createdAt: "2014-03-02T12:41:14.000Z"
      onMap: false
      similar: []
      position: 2
      title: "1924 Lombard St 1ST FL"
      summary: ""
      postal_code: "19146 19146"
      street: "1924 Lombard St 1ST FL"
      price: "1550"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1915"
      features: ["Heating/Cooling/Utilities: Wall/WndowAC", "PublicWater", "PublicSewer",
                 "100-150AmpElGarages & Parking: NoGarage", "StreetParkng Kit: KitW/NookBar", "Refrigerator",
                 "Disposal Bsmt: FullBasement Interior: StorBasemnt", "OneFP", "CableTVWired", "BsmtLaundry",
                 "NoModifs/Unk Exterior: Sidewalks", "StreetLights", "BrickExt", "Patio",
                 "RearyrdLot Other: TenantElec", "TenantGas"]
      heatingAndCooling: "N"
      description: "Lovely Rittenhouse one-bedroom apartment with hardwood floors, living room FIREPLACE, kitchen with large breakfast bar for 4 people, energy-efficient sliding doors to a South-facing patio & garden, basement storage. Available February 3rd to see"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "Other"
      floor: ""
      fee: ""
      availableAt: "02/03/2014"
      secondDeposit: "$1,550"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Lovely Rittenhouse one-bedroom apartment with hardwood floors, living room FIREPLACE, kitchen with large breakfast bar for 4 people, energy-efficient sliding doors to a South-facing patio & garden, basement storage. Available February 3rd to see"
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MjMzNTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTYzNzg5O30="
      mlsNo: "6331928"
      latitude: 39.952335
      longitude: -75.163789

    2687:
      name: "1512 Naudain St"
      isPublished: true
      createdAt: "2014-03-02T12:41:27.000Z"
      onMap: false
      similar: []
      position: 2
      title: "1512 Naudain St"
      summary: ""
      postal_code: "19146 19146"
      street: "1512 Naudain St"
      price: "1600"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1914"
      features: ["Heating/Cooling/Utilities: GasHeat", "CentralAir", "GasHotWater", "PublicWater",
                 "100-150AmpElGarages & Parking: NoGarage", "StreetParkng Kit: FullKit", "Range", "Refrigerator",
                 "Washer", "Dryer", "Dishwasher Bsmt: NoBasement Interior: FinishedWood", "Foyer/VestEn", "LowFlrLndry",
                 "NoModifs/Unk Exterior: BrickExt", "Patio Other: TenantElec", "TenantHeat", "TenantGas", "TenantWtr",
                 "TenantSwr", "TenantHtWtr", "TenantInsur"]
      heatingAndCooling: "Y"
      description: "Lovely bi-level 1 bedroom + den with terrific newer kitchen, rear patio, hardwood floors, lots of light. Central air and washer/dryer. Working fireplace. Quiet Center City street. Separate utilities plus water and sewer. Owner prefers 16 month lease if possible."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "RowTwnhsClus"
      design: "2Story"
      floor: ""
      fee: ""
      availableAt: "02/18/2014"
      secondDeposit: "$3,200"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Lovely bi-level 1 bedroom + den with terrific newer kitchen, rear patio, hardwood floors, lots of light. Central air and washer/dryer. Working fireplace. Quiet Center City street. Separate utilities plus water and sewer. Owner prefers 16 month lease if possible."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0NDQzNjI7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2NzU3Mjc7fQ=="
      mlsNo: "6339604"
      latitude: 39.9444362
      longitude: -75.1675727

    2688:
      name: "2115 South St 310"
      isPublished: true
      createdAt: "2014-03-02T12:41:33.000Z"
      onMap: false
      similar: []
      position: 9
      title: "2115 South St 310"
      summary: ""
      postal_code: "19146 19146"
      street: "2115 South St 310"
      price: "1750"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "702"
      plotArea: ""
      yearOfCompletion: "2011"
      features: ["Heating/Cooling/Utilities: ElectricHeat", "CentralAir", "ElectricHWt", "PublicWater",
                 "PublicSewerGarages & Parking: NoGarage", "StreetParkng", "Asgn/DeedPk", "PermitParkng Kit: FullKit",
                 "Range", "Refrigerator", "Washer", "Dryer", "Dishwasher",
                 "Disposal Bsmt: NoBasement Interior: MainFlrLndry", "NoModifs/Unk Other: TenantElec", "TenantHeat",
                 "TenantHtWtr", "TenantInsur", "CableTV", "OtherTenant", "ComAreaMaint", "ExtBldgMaint", "SnowRemoval",
                 "TrashRemoval", "WaterFee", "ManagmentFee", "CallToShow", "ComboLockBox"]
      heatingAndCooling: "Y"
      description: "Enjoy breathtaking city skyline views from this bright and sunny corner one bedroom apartment in Fitler Square. The living areas offer high ceilings and oversized windows which fill the space with light. The newer open-layout kitchen showcases all stainless steel appliances, wood cabinets and ample countertop space. The bedroom has a walk-in closet and the spacious bathroom features chrome fixtures and a ceramic sink with storage vanity. An in-unit washer & dryer and available parking complete this beautiful apartment. Perfectly situated in Fitler Square, this pet-friendly home is steps away from the Schuylkill River Walking & Bike Path, University City, UPenn, Rittenhouse Square and major highways. Honey's Sit 'n Eat, City Fitness, La Va Cafe, CVS and South Square Market, are right at your doorstep! LIMITED TIME OFFER: One month rent FREE with a 12 month lease."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "LoRise"
      floor: "3"
      fee: "50"
      availableAt: "01/20/2014"
      secondDeposit: "$1,750"
      minTerm: "6"
      parking: ""
      basement: ""
      other: ""
      remarks: "Enjoy breathtaking city skyline views from this bright and sunny corner one bedroom apartment in Fitler Square. The living areas offer high ceilings and oversized windows which fill the space with light. The newer open-layout kitchen showcases all stainless steel appliances, wood cabinets and ample countertop space. The bedroom has a walk-in closet and the spacious bathroom features chrome fixtures and a ceramic sink with storage vanity. An in-unit washer & dryer and available parking complete this beautiful apartment. Perfectly situated in Fitler Square, this pet-friendly home is steps away from the Schuylkill River Walking & Bike Path, University City, UPenn, Rittenhouse Square and major highways. Honey's Sit 'n Eat, City Fitness, La Va Cafe, CVS and South Square Market, are right at your doorstep! LIMITED TIME OFFER: One month rent FREE with a 12 month lease."
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0NTI2ODg7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NzcyNDk7fQ=="
      mlsNo: "6325404"
      latitude: 39.9452688
      longitude: -75.1777249

    2708:
      name: "2006 Walnut St 3"
      isPublished: true
      createdAt: "2014-03-03T18:11:54.000Z"
      onMap: false
      similar: []
      position: 15
      title: "2006 Walnut St 3"
      summary: ""
      postal_code: "19103 19103"
      street: "2006 Walnut St 3"
      price: "2299"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "800"
      plotArea: ""
      yearOfCompletion: "1889"
      features: ["Heating/Cooling/Utilities: CentralAir", "PublicWaterGarages & Parking: NoGarage Kit: EatInKitchen",
                 "Range", "Refrigerator", "Washer", "Dryer", "Dishwasher", "Freezer",
                 "Disposal Bsmt: FullBasement Interior: NoFireplace", "FinishedWood", "SecureEntr", "CommonLndry",
                 "NoModifs/Unk Exterior: Sidewalks", "StreetLights", "StoneExt Other: TenantElec", "TenantHeat",
                 "TenantGas", "TenantWtr", "TenantHtWtr", "CableTV"]
      heatingAndCooling: "Y"
      description: "Be the first residents of the latest boutique building just steps off legendary Rittenhouse Square. The apartments are spacious, modern & tastefully appointed for the discerning resident. A seamless blend of old & new, each unit boasts recessed lighting, white oak hardwood floors, & modern square trim package. Gorgeous chef's kitchen brimming with the latest in kitchen design offer quartz countertops, sleek cabinetry & brand new appliances. Decadent full bathrooms with porcelain tile floors & shower surround as well as wetbed shower floors. The \"Provence\" unit features a generously proportioned bedroom with tons of closet space and natural light. All units include a washer & dryer. Moving in will be a breeze as the building is serviced by a high speed commercial elevator. Residents can escape to the shared roof deck to enjoy the outdoors, fresh air & center city skyline views. Ideal location near the Rittenhouse Garage, easy access to 76 & steps away from all the city has to offer. Occupancy beginning in February 2014!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: ""
      fee: ""
      availableAt: "02/01/2014"
      secondDeposit: "$2,299"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Be the first residents of the latest boutique building just steps off legendary Rittenhouse Square. The apartments are spacious, modern & tastefully appointed for the discerning resident. A seamless blend of old & new, each unit boasts recessed lighting, white oak hardwood floors, & modern square trim package. Gorgeous chef's kitchen brimming with the latest in kitchen design offer quartz countertops, sleek cabinetry & brand new appliances. Decadent full bathrooms with porcelain tile floors & shower surround as well as wetbed shower floors. The \"Provence\" unit features a generously proportioned bedroom with tons of closet space and natural light. All units include a washer & dryer. Moving in will be a breeze as the building is serviced by a high speed commercial elevator. Residents can escape to the shared roof deck to enjoy the outdoors, fresh air & center city skyline views. Ideal location near the Rittenhouse Garage, easy access to 76 & steps away from all the city has to offer. Occupancy beginning in February 2014!"
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MDMxMTk7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NDIzOTt9"
      mlsNo: "6302679"
      latitude: 39.9503119
      longitude: -75.174239

    2709:
      name: "224-30 W Rittenhouse Sq 2814"
      isPublished: true
      createdAt: "2014-03-03T18:11:59.000Z"
      onMap: false
      similar: []
      position: 17
      title: "224-30 W Rittenhouse Sq 2814"
      summary: ""
      postal_code: "19103 19103"
      street: "224-30 W Rittenhouse Sq 2814"
      price: "2500"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "740"
      plotArea: ""
      yearOfCompletion: "1964"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: FullKit Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantInsur", "OtherTenant"]
      heatingAndCooling: "Y"
      description: "FOR RENT: Sunny, west facing 1 bedroom at the Dorchester on Rittenhouse Square. Available immediately. This apartment is 740 square feet, parquet floors throughout, includes balcony. Washer/dryer in the unit. A summer rooftop pool (free Monday-Thursday; available at an additional cost during weekend times). On-site fitness center available at an additional cost. The Dorchester is a favorite among Wharton MBA students, as well as those who seek a location convenient to Center City attractions. The Dorchester does not allow pets and is a non-smoking building. On-site garage parking at additional cost, subject to availability. TENANT REQUIREMENTS: 1st month's rent, last month's rent, and one month security deposit to be paid at time of lease signing; minimum of average credit score for all adult applicants."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "02/27/2014"
      secondDeposit: "$2,500"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "FOR RENT: Sunny, west facing 1 bedroom at the Dorchester on Rittenhouse Square. Available immediately. This apartment is 740 square feet, parquet floors throughout, includes balcony. Washer/dryer in the unit. A summer rooftop pool (free Monday-Thursday; available at an additional cost during weekend times). On-site fitness center available at an additional cost. The Dorchester is a favorite among Wharton MBA students, as well as those who seek a location convenient to Center City attractions. The Dorchester does not allow pets and is a non-smoking building. On-site garage parking at additional cost, subject to availability. TENANT REQUIREMENTS: 1st month's rent, last month's rent, and one month security deposit to be paid at time of lease signing; minimum of average credit score for all adult applicants."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTA0NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTczNTk5OTt9"
      mlsNo: "6344272"
      latitude: 39.949045
      longitude: -75.1735999

    2710:
      name: "224-30 W Rittenhouse Sq 2512"
      isPublished: true
      createdAt: "2014-03-03T18:12:00.000Z"
      onMap: false
      similar: []
      position: 19
      title: "224-30 W Rittenhouse Sq 2512"
      summary: ""
      postal_code: "19103 19103"
      street: "224-30 W Rittenhouse Sq 2512"
      price: "2600"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "934"
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: NoneTentResp", "HealthFee", "CallToShow", "24HrNoticShw"]
      heatingAndCooling: "Y"
      description: "Rarely available and highly upgraded corner deluxe one bedroom with south and west views, separate dining area, balcony and washer/dryer. Renovated open kitchen, upgraded bath, walk-in closets. Built-in wall unit in living room and dining area. The Dorchester is a non-smoking building and does not permit pets. It has a health club available to all residents at $15 per month, seasonal rooftop pool available during the week with no charge and there is a fee for weekend use. Rent includes all utilities and basic cable. If interested, listing agent will prepare lease."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "25"
      fee: ""
      availableAt: "04/05/2014"
      secondDeposit: "$2,600"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Rarely available and highly upgraded corner deluxe one bedroom with south and west views, separate dining area, balcony and washer/dryer. Renovated open kitchen, upgraded bath, walk-in closets. Built-in wall unit in living room and dining area. The Dorchester is a non-smoking building and does not permit pets. It has a health club available to all residents at $15 per month, seasonal rooftop pool available during the week with no charge and there is a fee for weekend use. Rent includes all utilities and basic cable. If interested, listing agent will prepare lease."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTA0NTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTczNTk5OTt9"
      mlsNo: "6343589"
      latitude: 39.949045
      longitude: -75.1735999

    2711:
      name: "1414 S Penn Sq 6G"
      isPublished: true
      createdAt: "2014-03-03T18:23:15.000Z"
      onMap: false
      similar: []
      position: 18
      title: "1414 S Penn Sq 6G"
      summary: ""
      postal_code: "19102 19102"
      street: "1414 S Penn Sq 6G"
      price: "3250"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "894"
      plotArea: ""
      yearOfCompletion: "2011"
      features: ["Heating/Cooling/Utilities: GasHeat", "CentralAir", "GasHotWater", "PublicWater",
                 "400+AmpElecSGarages & Parking: 1-CarGarage", "1-CarParking", "Private Kit: KitW/NookBar", "Range",
                 "Refrigerator", "Washer", "Dryer", "Dishwasher", "Freezer", "Microwave",
                 "Disposal Bsmt: NoBasement Interior: NoFireplace", "SecureEntr", "MainFlrLndry",
                 "MoblImprMods Other: TenantElec", "CableTV", "ComAreaMaint", "ExtBldgMaint", "SnowRemoval",
                 "TrashRemoval", "HeatFee", "WaterFee", "SewerFee", "HotWtrFee", "CookFee", "ParkFee", "HealthFee",
                 "AllGroundFee", "ManagmentFee", "Security", "CallToShow", "ComboLockBox"]
      heatingAndCooling: "Y"
      description: "Live the Ritz-Carlton life! Indulge in hotel amenities at Philadelphia's most opulent residential community. Contemporary design by world-renowned Handel Architects. Chauffeur Service in a Mercedes towncar, state-of-the-art Fitness Center w/pool & yoga room, private landscaped park with 12' waterfall, Residents' Lounge w/attached media room & outdoor terrace. Homes enjoy Operable Windows in every room, 9' ceilings, wood floors. Designer kitchen featuring Viking gas range, Sub-Zero refrigerator, Miele dishwasher, Dornbracht fixtures, granite countertops, Franke S/S undermount sink, glass tile backsplash. Master bath features Calacatta marble, double vessel sinks, Bain ultra soaking tub, Duravit commodes, separate stall shower with frameless glass enclosure. Great Cafe and Coffee Shop right at your front door. Walk to everything Center City has to offer."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: "15"
      availableAt: "08/01/2013"
      secondDeposit: "$3,500"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Live the Ritz-Carlton life! Indulge in hotel amenities at Philadelphia's most opulent residential community. Contemporary design by world-renowned Handel Architects. Chauffeur Service in a Mercedes towncar, state-of-the-art Fitness Center w/pool & yoga room, private landscaped park with 12' waterfall, Residents' Lounge w/attached media room & outdoor terrace. Homes enjoy Operable Windows in every room, 9' ceilings, wood floors. Designer kitchen featuring Viking gas range, Sub-Zero refrigerator, Miele dishwasher, Dornbracht fixtures, granite countertops, Franke S/S undermount sink, glass tile backsplash. Master bath features Calacatta marble, double vessel sinks, Bain ultra soaking tub, Duravit commodes, separate stall shower with frameless glass enclosure. Great Cafe and Coffee Shop right at your front door. Walk to everything Center City has to offer."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTQ4OTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY0OTQ7fQ=="
      mlsNo: "6246503"
      latitude: 39.951489
      longitude: -75.16494

    2712:
      name: "1414 S Penn Sq 15D"
      isPublished: true
      createdAt: "2014-03-03T18:23:21.000Z"
      onMap: false
      similar: []
      position: 16
      title: "1414 S Penn Sq 15D"
      summary: ""
      postal_code: "19102 19102"
      street: "1414 S Penn Sq 15D"
      price: "3900"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,050"
      plotArea: ""
      yearOfCompletion: "2010"
      features: ["Heating/Cooling/Utilities: ElectricHeat", "CentralAir", "ElectricHWt",
                 "PublicWaterGarages & Parking: 4+CarGarage", "ParkingGarage Kit: EatInKitchen", "Range",
                 "Refrigerator", "Washer", "Dryer", "Dishwasher", "Microwave",
                 "Disposal Bsmt: NoBasement Interior: FinishedWood", "W/WCarpeting", "CableTVWired", "FullBath-MBR",
                 "Foyer/VestEn", "MainFlrLndry", "NoModifs/Unk Other: CableTV", "OtherTenant", "ElecFee", "HeatFee",
                 "WaterFee", "SewerFee", "CookFee", "SwimFee", "ClubFee", "HealthFee", "CallToShow"]
      heatingAndCooling: "Y"
      description: "Live in luxury at the Residences at The Ritz-Carlton! This fully furnished 1 Bed, 1.5 bath contemporary unit features these top of the line finishes: hardwood floors; beautiful kitchen with glass cabinets, gray stone countertops, Sub-zero refrigerator, wine refrigerator, Miele dishwasher, Viking oven, microwave; 10' ceilings with floor-to-ceiling operable windows; marble bathrooms with Bain ultra soaking tub in master bath; lots of closet space; laundry closet with washer/dryer; & much more. The building offers amazing amenities, such as 24/7 concierge service, valet parking w/on-site garage, chauffeur-driven town car, state of the art fitness center w/60 ft. lap pool & yoga studio, gated landscaped garden with fountain, access to resident's lounge w/media room, outdoor terrace & catering pantry; & any amenity that you can get as a guest at the adjacent Ritz-Carlton Hotel. Not only is the unit stunning, but the northern view of the city and view of the amazing architecture of Philadelphia's Historic City Hall are ecstatic. Also, coming this Spring 2014, you will be able to take in the view of the new Dilworth Plaza - promised to create an extraordinary center for arts & entertainment and a central first-class hub to all of the amazing things that downtown Philadelphia has to offer. The building is within walking distance to shopping, restaurants, bars, museums, hotels and easily accessible to all major pubic transportation. Enjoy \"Hotel Living\" every day of the week!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "3+Story"
      floor: "15"
      fee: "45"
      availableAt: "11/01/2013"
      secondDeposit: "$4,000"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Live in luxury at the Residences at The Ritz-Carlton! This fully furnished 1 Bed, 1.5 bath contemporary unit features these top of the line finishes: hardwood floors; beautiful kitchen with glass cabinets, gray stone countertops, Sub-zero refrigerator, wine refrigerator, Miele dishwasher, Viking oven, microwave; 10' ceilings with floor-to-ceiling operable windows; marble bathrooms with Bain ultra soaking tub in master bath; lots of closet space; laundry closet with washer/dryer; & much more. The building offers amazing amenities, such as 24/7 concierge service, valet parking w/on-site garage, chauffeur-driven town car, state of the art fitness center w/60 ft. lap pool & yoga studio, gated landscaped garden with fountain, access to resident's lounge w/media room, outdoor terrace & catering pantry; & any amenity that you can get as a guest at the adjacent Ritz-Carlton Hotel. Not only is the unit stunning, but the northern view of the city and view of the amazing architecture of Philadelphia's Historic City Hall are ecstatic. Also, coming this Spring 2014, you will be able to take in the view of the new Dilworth Plaza - promised to create an extraordinary center for arts & entertainment and a central first-class hub to all of the amazing things that downtown Philadelphia has to offer. The building is within walking distance to shopping, restaurants, bars, museums, hotels and easily accessible to all major pubic transportation. Enjoy \"Hotel Living\" every day of the week!"
      furnished: "Y"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTQ4OTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTY0OTQ7fQ=="
      mlsNo: "6300894"
      latitude: 39.951489
      longitude: -75.16494

    2713:
      name: "2101 Market St 901"
      isPublished: true
      createdAt: "2014-03-03T18:23:27.000Z"
      onMap: false
      similar: []
      position: 12
      title: "2101 Market St 901"
      summary: ""
      postal_code: "19103 19103"
      street: "2101 Market St 901"
      price: "3100"
      bedrooms: "1"
      bathrooms: "1"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,091"
      plotArea: ""
      yearOfCompletion: "2009"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: 1-CarGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: W/WCarpeting",
                 "CableTVWired", "MainFlrLndry",
                 "NoModifs/Unk Exterior: Balcony Building Orient: BldOrientationN Other: TenantElec", "CableTV"]
      heatingAndCooling: "Y"
      description: ""
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: "9"
      fee: "45"
      availableAt: "02/01/2014"
      secondDeposit: "$3,100"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: ""
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1NDA2NDM7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE3NTM5MjU7fQ=="
      mlsNo: "6312437"
      latitude: 39.9540643
      longitude: -75.1753925

    2722:
      name: "1930-34 Chestnut St 17A"
      isPublished: true
      createdAt: "2014-03-04T05:51:26.000Z"
      onMap: false
      similar: []
      position: 11
      title: "1930-34 Chestnut St 17A"
      summary: ""
      postal_code: "19103 19103"
      street: "1930-34 Chestnut St 17A"
      price: "2150"
      bedrooms: "1"
      bathrooms: "2"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1930"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: EatInKitchen Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantGas", "CableTV", "OtherTenant"]
      heatingAndCooling: "Y"
      description: "Fantastic 1 bedroom, 2 bath apartment with Den for rent JUST STEPS OFF OF RITTENHOUSE SQUARE. Open living and dining space, well proportioned bedroom. Great space and value. A MUST SEE!!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "LoRise"
      floor: ""
      fee: ""
      availableAt: "11/26/2013"
      secondDeposit: "$2,150"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Fantastic 1 bedroom, 2 bath apartment with Den for rent JUST STEPS OFF OF RITTENHOUSE SQUARE. Open living and dining space, well proportioned bedroom. Great space and value. A MUST SEE!!"
      furnished: "N"
      pets: "Y"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk1MTg0MTtzOjk6ImxvbmdpdHVkZSI7ZDotNzUuMTczMzM7fQ=="
      mlsNo: "6311930"
      latitude: 39.951841
      longitude: -75.17333

    2724:
      name: "1700 Walnut St 3A"
      isPublished: true
      createdAt: "2014-03-04T05:51:31.000Z"
      onMap: false
      similar: []
      position: 7
      title: "1700 Walnut St 3A"
      summary: ""
      postal_code: "19103 19103"
      street: "1700 Walnut St 3A"
      price: "2650"
      bedrooms: "2"
      bathrooms: "2"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: ""
      plotArea: ""
      yearOfCompletion: "1015"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage Kit: KitW/NookBar Bsmt: NoBasement Interior: MainFlrLndry",
                 "NoModifs/Unk Other: TenantElec", "TenantHeat", "TenantWtr", "TenantInsur", "CableTV"]
      heatingAndCooling: "Y"
      description: "Fantastic 2 bedroom, 2 1/2 bath apartment for rent, Just off of RITTENHOUSE SQUARE. Open living and dining space 2 LARGE all tile baths, plus additional 1/2 bath. Wonderful natural sun light and TERRIFIC CLOSET SPACE. A MUST SEE!!"
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "HiRise"
      floor: ""
      fee: ""
      availableAt: "09/05/2013"
      secondDeposit: "$2,650"
      minTerm: "12"
      parking: ""
      basement: ""
      other: ""
      remarks: "Fantastic 2 bedroom, 2 1/2 bath apartment for rent, Just off of RITTENHOUSE SQUARE. Open living and dining space 2 LARGE all tile baths, plus additional 1/2 bath. Wonderful natural sun light and TERRIFIC CLOSET SPACE. A MUST SEE!!"
      furnished: "N"
      pets: "R"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0OTgyMjQ7czo5OiJsb25naXR1ZGUiO2Q6LTc1LjE2OTI2MDE7fQ=="
      mlsNo: "6274773"
      latitude: 39.9498224
      longitude: -75.1692601

    2726:
      name: "226 W Rittenhouse Sq 1101"
      isPublished: true
      createdAt: "2014-03-04T05:51:39.000Z"
      onMap: false
      similar: []
      position: 4
      title: "226 W Rittenhouse Sq 1101"
      summary: ""
      postal_code: "19103 19103"
      street: "226 W Rittenhouse Sq 1101"
      price: "2850"
      bedrooms: "2"
      bathrooms: "2"
      contactPerson: "YToyOntzOjU6ImxhYmVsIjtzOjE0OiJUaGUgUmVudCBTY2VuZSI7czozOiJ1cmwiO3M6MjQ6InZpZXdpbmdAdGhlcmVudHNjZW5lLmNvbSI7fQ=="
      phone: ""
      sqft: "1,140"
      plotArea: ""
      yearOfCompletion: "1964"
      features: ["Heating/Cooling/Utilities: CentralAirGarages & Parking: NoGarage", "PermitParkng Kit: FullKit",
                 "Range", "Washer", "Dryer", "Dishwasher", "Freezer", "Microwave",
                 "Disposal Bsmt: FullBasement Interior: FinishedWood", "TileFlr", "StoneFlr", "FullBath-MBR",
                 "WICloset-MBR", "MainFlrLndry", "NoModifs/Unk Exterior: AbovGrndPool", "Other: NoneTentResp",
                 "CallToShow"]
      heatingAndCooling: "Y"
      description: "Brand New Renovation at The Dorchester: High-End sophisticated renovation ? 2 Bedrm, 2 Bath Terraced Corner Apt on Ritt Sq in prominent doorman bldg. Renovation worthy of raves: Miele appliances, Quartz Counters, Stainless Steel tile, Floating Vanities, Miele Washer, Miele Dryer, Designer Lighting, Wd Flrs Throughout, Custom Window Cover ? More. Fine bldg w/ on site prkg priced below market at add'l cost; gym, nominal add'l cost; glamorous outdr rooftop pool w/ generous evening hours, nominal add'l cost. Services, services and then some: Excellent security, Doorman plus 24 hour Lobby Desk/Concierge. Renovation nearing competion. Rental Avail March 15. Rent includes cable & all utilities, except phone. No pets, no smoking. Rare offering. Ceiling to floor new kitchen ? unheard of ? more."
      specialOffer: ""
      website: "YTozOntzOjU6ImxhYmVsIjtzOjA6IiI7czo4OiJwcm90b2NvbCI7czowOiIiO3M6MzoidXJsIjtOO30="
      special: ""
      type: "UnitFlat"
      design: "1Story"
      floor: "11"
      fee: "75"
      availableAt: "03/15/2014"
      secondDeposit: "$2,850"
      minTerm: "24"
      parking: ""
      basement: ""
      other: ""
      remarks: "Brand New Renovation at The Dorchester: High-End sophisticated renovation ? 2 Bedrm, 2 Bath Terraced Corner Apt on Ritt Sq in prominent doorman bldg. Renovation worthy of raves: Miele appliances, Quartz Counters, Stainless Steel tile, Floating Vanities, Miele Washer, Miele Dryer, Designer Lighting, Wd Flrs Throughout, Custom Window Cover ? More. Fine bldg w/ on site prkg priced below market at add'l cost; gym, nominal add'l cost; glamorous outdr rooftop pool w/ generous evening hours, nominal add'l cost. Services, services and then some: Excellent security, Doorman plus 24 hour Lobby Desk/Concierge. Renovation nearing competion. Rental Avail March 15. Rent includes cable & all utilities, except phone. No pets, no smoking. Rare offering. Ceiling to floor new kitchen ? unheard of ? more."
      furnished: "N"
      pets: "N"
      applyAt: ""
      country: "U.S.A"
      city: "Philadelphia"
      location: "YToyOntzOjg6ImxhdGl0dWRlIjtkOjM5Ljk0ODg5O3M6OToibG9uZ2l0dWRlIjtkOi03NS4xNzMxMjk7fQ=="
      mlsNo: "6344766"
      latitude: 39.94889
      longitude: -75.173129

    2750:
      name: "Kennedy-Warren Apartments"
      isPublished: true
      createdAt: "2014-06-01T14:17:20.000Z"
      onMap: true
      similar: []
      position: null
      mlsNo: ""
      secondDeposit: ""
      minTerm: ""
      basement: ""
      other: ""
      applyAt: ""
      floor: ""
      type: ""
      design: ""
      special: ""
      parking: ""
      furnished: ""
      pets: ""
      sqft: ""
      specialOffer: ""
      remarks: ""
      plotArea: ""
      features: [""]
      bedrooms: ""
      bathrooms: ""
      availableAt: ""
      propertyType: "0"
      laundry: ""
      title: "Kennedy-Warren Apartments"
      yearOfCompletion: ""
      heatingAndCooling: ""
      description: "Nice building in Washington DC"
      street: "3133 Connecticut Ave NW"
      fee: ""
      postal_code: "20008"
      price: ""
      city: "Washington DC"
      country: "United States"
      summary: ""
      phone: ""
      latitude: 38.931927
      longitude: -77.055606
      studio:
        from: 1450

    2752:
      name: ""
      isPublished: true
      createdAt: "2014-06-21T22:29:27.000Z"
      onMap: false
      similar: []
      position: null
      propertyType: "0"
      laundry: "0"
      title: ""
      yearOfCompletion: ""
      heatingAndCooling: ""
      description: ""
      street: ""
      fee: ""
      postal_code: ""
      price: ""
      city: ""
      country: ""
      summary: ""
      phone: ""
      remarks: ""
      plotArea: ""
      features: [""]
      bedrooms: ""
      bathrooms: ""
      availableAt: ""
      parking: ""
      furnished: ""
      pets: ""
      sqft: ""
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      secondDeposit: ""
      minTerm: ""
      basement: ""
      other: ""
      applyAt: ""
      mlsNo: ""
      latitude: 0
      longitude: 0

    2753:
      name: ""
      isPublished: true
      createdAt: "2014-06-22T08:47:14.000Z"
      onMap: false
      similar: []
      position: null
      furnished: ""
      pets: ""
      sqft: ""
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      secondDeposit: ""
      minTerm: ""
      basement: ""
      other: ""
      applyAt: ""
      mlsNo: ""
      parking: ""
      availableAt: ""
      bathrooms: ""
      bedrooms: ""
      features: [""]
      plotArea: ""
      remarks: ""
      phone: ""
      summary: ""
      country: ""
      city: ""
      price: ""
      postal_code: ""
      fee: ""
      street: ""
      description: ""
      heatingAndCooling: ""
      yearOfCompletion: ""
      title: ""
      laundry: ""
      propertyType: "0"
      latitude: 0
      longitude: 0

    2754:
      name: ""
      isPublished: true
      createdAt: "2014-06-22T08:49:02.000Z"
      onMap: false
      similar: []
      position: null
      applyAt: ""
      mlsNo: ""
      other: ""
      title: ""
      yearOfCompletion: ""
      heatingAndCooling: ""
      description: ""
      street: ""
      fee: ""
      postal_code: ""
      price: ""
      city: ""
      country: ""
      summary: ""
      phone: ""
      remarks: ""
      plotArea: ""
      features: [""]
      bedrooms: ""
      bathrooms: ""
      availableAt: ""
      parking: ""
      furnished: ""
      pets: ""
      sqft: ""
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      secondDeposit: ""
      minTerm: ""
      basement: ""
      propertyType: "0"
      laundry: ""
      latitude: 0
      longitude: 0

    2771:
      name: "testtttttttt"
      isPublished: true
      createdAt: "2014-06-24T07:03:24.000Z"
      onMap: false
      similar: []
      position: 100
      mlsNo: ""
      applyAt: ""
      other: ""
      basement: ""
      minTerm: ""
      secondDeposit: ""
      floor: ""
      design: ""
      type: ""
      special: ""
      specialOffer: ""
      sqft: ""
      pets: "{\"radio\":\"0\",\"comment\":\"\"}"
      furnished: ""
      parking: "{\"radio\":\"0\",\"comment\":\"\"}"
      availableAt: ""
      bathrooms: ""
      bedrooms: ""
      features: [""]
      plotArea: ""
      remarks: ""
      phone: ""
      summary: ""
      country: ""
      city: ""
      price: ""
      postal_code: ""
      fee: ""
      street: ""
      description: "testtttttttt"
      heatingAndCooling: ""
      yearOfCompletion: ""
      title: "testtttttttt"
      laundry: "0"
      propertyType: "0"
      latitude: 0
      longitude: 0

    2772:
      name: "test4564"
      isPublished: true
      createdAt: "2014-06-24T07:04:35.000Z"
      onMap: false
      similar: []
      position: 101
      applyAt: ""
      basement: ""
      other: ""
      propertyType: "0"
      laundry: "0"
      title: "test4564"
      yearOfCompletion: ""
      heatingAndCooling: ""
      description: ""
      street: ""
      fee: ""
      postal_code: ""
      price: ""
      city: ""
      country: ""
      summary: ""
      phone: ""
      remarks: ""
      plotArea: ""
      features: [""]
      bedrooms: ""
      bathrooms: ""
      availableAt: ""
      parking: "{\"radio\":\"0\",\"comment\":\"\"}"
      furnished: ""
      pets: "{\"radio\":\"0\",\"comment\":\"\"}"
      sqft: ""
      specialOffer: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      secondDeposit: ""
      minTerm: ""
      mlsNo: ""
      latitude: 0
      longitude: 0

  insertData(buildings, Buildings)
