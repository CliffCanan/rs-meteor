Template.clientRecommendationsToggle.onCreated ->
  instance = @
  recommendation = @data

  (unitIds = recommendation.unitIds.map (value) -> value.unitId) if recommendation.unitIds?
  recommendedIds = recommendation.buildingIds.concat(unitIds) if recommendation.buildingIds?

  @importCompletedCount = new ReactiveVar(0)
  
  if recommendedIds
    @subscribe "recommendedBuildings", recommendedIds, ->
      importCompletedCount = Buildings.find({_id: {$in: recommendation.buildingIds}, $or: [{$and: [{isImportCompleted: {$exists: true}}, {isImportCompleted: true}]}, {isImportCompleted: {$exists: false}}]}).count()
      instance.importCompletedCount.set importCompletedCount

  @clientRecommendation = ->
    return ClientRecommendations.findOne @data._id

Template.clientRecommendationsToggle.onRendered ->
  # Overwrite default property leave events so stays open when the user hover overs the content to click on any links.
  originalLeave = $.fn.popover.Constructor.prototype.leave;
  $.fn.popover.Constructor.prototype.leave = (obj) ->
    self = if obj instanceof @.constructor then obj else $(obj.currentTarget)[this.type](this.getDelegateOptions()).data('bs.' + this.type)

    originalLeave.call(@, obj);

    if obj.currentTarget
      container = $(obj.currentTarget).next('.popover')
      container.one 'mouseenter.tooltip.extra', ->
        self.hoverState = 'in'
        clearTimeout(self.timeout)
        container.one 'mouseleave.tooltip.extra', -> $.fn.popover.Constructor.prototype.leave.call(self, self)
  
  originalShow = $.fn.popover.Constructor.prototype.show;

  $.fn.popover.Constructor.prototype.show = ->
    thisTip = @.tip();
    $('.popover').not(thisTip).popover('hide');
    if not thisTip.is(':visible')
      originalShow.call(@)

  Tracker.autorun ->
    if Session.get 'showRecommendations'
      $('#my-recommendations-toggle').addClass('active')
      $('#all-listings-toggle').removeClass('active')
      $('.filter-wrap .dropdown-toggle').addClass('disabled')
      $('.filter-wrap .building-title-search').attr('disabled', 'disabled')
      $('.price-slider').slider('disable')

      popoverOptions = 
        content: 'Filters not available on recommendation list. <a href="#" class="show-all-listings">Click to activate and view all properties.</a>'
        html: true
        trigger: 'click hover'
        placement: 'auto'
        delay: {show: 50, hide: 400}

      $('.filter-wrap .city-sub-header-list-wrap,
        .filter-wrap .features-wrap,
        .city-subheader-price .slider,
        .building-title-search-wrapper').popover(popoverOptions)

      return
    else
      $('#all-listings-toggle').addClass('active')
      $('#my-recommendations-toggle').removeClass('active')
      $('.filter-wrap .dropdown-toggle').removeClass('disabled');
      $('.filter-wrap .building-title-search').removeAttr('disabled')
      $('.price-slider').slider('enable')

      $('.filter-wrap .city-sub-header-list-wrap,
        .filter-wrap .features-wrap,
        .city-subheader-price .slider,
        .building-title-search-wrapper').popover('destroy')
      return

  $('#import-status').tooltip()
  instance = @
  Tracker.autorun ->
    importCompletedCount = Buildings.find({_id: {$in: Router.current().data().buildingIds}, $or: [{$and: [{isImportCompleted: {$exists: true}}, {isImportCompleted: true}]}, {isImportCompleted: {$exists: false}}]}).count()
    instance.importCompletedCount.set(importCompletedCount)
    Tracker.afterFlush ->
      $('#import-status').tooltip()

Template.clientRecommendationsToggle.helpers
  showImportStatus: ->
    Router.current().route.getName() is "clientRecommendations"
  isTemplateSubscriptionsReady: ->
    if Template.instance().subscriptionsReady() is true
      Tracker.afterFlush ->
        $('#import-status').tooltip()      
    Template.instance().subscriptionsReady()
  isImportPending: ->
    instance = Template.instance()
    importCompletedCount = instance.importCompletedCount.get()
    importCompletedCount isnt instance.data.buildingIds.length  
  importCompletedCount: ->
    instance = Template.instance()
    $('#import-status').tooltip()
    instance.importCompletedCount.get()
  totalPropertiesCount: ->
    instance = Template.instance()
    instance.data.buildingIds.length
  completedImportText: ->
    instance = Template.instance()
    totalPropertiesCount = instance.data.buildingIds.length

    if instance.clientRecommendation().userName and instance.clientRecommendation().createdAt and instance.clientRecommendation().importCompletedAt
      difference = Math.floor((instance.clientRecommendation().importCompletedAt - instance.clientRecommendation().createdAt) / 1000)

      minutes = Math.floor(difference / 60)
      differenceText = ''

      if minutes
        seconds = difference - minutes * 60

        if minutes is 1
          differenceText = "#{minutes} minute"
        else
          differenceText = "#{minutes} minutes"
      else
        seconds = difference

      if seconds
        if seconds is 1
          differenceText += " #{seconds} second"
        else
          differenceText += " #{seconds} seconds"

      importDate = moment(instance.clientRecommendation().createdAt).format('MMM D, YYYY')

      return "#{totalPropertiesCount} properties imported by #{instance.clientRecommendation().userName} #{importDate} (#{differenceText})"
    else
      return "#{totalPropertiesCount} properties imported"

Template.clientRecommendationsToggle.events
  "click #all-listings-toggle": ->
    Session.set "showRecommendations", false
    $('.main-city-list-wrap').css('height', '100%')
    return
  "click #my-recommendations-toggle": ->
    Session.set "showRecommendations", true
    $('.main-city-list-wrap').css('height', '100%')
    return
