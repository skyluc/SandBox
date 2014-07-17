#!/bin/bash -xe
#####
#
#####
# $1 result file
# $2 partern to exclude. '/' chars have to be escaped: '\/'
#####

RESULT_FILE="$1"
EXCL_PATTERN="$2"

# clear the file
echo -n "" > ${RESULT_FILE}

for CLASSFILE in $(find . -name '*.class')
do
  # for each .class file in the hierarchy
  CLASSNAME=${CLASSFILE#*classes/}
  CLASSNAME=${CLASSNAME%.class}
  CLASSNAME=${CLASSNAME//\//.}

  # extract binary references
  javap -v ${CLASSFILE} | grep '= \(Methodref\|Class\)' | awk "/org\/scalaide\// && !/${EXCL_PATTERN}/ {print \$6\" ${CLASSNAME}\"}" >> ${RESULT_FILE}
done
