CC = nvcc
CPPFLAGS = -m64 -I$(HADOOP_HOME)/c++/Linux-amd64-64/include

gpu-vector_mul: gpu-vector_mul.cu
	$(CC) $(CPPFLAGS) $< -L$(HADOOP_HOME)/c++/Linux-amd64-64/lib -lhadooppipes -lhadooputils -lpthread -lcrypto -g -O2 -o $@

clean:
	rm -rf gpu-vector_mul
