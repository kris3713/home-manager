set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

cd "$SCRIPT_DIR"

git fetch origin master && git pull origin master
