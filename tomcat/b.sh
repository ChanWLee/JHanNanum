#!/bin/sh -e
javac -cp WEB-INF/lib/jhannanum.jar:WEB-INF/lib/json_simple-1.1.jar:WEB-INF/lib/resources.jar \
  -d classes \
  src/kr/co/websync/safeschool/hn.java
cd classes
jar cf ../WEB-INF/lib/hn.jar *
