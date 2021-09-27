#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>

/* Variaveis globais */
int nthreads = 2;
long long int contador=0;
int imp = 1;

pthread_cond_t x_cond;
pthread_mutex_t x_mutex;

/* Funcao das threads */
void FazAlgo(int c){
	usleep(50);// dorme pro 0.05 segundos
	if(contador%100==0){
		imp = 1;	// mostra que quer entrar no loop
		pthread_mutex_lock(&x_mutex); 
		pthread_cond_broadcast(&x_cond); // autoriza o T2 a imprimir
		while(imp) // entra no loop caso imp = 1
			pthread_cond_wait(&x_cond,&x_mutex); // sai apenas com o broadcast do T2
		pthread_mutex_unlock(&x_mutex);
	}
}
void *T1 (void *v) {
	while(1) {
		FazAlgo(contador);
		contador++;
	}
}

void *T2 (void *v) {
	while(1) {
		pthread_mutex_lock(&x_mutex);
		pthread_cond_wait(&x_cond,&x_mutex);
		printf("contador = %lld\n",contador); // imprime
		imp = 0; // impede T1 de reentrar no loop 
		pthread_cond_broadcast(&x_cond); // retira T1 da condição de espera
		pthread_mutex_unlock(&x_mutex);
	}
}

/* Funcao principal */
int main(int argc, char *argv[]) {
	pthread_t threads[nthreads];
	int id[nthreads];

	pthread_create(&threads[0], NULL, T1, NULL);
	pthread_create(&threads[1], NULL, T2, NULL);
	/* Espera todas as threads completarem */
	for (int i = 0; i < nthreads; i++) {
		pthread_join(threads[i], NULL);
	}

	/* Armazena o vetor de saida, libera variáveis e encerra */
	return 0;
}
