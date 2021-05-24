#!/bin/bash
set -e
ECR_IMAGE_TAG="<IMAGE1_NAME>"
TASK_FAMILY=ecs-blog-svc
Regions=ca-central-1

if [ "$TASK_FAMILY" = "" ]; then
  echo "Missing variable TASK_FAMILY" >&2
  exit 1
fi

if [ "$Regions" = "" ]; then
  echo "Missing variable Regions" >&2
  exit 1
fi

if [ "$ECR_IMAGE_TAG" = "" ]; then
  echo "Missing variable ECR_IMAGE_TAG" >&2
  exit 1
fi

TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition "$TASK_FAMILY")
NEW_TASK_DEFINTIION=$(echo "$TASK_DEFINITION" | jq --arg IMAGE "$ECR_IMAGE_TAG" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities)')
#NEW_TASK_INFO=$(aws ecs register-task-definition --region "$Regions" --cli-input-json "$NEW_TASK_DEFINTIION")
echo $NEW_TASK_INFO > taskdef.json
#NEW_REVISION=$(echo "$NEW_TASK_INFO" | jq '.taskDefinition.revision')
echo $NEW_TASK_INFO
# return new task revision
#echo "${TASK_FAMILY}:${NEW_REVISION}"