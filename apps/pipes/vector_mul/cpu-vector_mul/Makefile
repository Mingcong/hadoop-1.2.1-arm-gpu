CC = g++
CPPFLAGS = -m64 -I$(HADOOP_HOME)/c++/Linux-amd64-64/include

cpu-vector_mul: cpu-vector_mul.cc
	$(CC) $(CPPFLAGS) $< -L$(HADOOP_HOME)/c++/Linux-amd64-64/lib -lhadooppipes -lhadooputils -lpthread -lcrypto -g -O2 -o $@

clean: 
	rm -rf cpu-vector_mul
