#!/bin/bash

./mint-massage.rb chase_home_card.csv chase_joint.csv chase_solo.csv

# GNU `tac` command. Installed via `brew install coreutils`
gtac expenses-2016-expenses.csv > temp.csv; mv temp.csv expenses-2016-expenses.csv; rm -f temp.csv
gtac expenses-2016-income.csv > temp.csv; mv temp.csv expenses-2016-income.csv; rm -f temp.csv

./mint-sumsort.rb expenses-2016-expenses.csv expenses-2016-expenses-sorted.csv
./mint-sumsort.rb expenses-2016-income.csv expenses-2016-income-sorted.csv

