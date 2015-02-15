dataFields =
  100: "title"
  101: "summary"
  102: "postal_code"
  103: "street"
  104: "price"
  105: "bedrooms"
  106: "bathrooms"
  107: "contactPerson"
  108: "phone"
  109: "sqft"
  110: "plotArea"
  111: "yearOfCompletion"
  112: "features"
  113: "heatingAndCooling"
  114: "images"
  115: "description"
  116: "specialOffer"
  117: "website"
  118: "special"
  119: "type"
  120: "design"
  121: "floor"
  122: "fee"
  123: "availableAt"
  124: "secondDeposit"
  125: "minTerm"
  126: "parking"
  127: "basement"
  128: "other"
  129: "remarks"
  130: "furnished"
  131: "pets"
  133: "applyAt"
  134: "country"
  135: "city"
  136: "location"
  137: "mlsNo"
  138: "propertyType"
  139: "laundry"


tables = [
  "trsproperties_article", "trsproperties_availability",
  "trsproperties_buildings", "trsproperties_field",
  "trsproperties_field_data", "trsproperties_field_geo",
  "trsproperties_form", "trsproperties_prices",
  "trsproperties_units"
]

@mysqlImport = ->
  mysql = Meteor.npmRequire("mysql")

  connection = mysql.createConnection
    host: "localhost"
    user: "root"
    database: "rentscene"

  connection.connect (error) ->
    if error
      console.error("error connecting: " + error.stack)
    else
      console.log("connected as id " + connection.threadId)

      buildings = {}
      connection.query "SELECT * FROM skp8s_trsproperties_article", (error, rows, fields) ->
        throw error if (error)
        for article in rows
          building = buildings[article.id] =
            name: article.name
            isPublished: !!article.published
            createdAt: new Date(article.createdtime)
            onMap: !!article.onMap
            similar: []
            position: article.ordering

          if article.similar
            similar = article.similar.replace(/["\[\]]/g, "")
            if similar.length
              building.similar = similar.split(",")

        connection.query "SELECT * FROM skp8s_trsproperties_field_data", (error, rows, fields) ->
          throw error if (error)
          for data in rows
            building = buildings[data.articleid]
            if building
              fieldName = dataFields[data.fieldid]
              if fieldName is "features"
                building[fieldName] = data.value.split(", ")
              else if fieldName is "images"
                # TODO: process images
              else
                building[fieldName] = data.value

          connection.query "SELECT * FROM skp8s_trsproperties_field_geo", (error, rows, fields) ->
            throw error if (error)
            for data in rows
              building = buildings[data.articleid]
              if building
                building.latitude = data.latitude
                building.longitude = data.longitude

            connection.query "SELECT * FROM skp8s_trsproperties_prices", (error, rows, fields) ->
              throw error if (error)
              for data in rows
                building = buildings[data.propertyId]
                if building
                  property_type = data["property_type"]
                  building[property_type] = building[property_type] or {}
                  if data.price_type is "range"
                    range = data.price_value.split("-")
                    building[property_type].from = range[0]
                    building[property_type].to = range[1]
                  else
                    building[property_type].from = parseInt(data.price_value)

              fs = Meteor.npmRequire("fs")
              fs.writeFile "/tmp/res.json", JSON.stringify(buildings), (error) ->
                if error
                  console.log(error)
                else
                  console.log("The file was saved!")


#mysqlImport()
