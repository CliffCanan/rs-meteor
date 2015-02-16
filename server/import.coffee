dataFields =
  100: "title"
  101: "summary"
  102: "postalCode"
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
  122: "appFee"
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
  139: "floorPlans"
  140: "laundry"
  141: "security"
  142: "fitnessCenter"
  143: "isAvailable"
  144: "videos"
  145: "parentId"
  146: "unitNumber"
  147: "adminAvailability"
  148: "adminEscorted"
  149: "adminAppFee"
  150: "adminOfficeHours"
  151: "adminScheduling"
  152: "adminContact"
  153: "adminNotes"

  155: "adminSame"
  156: "utilities"
  157: "featured"
  158: "neighborhood"


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
      connection.query("SET CHARACTER_SET_CLIENT utf8;" +
        "SET CHARACTER_SET_CONNECTION utf8;" +
        "SET CHARACTER_SET_RESULTS utf8;" +
        "SET CHARACTER_SET utf8;" +
        "SET NAMES utf8;")
      connection.query "SELECT * FROM skp8s_trsproperties_article", (error, rows, fields) ->
        throw error if (error)
        for article in rows.slice(0, 100)
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
                building.features = data.value.split(", ")
              else if fieldName in ["fitnessCenter", "security", "laundry", "parking", "pets", "utilities"]
                if data.value.length
                  try
                    object = JSON.parse(data.value)
                    building[fieldName] =
                      value: object.radio
                      comment: object.comment
              else if fieldName is "images"
                # TODO: process images
              else if fieldName is "videos"
                # TODO: process videos
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
              js2coffee = Meteor.npmRequire("js2coffee")
              coffee = js2coffee.build("this.buildingsFixtures = " + JSON.stringify(buildings));
              fs.writeFile process.env.PWD + "/server/buildings.coffee", coffee.code, (error) ->
                if error
                  console.log(error)
                else
                  console.log("The file was saved!")


#mysqlImport()
