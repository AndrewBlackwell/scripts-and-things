#!/usr/bin/env bash
set -euo pipefail

case "${1-}" in
  cleanup) pkill -f "ollama serve" 2>/dev/null || true; exit ;;
  generate) shift; mode=oneshot;;
  *) mode=chat;;
esac

# start Ollama only if it isn’t up
started=false
pgrep -f "ollama serve" &>/dev/null || { ollama serve &>/dev/null & disown; started=true; sleep 1; }

if [[ $mode == oneshot ]]; then
  echo "$*" | ollama run aegis
else
  ollama run aegis
fi
status=$?

$started && pkill -f "ollama serve" 2>/dev/null || true
exit "$status"
