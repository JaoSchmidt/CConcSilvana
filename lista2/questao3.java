import java.util.LinkedList;

class FilaTarefas {

	private int nThreads;
	private MyPoolThreads[] threads;
	private LinkedList<Runnable> queue;//similar a um vetor de objetos Runnable 
	private boolean shutdown;

	public FilaTarefas(int nThreads) {
		this.shutdown=false; 
		this.nThreads=nThreads;
		queue=new LinkedList<Runnable>();
		threads = new MyPoolThreads[nThreads];
		for (int i=0; i<nThreads; i++) {
			threads[i] = new MyPoolThreads();
			threads[i].start(); 
		}
	}
	public void execute(Runnable r) {
		synchronized(queue) {
		if (this.shutdown) return;
			queue.addLast(r); //inclui um novo elemento na lista ’queue’
			queue.notify();
		}
	}
	public void shutdown() {
		synchronized(queue){ 
			this.shutdown=true;
		}
		for (int i=0; i<nThreads; i++)
			try { 
				threads[i].join(); 
			} catch (InterruptedException e) { 
				return;
		 	}
	}
	private class MyPoolThreads extends Thread {
		public void run() {
			Runnable r;
			while (true) {
				synchronized(queue) {
					//verifica se a lista est ́a vazia...
					while (queue.isEmpty() && (!shutdown)) {
						try { queue.wait();
						} catch (InterruptedException ignored){}
					}
					//retira o primeiro elemento da lista e o retorna
					if(queue.isEmpty() && shutdown) return;
						r = (Runnable) queue.removeFirst();
				}	
				try { r.run(); } catch (RuntimeException e) {}
			}
		} 
	}
	static class Tarefa implements Runnable{
		int id;
		Tarefa(int id){
			this.id=id;
		}
		public void run(){
			int bob1=1000,bob2=1000000;
			for(;bob1<bob2;bob1++){}
			System.out.println(id);
		}
	}
	public static void main(String[] args){
		FilaTarefas a = new  FilaTarefas(10);
		//System.out.println("Id das tarefas executadas:");
		for(int i=0;i<5;i++)
			a.execute(new Tarefa(i));	
		a.shutdown();
	}
}
