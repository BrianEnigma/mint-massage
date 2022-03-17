#!/bin/bash
set -e

YEAR=2021

./mint-massage.rb $YEAR chase-amazon_card.csv \
    chase-house_card.csv \
    chase-joint_checking.csv \
    chase-solo_checking.csv

## GNU `tac` command. Installed via `brew install coreutils`
#gtac expenses-$YEAR-expenses.csv > temp.csv; mv temp.csv expenses-$YEAR-expenses.csv; rm -f temp.csv
#gtac expenses-$YEAR-income.csv > temp.csv; mv temp.csv expenses-$YEAR-income.csv; rm -f temp.csv
sort expenses-$YEAR-expenses.csv > temp.csv; mv temp.csv expenses-$YEAR-expenses.csv; rm -f temp.csv
sort expenses-$YEAR-income.csv > temp.csv; mv temp.csv expenses-$YEAR-income.csv; rm -f temp.csv

./mint-sumsort.rb expenses-$YEAR-expenses.csv expenses-$YEAR-expenses-sorted.csv expense-$YEAR-categories.csv
./mint-sumsort.rb expenses-$YEAR-income.csv expenses-$YEAR-income-sorted.csv
