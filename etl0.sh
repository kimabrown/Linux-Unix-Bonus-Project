#!/bin/bash
#Kima Brown
#Final Project
#etl.sh      

host=$2
#host="161.31.72.29"

file=$3
#file="/fall2018/MOCK_MIX_v2.1.csv.bz2"

user=$1

# 1 - Transfer file MOCK_MIX_v2.1.csv.bz2 naming it transaction
echo "Transfer file MOCK_MIX_v2.1.csv.bz2 naming it transaction"
echo "scp $user@$host:$file ."
scp $user@$host:$file .
mv MOCK_MIX_v2.1.csv.bz2 transaction.bz2

# 2 - Unzip the transaction file
echo "Unzip the transaction file"
bzip2 -dk transaction.bz2

# 3 - Remove header record from the file
echo "Removed header record created another file called transaction1"
tail -n +2 transaction > transaction1 

# 4 - Convert all text in file to lower case 
echo "Convert all text in file to lower case"
tr '[:upper:]' '[:lower:]' < transaction1 > transaction
