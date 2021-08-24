#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NTHREADS 4

/* Variaveis globais */
int x = 0;
pthread_mutex_t x_mutex;
pthread_cond_t x_cond;

void *t1 (void *t) {
	pthread_mutex_lock(&x_mutex);
	x++;
	//printf("t1 out: x = %d\n", x);	
	printf("Seja bem-vindo\n");
	pthread_mutex_unlock(&x_mutex);
	pthread_cond_broadcast(&x_cond);
	pthread_exit(NULL);
}

void *t2 (void *t) {
	pthread_mutex_lock(&x_mutex);
	if (x<1) { 
		//printf("t2: x= %d, vai se bloquear...\n", x);
		pthread_cond_wait(&x_cond, &x_mutex);
		//printf("t2: sinal recebido e mutex realocado, x = %d\n", x);
	}
	x++;
	//printf("t2 out. x = %d\n",x);
	printf("Sente-se por favor!\n");
	pthread_mutex_unlock(&x_mutex); 
	pthread_cond_broadcast(&x_cond);
	pthread_exit(NULL);
}

void *t3 (void *t) {
	pthread_mutex_lock(&x_mutex);
	if (x<1) { 
		//printf("t3: x= %d, vai se bloquear...\n", x);
		pthread_cond_wait(&x_cond, &x_mutex);
		//printf("t3: sinal recebido e mutex realocado, x = %d\n", x);
	}
	x++;
	//printf("t3 out. x = %d\n",x);
	printf("Fique a vontade.\n");
	pthread_mutex_unlock(&x_mutex); 
	pthread_cond_broadcast(&x_cond);
	pthread_exit(NULL);
}

void *t4 (void *t) {
	pthread_mutex_lock(&x_mutex);
	while (x < 3) { 
		//printf("t4: x= %d, vai se bloquear...\n", x);
		pthread_cond_wait(&x_cond, &x_mutex);
		//printf("t4: sinal recebido e mutex realocado, x = %d\n", x);
	}
	//printf("t4 out. x = %d\n",x);
	printf("Volte sempre!\n");
	pthread_mutex_unlock(&x_mutex); 
	pthread_exit(NULL);
}

int main(){
	pthread_t threads[NTHREADS];

	/* Inicilaiza o mutex (lock de exclusao mutua) e a variavel de condicao */
	pthread_mutex_init(&x_mutex, NULL);
	pthread_cond_init (&x_cond, NULL);

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
	pthread_mutex_destroy(&x_mutex);
	pthread_cond_destroy(&x_cond);	

	return 0;
}

