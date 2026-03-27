#!/bin/bash

set -euo pipefail
# e: exit if command fails
# u: reference to an unset variable will fail the script
# o pipefail: fail if pipeline fails

echo "—————————————————————————————————————————————————————————————————————————————————————————————"
echo "——————————————————————————————————— post-create-script.sh ———————————————————————————————————"
set -x # print commands to terminal

# make symbolic reference of .aws folder in user-dir to root dir
# This makes the aws login of the user work with sudo commands, or commands run as root user
# sudo ln --force --symbolic --no-dereference "/home/$USER/.aws /root/.aws"

# Install/update Python packages
uv sync

# Install pre-commit
sudo pre-commit install

# set up git auto push
cat > .git/hooks/post-commit << 'EOF'
#!/bin/bash
set -euo pipefail
export AWS_PROFILE=hc-dx-dlh-accept
git push
EOF
chmod +x .git/hooks/post-commit

# TODO: check if this fixes commands not running because the git repo is initially not trusted
git config --global --add safe.directory "$(pwd)"

# Configure git
git config merge.ff false
git config pull.rebase true
git config push.autoSetupRemote true

set +x
echo "——————————————————————————————————— post-create-script.sh ———————————————————————————————————"
echo "—————————————————————————————————————————————————————————————————————————————————————————————"
