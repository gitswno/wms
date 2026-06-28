# Ti Qu Zuo Biao
x=`wm size | tail -n1 | awk '{print $3 }'| cut -dx -f1`
y=`wm size | tail -n1 | awk '{print $3 }'| cut -dx -f2`
as='adb shell'

# Ding Yi Qi Dian
startX=$((x / 2))
startY=$((y - 500))
endX=$startX
endY=$((startY-1000))
sleep 3
for ((i=0; i<"$1"; i++)); do
	$as input swipe $startX $startY $endX $endY
done
