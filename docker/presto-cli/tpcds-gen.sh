#!/bin/bash
#
# Generate TPC-DS data.
# This also creates schema and tables.
#

sql_exec() {
    /opt/presto-cli --server $PRESTO_SERVER --catalog hive --execute "$1"
}

echo "`date`: Drop existing schema: $SCHEMA"
declare TABLES="$(sql_exec "SHOW TABLES FROM tpcds.sf$SCALE;" | sed s/\"//g | tr -d '\r')"
# clean up from any previous runs.
for tab in $TABLES; do
    echo $tab
    sql_exec "DROP TABLE IF EXISTS $SCHEMA.$tab;"
done
sql_exec "DROP SCHEMA IF EXISTS $SCHEMA;"

# Create schema 
LOCATION="s3a://deephub/warehouse/$SCHEMA.db/"
echo "`date`: Create schema under location: $LOCATION"
sql_exec "CREATE SCHEMA $SCHEMA WITH (location = '$LOCATION');"

# Create tables, generate data
echo "`date`: Generating tpcds.sf$SCALE data..."

START=`date +%s`
for tab in $TABLES; do
    sql_exec "CREATE TABLE $SCHEMA.$tab WITH (format = 'PARQUET') AS SELECT * FROM tpcds.sf$SCALE.$tab;"
done

END=`date +%s`
RUNTIME=$((END-START))
echo "`date`: Finished tpcds.sf$SCALE data generation. Time taken: $RUNTIME s"
echo "`date`: Finished tpcds.sf$SCALE data generation. Time taken: $RUNTIME s" > /data/generate_data_sf$SCALE

