#!/bin/bash

set -e

DEFAULT_SITE="godam.localhost"
SITE_NAME="${1:-$DEFAULT_SITE}"

echo "Running setup for site: $SITE_NAME"

if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_PAT" ]; then
  echo "ERROR: Missing GITHUB_USERNAME or GITHUB_PAT"
  echo "Before running this script, execute:"
  echo "export GITHUB_USERNAME=\"your-github-username\""
  echo "export GITHUB_PAT=\"your-github-personal-access-token\""
  exit 1
fi

echo "Configuring git credentials..."
echo "https://$GITHUB_USERNAME:$GITHUB_PAT@github.com" >> ~/.git-credentials
git config --global credential.helper store

echo "Activating venv..."
source ./env/bin/activate

echo "Installing Python dependencies..."
pip3 install deepgram-captions deepgram-sdk pydash2hls

echo "Fetching and building required apps..."
install_app() {
  local repo="$1"
  local branch="$2"
  bench restart
  bench get-app "$repo" --branch "$branch"
}

install_app "telephony" "develop"
install_app "helpdesk" "main"
install_app "payments" "version-15"
install_app "https://github.com/rtCamp/godam-core.git" "develop"
install_app "https://github.com/rtCamp/frappe-organization.git" "develop"
install_app "https://github.com/rtCamp/frappe-comment-xt.git" "develop"
install_app "https://github.com/rtCamp/frappe-stripe-subscription.git" "develop"

echo "Installing required apps to site..."
bench --site "$SITE_NAME" install-app \
  telephony \
  helpdesk \
  payments \
  godam_core \
  frappe_organization \
  frappe_comment_xt \
  frappe_stripe_subscription

echo "Setup complete!"
echo "Next steps:"
echo " 1. Exit shell"
echo " 2. Run: fm stop $SITE_NAME"
echo " 3. Run: fm start $SITE_NAME"