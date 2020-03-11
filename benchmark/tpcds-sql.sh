#!/bin/bash

PRESTO_CODE=~/code/prestosql
TPCDS_SQL=$PRESTO_CODE/presto-benchto-benchmarks/src/main/resources/sql/presto/tpcds

echo "Replacing database and schema from Presto tpcds SQL."
mkdir tpcds
for SQL in $TPCDS_SQL/*.sql
do
	FILENAME=`basename $SQL`
	cat $SQL | sed 's/${database}/hive/g' | sed 's/${schema}/tpcds_sf1000_orc/g' > tpcds/$FILENAME
done

echo "Replaced SQL to ./tpcds"
