#!/bin/bash

echo '' > printX.log
for i in {1..30}; do
	echo -e "\nTeste $i do printX\n" >> printX.log
	./printX.out >> printX.log
done
