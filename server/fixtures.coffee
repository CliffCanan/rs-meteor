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
        role: "admin"
    SecondAdmin:
      profile:
        name: "Second Admin"
        role: "admin"
    Tatiana:
      name: "Tatiana"
      role: "customer"
      autoSaved: true
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

  buildings = buildingsFixtures or {}
  insertData(buildings, Buildings)

  userList =
    testUserList:
      customerId: "Tatiana"
      customerName: "Tatiana"
      buildingsIds: [
        "2401",
        "2403",
        "2404",
        "2406"
      ]
  usersInserted = insertData(userList, UserLists)
