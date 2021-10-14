#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <semaphore.h>

#define N 100000
#define P 1
#define C 1

int Buffer[N];
int count=0,in=0,out=0;

sem_t d;

void IniciaBuffer(){
	for(int i=0;i<N;i++)
		Buffer[i]=0;
}

void retira_item(int* item){
	*item = Buffer[out];
	Buffer[out]=0;
	out=(out+1)%N;
}
void insere_item(int item){
	Buffer[in]=item;
	in=(in+1)%N;
}

void * consumidor(void * arg){
	int *id = (int *) arg;
	int item;
	while(1){
		sem_wait(&d); //&slot_cheio
		retira_item(&item); ;
		printf("C[%d] consumiu %d\n",*id,item);
		//sleep(1);
	}	

	free(arg);
	pthread_exit(NULL);
}

void * produtor(void * arg){
	int *id = (int *) arg;
	while(1){
		insere_item(*id);
		sem_post(&d); //&slot_cheio 
		//sleep(1);
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

	sem_init(&d,0,0);//&s

	for(int i=0;i<P;i++)
		if(pthread_create(&tid[i],NULL,produtor,(void *) id[i])) exit(1);
	for(int i=0;i<C;i++)
		if(pthread_create(&tid[i+P],NULL,consumidor,(void *) id[i+P])) exit(1);

	pthread_exit(NULL);
	return 0;
}

