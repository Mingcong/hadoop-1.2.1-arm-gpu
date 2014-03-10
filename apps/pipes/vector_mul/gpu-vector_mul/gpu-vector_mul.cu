/***********************************************************************
 	hadoop-gpu
	Authors: Koichi Shirahata, Hitoshi Sato, Satoshi Matsuoka

This software is licensed under Apache License, Version 2.0 (the  "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-------------------------------------------------------------------------
File: gpu-matmul.cc
 - Plain matrix multiplication on GPU.
Version: 0.20.1
***********************************************************************/

#include  "stdint.h"

#include "hadoop/Pipes.hh"
#include "hadoop/TemplateFactory.hh"
#include "hadoop/StringUtils.hh"

#include <cuda.h>
#include <cuda_runtime.h>

#include <iostream>

#include <time.h>
#include <sys/time.h>

/*
__global__ void mul(float *a, float *b, float *muled, int len)
{
  int i;
  int tid = threadIdx.x + blockDim.x * blockIdx.x;
  int nthreads = blockDim.x * gridDim.x;
  int part = len / nthreads;
  for(i = part*tid; i < part*(tid+1); i++) {
    muled[i] = a[i] * b[i];
  }
  return;
}
*/

__global__ void mul(float *a, float *b, float *muled)
{
  int i = threadIdx.x + blockDim.x * blockIdx.x;
  muled[i] = a[i] * b[i];
  return;
}

class MatmulMap: public HadoopPipes::Mapper {
public:
  MatmulMap(HadoopPipes::TaskContext& context){}


  void map(HadoopPipes::MapContext& context) {
    int k;
    std::string line = context.getInputValue();
    std::vector<std::string> elements = HadoopUtils::splitString(line, " ");
    int i = HadoopUtils::toFloat(elements[0]);
    int T = (elements.size()-1) / 2;
    float a[T], b[T], vals[T];

    //variables for CUDA
    float *ad, *bd, *muled;
    size_t array_size = sizeof(float) * T;


    std::string key = HadoopUtils::toString(i);
    
    for(k =  0; k < T; ++k) {
      a[k] = HadoopUtils::toFloat(elements[k + 1]);
    }
    for(k = 0; k < T; ++k) {
      b[k] = HadoopUtils::toFloat(elements[k + (T + 1)]);
    }    

    cudaMalloc((void **)&ad, array_size);
    cudaMalloc((void **)&bd, array_size);
    cudaMalloc((void **)&muled, array_size);    
    

    cudaMemcpy(ad, a, array_size, cudaMemcpyHostToDevice);
    cudaMemcpy(bd, b, array_size, cudaMemcpyHostToDevice);


    mul<<<T/512, 512>>>(ad, bd, muled);

    
    cudaMemcpy(vals, muled, array_size, cudaMemcpyDeviceToHost);


    for(k = 0; k < T; ++k) {
      context.emit(key, HadoopUtils::toString(vals[k]));
    }
  }
};

class MatmulReduce: public HadoopPipes::Reducer {
public:
  MatmulReduce(HadoopPipes::TaskContext& context){}
  void reduce(HadoopPipes::ReduceContext& context) {
    // sumup values which have the same keys
    float sum = 0;
    while (context.nextValue()) {
      sum += HadoopUtils::toFloat(context.getInputValue());
    }
    context.emit(context.getInputKey(), HadoopUtils::toString(sum));
  }
};

int main(int argc, char *argv[]) {
  return HadoopPipes::runTask(HadoopPipes::TemplateFactory<MatmulMap,
                                                           MatmulReduce>());
}
