#!/bin/bash

./mint-massage.rb chase_home_card.csv chase_joint.csv chase_solo.csv

gtac expenses-2015-expenses.csv > temp.csv; mv temp.csv expenses-2015-expenses.csv; rm -f temp.csv
gtac expenses-2015-income.csv > temp.csv; mv temp.csv expenses-2015-income.csv; rm -f temp.csv

./mint-sumsort.rb expenses-2015-expenses.csv expenses-2015-expenses-sorted.csv
./mint-sumsort.rb expenses-2015-income.csv expenses-2015-income-sorted.csv

