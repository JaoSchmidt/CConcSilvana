#!/bin/bash

echo '' > hellobye.log
for i in {1..30}; do
	echo -e "\nTeste $i do hellobye\n" >> hellobye.log
	./hellobye.out >> hellobye.log
done
