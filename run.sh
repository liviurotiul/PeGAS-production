#!/bin/bash

docker build -t bacdistest .

docker run -u $(id -u) -v $1/data:/app/data -v $1/database:/app/database bacdistest:latest 
