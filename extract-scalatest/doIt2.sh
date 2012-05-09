#!/bin/bash

set -x

PWD_START=${PWD}

LOG_FILE=${HOME}/tmp/extract-scalatest/log.txt
REPO_DIR=${HOME}/dev/scala-ide/scalatest

# start from clean state

rm -rf ${REPO_DIR} ${REPO_DIR}.tmp ${REPO_DIR}.1 ${REPO_DIR}.2
#cp -r ${REPO_DIR}.bak ${REPO_DIR}.tmp
#cd ${REPO_DIR}.tmp

> ${LOG_FILE}

function extract () {
  cp -r ${REPO_DIR}.bak ${REPO_DIR}.$1
  cd ${REPO_DIR}.$1
  git remote rm origin
  git tag -l | xargs git tag -d
  git filter-branch --tag-name-filter cat --prune-empty --subdirectory-filter $2 HEAD
  git reset --hard
  git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d
  git reflog expire --expire=now --all
  git gc --aggressive --prune=now
}

extract 1 org.scala-ide.sdt.scalatest
extract 2 org.scala-ide.sdt.scalatest.tests

mkdir ${REPO_DIR}
cd ${REPO_DIR}
git init
touch README.rst
git add README.rst
git commit -m "README commit"

function merge () {
  git remote add -f p$1 ${REPO_DIR}.$1
  git merge -s ours --no-commit p$1/master
  git read-tree --prefix=$2/ -u p$1/master
  git commit -m "merged $2"
}

merge 1 org.scala-ide.sdt.scalatest
merge 2 org.scala-ide.sdt.scalatest.tests

cd ${PWD_START}
