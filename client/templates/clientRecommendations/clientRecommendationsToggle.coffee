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

Template.clientRecommendationsToggle.events
  "click #all-listings-toggle": ->
    Session.set "showRecommendations", null
    return
  "click #my-recommendations-toggle": ->
    Session.set "showRecommendations", true
    return