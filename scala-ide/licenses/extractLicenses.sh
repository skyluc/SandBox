#!/bin/bash -ex

BASE_DIR=$(pwd)

for i in eclipse/plugins/*.jar
do
  cd $BASE_DIR/tmp
  rm -rf *
  unzip -qo ../$i

  
  MAX=0
  FOUND=""

  IDL="${i%.jar}"
  ID="${IDL##*/}"

  if [ -f $BASE_DIR/tmp/about.html ]
  then
    sed -i 's%<[pP]>.*[0-9][0-9][0-9][0-9]</[pP]>%<p></p>%' $BASE_DIR/tmp/about.html
    for j in $BASE_DIR/licenses/*
    do
      RES=$(diff -q $BASE_DIR/tmp/about.html $j/about.html > /dev/null 2>&1; echo $?)
      if [ $RES == 0 ]
      then
        FOUND=$j
        break
      fi

      NEW_MAX="${j##*/}"
      if [ $NEW_MAX -gt $MAX ]
      then
        MAX="$NEW_MAX"
      fi
    done

    if [ -n "$FOUND" ]
    then
      touch $FOUND/${ID}
    else
      NEW_FOLDER="$BASE_DIR/licenses/$((MAX + 1))"
      mkdir $NEW_FOLDER
      cp $BASE_DIR/tmp/about.html $NEW_FOLDER/about.html
      touch $NEW_FOLDER/${ID}
    fi
  else
    touch $BASE_DIR/nolicense/${ID}
  fi

done
