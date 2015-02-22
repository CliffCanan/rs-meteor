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
    Admin:
      profile:
        name: "Admin"
        isRealName: true
      role: "admin"
    JaneSmith:
      profile:
        name: "Jane Smith"
        isRealName: true
      role: "customer"
      autoSaved: true
    DavidPhillips:
      profile:
        name: "David Phillips"
        isRealName: true
      role: "super"
    Tori:
      profile:
        name: "Tori"
        isRealName: true
      role: "staff"

  for _id, user of users
    _.defaults(user,
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

  insertData(buildingsFixtures, Buildings)

  if BuildingImages.find().count() is 0
    for buildingId, images of buildingImagesFixtures
      building = Buildings.findOne(buildingId)
      if building
        for dataURI in images
          cl "inserting file for building " + building._id
          file = BuildingImages.insert(dataURI)
          Buildings.update(_id: building._id, {$addToSet: {images: file}})

  userList =
    testUserList:
      customerId: "JaneSmith"
      customerName: "Jane Smith"
      buildingsIds: [
        "2401",
        "2403",
        "2404",
        "2406"
      ]
  usersInserted = insertData(userList, UserLists)
