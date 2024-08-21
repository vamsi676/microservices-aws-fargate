#!/bin/bash

DOCKER_REPO_URI=017820685114.dkr.ecr.us-west-1.amazonaws.com/msdemo


function build() {
    echo "Building customer service"
    pushd services/customerservice
    npm install
    docker build -t msdemo/customerservice .
    popd

    echo "Building order service"
    pushd services/orderservice
    npm install
    docker build -t msdemo/orderservice .
    popd
}

function push() {
    echo "Push images"
    $(aws ecr get-login-password --region us-west-1)
    
    docker tag msdemo/customerservice:latest $DOCKER_REPO_URI/customerservice:latest
    docker tag msdemo/orderservice:latest $DOCKER_REPO_URI/orderservice:latest

    docker push $DOCKER_REPO_URI/customerservice:latest
    docker push $DOCKER_REPO_URI/orderservice:latest
}

function options() {
      echo "./start build -> Build docker images"
      echo "./start push -> Push images to docker registry. Plz configure repo  before push."
}



for var in "$@"
do
  case "$var" in
    build)
      build
      ;;
    push)
      push
      ;;      
    *)
      options
      ;;
  esac    
done

