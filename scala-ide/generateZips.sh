#!/bin/bash -xe

WITH_VERSION_IN_NAME=false
case $1 in
  --with-version-in-name )
    WITH_VERSION_IN_NAME=true
    shift    
  ;;
esac

VERSION=$1
DEST_FOLDER=$2

function genLibrary () {
  cd scala-library
  cat > library.properties << EOF
# To test library with a 2.10.x version number

version.number=${VERSION}
copyright.string=Copyright 2002-2011, LAMP/EPFL
EOF

  local JAR_NANE=""
  if $WITH_VERSION_IN_NAME
  then
    JAR_NAME="scala-library_${VERSION}.jar"
  else
    JAR_NAME="scala-library.jar"
  fi

  zip -r ${JAR_NAME} library.properties META-INF/ scala/

  cp ${JAR_NAME} ${DEST_FOLDER}

  cd ..
}

function gen () {
  ID=$1

  mkdir -p scala-${ID}
  cd scala-${ID}
  cat > ${ID}.properties << EOF
version.number=${VERSION}
EOF

  local JAR_NANE=""
  if $WITH_VERSION_IN_NAME
  then
    JAR_NAME="scala-${ID}_${VERSION}.jar"
  else
    JAR_NAME="scala-${ID}.jar"
  fi

  zip ${JAR_NAME} ${ID}.properties

  cp ${JAR_NAME} ${DEST_FOLDER}

  cd ..
}

mkdir -p ${DEST_FOLDER}

genLibrary
gen compiler
gen reflect
gen swing
gen actor

