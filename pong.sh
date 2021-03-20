w=$(tput cols)
h=$(tput lines)
(( h = h > 42 ? 42 : h - 1 ))
(( w = w > 105 ? 105 : w ))
w-=5
whitespace=`printf "%0.s " $(seq $w)`
pos_x=$(($w/2-$w/4))
pos_y=$(($h/2))
vel_y=1
vel_x=1
pos_l=0
board_l_h=$(($h/2))
board_r_h=$(($h/2))
tmp=0
half=0
point_l=0
point_r=0

function pause(){
   read -t 3 -s -p  "$*"
}

draw_board() {
	lorr=$1
	pos=$(($2))
    echo -en "\033[${pos};${lorr}H▮"
    for i in $(seq 5); do
		pos=$(($pos+1))
	   	echo -en "\033[${pos};${lorr}H▮"
    done
    pos=$(($pos+1))
    echo -en "\033[${pos};${lorr}H▮"
}

tput civis
tput clear

draw_blank(){
	lorr=$1
	pos=$(($2))
    echo -en "\033[${pos};${lorr}H "
    for i in $(seq 5); do
		pos=$(($pos+1))
	   	echo -en "\033[${pos};${lorr}H "
    done
    pos=$(($pos+1))
    echo -en "\033[${pos};${lorr}H "

}
draw_line() {
	for i in `seq $(($h-1))`; do
		tmp=$((w/2))
		echo -en "\033[$i;${tmp}H▮"
		tmp=$(($h+1))

	done
}
draw_ground(){
			for i in $(seq $w); do
			echo -en "\033[${h};${i}H="
		done
		tmp=$((w/2-3))
		echo -en "\033[${h};${tmp}H"
		echo $point_l
		tmp=$((w/2+3))
		echo -en "\033[${h};${tmp}H"
		echo $point_r

}
draw_ground
draw_line
 draw_board 1 $(($h/2))
 draw_board $w $(($h/2))
 
 while [[ $q != q ]]; do
 
	draw_line
    echo -e "\033[${pos_y};${pos_x}H●"
    stty -echo
    read -n 1 -s -t 0.05 q
    case "$q" in 
        [Rr]*) stty -echo
        		draw_blank 1 board_l_h
        		(( board_l_h -= 2 ))
    			(( board_l_h = board_l_h < 1 ? 1 : board_l_h ))
        		draw_board 1 board_l_h;;
        [Ff]*) stty -echo
        		draw_blank 1 board_l_h
        		(( board_l_h += 2))
    			(( board_l_h = board_l_h > h - 7 ? h - 7 : board_l_h ))
        		draw_board 1 board_l_h;; 
        		
        [Oo]*) 	stty -echo
        		draw_blank $w board_r_h
        		(( board_r_h -= 2 ))
    			(( board_r_h = board_r_h < 1 ? 1 : board_r_h ))
        		draw_board $w board_r_h;;
        [Ll]*) stty -echo
        		draw_blank $w board_r_h
        		(( board_r_h += 2 ))
    			(( board_r_h = board_r_h > h - 7 ? h - 7 : board_r_h ))
        		draw_board $w $board_r_h;;
    esac
    stty -echo
    echo -e "\033[${pos_y};${pos_x}H "
    (( pos_y <= 1 || pos_y + vel_y > h-2 )) && (( vel_y = - vel_y ))
    (( vel_x < 0 && (pos_x-vel_x >= w/2 && pos_x-vel_x <= w/2+2))) && ((draw_line))
    (( vel_x > 0 && (pos_x-vel_x <= w/2 && pos_x-vel_x >= w/2-2))) && ((draw_line))
    if (( pos_x+vel_x < 2 || pos_x+vel_x > w-1 )); then
        if (( pos_x+vel_x < 2 && pos_y >= board_l_h && pos_y <= board_l_h+6 )); then
        	(( vel_x = - vel_x ))
       	 	if ((pos_y <= board_l_h+2 || pos_y >= board_l_h+4)); then
		   	 	(( vel_x += 1 ))
       	 	fi
        elif ((pos_x+vel_x > w-1 && pos_y >= board_r_h && pos_y <= board_r_h+6 )); then
       		(( vel_x = - vel_x ))	
            if ((pos_y <= board_r_h+2 || pos_y >= board_r_h+4)); then
       	 		(( vel_x -= 1 ))
       	 	fi
        else
		    if ((pos_x+vel_x < 2)); then
		    	((point_r+=1))
		    else
		    	((point_l+=1))
		    fi
		    draw_ground
        	pause ""
        	((half+=1))
            pos_x=w/2-w/4
            pos_y=h/2
            vel_y=1
            vel_x=1
            if ((half==1)); then
            pos_x=w/2+w/4
            (( vel_x = - vel_x ))
            (( vel_y = - vel_y ))
            ((half=-1))
            fi
        fi
    fi
    (( pos_x += vel_x ))
    (( pos_y += vel_y ))
done

tput cnorm
