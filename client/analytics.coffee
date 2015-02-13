Meteor.startup ->
  Deps.autorun ->
    user = Meteor.user()
    unless user
      return
    user = share.Transformations.user(user)
    if user.isInternal or share.isAutologin()
      mixpanel.disable()
    if user.isAliasedByMixpanel
      mixpanel.identify(user._id)
    else
      mixpanel.alias(user._id)
      mixpanel.track("$signup")
      Meteor.users.update(user._id, {$set: {isAliasedByMixpanel: true}})
      return # reactivity reruns the function
    mixpanel.people.set(
      _id: user._id
      $name: user.profile.name
      $first_name: user.firstName
      $last_name: user.lastName
      $email: user.emails[0].address
      $created: user.createdAt
      isRealName: user.profile.isRealName
    )
