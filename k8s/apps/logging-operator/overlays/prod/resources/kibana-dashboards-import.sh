#!/bin/bash
# Import Kibana dashboards for the logging stack.
#
# This imports the "Kubernetes Pod Logs" dashboard and its 6 Lens
# visualizations plus the fluentd* data view into the logging Kibana
# instance. The import uses --overwrite so it is safe to re-run.
#
# Prerequisites:
#   - kubectl access to the k8s-235 cluster (context: oidc@k8s-235-1)
#   - The logging namespace ES + Kibana must be running
#
# To export updated dashboards back to this file:
#   kubectl exec -i elasticsearch-es-default-0 -n logging -c elasticsearch \
#     --context=oidc@k8s-235-1 -- sh -c \
#     "curl -sk -u elastic:\$ES_PASSWORD -X POST \
#       'https://kibana-kb-http:5601/api/saved_objects/_export' \
#       -H 'kbn-xsrf: true' -H 'Content-Type: application/json' \
#       -d '{\"objects\":[{\"type\":\"dashboard\",\"id\":\"dashboard-k8s-pod-logs\"}],\"includeReferencesDeep\":true,\"excludeExportDetails\":true}'" \
#     > kibana-dashboards.ndjson

set -euo pipefail

CONTEXT="${CONTEXT:-oidc@k8s-235-1}"
NAMESPACE="logging"
ES_POD="elasticsearch-es-default-0"
KIBANA_URL="https://kibana-kb-http:5601"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NDJSON_FILE="$SCRIPT_DIR/kibana-dashboards.ndjson"

if [ ! -f "$NDJSON_FILE" ]; then
  echo "Error: $NDJSON_FILE not found"
  exit 1
fi

ES_PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user \
  -n "$NAMESPACE" --context="$CONTEXT" \
  -o jsonpath='{.data.elastic}' | base64 -d)

echo "Importing Kibana dashboards into $NAMESPACE namespace..."

cat "$NDJSON_FILE" | kubectl exec -i "$ES_POD" \
  -n "$NAMESPACE" -c elasticsearch --context="$CONTEXT" -- \
  sh -c "cat > /tmp/kibana-import.ndjson && \
    curl -sk -u elastic:$ES_PASSWORD -X POST \
      '${KIBANA_URL}/api/saved_objects/_import?overwrite=true' \
      -H 'kbn-xsrf: true' \
      -F file=@/tmp/kibana-import.ndjson && \
    rm /tmp/kibana-import.ndjson"

echo ""
echo "Done. Dashboard available at:"
echo "  https://logs.monitoring.235.tdude.co/app/dashboards#/view/dashboard-k8s-pod-logs"
