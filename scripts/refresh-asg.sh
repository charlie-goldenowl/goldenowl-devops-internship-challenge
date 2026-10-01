#!/usr/bin/env bash
set -euo pipefail

TAG="$1"
PARAM="/goldenowl/image-tag"
ASG="goldenowl-asg"

aws ssm put-parameter --name "$PARAM" --value "$TAG" --type String --overwrite > /dev/null

REFRESH_ID=$(aws autoscaling start-instance-refresh \
  --auto-scaling-group-name "$ASG" \
  --preferences '{"MinHealthyPercentage":50,"InstanceWarmup":90}' \
  --query InstanceRefreshId --output text)
echo "Started instance refresh $REFRESH_ID for image tag $TAG"

for i in $(seq 1 60); do
  STATUS=$(aws autoscaling describe-instance-refreshes \
    --auto-scaling-group-name "$ASG" \
    --instance-refresh-ids "$REFRESH_ID" \
    --query 'InstanceRefreshes[0].Status' --output text)
  echo "[$i] status: $STATUS"
  case "$STATUS" in
    Successful) exit 0 ;;
    Failed|Cancelled|RollbackSuccessful|RollbackFailed) exit 1 ;;
  esac
  sleep 30
done

echo "Timed out waiting for instance refresh"
exit 1