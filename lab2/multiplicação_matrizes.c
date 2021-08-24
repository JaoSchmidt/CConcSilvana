#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "timer.h"

/*Variaveis globais*/
long *matrix1; //matriz 1
long *matrix2; //matriz 2
long *matrixOut; //matriz de saída
int nthreads;

typedef struct{
	int id;
	int dimens;
} tArgs;

//tarefa q as threads executarão

void * tarefa(void *a){
	tArgs *args = (tArgs*) a;
	for(int i=args->id; i<args->dimens;i+=nthreads){
		for(int j=0; j<args->dimens;j++){
			for(int k=0; k<args->dimens;k++){
				matrixOut[i*args->dimens + j] += matrix1[i*args->dimens + k] * matrix2[k*args->dimens + j] ;
				//equivalente a matrixOut[i][j] += matrix1[i][k] * matrix2[k][j]
			}
		}
	//printf("linha %d completa\n",i);
	}
	pthread_exit(NULL);	
}

int main(int argc, char* argv[]){
	int dimens; //dimensção
	pthread_t *tid; //thread id
	tArgs *args; //estrutura com dimensão e id
	double t1, t2, delta;
	//verificando input do usuário
	if(argc<3){
		printf("Digite: %s <dimensção da matriz> <numero de threads>",argv[0]);
		exit(1);
	}
	dimens = atoi(argv[1]);
	nthreads = atoi(argv[2]);
	printf("Multiplicando matrizes de dimensão %d usando %d threads\n",dimens,nthreads);
	//alocando matrizes
	GET_TIME(t1);
	matrix1 = (long *) malloc(sizeof(long)*dimens*dimens);
	if(matrix1 == NULL){printf("ERRO -- malloc\n");exit(2);}
	matrix2 = (long *) malloc(sizeof(long)*dimens*dimens);
	if(matrix2 == NULL){printf("ERRO -- malloc\n");exit(2);}
	matrixOut = (long *) malloc(sizeof(long)*dimens*dimens);
	if(matrixOut == NULL){printf("ERRO -- malloc\n");exit(2);}
	//alocando threads
	tid = (pthread_t*) malloc(sizeof(pthread_t)*nthreads);
	if(tid == NULL){printf("ERRO -- malloc\n");exit(2);}
	args = (tArgs*) malloc(sizeof(tArgs)*nthreads);
	if(args == NULL){printf("ERRO -- malloc\n");exit(2);}
	
	//criação das matrizes
	for(int i=0;i<dimens;i++)	{
		srand(i+1); //srand(0) = srand(1)...
		for(int j=0; j<dimens;j++){
			matrix1[i*dimens+j] = rand()%15;
			matrix2[i*dimens+j] = rand()%15;
			matrixOut[i*dimens+j] = 0;
		}
	}
	GET_TIME(t2);
	delta = t2-t1;
	printf("(a) inicialização das estruturas de dados = %f\n",delta);
	//multiplicação das matrizes	
	for(int i=0;i<nthreads;i++)	{
		(args+i)->id = i;
		(args+i)->dimens = dimens;
		if(pthread_create(tid+i, NULL, tarefa, (void*) (args+i))){
			printf("ERRO -- malloc\n");exit(3);
		}
	}

	//espera pelas threads
	for (int i=0;i<nthreads;i++) {
		pthread_join(*(tid+i),NULL);
	}
	GET_TIME(t1);
	delta = t1-t2;
	printf("(b) criação das threads, execução da multiplicação, e término das threads = %f\n",delta);

	/*
	printf("\nMatriz de entrada1:\n");
	for(int i=0; i<dimens;i++){
		for(int j=0;j<dimens;j++){
			printf("%ld ",matrix1[i*dimens+j]);
		}
		printf("\n");
	}
	printf("\nMatriz de entrada2:\n");
	for(int i=0; i<dimens;i++){
		for(int j=0;j<dimens;j++){
			printf("%ld ",matrix2[i*dimens+j]);
		}
		printf("\n");
	}
	printf("\nMatriz de saida:\n");
	for(int i=0; i<dimens;i++){
		for(int j=0;j<dimens;j++){
			printf("%ld ",matrixOut[i*dimens+j]);
		}
		printf("\n");
	}*/
	//liberação de memoria
	free(tid);
	free(args);
	free(matrix1);
	free(matrix2);
	free(matrixOut);
	
	GET_TIME(t2);
	delta = t2-t1;
	printf("(c) finalização do programa = %f\n",delta);
	return 0;
}

