#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <semaphore.h>
#include <unistd.h>

//globais
int a=0, b=0, c=0; //numero de threads A, B e C usando o recurso, respectivamente
sem_t emA, emB, emC; //semaforos para exclusao mutua
sem_t rec; //semaforo para sincronizacao logica
//funcao executada pelas As
void *A (void *i) {
	long int id = (long int) i;
	while(1) {
		sem_wait(&emA);
		a++;
		if(a==1) {
			printf("Thread A[%ld] bloqueada\n",id);
				sem_wait(&rec);
			printf("Thread A[%ld] liberada\n",id);
		}
		sem_post(&emA);
		printf("A[%ld] está usando o recurso\n",id);
		//SC: usa o recurso
		sleep(1);
		sem_wait(&emA);
		a--;
		if(a==0){
			sem_post(&rec);
			printf("A[%ld] liberando para todas as threads\n",id);
		}
		sem_post(&emA);
	}
}
//funcao executada pelas Bs
void *B (void *i) {
	long int id = (long int) i;
	while(1) {
		sem_wait(&emB);
		b++;
		if(b==1) {
			printf("Thread B[%ld] bloqueada\n",id);
			sem_wait(&rec);
			printf("Thread B[%ld] liberada\n",id);
		}
		sem_post(&emB);
		printf("B[%ld] está usando o recurso\n",id);
		//SC: usa o recurso
		sem_wait(&emB);
		b--;
		if(b==0){
			sem_post(&rec);
			printf("B[%ld] liberando para todas as threads\n",id);
		}
		sem_post(&emB);
		sleep(1);
	}
}

//funcao executada pelas Cs
void *C (void *i) {
	long int id = (long int) i;
	while(1) {
		sem_wait(&emC);
		c++;
		if(c==1) {
			printf("Thread C[%ld] bloqueada\n",id);
			sem_wait(&rec);
			printf("Thread C[%ld] liberada\n",id);
		}
		sem_post(&emC);
		printf("C[%ld] está usando o recurso\n",id);
		//SC: usa o recurso
		sem_wait(&emC);
		c--;
		if(c==0){
			sem_post(&rec);
			printf("C[%ld] liberando para todas as threads\n",id);
		}
		sem_post(&emC);
		sleep(1);
	}
}
int main(){
	//inicializacoes que devem ser feitas na main() antes da criacao das threads
	sem_init(&emA, 0, 1);
	sem_init(&emB, 0, 1);
	sem_init(&emC, 0, 1);
	sem_init(&rec, 0, 1);

	int NumA=6,NumB=2,NumC=2;
	pthread_t tid[NumA+NumB+NumC];

	//criação de threads
	long int i;
	for(i=0;i<NumA;i++){
		if(pthread_create(&tid[i],NULL,A,(void *) i)){
			printf("--Errro: pthread_create() \n");exit(-1);
		}
	}
	for(i=0;i<NumB;i++){
		if(pthread_create(&tid[i+NumA],NULL,B,(void *) i)){
			printf("--Errro: pthread_create() \n");exit(-1);
		}
	}
	for(i=0;i<NumC;i++){
		if(pthread_create(&tid[i+NumA+NumB],NULL,C,(void *) i)){
			printf("--Errro: pthread_create() \n");exit(-1);
		}
	}

	//junção de threads
	for(int i=0;i<NumA+NumB+NumC;i++){
		if(pthread_join(tid[i],NULL)){
			printf("--Erro: pthread_join() \n");exit(-1);
		}
	}
	return 0;
}
