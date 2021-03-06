# ----------------------------------------------------------------------------
#
# Package			: reactive-streams
# Version			: 1.0.3
# Source repo		: https://github.com/reactive-streams/reactive-streams-jvm
# Tested on			: RHEL 7.6
# Script License	: Apache License Version 2.0
# Maintainer		: Pratham Murkute <prathamm@us.ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#			  
# ----------------------------------------------------------------------------

#!/bin/bash

# install tools and dependent packages
#yum -y update
yum install -y git wget curl unzip nano vim make build-essential dos2unix
#yum install -y gcc ant

# setup java environment
yum install -y java java-devel
which java
ls /usr/lib/jvm/
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-ibm-1.8.0.6.5-1jpp.1.el7.ppc64le
# update the path env. variable 
export PATH=$PATH:$JAVA_HOME/bin

# install gradle 
GRADLE_VERSION=6.2.2
wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip
mkdir -p usr/local/gradle
unzip -d /usr/local/gradle gradle-$GRADLE_VERSION-bin.zip
ls usr/local/gradle/gradle-$GRADLE_VERSION/
rm gradle-$GRADLE_VERSION-bin.zip
export GRADLE_HOME=/usr/local/gradle
# update the path env. variable 
export PATH=$PATH:$GRADLE_HOME/gradle-$GRADLE_VERSION/bin

# create folder for saving logs 
mkdir -p /logs

# variables
PKG_NAME="reactive-streams"
PKG_VERSION=1.0.2
PKG_VERSION_LATEST=1.0.3
LOGS_DIRECTORY=/logs
LOCAL_DIRECTORY=/root
REPOSITORY="https://github.com/reactive-streams/reactive-streams-jvm.git"

# install java 11
yum install -y java-11-openjdk java-11-openjdk-devel
rm /etc/alternatives/java
ln -s /usr/lib/jvm/java-11-openjdk-11.0.6.10-1.el7_7.ppc64le/bin/java /etc/alternatives/java
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.6.10-1.el7_7.ppc64le
java -version

# clone, build and test latest version
cd $LOCAL_DIRECTORY
git clone $REPOSITORY $PKG_NAME-$PKG_VERSION_LATEST
cd $PKG_NAME-$PKG_VERSION_LATEST/
git checkout -b $PKG_VERSION_LATEST tags/v$PKG_VERSION_LATEST
./gradlew build | tee $LOGS_DIRECTORY/$PKG_NAME-$PKG_VERSION_LATEST.txt

# clone, build and test master
#cd $LOCAL_DIRECTORY
#git clone $REPOSITORY $PKG_NAME-master
#cd $PKG_NAME-master/
#./gradlew build | tee $LOGS_DIRECTORY/$PKG_NAME.txt

# fallback to default java version
#rm /etc/alternatives/java
#ln -s /usr/lib/jvm/java-1.8.0-ibm-1.8.0.6.5-1jpp.1.el7.ppc64le/jre/bin/java /etc/alternatives/java
#export JAVA_HOME=/usr/lib/jvm/java-1.8.0-ibm-1.8.0.6.5-1jpp.1.el7.ppc64le
#java -version
