Template.city.helpers
  buildings: ->
    Buildings.find()
  mainImage: ->
    @images?[0]?.getFileRecord()
  randomImage: ->
#    images = [
#      "/images/search-img1.jpg"
#      "/images/search-img2.jpg"
#      "/images/search-img3.jpg"
#    ]
#    images[Math.floor(Math.random() * images.length)]
    "/images/search-img3.jpg"

Template.city.rendered = ->
  $('.slider').slider()
