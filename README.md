# Development Workflow

To start development, first clone the repository in your development machine.

    :::bash
    git clone git@bitbucket.org:rentscene/rs-2.git

# Deployment

The project is deployed with Meteor UP. There are two MUP configuration files:

    :::bash
    /mup/dev/mup.json
    /mup/prod/mup.json

To deploy the project to *development* server, run the following command from the project directory:

    :::bash
    ./bin/deploy dev

To deploy the project to *production* server, run the following command from the project directory:

    :::bash
    ./bin/deploy prod

The deployment process takes about 10 minutes.
