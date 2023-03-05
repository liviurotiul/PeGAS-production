#!/bin/bash

docker build -t pegas .

docker run -u $(id -u) -v $(pwd)/data/data:/app/data -v $(pwd)/data/database:/app/database pegas:latest 
