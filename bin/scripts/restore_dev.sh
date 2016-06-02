#!/bin/bash

mongorestore --drop --host candidate.36.mongolayer.com --port 11187 -u dev -p feature123 --db rentscene --archive=dump
