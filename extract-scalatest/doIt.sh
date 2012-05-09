#!/bin/bash

set -x

PWD_START=${PWD}

LOG_FILE=${HOME}/tmp/extract-scalatest/log.txt
REPO_DIR=${HOME}/dev/scala-ide/scalatest

# start from clean state

rm -rf ${REPO_DIR} ${REPO_DIR}.tmp
cp -r ${REPO_DIR}.bak ${REPO_DIR}.tmp
cd ${REPO_DIR}.tmp

> ${LOG_FILE}

git remote rm origin >> ${LOG_FILE}

git tag -l | xargs git tag -d >> ${LOG_FILE}

# generate index-filter command

TO_DELETE="eclipse-director.sh org.scala-ide.sbt.full.library org.scala-ide.sdt.core.tests org.scala-ide.sdt.update-site org.scala-ide.scala.compiler org.scala-ide.sdt.debug org.scala-ide.sdt.weaving.feature org.scala-ide org.scala-ide.scala.library org.scala-ide.sdt.debug.tests README.md org.scala-ide.build org.scala-ide.sdt.aspects org.scala-ide.sdt.feature update-scala.sh org.scala-ide.build-toolchain  org.scala-ide.sdt.core org.scala-ide.sdt.source.feature"

TO_KEEP="LICENSE org.scala-ide.sdt.scalatest org.scala-ide.sdt.scalatest.tests"

# marking everything to delete (and failing)

INDEX_FILTER_CMD=""

for i in ${TO_DELETE}
do
  if [ -n "${INDEX_FILTER_CMD}" ]
  then
    INDEX_FILTER_CMD="${INDEX_FILTER_CMD};"
  fi
  INDEX_FILTER_CMD="${INDEX_FILTER_CMD} git rm -r -f --cached --ignore-unmatch ${i}"
done

#INDEX_FILTER_CMD="git rm -r -f --cached --ignore-unmatch"
#
#for i in ${TO_KEEP}
#do
#  INDEX_FILTER_CMD="${INDEX_FILTER_CMD} !(${i})"
#done

git filter-branch --tag-name-filter cat --prune-empty --index-filter "$INDEX_FILTER_CMD" -- --all  >> ${LOG_FILE}

git clone file://${REPO_DIR}.tmp ${REPO_DIR} >> ${LOG_FILE}
cd ${REPO_DIR}

git reset --hard >> ${LOG_FILE}
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d >> ${LOG_FILE}
git reflog expire --expire=now --all >> ${LOG_FILE}
git repack -ad >> ${LOG_FILE}
git gc --aggressive --prune=now >> ${LOG_FILE}

cd ${PWD_START}
