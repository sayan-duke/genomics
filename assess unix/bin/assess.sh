#!/bin/sh

#
# Universal program loader.
# Based on Apache ANT script.
#

# change this to increase/decrease heap size
JAVA_OPTS="-mx512M"


## DO NOT EDIT BELOW HERE
###############################################################
cygwin=false;
darwin=false;
case "`uname`" in
    Darwin*) 
	darwin=true
	if [ -z "$JAVA_HOME" ] ; then
	    JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
	fi
	;;
    CYGWIN*) 
	cygwin=true 
	;;
esac

## Try to find our home directory 
command="$0"
progname=`basename "$0"`
# need this for relative symlinks
while [ -h "$command" ] ; do
    ls=`ls -ld "$command"`
    link=`expr "$command" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
	command="$link"
    else
	command=`dirname "$command"`"/$link"
    fi
done

ASSESS_BIN=`dirname "$command"`
ASSESS_BIN=`cd "$ASSESS_BIN" && pwd`

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
    [ -n "$ASSESS_BIN" ] && ASSESS_BIN=`cygpath --unix "$ASSESS_BIN"`
    [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
fi

ASSESS_HOME=`cd "$ASSESS_BIN/.." && pwd`
LIB="$ASSESS_HOME/lib"


if [ -z "$JAVACMD" ] ; then
  if [ -n "$JAVA_HOME"  ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD="$JAVA_HOME/jre/sh/java"
    else
      JAVACMD="$JAVA_HOME/bin/java"
    fi
  else
    JAVACMD=`which java 2> /dev/null `
    if [ -z "$JAVACMD" ] ; then
        JAVACMD=java
    fi
  fi
fi

if [ ! -x "$JAVACMD" ] ; then
  echo "Warning: JAVA_HOME is not defined correctly."
  $JAVACMD = "java"
fi

CLASSPATH=""

# Add user-specified classpath. 
CLASSPATH=$LIB/commons-math-1.1.jar:$LIB/gsea-lib.jar:$LIB/javax.servlet.jar:$LIB/assess.jar

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
    JAVA_HOME=`cygpath --windows "$JAVA_HOME"`
    LOCALCLASSPATH=`cygpath --path --windows "$LOCALCLASSPATH"`
    CYGHOME=`cygpath --windows "$HOME"`
fi

if [ "$1" = "--jdb" ] ; then
   JAVAOPTS="-ea -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005 $PXE_JAVAOPTS"
   shift
fi

exec  "$JAVACMD" $JAVA_OPTS -cp $CLASSPATH xapps.gsea.Main &