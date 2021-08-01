#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "timer.h"
#define AMPLITUDE 1;

/* variaveis globais */
float *vetor;
int nthreads;
long int dim;

typedef struct s_retorno {
	float max;
	float min;
}tRet;

void * tarefa(void * arg){
	long int id = (long int) arg; //identificador da thread
	long int tamBloco = dim/nthreads; //tam do bloco da thread
	long int ini = id * tamBloco; //elem inicial do bloco
	long int fim = ini+tamBloco; //elem final com i<fim
	fim = id==nthreads-1 ? dim : ini+tamBloco;
	
	tRet* pretorno;
	pretorno = (tRet*) malloc(sizeof(struct s_retorno));
	pretorno->max=-1;
	pretorno->min=(float) RAND_MAX;
	
	//comparação dos elementos
	for(long int i=ini;i<fim;i++){
		if(vetor[i] > pretorno->max) 
			pretorno->max = vetor[i];
		if(vetor[i] < pretorno->min)
			pretorno->min = vetor[i];
	}
	//retorna o resultado da soma local
	pthread_exit((void *) pretorno);
}


int main(int argc, char *argv[]){
	float maxValorSeq=-1;
	float minValorSeq=(float) RAND_MAX;
	float maxValorConc=-1;
	float minValorConc=(float) RAND_MAX;
	tRet* pretorno;
	double t1,t2,delta; //tempo
	pthread_t *tid;

	if(argc <3){
		fprintf(stderr,"Digite %s <dimensao do vetor> <numero threads>\n", argv[0]);
		return 1;
	}
	dim = atoi(argv[1]);
	nthreads = atoi(argv[2]);
	printf("Algoritmo para max e min de vetor tam = %ld, nthreads = %d\n",dim,nthreads);
	//preenche o vetor de entrada
	vetor = (float*) malloc(sizeof(float)*dim);
	if(vetor == NULL){
		fprintf(stderr,"Erro --malloc\n");
		return 2;
	}
	srand(1);
	for(long int i=0; i<dim; i++){
		vetor[i] = (float)rand()/10000;
	}

	//soma seq
	GET_TIME(t1);
	for(long int i=0; i<dim; i++){
		if(vetor[i] > maxValorSeq) 
			maxValorSeq = vetor[i];
		if(vetor[i] < minValorSeq) 
			minValorSeq = vetor[i];
	}
	GET_TIME(t2);
	delta = t2-t1;
	printf("Tempo sequencial: %f\n", delta);
	printf("Maximo Valor seq:%f\n",maxValorSeq);
	printf("Minimo Valor seq:%f\n",minValorSeq);

	//soma conc
	tid = (pthread_t*) malloc(sizeof(pthread_t)*nthreads);
	if(tid==NULL){
		fprintf(stderr,"Erro--malloc\n");
		return 2;
	}
	//criação das threads
	for (long int i=0;i<nthreads;i++) {
		if(pthread_create(tid+i,NULL,tarefa,(void*) i)){
			fprintf(stderr,"ERRO--pthread_create\n");
			return 3;
		}
	}
	//aguardar o termino das threads
	for (long int i=0;i<nthreads;i++) {
		if(pthread_join(*(tid+i),(void **) &pretorno)){
			fprintf(stderr,"ERRO--pthread_create\n");
			return 3;
		}
		if(maxValorConc<pretorno->max)
			maxValorConc=pretorno->max;
		if(minValorConc>pretorno->min)
			minValorConc=pretorno->min;
		free(pretorno);
	}
	GET_TIME(t1);
	delta = t1-t2;
	//mostrar valores finais
	printf("Tempo concorrente: %f\n", delta);
	printf("Maximo Valor Conc:%f\n",maxValorConc);
	printf("Minimo Valor Conc:%f\n",minValorConc);
	//liberação da mem
	free(vetor);
	return 0;
}

