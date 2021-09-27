#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#define NTHREADS 4

/* Variaveis globais */
int x = 0;
sem_t condt1,condt2,condt3;

void *t1 (void *t) {
	printf("Seja bem-vindo\n");
	sem_post(&condt1);
	pthread_exit(NULL);
}

void *t2 (void *t) {
	sem_wait(&condt1);
	printf("Sente-se por favor!\n");
	sem_post(&condt1);
	sem_post(&condt2);
	pthread_exit(NULL);
}

void *t3 (void *t) {
	sem_wait(&condt1);
	printf("Fique a vontade.\n");
	sem_post(&condt1);
	sem_post(&condt3);
	pthread_exit(NULL);
}

void *t4 (void *t) {
	sem_wait(&condt3);
	sem_wait(&condt2);
	printf("Volte sempre!\n");
	pthread_exit(NULL);
}

int main(){
	pthread_t threads[NTHREADS];

	/* Inicilaiza semaforos*/
	sem_init(&condt1,0,0);
	sem_init(&condt2,0,0);
	sem_init(&condt3,0,0);

	/* Cria as threads */
	pthread_create(&threads[3], NULL, t1, NULL);
	pthread_create(&threads[2], NULL, t2, NULL);
	pthread_create(&threads[1], NULL, t3, NULL);
	pthread_create(&threads[0], NULL, t4, NULL);

	/* Espera todas as threads completarem */
	for (int i = 0; i < NTHREADS; i++) {
		pthread_join(threads[i], NULL);
	}

	/* Desaloca variaveis e termina */
	sem_destroy(&condt1);
	sem_destroy(&condt2);
	sem_destroy(&condt3);

	return 0;
}

