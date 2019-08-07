#!/bin/bash

attempt(){
	if [ $? -eq 1 ]; then
		echo $2
		exit 1
	fi
	echo $1

}

usage(){
echo "usage: $0 remoteuser remoteserver remotefilename dbusername dbname"
}

if [ $# -ne 5 ]
then
	usage
	exit 0
fi

if [ $# -eq 5 ]
then
	dbname=$5
	dbusername=$4
        remotefilename=$3
	remoteserver=$2
	remoteuser=$1

	rm exceptions.csv summary.csv  *ransactio* purchase-rpt    

	./etl0.sh $remoteuser $remoteserver $remotefilename
        attempt "Transfer and unzip file" "transferred and unzipped" 

        awk -f etl1 transaction1
        attempt "Convert Gender" "Gender converted" 

        ./etl1a.sh
        attempt "Cat files transaction2-4 after gender converted and remove them" "Files Concatenated to create transaction5 file in next step" 

        awk -f etl2 transaction5
	attempt "Create filtered_transaction file and exception.csv file" "filtered_transaction and exception files created" 

        awk -f etl3 filtered_transaction > temp
        attempt "Remove $ from purchase amount of filtered_transaction file" "$ removed from filtered_transaction file" 

        ./etl3a.sh
        attempt "Move temp file from previous step back to filtered_transaction file" "temp file moved to filtered_transaction file" 

        ./etl4.sh
        attempt "Sort filtered_transaction file by customerID to create transaction.csv file" "File created transaction.csv sorted by customerID" 

        awk -f etl5 transaction.csv > summary.csv
        attempt "Create the summary.csv file from using the transaction.csv file" "Summary file created"

        ./etl6.sh
        attempt "Sort summary.csv file by state zip lastname firstname" "Summary file sorted"

        awk -f etl7 transaction.csv > transaction-rpt
        attempt "Create the transaction-rpt" "transaction-rpt created"

        awk -f etl8 transaction.csv > purchase-rpt
        attempt "Create the purchase-rpt" "purchse-rpt created"

        ./etl9.sh
        attempt "Create uppercase SUMMARY.CSV and TRANSACTION.CSV" "Files for database created"

	mysqlimport -u $dbusername -p --fields-terminated-by=, --local $dbname SUMMARY.CSV TRANSACTION.CSV
        attempt "Create tables for database with SUMMARY.CSV and TRANSACTION.CSV file" "Database tables created"

	rm SUMMARY.CSV TRANSACTION.CSV
fi
