for i in {0..99}
do 
	teste=$(cat resultado | grep "\b$i\b")
	if [ -z "$teste" ]
	then
		echo "empty"
	else
		echo $teste
	fi
done
