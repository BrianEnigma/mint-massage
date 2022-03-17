#!/bin/bash

# Amazon card is almost 100% shopping/hobbies. We only care about the charities.

INFILE=chase-amazon_card.csv
OUTFILE=chase-amazon_card-fixed.csv

head -n1 $INFILE > $OUTFILE
grep Charity $INFILE >> $OUTFILE

