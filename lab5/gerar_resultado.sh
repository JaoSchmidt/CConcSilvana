#!/bin/bash

filename="main.out.resultado"
touch $filename
echo ''> $filename

if [[ $# -eq 0 ]]; then
	for i in {1..16}; do	#testa 16 vezes
			for j in {1..5}; do	#testa 5 vezes
				echo "./main.out $i #pela $jº vez: ####################################################################" >> $filename
				echo "$(./main.out $i)" >> $filename
			done
	done
else 
	for ((c=1; c<=$1; c++)); do	#testa ateh $1
			for j in {1..5}; do	#testa 5 vezes
				echo "./main.out $c #pela $jº vez: ####################################################################" >> $filename
				echo "$(./main.out $c)" >> $filename
			done
	done
fi
