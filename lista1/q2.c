#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

typedef struct{
	int id;
} Args;

int num_threads; //numero de threads
int n; //último termo do somatório

void *tarefa(void *p){
	Args *args = (Args *) p;

	//evitar perda ao sair do escopo
	double *psoma = (double*) malloc(sizeof(double));
	//vai precisar liberar dps, como feito no laboratório 3

	for (int i = (args->id + 1); i <= n; i += num_threads){
		if(i%2){
			*psoma -= ((double) 4)/(2*i+1);
		}else{
			*psoma += ((double) 4)/(2*i+1);
		}
	}
	pthread_exit((void *) psoma);
}

int main(){
	return 0;
}

