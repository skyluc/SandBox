#!/bin/bash

set -x

ROOT_DIR=$(dirname $0)
cd ${ROOT_DIR}
ROOT_DIR=${PWD}

COMPOSITE_DIR=/xdata/dev/scala-ide/test-plugins/composite

# clean
rm -r ${ROOT_DIR}/target

# scala IDE - 1

cd ${ROOT_DIR}/scala-ide
SET_VERSION=true ./build-all.sh -Dversion.tag=m2 -Dmaven.test.skip=true clean install

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

# ecosystem-base - 1 (s1)

cd ${COMPOSITE_DIR}
mvn  -Drepo.source=${ROOT_DIR}/scala-ide/org.scala-ide.sdt.update-site/target/site -Drepo.dest=${ROOT_DIR}/target/ecosystem-base-1 prepare-package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/target/ecosystem-base-1 ${ROOT_DIR}/target/ecosystem-base

# ecosystem - 1 (s1)

# Duplicate, to seed the ecosystem
cp -r ${ROOT_DIR}/target/ecosystem-base-1 ${ROOT_DIR}/target/ecosystem-1
cp -r ${ROOT_DIR}/target/ecosystem-1 ${ROOT_DIR}/target/ecosystem

# worksheet - 1

cd ${ROOT_DIR}/scala-worksheet
mvn --non-recursive -Pset-versions -Dtycho.mode=maven -Drepo.scala-ide=file:///home/luc/tmp/build-ecosystem/target/ecosystem-base exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn -Drepo.scala-ide=file:///home/luc/tmp/build-ecosystem/target/ecosystem-base -Dversion.tag=w1 clean package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/scala-worksheet/org.scalaide.worksheet.update-site/target/site ${ROOT_DIR}/target/worksheet-1
cp -r ${ROOT_DIR}/target/worksheet-1 ${ROOT_DIR}/target/worksheet

# ecosystem - 2 (s1,w1)

cd ${ROOT_DIR}/ecosystem
mvn exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cd ${ROOT_DIR}/ecosystem/target/builds
mvn clean package -Pbuild

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn clean package -Ppackage

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/ecosystem/target/builds/dev21-scala29/target/site ${ROOT_DIR}/target/ecosystem-2
rm -rf ${ROOT_DIR}/target/ecosystem
cp -r ${ROOT_DIR}/target/ecosystem-2 ${ROOT_DIR}/target/ecosystem

# product - 1

cd ${ROOT_DIR}/scala-ide-product
mvn clean package -Drepo.scala-ide.ecosystem=file://${ROOT_DIR}/target/ecosystem

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

# ecosystem-base - 2 (s1, p1)
cd ${COMPOSITE_DIR}
mvn -Drepo.source=${ROOT_DIR}/scala-ide-product/org.scala-ide.product/target/repository -Drepo.dest=${ROOT_DIR}/target/ecosystem-base-2 prepare-package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn -Drepo.source=${ROOT_DIR}/target/ecosystem-base -Drepo.dest=${ROOT_DIR}/target/ecosystem-base-2 prepare-package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

rm -rf ${ROOT_DIR}/target/ecosystem-base
cp -r ${ROOT_DIR}/target/ecosystem-base-2 ${ROOT_DIR}/target/ecosystem-base

# ecosystem - 3 (s1,p1,w1)

cd ${ROOT_DIR}/ecosystem
mvn exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cd ${ROOT_DIR}/ecosystem/target/builds
mvn clean package -Pbuild

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn clean package -Ppackage

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/ecosystem/target/builds/dev21-scala29/target/site ${ROOT_DIR}/target/ecosystem-3
rm -rf ${ROOT_DIR}/target/ecosystem
cp -r ${ROOT_DIR}/target/ecosystem-3 ${ROOT_DIR}/target/ecosystem

# scala IDE - 2

cd ${ROOT_DIR}/scala-ide
SET_VERSION=true ./build-all.sh -Dversion.tag=m3 -Dmaven.test.skip=true clean install

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

# ecosystem-base - 3 (s1, s2, p1)
cd ${COMPOSITE_DIR}
mvn -Drepo.source=${ROOT_DIR}/scala-ide/org.scala-ide.sdt.update-site/target/site -Drepo.dest=${ROOT_DIR}/target/ecosystem-base-3 prepare-package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn -Drepo.source=${ROOT_DIR}/target/ecosystem-base -Drepo.dest=${ROOT_DIR}/target/ecosystem-base-3 prepare-package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

rm -rf ${ROOT_DIR}/target/ecosystem-base
cp -r ${ROOT_DIR}/target/ecosystem-base-3 ${ROOT_DIR}/target/ecosystem-base

# ecosystem - 4 (s1,s2,p1,w1)

cd ${ROOT_DIR}/ecosystem
mvn exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cd ${ROOT_DIR}/ecosystem/target/builds
mvn clean package -Pbuild

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn clean package -Ppackage

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/ecosystem/target/builds/dev21-scala29/target/site ${ROOT_DIR}/target/ecosystem-4
rm -rf ${ROOT_DIR}/target/ecosystem
cp -r ${ROOT_DIR}/target/ecosystem-4 ${ROOT_DIR}/target/ecosystem

# worksheet - 2 (s2)

cd ${ROOT_DIR}/scala-worksheet
mvn --non-recursive -Pset-versions -Dtycho.mode=maven -Drepo.scala-ide=file://${ROOT_DIR}/target/ecosystem-base exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn -Dversion.tag=w1 -Drepo.scala-ide=file://${ROOT_DIR}/target/ecosystem-base clean package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/scala-worksheet/org.scalaide.worksheet.update-site/target/site ${ROOT_DIR}/target/worksheet-2
rm -rf ${ROOT_DIR}/target/worksheet
cp -r ${ROOT_DIR}/target/worksheet-2 ${ROOT_DIR}/target/worksheet

# ecosystem - 5 (s1,s2,p1,w1,w1)

cd ${ROOT_DIR}/ecosystem
mvn exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cd ${ROOT_DIR}/ecosystem/target/builds
mvn clean package -Pbuild

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn clean package -Ppackage

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/ecosystem/target/builds/dev21-scala29/target/site ${ROOT_DIR}/target/ecosystem-5
rm -rf ${ROOT_DIR}/target/ecosystem
cp -r ${ROOT_DIR}/target/ecosystem-5 ${ROOT_DIR}/target/ecosystem

# worksheet - 3 (s2)

cd ${ROOT_DIR}/scala-worksheet
mvn --non-recursive -Pset-versions -Dtycho.mode=maven -Drepo.scala-ide=file://${ROOT_DIR}/target/ecosystem-base exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn -Dversion.tag=w2 -Drepo.scala-ide=file://${ROOT_DIR}/target/ecosystem-base clean package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/scala-worksheet/org.scalaide.worksheet.update-site/target/site ${ROOT_DIR}/target/worksheet-3
rm -rf ${ROOT_DIR}/target/worksheet
cp -r ${ROOT_DIR}/target/worksheet-3 ${ROOT_DIR}/target/worksheet

# ecosystem - 6 (s1,s2,p1,w1,w2)

cd ${ROOT_DIR}/ecosystem
mvn exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cd ${ROOT_DIR}/ecosystem/target/builds
mvn clean package -Pbuild

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn clean package -Ppackage

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/ecosystem/target/builds/dev21-scala29/target/site ${ROOT_DIR}/target/ecosystem-6
rm -rf ${ROOT_DIR}/target/ecosystem
cp -r ${ROOT_DIR}/target/ecosystem-6 ${ROOT_DIR}/target/ecosystem

# worksheet - 4 (s2)

cd ${ROOT_DIR}/scala-worksheet
mvn --non-recursive -Pset-versions -Dtycho.mode=maven -Drepo.scala-ide=file://${ROOT_DIR}/target/ecosystem-base exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn -Dversion.tag=w3 -Drepo.scala-ide=file://${ROOT_DIR}/target/ecosystem-base clean package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/scala-worksheet/org.scalaide.worksheet.update-site/target/site ${ROOT_DIR}/target/worksheet-4
rm -rf ${ROOT_DIR}/target/worksheet
cp -r ${ROOT_DIR}/target/worksheet-4 ${ROOT_DIR}/target/worksheet

# ecosystem - 5 (s1,s2,p1,w1,w3)

cd ${ROOT_DIR}/ecosystem
mvn exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cd ${ROOT_DIR}/ecosystem/target/builds
mvn clean package -Pbuild

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn clean package -Ppackage

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/ecosystem/target/builds/dev21-scala29/target/site ${ROOT_DIR}/target/ecosystem-6
rm -rf ${ROOT_DIR}/target/ecosystem
cp -r ${ROOT_DIR}/target/ecosystem-6 ${ROOT_DIR}/target/ecosystem

# product - 2

cd ${ROOT_DIR}/scala-ide-product
mvn clean package -Drepo.scala-ide.ecosystem=file://${ROOT_DIR}/target/ecosystem

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

# ecosystem-base - 4 (s1, s2, p1, p2)
cd ${COMPOSITE_DIR}
mvn -Drepo.source=${ROOT_DIR}/scala-ide-product/org.scala-ide.product/target/repository -Drepo.dest=${ROOT_DIR}/target/ecosystem-base-4 prepare-package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn -Drepo.source=${ROOT_DIR}/target/ecosystem-base -Drepo.dest=${ROOT_DIR}/target/ecosystem-base-4 prepare-package

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

rm -rf ${ROOT_DIR}/target/ecosystem-base
cp -r ${ROOT_DIR}/target/ecosystem-base-4 ${ROOT_DIR}/target/ecosystem-base

# ecosystem - 7 (s1, s2, p1, p2, w1, w3)

cd ${ROOT_DIR}/ecosystem
mvn exec:java

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cd ${ROOT_DIR}/ecosystem/target/builds
mvn clean package -Pbuild

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

mvn clean package -Ppackage

RES=$?
if [ ${RES} != 0 ]
then
  exit ${RES}
fi

cp -r ${ROOT_DIR}/ecosystem/target/builds/dev21-scala29/target/site ${ROOT_DIR}/target/ecosystem-7
rm -rf ${ROOT_DIR}/target/ecosystem
cp -r ${ROOT_DIR}/target/ecosystem-7 ${ROOT_DIR}/target/ecosystem


