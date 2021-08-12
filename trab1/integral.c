
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <pthread.h>
#include "timer.h"

#define RED "\x1b[31m"
#define WHT "\e[0;37m"

double LetraA(double);
double LetraB(double);
double LetraC(double);
double LetraD(double);
void *Menu();
void *somaRiemann();

int NTHREADS;                     //Declaracao do nº de threads
double a, b;                      //Variaveis do intervalo definido pelo user
int nRetangulos;                  //Variavel para armazenmento da quant de divisoes a serem realizada
double delta, resultIntegral = 0; //Delta X dos retangulos e o rultado final.
pthread_mutex_t lock;             //Declaração do mutex

//Estrutura para armazenamento das informações da thread, como seu id e qual função o usuario selecionou
typedef struct
{
    int id;
    double (*function)(double);
} Args;

int main(int argc, char *argv[])
{

    double inicio, fim, (*option)(double); //Variaveis para marcação do tempo e ponteiro para armazenamento de adress de function
    Args *thread;
    pthread_t *tid;

    //leitura e avalicao de paramentros
    if (argc < 4)
    {
        fprintf(stderr, "Digite : %s <Intervalo a> <Intervalo b> <nº de retangulos> <nº de thread>\n", argv[0]);
        return 1;
    }
    a = atof(argv[1]);
    b = atof(argv[2]);
    nRetangulos = atoi(argv[3]);
    NTHREADS = atoi(argv[4]);
    delta = (b - a) / nRetangulos;

    thread = (Args *)malloc(sizeof(Args) * NTHREADS);
    tid = (pthread_t *)malloc(sizeof(pthread_t) * NTHREADS);
    if (tid == NULL || thread == NULL)
    {
        printf(RED "|-->ERRO: malloc\n");
        return 2;
    }

    option = Menu(); //acessando o menu para o usuario e recebendo o adress da função escolhida

    //Inicialização do mutex e criação das thread e execução da soma
    pthread_mutex_init(&lock, NULL);

    GET_TIME(inicio);
    for (int i = 0; i < NTHREADS; i++)
    {
        (thread + i)->id = i;
        (thread + i)->function = option;
        if (pthread_create(tid + i, NULL, somaRiemann, (void *)(thread + i)))
        {
            fprintf(stderr, RED "|-->ERRO: pthread_create() <--|\n");
            return 3;
        }
    }

    for (int i = 0; i < NTHREADS; i++)
        if (pthread_join(*(tid + i), NULL))
        {
            printf(RED "|-->ERRO: pthread_join()<--| \n");
            exit(-1);
        }
    GET_TIME(fim);

    printf("\nResultado: %lf\n", resultIntegral * delta);
    printf("Tempo de calculo: %lf\n\n", fim - inicio);

    pthread_mutex_destroy(&lock);
    free(thread);
    free(tid);
    pthread_exit(NULL);
    return 0;
}

void *somaRiemann(void *arg)
{
    Args *thread = (Args *)arg;
    double somaLocal = 0;

    for (int i = (thread->id + 1); i <= nRetangulos; i += NTHREADS)
    {
        somaLocal += (thread->function(i * delta));
    }

    pthread_mutex_lock(&lock);
    resultIntegral += somaLocal;
    pthread_mutex_unlock(&lock);

    pthread_exit(NULL);
}

void *Menu()
{

    char letra;
    printf("Escolha a função:\n\na- x*2\nb- x^2\nc- (x^3)-6*x\nd- seno(x^2)\n\n");

    printf("Digite a letra da função que deseja executar: \n");
    scanf("%c", &letra);

    switch (letra)
    {
    case 'a':
    case 'A':
        return (double *)LetraA;
        break;
    case 'b':
    case 'B':
        return (double *)LetraB;
        break;
    case 'c':
    case 'C':
        return (double *)LetraC;
        break;
    case 'd':
    case 'D':
        return (double *)LetraD;
        break;
    default:
        printf(RED "Opção Invalida.\n" WHT);
        exit(-1);
        break;
    }
    return 0;
}

double LetraA(double x)
{
    return x * 2;
}
double LetraB(double x)
{
    return pow(x, 2);
}
double LetraC(double x)
{
    return pow(x, 3) - (6 * x);
}

double LetraD(double x)
{
    return sin(pow(x, 2));
}
