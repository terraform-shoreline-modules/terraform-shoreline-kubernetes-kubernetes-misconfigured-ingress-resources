

#!/bin/bash



# Kubernetes cluster details

KUBECONFIG=${PATH_TO_KUBECONFIG_FILE}

NAMESPACE=${NAMESPACE}



# Get the Ingress resources associated with the application

INGRESS_LIST=$(kubectl --kubeconfig=$KUBECONFIG get ingress -n $NAMESPACE -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')



# Loop through each Ingress resource and check for issues

for INGRESS_NAME in $INGRESS_LIST

do

  # Check if the Ingress resource has any routing rules

  RULES=$(kubectl --kubeconfig=$KUBECONFIG get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.rules}')

  if [ -z "$RULES" ]; then

    echo "Ingress resource $INGRESS_NAME does not have any routing rules"

  fi



  # Check if the Ingress resource has any security policies

  TLS=$(kubectl --kubeconfig=$KUBECONFIG get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.tls}')

  if [ -z "$TLS" ]; then

    echo "Ingress resource $INGRESS_NAME does not have any security policies"

  fi

done