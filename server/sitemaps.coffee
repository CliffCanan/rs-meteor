sitemaps.add '/sitemap.xml', ->
  pages = []

  # Home page
  pages.push page: '/', lastmod: new Date()

  # City pages
  # Get latest updated dates by city
  cityUpdatedDates = Buildings.aggregate([{$group: {_id: '$cityId', updatedAt: {$max: '$updatedAt'}}}])

  for cityId in @cityIds
    pages.push page: "/city/#{cityId}", lastmod:  _.where(cityUpdatedDates, {_id: cityId}).pop().updatedAt

  # Building pages
  for building, key in Buildings.find().fetch()
    data =
      cityId: building.cityId
      neighborhoodSlug: building.neighborhoodSlug
      buildingSlug: building.slug

    if building.parentId 
      parent = Buildings.findOne(building.parentId)
      data.buildingSlug = parent.slug
      data.unitSlug = building.slug
    pages.push page: Router.routes['building'].path(data), lastmod: building.updatedAt

  pages