#!/bin/bash

cd cpu-kmeans1D
make clean;make
cd ..

cd gpu-kmeans1D
make clean;make
cd ..

cd cpu-kmeans2D
make clean;make
cd ..

cd gpu-kmeans2D
make clean;make
cd ..
