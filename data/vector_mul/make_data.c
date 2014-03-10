/* make_ki.c */
/*
 * Make kmeans input file
 * whose cluster centroids and posions of data will be made at ramdom.
 * 
 * arguments
 * 1: k; the number of centroids 
 * 2: n; the number of data
 * 3: numiter; the number of dataset(which include k, n, and data for each line)
 * 4: fname; output file name (which contains k, n, and data, for kmeans input)
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {

  FILE *fp;
  char *fname = NULL;
  int i, j, M, N;
  if(argc > 3) {
    N = atoi(argv[1]);
    M = atoi(argv[2]);
    fname = argv[3];
    if((fp = fopen(fname, "w")) < 0) {
      error("Can't open %s", fname);
    }
    for(i=0; i < N; i++) {
    	fprintf(fp, "%d ", i);

    	for(j = 0; j < M; j++) {  
      	   fprintf(fp, "%f ", 1.0);
      	}
    	for(j = 0; j < M; j++) {  
      	   fprintf(fp, "%f ", 1.0);
      	}	
    	fprintf(fp, "\n");
    }
    fclose(fp);
  }
  else {
    puts("arguments must be included below");
    puts("1: N");
    puts("2: M");
    puts("3: fname)");
  }  
  
}
