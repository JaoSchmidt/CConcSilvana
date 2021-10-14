#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

//variaveis internas
sem_t s, x, h; int aux = 0;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;

void wait() {
	//pre-condicao: a thread corrente detem o lock de ’m’
	sem_wait(&x);
	aux++;
	sem_post(&x);

	pthread_mutex_lock(&m);
	sem_wait(&h);
	sem_post(&s);
	pthread_mutex_unlock(&m);
}

void notify() {
	sem_wait(&x);
	if (aux > 0) {
		aux--;
		sem_post(&h);
		sem_wait(&s);
	}
	sem_post(&x);
}

void notifyAll() {

	sem_wait(&x);
	for (int i = 0; i < aux; i++)
		sem_post(&h);
	while (aux > 0) {
		aux--;
		sem_wait(&s);
	}
	sem_post(&x);

}


sem_t a;

void * A() {
	printf("eu ");
	sem_post(&a);
	wait();
	printf(" de chocolote ");
	notify();
	notifyAll();
	pthread_exit(NULL);
}
void * B() {
	sem_wait(&a);
	printf("gosto");
	notify();
	pthread_exit(NULL);
}

int main(){
	//inicializacoes feitas na funcao principal
	sem_init(&s,0,0);
	sem_init(&x,0,1);
	sem_init(&h,0,0);
	sem_init(&a,0,0);

	pthread_t tid[2];

	if(pthread_create(&tid[1],NULL,B,NULL)) 
		exit(1);
	if(pthread_create(&tid[0],NULL,A,NULL)) 
		exit(1);

	pthread_exit(NULL);
	return 0;
}
