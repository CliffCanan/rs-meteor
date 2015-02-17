Template.city.helpers
  buildings: ->
    Buildings.find()
  randomImage: ->
    images = [
      "/images/search-img1.jpg"
      "/images/search-img2.jpg"
      "/images/search-img3.jpg"
    ]
    images[Math.floor(Math.random() * images.length)]

Template.city.rendered = ->
  $('.slider').slider()
