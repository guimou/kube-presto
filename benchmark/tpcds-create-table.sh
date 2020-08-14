#!/bin/bash
#
# Create TPC-DS schema and tables in Presto.
#

sql_exec() {
    /opt/presto-cli --server $PRESTO_SERVER --catalog hive --execute "$1"
}

echo "Drop existing schema: $SCHEMA"
declare TABLES="$(sql_exec "SHOW TABLES FROM tpcds.sf1000;" | sed s/\"//g | tr -d '\r')"
# clean up from any previous runs.
for tab in $TABLES; do
    echo "Drop $tab"
    sql_exec "DROP TABLE IF EXISTS $SCHEMA.$tab;"
done
sql_exec "DROP SCHEMA IF EXISTS $SCHEMA;"

# Create schema and tables
echo "Create schema and tables"
sql_exec "`cat tpcds-ddl/create-schema.sql`"

for SQL in tpcds-ddl/*.sql
do
	FILENAME=`basename $SQL`
	if [ "$FILENAME" == "create-schema.sql" ]; then
		continue
	fi
	tab=`echo $FILENAME | cut -d "." -f 1`
	echo "Create table $tab"
	sql_exec "`cat $SQL`"
done
