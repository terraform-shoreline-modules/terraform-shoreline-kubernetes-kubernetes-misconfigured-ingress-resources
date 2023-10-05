
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes - Misconfigured Ingress Resources
---

Misconfigured Ingress Resources is an incident type that occurs when the Ingress resources in a Kubernetes cluster are not properly configured, resulting in routing or security issues. Ingress resources are used to manage external access to services in a cluster, and when not configured correctly, can cause issues such as incorrect routing of traffic or unauthorized access to resources. This can result in service disruptions, security breaches, and other problems that can impact the overall performance and stability of the system.

### Parameters
```shell
export NAMESPACE="PLACEHOLDER"

export LABEL_SELECTOR="PLACEHOLDER"

export INGRESS_NAME="PLACEHOLDER"

export PATH_TO_KUBECONFIG_FILE="PLACEHOLDER"

export INGRESS_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### Check if the ingress controller is running
```shell
kubectl get pods -n ${NAMESPACE} -l ${LABEL_SELECTOR}
```

### Check if the ingress resources are correctly configured
```shell
kubectl describe ingress ${INGRESS_NAME} -n ${NAMESPACE}
```

### Check if the ingress resources have all the required annotations
```shell
kubectl describe ingress ${INGRESS_NAME} -n ${NAMESPACE} | grep -i annotation
```

### Check if the ingress resources have the correct backend service and port
```shell
kubectl describe ingress ${INGRESS_NAME} -n ${NAMESPACE} | grep -i backend
```

### Check if the ingress resources have the correct rules and paths
```shell
kubectl describe ingress ${INGRESS_NAME} -n ${NAMESPACE} | grep -i rule
```

### The Ingress resource was not properly configured with the appropriate routing rules and security policies.
```shell


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


```

## Repair

### Re-deploy the ingress resources to ensure that they are correctly configured and functional.
```shell


#!/bin/bash



# 1. Set the ${NAMESPACE} and ${INGRESS_NAME} variables to the appropriate values for your cluster

namespace=${NAMESPACE}

ingress_name=${INGRESS_NAME}



# 2. Delete the existing Ingress resources

kubectl delete ingress $ingress_name -n $namespace



# 3. Wait for the resources to be deleted before proceeding

sleep 10



# 4. Re-deploy the Ingress resources using the appropriate configuration file

kubectl apply -f ${INGRESS_CONFIG_FILE} -n $namespace



# 5. Verify that the new Ingress resources are correctly configured and functional

kubectl get ingress $ingress_name -n $namespace


```