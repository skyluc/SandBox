#!/bin/bash

#set -x

PWD_START=${PWD}

LOG_FILE=${HOME}/tmp/extract-scalatest/log.txt
REPO_DIR_ORIG=${HOME}/dev/scala-ide/scalatest.bak
REPO_DIR_DEST=${HOME}/dev/scala-ide/scalatest

# we don't want to see an editor
export EDITOR=/usr/bin/touch

# start from clean state

rm -rf ${REPO_DIR_DEST}

> ${LOG_FILE}

function cherry-pick () {
  git cherry-pick --strategy=recursive-theirs $1 >> ${LOG_FILE}
  if [ $? != 0 ]
  then
    git status
    ADDED=$(git status|grep "deleted by us" | awk '{print $5}')
    git add ${ADDED}
    git cherry-pick --continue
  fi
#  git log -1 | cat
}

mkdir ${REPO_DIR_DEST}
cd ${REPO_DIR_DEST}
git init
touch README.rst
git add README.rst
git commit -m "Initial commit"

git remote add -f bak ${REPO_DIR_ORIG}
git remote add -f upstream git@github.com:scala-ide/scala-ide.git

COMMIT_LIST=$(git log upstream/master..bak/master | grep 'commit' | awk '{print $2}')

for i in ${COMMIT_LIST}
do
  REVERSE_COMMIT_LIST="$i ${REVERSE_COMMIT_LIST}"
done


COUNT=0
for i in ${REVERSE_COMMIT_LIST}
do
  cherry-pick $i
  COUNT=$((COUNT + 1))
done

LOG_COUNT=$(git log | grep 'commit' | wc -l)

echo "applied cherry-pick: $COUNT. log length: $LOG_COUNT"

cd ${PWD_START}
