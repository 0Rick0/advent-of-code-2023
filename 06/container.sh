#!/bin/sh
docker run --rm -it -v "$PWD":/home/jovyan/work -p 8888:8888 jupyter/r-notebook
