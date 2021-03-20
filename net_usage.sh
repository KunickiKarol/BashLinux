start_trans=$(awk 'NR == 3  {print $2}' /proc/net/dev)
counter=0
diff_trans=0
before_trans=0
act_trans=$(awk 'NR == 3 {print $2}' /proc/net/dev)
tmp=0
rm txt
while true ; do
  counter=$(($counter+1))
  before_trans=$act_trans
  act_trans=$(awk 'NR == 3 {print $2}' /proc/net/dev)
  diff_trans=$(($act_trans-$before_trans))
  tmp=$(($act_trans-$start_trans))
  tmp=$(($tmp/$counter))
  echo $counter $(($diff_trans)) >> txt
  echo "set term png;set xlabel 'Seconds';set ylabel 'B';set output 'printme.png';plot 'txt' with linespoints ps 2 title 'UploadInSec'" | gnuplot 2>/dev/null
  eog printme.png &  
  
  

  if [ $diff_trans -lt 1024 ]
  then
    echo Przesłano $diff_trans B
  elif [ $diff_trans -lt 1048576 ]
  then
    echo Przesłano $(($diff_trans/1024)) KB
  else
    echo Przesłano $(($diff_trans/1024/1024)) MB
  fi


  if [ $tmp -lt 1024 ]
  then
    echo Srednio przeslano $tmp B
    elif [ $tmp  -lt 1048576 ]
  then
    echo Przesłano srednio $(($tmp/1024)) KB
  else
    echo Przesłano srednio $(($tmp/1024/1024)) MB
  fi

  	running_time=$(cut -d" " -f1 /proc/uptime)
  echo System dziala:$(echo $running_time | awk '{print "\t " int(int($1)/60/60/24) " dni " int(int($1)/60/60%24) " godzin " int(int($1)/60%60%24) " minut " int(int($1)%60%24) " sekund"}')
  awk '{print "Srednio procesow " $1}' /proc/loadavg
  echo 

	sleep 2
done
