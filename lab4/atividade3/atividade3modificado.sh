#!/bin/bash

echo '' > printXmodificado.log
for i in {1..30}; do
	echo -e "\nTeste $i do printXmodificado\n" >> printXmodificado.log
	./printXmodificado.out >> printXmodificado.log
done
