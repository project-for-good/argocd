#!/bin/bash

NAME='frontend-web'
DESTINATION_NAMESPACE='prod'
DESTINATION_CLUSTER='in-cluster'
APP_PATH=${DESTINATION_NAMESPACE}/${NAME}

if [ "$DESTINATION_CLUSTER" = "in-cluster" ]; then
APP_NAME=${NAME}
else
APP_NAME=${NAME}-${DESTINATION_CLUSTER}
fi

# Edit template
MANIFESTS_DIR="/opt/git/hustlegotreal/argocd/_config/Applications/clusters/${DESTINATION_CLUSTER}/${DESTINATION_NAMESPACE}/"

yq eval '.metadata.name = "'${APP_NAME}'"
 | .spec.destination.namespace = "'${DESTINATION_NAMESPACE}'"
 | .spec.destination.name = "'${DESTINATION_CLUSTER}'"
 | .spec.source.path = "'${APP_PATH}'" ' \
 Application-template.yaml > ${APP_NAME}.yaml

echo "Creating ${APP_NAME} Application.." \
  && kubectl create -f ${APP_NAME}.yaml \
  && echo "Saving manifest.." \
  && mv ${APP_NAME}.yaml ${MANIFESTS_DIR} \
  && echo "tasks are completed"
