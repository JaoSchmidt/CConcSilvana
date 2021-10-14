#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<semaphore.h>

#define L 4 //numero de threads leitoras
#define E 4 //numero de threads escritoras

//variaveis do problema
int leit=0; //contador de threads lendo
int escr=0; //contador de threads escrevendo
sem_t rec,priority,leit_mutex,leit_mutex2,escr_mutex;

//entrada leitura
void InicLeit (int id) {
	printf("L[%d] quer ler\n", id);
	sem_wait(&leit_mutex);
	if(escr>0){ // espera escritor
		printf("L[%d] esperando escrita\n",id);
		sem_wait(&rec);//bloqueia a si mesmo
		printf("L[%d] não precisa mais esperar\n",id);
	}else{ // "else" pois último escritor já aumenta leit
		leit++;//colocar depois perimite prioridade menor
	}
	sem_post(&leit_mutex);
}

//saida leitura
void FimLeit (int id) {
	sem_wait(&leit_mutex2);
	leit--;
	printf("L[%d] terminou de ler, leit = %d\n", id,leit);
	if(leit==0){ // espera escritor
		printf("L[%d] liberou escrita\n",id);
		sem_post(&priority);//libera escritor
	}
	sem_post(&leit_mutex2);
}

//entrada escrita
void InicEscr (int id) {
	printf("E[%d] quer escrever\n", id);
	sem_wait(&escr_mutex);
	escr++;// avisa aos leitores, aumenta prioridade do escritor
	if(leit>0){// espera qualquer escritor ocupado
		printf("E[%d] esperando leitura\n", id);
		sem_wait(&priority);
	}
}

//saida escrita
void FimEscr (int id) {
	escr--;
	printf("E[%d] terminou de escrever, escr = %d\n", id,escr);
	if(escr==0){
		printf("E[%d] liberou leitura\n",id);
		sem_post(&rec);//libera leitor	
		leit++; //colocado aqui pq senão o leitor não teria tempo de avisar
	}
	sem_post(&escr_mutex);
}

//thread leitora
void * leitor (void * arg) {
	int *id = (int *) arg;
	while(1) {
		InicLeit(*id);
		printf("Leitora %d esta lendo, leit = %d\n", *id,leit);
		sleep(1);
		FimLeit(*id);
	} 
	free(arg);
	pthread_exit(NULL);
}

//thread leitora
void * escritor (void * arg) {
	int *id = (int *) arg;
	while(1) {
		InicEscr(*id);
		printf("Escritora %d esta escrevendo, escr = %d\n", *id,escr);
		sleep(1);
		FimEscr(*id);
	} 
	free(arg);
	pthread_exit(NULL);
}

//funcao principal
int main(void) {
	//identificadores das threads
	pthread_t tid[L+E];
	int id[L+E];

	//inicializa as variaveis de sincronizacao
	sem_init(&rec,0,0);
	sem_init(&priority,0,0);
	sem_init(&leit_mutex,0,1);
	sem_init(&leit_mutex2,0,1);
	sem_init(&escr_mutex,0,1);


	//cria as threads leitoras
	for(int i=0; i<L; i++) {
		id[i] = i+1;
		if(pthread_create(&tid[i], NULL, leitor, (void *) &id[i])) exit(-1);
	} 

	//cria as threads escritoras
	for(int i=0; i<E; i++) {
		id[i+L] = i+1;
		if(pthread_create(&tid[i+L], NULL, escritor, (void *) &id[i+L])) exit(-1);
	} 

	pthread_exit(NULL);
	return 0;
}
