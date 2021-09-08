/* Disciplina: Computacao Concorrente */
/* Prof.: Silvana Rossetto */
/* Laboratório: 6 */
/* Codigo: Acessando variável compartilhada em um programa multithreading Java */
/* -------------------------------------------------------------------*/

//classe da estrutura de dados (recurso) compartilhado entre as threads
class S {
  //recurso compartilhado
  private int r[];
  //construtor
  public S(int size,int numTeste) { 
		if(numTeste==1){
			this.r = new int[size];
			for(int i=0;i<size;i++){
				this.r[i] = i*5;
			}
		}else if(numTeste==2){
			this.r = new int[size];
				for(int i=0;i<size;i++){
					this.r[i] = i;
			}
		}
		System.out.println("Array "+numTeste+"= ["+r[0]+", "+r[1]+", "+r[2]+", "+r[3]+", ...,"+r[size-3]+", "+r[size-2]+", "+r[size-1]+"]");
  }

  public boolean iseven(int index) { 
		if(r[index]%2==0)
			return true;
		return false;
  }
  
  // ou...
	/*
  public synchronized void inc() { 
  }

  public synchronized int get() { 
  }*/
  
}

//classe que estende Thread e implementa a tarefa de cada thread do programa 
class T extends Thread {
   //identificador da thread
   private int id,size,nthreads;
   //objeto compartilhado com outras threads
   S s;
	//saida
	private int count=0;
   //construtor
   public T(int tid, S s,int size,int nthreads) { 
      this.id = tid; 
      this.s = s;
		this.size = size;
		this.nthreads = nthreads;
   }

   //metodo main da thread
   public void run() {
		for(int i=id;i<size;i+=nthreads){
			if(s.iseven(i))
				count++;
		}
		somaFinal();
   }
	public synchronized void somaFinal(){
		TIncrementoBase.pares+=count;
	}
}

//classe da aplicacao
class TIncrementoBase {
   static final int N = 10;
	static final int size = 20000000;//20 milhões 
	static final int size2 = 4000000;//4 milhões
	static int pares = 0;
   public static void main (String[] args) {
      //reserva espaço para um vetor de threads
      Thread[] threads = new Thread[N];

      //cria uma instancia do recurso compartilhado entre as threads
      S s1 = new S(size,1);
      S s2 = new S(size2,2);

      //cria as threads da aplicacao
      for (int i=0; i<threads.length; i++) {
         threads[i] = new T(i, s1,size,N);
      }
      //inicia as threads
      for (int i=0; i<threads.length; i++) {
         threads[i].start();
      }
      //espera pelo termino de todas as threads
      for (int i=0; i<threads.length; i++) {
         try { threads[i].join(); } catch (InterruptedException e) { return; }
      }
      System.out.println("N pares teste 1 = "+pares); 
		pares = 0;
      //cria as threads da aplicacao
      for (int i=0; i<threads.length; i++) {
         threads[i] = new T(i, s2,size2,N);
      }
      //inicia as threads
      for (int i=0; i<threads.length; i++) {
         threads[i].start();
      }
      //espera pelo termino de todas as threads
      for (int i=0; i<threads.length; i++) {
         try { threads[i].join(); } catch (InterruptedException e) { return; }
      }
      System.out.println("N pares teste 2 = "+pares); 
   }
}
