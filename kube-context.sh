#!/bin/bash
CURRENT_CTX=$(kubectl config current-context)
CTX=(`kubectl config view -o json | jq ".contexts | .[] | .name" | sed s/\"//g`)
for ((i = 0; i < ${#CTX[@]}; ++i)); do
  OPTS="$OPTS $i ${CTX[$i]}"
done
echo $OPTS
CHOICE=$(dialog \
  --clear \
  --backtitle "Kuberenetes" \
  --title "Contexts (Current: $CURRENT_CTX)" \
  --menu "Choose one:" 22 36 16 $OPTS 2>&1 >/dev/tty )
EXIT_CODE=$?
if [[ $EXIT_CODE -eq 0 ]]; then
  kubectl config use-context ${CTX[$CHOICE]}
fi
clear;
kubectl config get-contexts
