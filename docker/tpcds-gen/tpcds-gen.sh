#!/bin/bash
#
# Generate TPC-DS data.
# This also creates schema and tables.
#

# Presto CLI call function
sql_exec() {
    /opt/presto-cli --server $PRESTO_SERVER --catalog hive --execute "$1"
}

# Create log dir and file
echo "`date`: Create log dir and file"
mkdir -p /data/generate_data_sf$SCALE
LOG_FILE="/data/generate_data_sf$SCALE/$(date "+%Y-%m-%d_%H:%M:%S").log"
touch $LOG_FILE

# Redirect echo commands to both console and log file
exec 3>&1 1>>$LOG_FILE 2>&1

# Drop previously existing schema
echo "`date`: Dropping existing schema: $SCHEMA" | tee /dev/fd/3
declare TABLES="$(sql_exec "SHOW TABLES FROM tpcds.sf$SCALE;" | sed s/\"//g | tr -d '\r')"
# clean up from any previous runs.
for tab in $TABLES; do
    echo "Dropping table: $tab" | tee /dev/fd/3
    sql_exec "DROP TABLE IF EXISTS $SCHEMA.$tab;"
done
sql_exec "DROP SCHEMA IF EXISTS $SCHEMA;"

# Create schema 
echo "`date`: Creating schema under location: $LOCATION" | tee /dev/fd/3
sql_exec "CREATE SCHEMA $SCHEMA WITH (location = '$LOCATION');"

# Create tables and generate data
echo "`date`: Generating tpcds.sf$SCALE data" | tee /dev/fd/3
START=`date +%s`
for tab in $TABLES; do
    echo "Creating and populating table: $tab"
    START_TABLE=`date +%s`
    sql_exec "CREATE TABLE $SCHEMA.$tab WITH (format = '$FORMAT') AS SELECT * FROM tpcds.sf$SCALE.$tab;"
    END_TABLE=`date +%s`
    RUNTIME_TABLE=$((END_TABLE-START_TABLE))
    echo "`date`: Finished $tab data generation. Time taken: $RUNTIME_TABLE s" | tee /dev/fd/3
done
END=`date +%s`
RUNTIME=$((END-START))
echo "`date`: Finished tpcds.sf$SCALE data generation. Time taken: $RUNTIME s" | tee /dev/fd/3

# Analyse tables
echo "`date`: Analyzing tpcds.sf$SCALE tables" | tee /dev/fd/3
START=`date +%s`
for tab in $TABLES; do
    echo "Analyze $SCHEMA.$tab"  | tee /dev/fd/3
    START_TABLE=`date +%s`
    sql_exec "ANALYZE $SCHEMA.$tab;"
    END_TABLE=`date +%s`
    RUNTIME_TABLE=$((END_TABLE-START_TABLE))
    echo "`date`: Finished $tab analysis. Time taken: $RUNTIME_TABLE s" | tee /dev/fd/3
done
END=`date +%s`
RUNTIME=$((END-START))
echo "`date`: Finished tpcds.sf$SCALE data analysis. Time taken: $RUNTIME s" | tee /dev/fd/3
