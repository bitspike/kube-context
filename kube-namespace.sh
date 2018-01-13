#!/bin/bash
# CTX=(`kubectl config view -o json | jq ".contexts | .[] | .name" | sed s/\"//g`)
NS=(`kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'`)
for ((i = 0; i < ${#NS[@]}; ++i)); do
  OPTS="$OPTS $i ${NS[$i]}"
done
echo $OPTS
CHOICE=$(dialog \
  --clear \
  --backtitle "Kuberenetes" \
  --title "Namespaces" \
  --menu "Choose one:" 22 36 16 $OPTS 2>&1 >/dev/tty )
EXIT_CODE=$?
if [[ $EXIT_CODE -eq 0 ]]; then
  kubectl config set-context $(kubectl config current-context) --namespace=${NS[$CHOICE]}
fi
clear;
