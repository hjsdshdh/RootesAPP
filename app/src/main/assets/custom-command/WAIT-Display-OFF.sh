while [ true ]; do
  if [[ $(dumpsys power | grep Display | grep 'ON') != '' ]] || [[ $(dumpsys display | grep -E 'Display.*=ON') != '' ]]; then
    sleep 5
  else
    break
  fi
done
# echo 'Display(OFF), To NEXT >>'
