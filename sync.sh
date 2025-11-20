set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

echo "cd into $SCRIPT_DIR"
cd "$SCRIPT_DIR"

git fetch origin master && git pull origin master
