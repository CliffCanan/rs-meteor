Template.reviewBar.helpers
  barWidth: ->
    instance = Template.instance()
    instance.data.score / 5 * 100