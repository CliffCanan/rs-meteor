var DDPClient = require("ddp");
var login = require('ddp-login');

var ddpclient = new DDPClient({
  // All properties optional, defaults shown
  host: "localhost",
  port: 3000,
  ssl: false,
  autoReconnect: true,
  autoReconnectTimer: 500,
  maintainCollections: true,
  ddpVersion: '1', // ['1', 'pre2', 'pre1'] available
  // uses the SockJs protocol to create the connection
  // this still uses websockets, but allows to get the benefits
  // from projects like meteorhacks:cluster
  // (for load balancing and service discovery)
  // do not use `path` option when you are using useSockJs
  useSockJs: true,
  // Use a full url instead of a set of `host`, `port` and `ssl`
  // do not set `useSockJs` option if `url` is used
  url: 'wss://localhost:3000/websocket'
});

/*
 * Connect to the Meteor Server
 */
ddpclient.connect(function(error, wasReconnect) {
  // If autoReconnect is true, this callback will be invoked each time
  // a server connection is re-established
  if (error) {
    console.log('DDP connection error!');
    return;
  }

  console.log("connected");

  if (wasReconnect) {
    console.log('Reestablishment of a connection.');
  }
  ddpclient.call("login", [{
    user: {
      email: "admin@rentscene.com"
    },
    password: "123123"
  }], function(err, result) {
    if (err) {
      return console.log(err);
      // Something went wrong...
    }

    console.log("authenticated");
    // We are now logged in, with userInfo.token as our session auth token.
    token = result.token;

    console.log(result);

    var data = [{
      "isPublished": false,
      "btype": "studio",
      "title": "something",
      "description": "",
      "availableAt": new Date(),
      "security": 1,
      "securityComment": "",
      "laundry": 1,
      "laundryComment": "",
      "bathroomsFrom": 1,
      "bathroomsTo": 1,
      "sqftFrom": 497,
      "sqftTo": 497,
      "priceFrom": 1550,
      "priceTo": 1600,
      "cityId": "philadelphia",
      "neighborhood": "Center City West",
      "ownerId": null,
      "createdAt": new Date(),
      "updatedAt": new Date(),
      "isOnMap": false,
      "propertyType": 0,
      "position": 10000,
      "features": [],
      "images": [],
      "agroCanBeSame": false,
      "agroIsUnit": true,
      "neighborhoodSlug": "center-city-west"
    }];

    ddpclient.call('importProperties', [data], 
      function(err, result) {
        if (err) {
          console.log("ERR", err);
          return ddpclient.close();
        }
      },
      function () { 
        console.log('import completed!');
        return ddpclient.close();
      });

  });
});
