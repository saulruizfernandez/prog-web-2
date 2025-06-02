#!/bin/bash
SRC_DIR="./servlet-web-2/WEB-INF/classes"
BUILD_DIR="./servlet-web-2/WEB-INF/classes"
TOMCAT_LIB="/opt/tomcat/lib/servlet-api.jar"
DEPLOY_DIR="/opt/tomcat/webapps/servlet-web-2"
LOCAL_DEPLOY_DIR="./servlet-web-2"

echo "Compiling files .java..."
find "$SRC_DIR" -name "*.java" -print0 | xargs -0 javac -cp "$TOMCAT_LIB" -d "$BUILD_DIR"

echo "Deploying app in Tomcat..."
rm -rf "$DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"
cp -r "$LOCAL_DEPLOY_DIR"/* "$DEPLOY_DIR"

echo "Restarting Tomcat..."
sudo systemctl restart tomcat

echo "Deployment finished. Visit app in http://localhost:8080/servlet-web-2/servlet/HelloWorld"