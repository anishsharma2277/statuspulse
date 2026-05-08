#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8000}"

pass() {
  echo "PASS: $1"
}

fail() {
  echo "FAIL: $1"
  exit 1
}

check_status() {
  local method="$1"
  local endpoint="$2"
  local expected="$3"
  local data="${4:-}"

  if [ -n "$data" ]; then
    code=$(curl -s -o /tmp/response.json -w "%{http_code}" \
      -X "$method" "$BASE_URL$endpoint" \
      -H "Content-Type: application/json" \
      -d "$data")
  else
    code=$(curl -s -o /tmp/response.json -w "%{http_code}" \
      -X "$method" "$BASE_URL$endpoint")
  fi

  [ "$code" = "$expected" ] || fail "$method $endpoint expected $expected got $code"
  python3 -m json.tool /tmp/response.json >/dev/null || fail "$method $endpoint invalid JSON"
  pass "$method $endpoint returned $expected with valid JSON"
}

check_status GET /health 200
check_status POST /services 200 '{"name":"google","url":"https://google.com"}'
check_status GET /services 200
check_status POST /services 409 '{"name":"google","url":"https://google.com"}'
check_status POST /incidents 200 '{"service_name":"google","title":"Test incident","description":"Testing","severity":"minor"}'
check_status GET /incidents 200

echo "All integration tests passed"
