#!/bin/bash

echo '' > byehello.log
for i in {1..30}; do
	echo -e "\nTeste $i do byehello\n" >> byehello.log
	./byehello.out >> byehello.log
done
