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

  #images = [{\"name\":\"img_2121%20Market%20%281%29.jpg\",\"url\":\"components/com_trsproperties/assets/uploader/server/php/files/img_2121%20Market%20%281%29.jpg\",\"thumb\":\"components/com_trsproperties/assets/uploader/server/php/files/thumbnail/img_2121%20Market%20%281%29.jpg\"},{\"name\":\"img_2121%20Market2%20%281%29.jpg\",\"url\":\"components/com_trsproperties/assets/uploader/server/php/files/img_2121%20Market2%20%281%29.jpg\",\"thumb\":\"components/com_trsproperties/assets/uploader/server/php/files/thumbnail/img_2121%20Market2%20%281%29.jpg\"},{\"name\":\"img_2121%20Market3%20%281%29.jpg\",\"url\":\"components/com_trsproperties/assets/uploader/server/php/files/img_2121%20Market3%20%281%29.jpg\",\"thumb\":\"components/com_trsproperties/assets/uploader/server/php/files/thumbnail/img_2121%20Market3%20%281%29.jpg\"},{\"name\":\"img_2121%20Market4%20%281%29.jpg\",\"url\":\"components/com_trsproperties/assets/uploader/server/php/files/img_2121%20Market4%20%281%29.jpg\",\"thumb\":\"components/com_trsproperties/assets/uploader/server/php/files/thumbnail/img_2121%20Market4%20%281%29.jpg\"},{\"name\":\"img_2121%20Market6%20%281%29.jpg\",\"url\":\"components/com_trsproperties/assets/uploader/server/php/files/img_2121%20Market6%20%281%29.jpg\",\"thumb\":\"components/com_trsproperties/assets/uploader/server/php/files/thumbnail/img_2121%20Market6%20%281%29.jpg\"},{\"name\":\"img_2121%20Market7%20%281%29.jpg\",\"url\":\"components/com_trsproperties/assets/uploader/server/php/files/img_2121%20Market7%20%281%29.jpg\",\"thumb\":\"components/com_trsproperties/assets/uploader/server/php/files/thumbnail/img_2121%20Market7%20%281%29.jpg\"}]

  buildings =
    first:
      title: "2121 Market Street"
      summary: "2121 Market, most prominently known for it\'s price, is conveniently located directly above a Trader Joe\'s. Safe to say, you truly get what you pay for with this property."
      postalCode: "19103"
      street: "2121 Market Street"
      price: "$1140"
      bedrooms: ""
      bathrooms: ""
      contactPerson: ""
      phone: "914-500-8662"
      sqft: ""
      plotArea: ""
      yearOfCompletion: ""
      features: [
        "On-site laundry"
        "Pet friendly"
        "High ceilings"
        "Shared Laundry"
      ]
      images: ""
      description: ""
      specialOffer: ""
      website: ""
      special: ""
      type: ""
      design: ""
      floor: ""
      fee: ""
      available: ""
      secondDeposit: ""
      minTerm: ""
      parking: ""
      basement: ""
      other: ""
      remarks: ""
      furnished: ""
      pets: ""
      applyAt: ""
      country: ""
      city: ""
      location: ""
      mls: ""
      propertyType: ""
      laundry: ""
