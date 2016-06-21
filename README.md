# Development Workflow

To start development, first clone the repository in your development machine.

    :::bash
    git clone git@bitbucket.org:rentscene/rs-2.git

There are two Mup configuration files. They are place in:

    :::bash
    /mup/dev/mup.json
    /mup/prod/mup.json

In order to deploy current version of the application to development server call this command from the root directory:

    :::bash
    ./bin/deploy dev

and if you want to deploy to live site use:

    :::bash
    ./bin/deploy prod

It takes about 10 minutes until the script is finished.
