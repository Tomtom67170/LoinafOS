LOCK_HOUR=$(cat "/tmp/unlock.txt")
unlock_time=$((LOCK_HOUR + 3600))
time=$(date +"%s")

if [ $time -ge $unlock_time ] 
then
	echo "$time et $unlock_time"
	echo "Temps écoulé"
	loginctl terminate-user $USER
	
else
	echo "Trop tôt"
fi

