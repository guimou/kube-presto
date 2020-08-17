#!/bin/bash
#
# Generate TPCDS table DDL, point to external location.
#

sql_exec() {
    /opt/presto-cli --server $PRESTO_SERVER --catalog hive --execute "$1"
}

# clean up from any previous runs.
rm -rf /data/tpcds-ddl/sf$SCALE
mkdir /data/tpcds-ddl/sf$SCALE

# Retrieve table schema
declare TABLES="$(sql_exec "SHOW TABLES FROM tpcds.sf$SCALE;" | sed s/\"//g | tr -d '\r')"

echo "Generate table DDL"
for TABLE in $TABLES; do
    echo $TABLE
    sql_exec "SHOW CREATE TABLE tpcds.sf$SCALE.$TABLE;" | sed s/\"//g | sed s/tpcds/hive/g | sed s/sf$SCALE/$SCHEMA/g > /data/tpcds-ddl/sf$SCALE/$TABLE.sql
    echo "WITH (format = 'PARQUET', external_location = '$LOCATION/$TABLE')" >> /data/tpcds-ddl/sf$SCALE/$TABLE.sql
done

# Create schema 
echo "Generate schema DDL"
echo "CREATE SCHEMA $SCHEMA WITH (location = '$LOCATION');" > /data/tpcds-ddl/sf$SCALE/create-schema.sql
