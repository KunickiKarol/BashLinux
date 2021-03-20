echo PID NAME STATE PPID GPID SPID TTY NICE+15 PRIORITY OPENED_F >> nice
for PID in /proc/[0-9]*
do
	echo $(cut -d " " -f 1,2,3,6,7,8,9,21,40 $PID/stat) $(ls $PID/fd | wc -l) >> nice
done
column -t -s' ' nice
rm nice
