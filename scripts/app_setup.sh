#!/bin/bash

# Setting up script variables
WEB_ROOT="$HOME/www"
APP_NAME="reactstart"
REMOTE="https://github.com/v3rt1go/reactfundamental.git"

APP_ROOT=$WEB_ROOT/apps
TEMP_ROOT=$WEB_ROOT/temp
REPO_ROOT=$WEB_ROOT/repos
SHARED_ROOT=$WEB_ROOT/shared

APP_DIR=$APP_ROOT/$APP_NAME         # ~/www/apps/boilerplate
TEMP_DIR=$TEMP_ROOT/$APP_NAME       # ~/www/temp/boilerplate
REPO_DIR=$REPO_ROOT/$APP_NAME       # ~/www/repos/boilerplate
SHARED_DIR=$SHARED_ROOT/$APP_NAME   # ~/www/shared/boilerplate

echo "Running app server setup script ..."
# Create a dir for holding the apps
mkdir -p $APP_DIR
# Create a dir for git repo receives
mkdir -p $REPO_DIR
# Create a temp dir for holding live pushes
mkdir -p $TEMP_DIR
# Create images and data shared dirs for user uploaded content
mkdir -p $SHARED_DIR/images
mkdir -p $SHARED_DIR/data

# Create a bare git repo for this apps
# A bare repo means it will use that folder for the git repo instead of the usual
# .git folder. Usually when we say git init it will create the .git folder and put
# the contents of this folder there. With a bare repo we are basicly saying we're
# going to use this folder as the git repo.
echo "Initiating bare git repo in $REPO_DIR for $APP_NAME ..."
git init --bare $REPO_DIR

# Check out the hooks directory - the symlinks
# Create with vim post-recieve the script and add #!/bin/bash at the first line and echo "Hi Alex" on the second line
# Give x permissions to the file with chmod +x post-recieve
# From the project folder (~/Projects/boilerplate) add a git remote to /www/repos/boilerplate
# git remote add deploy /home/v3rt1go/www/repos/boilerplate
# add and commit the changes
# git push deploy master ---- we should see remote: Hi Alex in the output

echo "Fetching files from $REMOTE to $APP_DIR ..."
git clone $REMOTE $APP_DIR

echo "Setting up deploy hooks ..."
# Create a symlink between our own post_receive.sh script and the git post-receive hook from the repo
# We shouldn't need to do this step on a real server deploy
# ln -s ~/Projects/boilerplate/scripts/post_receive.sh ~/www/repos/boilerplate/hooks/post-receive
ln -s $APP_DIR/scripts/post_receive.sh $REPO_DIR/hooks/post-receive
# Make the link executable
chmod +x $REPO_DIR/hooks/post-receive

echo "App server setup done!"
