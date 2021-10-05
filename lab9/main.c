#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <semaphore.h>

#define N 10
#define P 5
#define C 3

int Buffer[N];
int count=0,in=0,out=0;

sem_t slot_cheio,slot_vazio,mutexCons,mutexProd;

void IniciaBuffer(){
	for(int i=0;i<N;i++)
		Buffer[i]=0;
}

void ImprimeBuffer(){
	for(int i=0;i<N;i++)
		printf("%d ",Buffer[i]);
	printf("\n");
}

void Insere(int item,int id){
	sem_wait(&slot_vazio);

	sem_wait(&mutexProd);
	printf("P[%d] rodando\n",id);
	Buffer[in]=item;
	in=(in+1)%N;
	printf("P[%d] inseriu %d\n",id,id);
	ImprimeBuffer();//Esse código poderá ser rodando enquando houver consumidores retirando, então a escrita do buffer do printf pode acabar sendo paralisada algumas vezes
	sem_post(&mutexProd);

	sem_post(&slot_cheio);

}

int Retira(int id){
	int item;
	sem_wait(&slot_cheio);

	sem_wait(&mutexCons);
	printf("C[%d] rodando\n",id);
	item = Buffer[out];
	Buffer[out]=0;
	out=(out+1)%N;
	printf("C[%d] consumiu %d\n",id,item);
	ImprimeBuffer();//Igualmente como esse também pode ser sobreescrito por um produtor
	sem_post(&mutexCons);

	sem_post(&slot_vazio);
	return item;
}

void * produtor(void * arg){
	int *id = (int *) arg;
	while(1){
		Insere(*id,*id);
		sleep(1);
	}
	free(arg);
	pthread_exit(NULL);
}

void * consumidor(void * arg){
	int *id = (int *) arg;
	int item;
	while(1){
		item = Retira(*id);
		sleep(1);
	}
	free(arg);
	pthread_exit(NULL);
}

int main(){

	pthread_t tid[P+C];
	int *id[P+C];

	for(int i=0;i<P+C;i++){
		id[i]=malloc(sizeof(int));
		if(id[i]==NULL) exit(1);
		*id[i]=i+1;
	}
	IniciaBuffer();

	sem_init(&mutexCons,0,1);
	sem_init(&mutexProd,0,1);
	sem_init(&slot_cheio,0,0);
	sem_init(&slot_vazio,0,N);

	for(int i=0;i<P;i++)
		if(pthread_create(&tid[i],NULL,produtor,(void *) id[i])) exit(1);
	for(int i=0;i<C;i++)
		if(pthread_create(&tid[i+P],NULL,consumidor,(void *) id[i+P])) exit(1);

	pthread_exit(NULL);
	return 0;
}

