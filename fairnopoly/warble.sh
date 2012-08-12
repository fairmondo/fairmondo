#!/bin/bash

echo ""
echo " ##############################################################"
echo " # WAR Generation of Fairnopoly                               #"
echo " #                                                            #"
echo " # NOTE: This script must be run from the Rails project root. #"
echo " #                                                            #"
echo " ##############################################################"
echo ""
read -p "Press [ENTER] to continue..." i

echo "INFO: [x] set JRUBY_OPTS to 1.9"
JRUBY_OPTS=--1.9

echo "INFO: [x] export JRUBY_OPTS"
export JRUBY_OPTS

#if [ "$TOMCAT_HOME" = "" ]; then
#  TOMCAT_HOME="/opt/tomcat"
#fi

#export MY_PROJECT_COMPILE=true

#echo "INFO: [x] TOMCAT_HOME is ${TOMCAT_HOME}."

echo "INFO: [x] Cleaning local WAR files."
jruby -S rake war:clean

#echo "INFO: [x] Deleting old *.class files."
#find . -type f -name *.class -print0 | xargs -0 rm

echo "INFO: [x] Generating new WAR for Fairnopoly"
jruby -S rake war

# no longer compiling, so deactivate this flag
#export MY_PROJECT_COMPILE=""

# necessary evil
#echo "INFO: [x] Removing old WAR deployment and shutting down Tomcat."
#./script/my_project/war-undeploy
#$TOMCAT_HOME/bin/shutdown.sh

#echo "INFO: [x] Copying new WAR to Tomcat in ${TOMCAT_HOME}/webapps/"
#cp my_project.war $TOMCAT_HOME/webapps/

#echo "INFO: [x] Starting Tomcat."
#$TOMCAT_HOME/bin/startup.sh
