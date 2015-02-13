_.defaults(Match,
  Id: Match.Where (value) ->
    check(value, String)
    if value in share.fixtureIds or share.isDebug
      return true # verbose IDs
    if value.length isnt 17 or _.difference(value.split(""), ["2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]).length
      throw new Match.Error("Value \"" + value + "\" is not a valid ID")
    true
  UserId: Match.Where (value) ->
    check(value, Match.Id)
    unless Meteor.users.findOne(value)
      throw new Match.Error("User with ID \"" + value + "\" doesn't exist")
    true
  InArray: (possibleValues) ->
    Match.Where (value) ->
      if possibleValues.indexOf(value) == -1
        throw new Match.Error("Expected one of \""+possibleValues.join("\", \"")+"\"; got \"" + value + "\"")
      true
  UnsignedNumber: Match.Where (value) ->
    check(value, Number)
    if value < 0
      throw new Match.Error("Must be unsigned number")
    true
  Email: Match.Where (value) ->
    value.match(share.emailRegex)
  Url: Match.Where (value) ->
    value.length < 2083 && value.match(/^(?!mailto:)(?:(?:https?|ftp):\/\/)?(?:\S+(?::\S*)?@)?(?:(?:(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[0-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))|localhost)(?::\d{2,5})?(?:\/[^\s]*)?$/i);
  WidgetId: Match.Where (value) ->
    check(value, Match.Id)
    unless Widgets.findOne(value)
      throw new Match.Error("Widget #\"" + value + "\" doesn't exist")
    true
)
