#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>

int nthreads;
int *vetorInt;
int leit=0;
pthread_mutex_t x_mutex;
pthread_cond_t x_barreira;

//declaração das funções
long int lerSoma(){
	long int s=0;
	for(int i=0;i<nthreads;i++)
		s += vetorInt[i];
	return s;
}

void *tarefa(void *a){
	//Leitura e escrita mutalmente exclusiva => n há necessiadade de seção crítica 
	long int id = (long int) a;
	long int *somaLocal = (long int*) malloc(sizeof(long int));
	*somaLocal = lerSoma();
	printf("thread[%ld] terminou de ler\n",id);
	if(leit == (nthreads-1)){
		printf("Primeira barreira passada\n");
		leit=0;
		pthread_cond_broadcast(&x_barreira);
	}else{
		leit++;
		pthread_cond_wait(&x_barreira,&x_mutex);
	}
	
	//segunda barreira
	vetorInt[id] = rand()%10;
	printf("thread[%ld] inseriu %d\n",id,vetorInt[id]);
	if(leit == (nthreads-1)){
		printf("Segunda barreira passada\n");
		leit=0;
		pthread_cond_broadcast(&x_barreira);
	}else{
		leit++;
		pthread_cond_wait(&x_barreira,&x_mutex);
	}
	pthread_mutex_unlock(&x_mutex);
	pthread_exit((void*) somaLocal);
}

int main(int argc, char *argv[]){
	
	//usuario pode n colocar o nthreads manualmente, caso não queira
	srand(time(NULL));
	if(argc<2)
		nthreads = 1 + rand() % 16;
	else
		nthreads = atoi(argv[1]);
	
	//criação do vetor
	vetorInt = (int*) malloc(sizeof(int)*nthreads);
	for(int i=0;i<nthreads;i++)
		vetorInt[i] = rand() % 9;
	
	//imprime o vetor pra eu ver
	printf("Valores iniciais do vetor:\n[");
	for(int i=0;i<nthreads-1;i++)
		printf("%d ,",vetorInt[i]);
	printf("%d]\n",vetorInt[nthreads-1]);

	//inicialização dos mutexs
	pthread_mutex_init(&x_mutex,NULL);
	pthread_cond_init(&x_barreira,NULL);

	//criação das threads
	pthread_t threads[nthreads];
	for (long int i=0;i<nthreads;i++) {
		if(pthread_create(&threads[i],NULL,tarefa,(void *) i)){
			fprintf(stderr,"Erro--phtread_create\n");
			return 3;
		}	
	}

	//termino das threads
	long int resultadoSoma = -1;
	int valorDireferente = 1;
	long int *pRetorno;
	for (long int j=0;j<nthreads;j++){
		if( pthread_join(threads[j], (void**) &pRetorno)){
			fprintf(stderr,"Erro--phtread_join\n");
			return 3;
		}
		if(resultadoSoma == -1){
			resultadoSoma = *pRetorno;
		}else if(resultadoSoma != *pRetorno){
			printf("Soma difere = %ld\n",*pRetorno);
			valorDireferente = 0;
		}
		free(pRetorno);
	}

	//impressão dos valores
	if(valorDireferente)
		printf("Valor de retorno das threads é sempre igual a %ld\n",resultadoSoma);
	else
		printf("Resultado das das threads somas difere!\n");
	printf("Valores finais do vetor:\n[");
	for(int i=0;i<nthreads-1;i++)
		printf("%d ,",vetorInt[i]);
	printf("%d]\n",vetorInt[nthreads-1]);

	//libera memória
	free(vetorInt);
	return 0;
}

