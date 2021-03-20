mkdir repozi
cd repozi 
site=$1
time=$2
version=0
file_name=$(echo $site | cut -d "/" -f 3 )
elinks -dump $site > $file_name$version
git add *
git commit -a --allow-empty-message -m ''
while true ; do
	sleep $time
	elinks -dump $site > test
	diff -q test $file_name$version 1>/dev/null
	if [[ $? == "1" ]]
	then
		version=$version+1
		elinks -dump $site > $file_name$version
		git add $file_name$version
		git commit -a --allow-empty-message -m ''
		zenity --info --width=400 --text="Uwaga" --title="Zaktualizowano strone $site"
	fi
done
