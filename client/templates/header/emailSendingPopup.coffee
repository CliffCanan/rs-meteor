Template.emailSendingPopup.onCreated ->
  @isEmailValid = (address) ->
    return /^[A-Z0-9'.1234z_%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test address

  @sendRecommendations = =>
    input = @$(".js-client-address")
    email = input.val()
    client = Session.get("recommendationsClientObject")

    if @isEmailValid email
      @$(".input-error-message").html("")
      if client
        name = client.name
        Meteor.call "setClientEmail", client._id, email, (error) ->
          if error
            share.notifyRecommendationsEmailError name
            console.log 'Error has been returned from "setClientEmail"', error
          else
            input.val("")
            $('#email-sending-popup').modal('hide')

            id = client._id
            Meteor.call "sendRecommendationEmail", id, (error) ->
              if error
                share.notifyRecommendationsEmailError name
                console.log 'Error has been returned from "sendRecommendationEmail"', error
              else
                share.notifyRecommendationsSuccessfullySent name
      else
        console.log "Error: Client object is not set!"
    else
      @$(".input-error-message").html("Please enter valid email address")

Template.emailSendingPopup.helpers
  
Template.emailSendingPopup.events
  "click #send-recommendation-email": (event, template) ->
    event.preventDefault()
    template.sendRecommendations()

  "submit .send-recommendation-email-form": (event, template) ->
    event.preventDefault()
    template.sendRecommendations()
