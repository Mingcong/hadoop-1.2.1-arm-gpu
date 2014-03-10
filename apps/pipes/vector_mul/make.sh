#!/bin/bash

cd cpu-vector_mul
make clean;make
cd ..

cd gpu-vector_mul
make clean;make
cd ..
