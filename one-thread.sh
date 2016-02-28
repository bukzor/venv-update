#!/bin/bash
set -eu
SEQ="$1"
DEMO=$LOGS/$SEQ
mkdir -p $DEMO
cd $DEMO

echo $DEMO

EXECNET_DEBUG=2 \
    COVERAGE_FILE=$DEMO/cov \
    COVERAGE_DEBUG=config,sys,trace,pid,dataio,dataop,callers,plugin \
    COVERAGE_PROCESS_START=$TOP/.coveragerc \
    py.test -vv -n1 $TOP/one_test.py \
    > test.log 2>&1

for cov in cov.*; do
    export COVERAGE_FILE=$cov
    if coverage report --fail-under 100 $TOP/one_test.py > ${COVERAGE_FILE}.report; then
        exit 0
    fi
done

echo "

====================================================================================
FAILED: $DEMO
====================================================================================

" | tee failure
exit 255
