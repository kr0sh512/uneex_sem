#!/bin/bash
exit_handler() {
  trap - EXIT
  tput clear
  exit
}

trap exit_handler EXIT HUP INT QUIT PIPE TERM


input=$(cat)

delay=${1:-0}

tput clear

char_in_line=() # требуется, чтобы строки были одной длины

arr=()
while IFS= read -r -n1 char; do
    if [[ -z "$char" ]]; then
        arr+=($'\n')
        char_in_line=${#arr[@]}
        # if [[ "$char_in_line" -eq -1 ]]; then
        #     char_in_line=${#arr[@]}
        # fi
    else
        arr+=("$char")
    fi
done <<< "$input"

arr_num=()

for i in "${!arr[@]}"; do
    arr_num[i]=$i
done

shuffled=($(printf "%s\n" "${arr_num[@]}" | shuf))

for i in "${!shuffled[@]}"; do
    if [[ "${arr[${shuffled[i]}]}" != [[:space:]] ]]; then # проверка на символ конца строки не удалась
        tput cup $((${shuffled[i]} / ${char_in_line[]})) $((${shuffled[i]} % $char_in_line))
        shuffled[i]="${arr[${shuffled[i]}]}"
        printf "%c" "${shuffled[i]}"
        sleep $delay
    fi
done

tput cup $((${#arr[@]} / $char_in_line)) 0

printf "\n"
