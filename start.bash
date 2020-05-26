#!/bin/bash

JSON_PATH=$PWD/gcp.json
APP_PATH=/app/app.jar

gcp_credentials(){
    if [[ -z ${GOOGLE_APPLICATION_CREDENTIALS} ]]
    then
        echo GCP credentials not found
        touch $JSON_PATH
    else
        echo GCP credentials found
        echo $GOOGLE_APPLICATION_CREDENTIALS | base64 -d > $JSON_PATH
    fi

    export GOOGLE_APPLICATION_CREDENTIALS=$JSON_PATH
}

run(){
    if [[ -f $APP_PATH ]]
    then
        echo Starting spark-submit: $APP_PATH
        echo ======================
        spark/bin/spark-submit /app/app.jar
    else
        echo Not found: $APP_PATH. Starting spark-shell
        echo ==========
        spark/bin/spark-shell
    fi
}


gcp_credentials
run