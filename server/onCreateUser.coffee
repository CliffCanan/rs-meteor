Accounts.onCreateUser (options, user) ->
  google = user.services?.google
  if google
    if google.email
      user.emails = user.emails || []
      user.emails.push { address: google.email.toLowerCase(), verified: !!google.verified_email }
    else
      throw new Error("gmail user must provide an email")

  user.profile = options.profile || {}
  if user.profile.name
    user.profile.isRealName = true # if auth service returned profile with name, assume it's a real name
  else
    user.profile.isRealName = false
    email = user.emails?[0]?.address
    if email
      user.profile.name = email.split("@")[0]
  return user
