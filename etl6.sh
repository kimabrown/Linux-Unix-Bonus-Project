#!/bin/bash
#Kima Brown
#Final Project
#etl6.sh     

# 10 - Sort by state zip lastname firstname
echo "Sort by state zip lastname firstname"
sort -t ',' -k 2,2 -k 3,3n -k 4,4 -k 5,5 summary.csv
