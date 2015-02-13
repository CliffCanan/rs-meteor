Accounts.onLogin (info) ->
  # Meteor calls onLogin even when already logged-in user reloads the page
  mixpanel.track("AuthenticatedPageload", {distinct_id: info.user._id, userId: info.user._id})
