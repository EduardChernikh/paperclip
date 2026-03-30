#!/bin/bash
set -e

OPENCODE_CONFIG_DIR="$HOME/.opencode"
OPENCODE_CONFIG_FILE="$OPENCODE_CONFIG_DIR/config.json"

if [ -n "$OPENROUTER_API_KEY" ]; then
    echo "Initializing config OpenCode for OpenRouter..."
    mkdir -p "$OPENCODE_CONFIG_DIR"
    cat <<EOF > "$OPENCODE_CONFIG_FILE"
{
  "providers": {
    "openrouter": {
      "apiKey": "$OPENROUTER_API_KEY",
      "model": "anthropic/claude-3-5-haiku"
    }
  },
  "defaultProvider": "openrouter"
}
EOF
    echo "Config created at: $OPENCODE_CONFIG_FILE"
else
    echo "Warning: OPENROUTER_API_KEY not found. OpenCode might require manual authorization."
fi

if [ -z "$PAPERCLIP_LOCAL_AGENT_JWT_SECRET" ]; then
    echo "[Warning] PAPERCLIP_LOCAL_AGENT_JWT_SECRET is missing! Local agents will fail to auth."
fi

find /paperclip -name "*.blocker" -delete 2>/dev/null || true
echo "[Init] Starting Paperclip Server..."

exec "$@"