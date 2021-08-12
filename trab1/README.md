# Compilação e Versão GCC

- **Versão**: 9.3.0
- **Compilação**: gcc -o integral integral.c -lpthread -lm -Wall

Caso prefira, ultilizar o makefile:

```sh
mkdir MarcosTrab1
cd MarcosTrab1
make
./integral <a> <b> <nº retangulo> <nº de threads>
```
