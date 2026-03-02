#!/usr/bin/env bash
set -euo pipefail

# ─── CONFIG ───────────────────────────────────────────────────────────────
BASE_URL="http://localhost:8080/DataCustodian"
TOKEN_URL="$BASE_URL/oauth/token"
BATCH_URL="$BASE_URL/espi/1_1/resource/Batch/RetailCustomer/1/UsagePoint"

CLIENT_ID="data_custodian"
CLIENT_SECRET="secret"

BATCH_PAYLOAD="batch_payload.xml"

# ─── STEP 2: FETCH OAUTH TOKEN ────────────────────────────────────────────
echo "Fetching OAuth token…"
TOKEN_JSON=$(curl -s -u "data_custodian:secret" \
  -d 'grant_type=client_credentials' \
  "http://localhost:8080/DataCustodian/oauth/token")

TOKEN=$(printf "%s" "$TOKEN_JSON" | python3 -c 'import sys, json; print(json.load(sys.stdin)["access_token"])')
echo "Got token: ${TOKEN:0:8}…"

# ─── STEP 3: UPLOAD BATCH ─────────────────────────────────────────────────
echo "Uploading batch payload…"
curl -v \
  -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/xml; charset=UTF-8" \
  --data-binary @"$BATCH_PAYLOAD" \
  "$BATCH_URL"

echo "Done."
