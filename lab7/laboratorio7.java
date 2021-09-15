/* Disciplina: Computacao Concorrente */
/* Prof.: Silvana Rossetto */
/* Codigo: Leitores e escritores usando monitores em Java */
/* -------------------------------------------------------------------*/

// Monitor que implementa a logica do padrao leitores/escritores
class LE {
  private int leit, escr, leitEscr;  
  public long variavel=0;
  // Construtor
  LE() { 
     this.leit = 0; //leitores lendo (0 ou mais)
     this.escr = 0; //escritor escrevendo (0 ou 1)
	  this.leitEscr = 0;
  } 
  
  // Entrada para leitores
  public synchronized void EntraLeitor (int id) {
    try { 
      while (this.escr > 0 || this.leitEscr > 0) {
         System.out.println ("le.leitorBloqueado("+id+")");
         wait();  //bloqueia pela condicao logica da aplicacao 
      }
      this.leit++;  //registra que ha mais um leitor lendo
      System.out.println ("le.leitorLendo("+id+")");
    } catch (InterruptedException e) { }
  }
  
  // Saida para leitores
  public synchronized void SaiLeitor (int id) {
     this.leit--; //registra que um leitor saiu
     if (this.leit == 0 || this.leitEscr == 0) 
           this.notify(); //libera escritor (caso exista escritor bloqueado)
     System.out.println ("le.leitorSaindo("+id+")");
  }
  
  // Entrada para escritores
  public synchronized void EntraEscritor (int id) {
    try { 
      while ((this.leit > 0) || (this.escr > 0) || (this.leitEscr > 0)) {
         System.out.println ("le.escritorBloqueado("+id+")");
         wait();  //bloqueia pela condicao logica da aplicacao 
      }
      this.escr++; //registra que ha um escritor escrevendo
      System.out.println ("le.escritorEscrevendo("+id+")");
    } catch (InterruptedException e) { }
  }
  
  // Saida para escritores
  public synchronized void SaiEscritor (int id) {
     this.escr--; //registra que o escritor saiu
     notifyAll(); //libera leitores e escritores (caso existam leitores ou escritores bloqueados)
     System.out.println ("le.escritorSaindo("+id+")");
  }
	
  //saida para LeitorEscritor, mesma coisa do escritor
	public synchronized void EntraLeitorEscritor(int id){
		try{
			while(this.leit >0 || this.escr > 0 || this.leitEscr > 0){
				System.out.println("le.LeitorEscritorBloqueado("+id+")");
				wait();
			}
			this.leitEscr++;
		} catch(InterruptedException e){}
	}
	public synchronized void SaiLeitorEscritor(int id){
		this.leitEscr--;
		notifyAll();	
		System.out.println("le.LeitorEsritorSaindo("+id+")");
	}
}



//Aplicacao de exemplo--------------------------------------------------------
// LeitorEscritor
class LeitorEscritor extends Thread {
	int id;
	int delay;
	LE monitor;

	LeitorEscritor(int id, int delayTime,LE m){
		this.id = id;
		this.delay = delayTime;
		this.monitor = m;
	}
	public void run(){
		try{
			for(;;){
				this.monitor.EntraLeitorEscritor(id);

				//checando se a variável é par ou ímpar
				if(monitor.variavel%2==0)
					System.out.println("variavel "+monitor.variavel+" é par");
				else
					System.out.println("variavel "+monitor.variavel+" é ímpar");

				//dpbrando o valor da variavel
				monitor.variavel*=2;

				this.monitor.SaiLeitorEscritor(id);
				sleep(this.delay);
			}
		}catch(InterruptedException e){}
	}
}
// Leitor
class Leitor extends Thread {
  int id; //identificador da thread
  int delay; //atraso bobo
  LE monitor;//objeto monitor para coordenar a lógica de execução das threads

  // Construtor
  Leitor (int id, int delayTime, LE m) {
    this.id = id;
    this.delay = delayTime;
    this.monitor = m;
  }

  // Método executado pela thread
  public void run () {
    try {
      for (;;) {
        this.monitor.EntraLeitor(this.id);
		  
			//checa se a variável é primo
			if(monitor.variavel==2){
				System.out.println("variavel = 2 é um número primo");
			}else if(monitor.variavel%2==0){
				System.out.println("variavel = "+monitor.variavel+" é um número divisível por 2");
			}else if(monitor.variavel==1){
				System.out.println("variavel = 1 não é primo nem composto");
			}else{
				for(int i=3;i<Math.sqrt(monitor.variavel);i+=2){
					if(monitor.variavel%i==0){
						System.out.println(monitor.variavel+" é um número divisível por "+i);
						break;
					}
				}
				System.out.println("variavel = "+monitor.variavel+" é um número primo");
			}

        this.monitor.SaiLeitor(this.id);
		  sleep(this.delay);
      }
    } catch (InterruptedException e) { return; }
  }
}

//--------------------------------------------------------
// Escritor
class Escritor extends Thread {
  int id; //identificador da thread
  int delay; //atraso bobo...
  LE monitor; //objeto monitor para coordenar a lógica de execução das threads

  // Construtor
  Escritor (int id, int delayTime, LE m) {
    this.id = id;
    this.delay = delayTime;
    this.monitor = m;
  }

  // Método executado pela thread
  public void run () {
    try {
      for (;;) {
        this.monitor.EntraEscritor(this.id); 
		
		//modifica o valor de variavel
		monitor.variavel = id;


        this.monitor.SaiEscritor(this.id); 
		  sleep(this.delay);
      }
    } catch (InterruptedException e) { return; }
  }
}

//--------------------------------------------------------
// Classe principal
class principal {
  static final int L = 7;
  static final int E = 3;
  static final int LE = 2;

  public static void main (String[] args) {
    int i;
    LE monitor = new LE();            // Monitor (objeto compartilhado entre leitores e escritores)
    Leitor[] l = new Leitor[L];       // Threads leitores
    Escritor[] e = new Escritor[E];   // Threads escritores
	 LeitorEscritor[] le = new LeitorEscritor[LE]; //Threads leitoresEscritores

    //inicia o log de saida
    System.out.println ("import verificaLE");
    System.out.println ("le = verificaLE.LE()");
    
    for (i=0; i<L; i++) {
       l[i] = new Leitor(i+1, (i+1)*1000, monitor);
       l[i].start(); 
    }
    for (i=0; i<E; i++) {
       e[i] = new Escritor(i+1, (i+1)*1500, monitor);
       e[i].start(); 
    }
    for (i=0; i<LE; i++) {
       le[i] = new LeitorEscritor(i+1, (i+1)*1500, monitor);
       le[i].start(); 
    }
  }
}

