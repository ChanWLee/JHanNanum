#!/bin/sh -x -e
classes=/tmp/$$/classes
target=$PWD/tomcat/WEB-INF/lib/hn.jar

mkdir -p $classes

javac -Xlint:unchecked -cp tomcat/WEB-INF/lib/jhannanum.jar:tomcat/WEB-INF/lib/json-simple-1.1.1.jar:tomcat/WEB-INF/lib/resources.jar \
  -d $classes \
  tomcat/src/kr/co/websync/safeschool/hn.java
cd $classes
jar cf $target *
