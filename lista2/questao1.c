#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

/* Variaveis globais */
int bloqueadas = 0;
pthread_mutex_t x_mutex;
pthread_cond_t x_cond;
int nthreads=8;
int *vetor;

/* Funcao barreira */
void barreira(int n) {
	pthread_mutex_lock(&x_mutex);
	if (bloqueadas == (n-1)) {
		//ultima thread a chegar na barreira
		for(int j=0;j<nthreads;j++)
			printf("%d ",vetor[j]);
		printf("\n");
		pthread_cond_broadcast(&x_cond);
		bloqueadas=0;
	} else {
		bloqueadas++;
		pthread_cond_wait(&x_cond, &x_mutex);
	}
	pthread_mutex_unlock(&x_mutex);
}

void barreira2(int n) {
	pthread_mutex_lock(&x_mutex);
	if (bloqueadas == (n-1)) {
		//ultima thread a chegar na barreira
		pthread_cond_broadcast(&x_cond);
		bloqueadas=0;
	} else {
		bloqueadas++;
		pthread_cond_wait(&x_cond, &x_mutex);
	}
	pthread_mutex_unlock(&x_mutex);
}
/* Funcao das threads */
void *tarefa (void *arg) {
	int id = *(int*)arg;
	int salto;
	int aux;
	for(salto=1; salto<nthreads; salto*=2) {
		if(id >= salto) {
			aux = vetor[id-salto];
			barreira2(nthreads-salto);
			vetor[id] = aux + vetor[id];
			//barreira2(nthreads-salto);
		} else break;
	}
	pthread_exit(NULL);
}

/* Funcao principal */
int main(int argc, char *argv[]) {
	pthread_t threads[nthreads];
	int id[nthreads];

	/* Inicilaiza o mutex (lock de exclusao mutua) e a variavel de condicao */
	pthread_mutex_init(&x_mutex,NULL);
	pthread_cond_init(&x_cond,NULL);

	/* Recebe os parametros de entrada (tamanho do vetor == número de threads) */
	vetor = (int*) malloc(sizeof(int)*nthreads);
	if(vetor==NULL){
		fprintf(stderr,"Erro--malloc\n");
		return 2;
	}

	/* Inicia as variaveis globais e carrega o vetor de entrada */
	srand(1);
	for(int i=0;i<nthreads;i++){
		vetor[i] = -10 + rand()%20;
		//printf("%d ",vetor[i]);
	}
	//printf("\n");

	/* Cria as threads */
	for(int i=0;i<nthreads;i++) {
		id[i]=i;
		pthread_create(&threads[i], NULL, tarefa, (void *) &id[i]);
	}
	/* Espera todas as threads completarem */
	for (int i = 0; i < nthreads; i++) {
		pthread_join(threads[i], NULL);
	}

	/*printa*/
	printf("resultado: ");
	for(int i=0;i<nthreads;i++){
		printf("%d ",vetor[i]);
	}
	printf("\n");
	/* Armazena o vetor de saida, libera variáveis e encerra */
	pthread_mutex_destroy(&x_mutex);
	pthread_cond_destroy(&x_cond);
	free(vetor);
	return 0;
}
