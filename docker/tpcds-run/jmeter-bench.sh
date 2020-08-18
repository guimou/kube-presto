#!/bin/sh

# Create log dir and file
echo "`date`: Create log dir and file"
mkdir -p /data/run_benchmark_sf$SCALE
LOG_FILE="/data/run_benchmark_sf$SCALE/$(date "+%Y-%m-%d_%H:%M:%S").log"
touch $LOG_FILE

# Redirect echo commands to both console and log file
exec 3>&1 1>>$LOG_FILE 2>&1

# Run jmeter CLI
REPORT_DIR="/data/reports/sf$SCALE/$(date "+%Y-%m-%d_%H:%M:%S")"
mkdir -p $REPORT_DIR

echo "Start JMeter test, report output to: $REPORT_DIR" | tee /dev/fd/3
START=`date +%s`
JAVA_HOME=$JAVA_HOME $JMETER_HOME/bin/jmeter \
	-JdbUrl=jdbc:presto://$PRESTO_SERVER/hive/tpcds_sf${SCALE}_${FORMAT}
	-n -t jmeter-tpcds.jmx \
	-l $REPORT_DIR/tpcds-log.jtl \
	-e -o $REPORT_DIR
END=`date +%s`
RUNTIME=$((END-START))
echo "`date`: Finished tpcds.sf$SCALE benchmark. Time taken: $RUNTIME s" | tee /dev/fd/3

