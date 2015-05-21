# Development Workflow

To start development, first clone the repository in your development machine.

```bash
git clone git@bitbucket.org:rentscene/rs-2.git
```

Then create a mup.json file with the below content:

```JSON
{
    "servers": [
        {
            "host": "{{SERVERIP}}",
            "username": "{{USERNAME}}",
            "password": "{{PASSWORD}}",
            "env": {
              "PORT": 80,
              "ROOT_URL": "http://www.rentscene.com",
              "MONGO_URL": "{{MONGOURL}}"
            }
        }
    ],
    "setupMongo": true,
    "setupNode": true,
    "nodeVersion": "0.10.36",
    "setupPhantom": true,
    "appName": "rentscene",
    "app": "{{LOCAL_FOLDER}}",
    "env": {
        "PORT": 80,
        "ROOT_URL": "http://www.rentscene.com",
        "MONGO_URL": "{{MONGOURL}}"
    },
    "deployCheckWaitTime": 200
}
 ```
 
You should edit this by replacing {{VARIABLES}} with the information you will get separately. Change {{LOCAL_FOLDER}} with the full path of the folder you cloned the repo on your development machine.

Once these are done, you can start coding. Once you are ready to push your code and update the server with the new codebase, first pull/push to/from origin git repository and then mup deploy:
 
 ```bash
 $ git pull
 $ git push
 $ mup deploy
 ```

Watch for `mup deploy` to finish successfully. It will take a few minutes, more than 200 seconds for sure, and this is normal.

Please be responsible and never push code that you didn't carefully tested to make sure it works!