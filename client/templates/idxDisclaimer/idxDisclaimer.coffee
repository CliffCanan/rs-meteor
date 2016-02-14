Template.idxDisclaimer.helpers ->
  showIDXDisclaimer: ->
    Router.current().route.getName() is 'city' or Router.current().route.getName() is 'building'