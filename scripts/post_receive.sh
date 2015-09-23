#!/bin/bash

# Setting up script variables
WEB_ROOT="$HOME/www"
APP_NAME="reactstart"

APP_ROOT=$WEB_ROOT/apps
TEMP_ROOT=$WEB_ROOT/temp
REPO_ROOT=$WEB_ROOT/repos
SHARED_ROOT=$WEB_ROOT/shared

APP_DIR=$APP_ROOT/$APP_NAME
TEMP_DIR=$TEMP_ROOT/$APP_NAME
REPO_DIR=$REPO_ROOT/$APP_NAME
SHARED_DIR=$SHARED_ROOT/$APP_NAME

echo "Running deploy script ..."

# Clone the repo in the temp dir
cd $TEMP_ROOT
echo "Cloning $REPO_DIR in $TEMP_DIR"
git clone $REPO_DIR $APP_NAME

# Install project dependencies on the cloned dir
cd $TEMP_DIR
echo "Setting node version"
# If we have nvm we should set the required node version here
echo "Installing npm dependencies"
npm install
echo "Installing bower dependencies"
bower install

# Create symlinks to data and images folders
# Before we create the symlinks we must make sure that data is copied over into the
# /shared/boilerplate/data & /shared/boilerplate/images folders, so we don't loose it by accident
# Also, make sure /upload/data and /upload/images are added in .gitignore - we do not want
# user data to end up in our git repo
echo "Linking user images and data"
ln -s $SHARED_DIR/images $TEMP_DIR/upload/images
ln -s $SHARED_DIR/data $TEMP_DIR/upload/data

# Turn off pm2 for this project
echo "Turning off the pm2 application"
pm2 stop $APP_NAME

# Move the temp bits & built stuff to our project in /apps and delete old files
echo "Deleting the old application"
rm -rf $APP_DIR
echo "Moving the new application"
mv $TEMP_DIR $APP_ROOT

echo "Refresh post-recieve git hook & permissions"
cd $REPO_DIR/hooks
chmod ug+x post-receive

# Turn pm2 back on for this site
echo "Starting the pm2 application"
cd $APP_DIR && pm2 start $APP_DIR/pm2_start.json

echo "All done! Please check your app."
