#!/bin/bash
set -e

./mint-massage.rb chase_home_card.csv chase_joint.csv

# GNU `tac` command. Installed via `brew install coreutils`
gtac expenses-2017-expenses.csv > temp.csv; mv temp.csv expenses-2017-expenses.csv; rm -f temp.csv
gtac expenses-2017-income.csv > temp.csv; mv temp.csv expenses-2017-income.csv; rm -f temp.csv

./mint-sumsort.rb expenses-2017-expenses.csv expenses-2017-expenses-sorted.csv
./mint-sumsort.rb expenses-2017-income.csv expenses-2017-income-sorted.csv

