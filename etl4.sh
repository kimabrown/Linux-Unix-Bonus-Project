#!/bin/bash
#Kima Brown
#Final Project
#etl4.sh     

# 8 - Sort by customerID
echo "Sort by customerID"
sort -t ',' -k 1,1 filtered_transaction > transaction.csv
