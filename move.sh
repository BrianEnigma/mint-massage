#!/bin/bash

head -n1 ~/Desktop/joint.csv > chase_joint.csv
head -n1 ~/Desktop/home.csv > chase_home_card.csv
grep '/2017",' ~/Desktop/joint.csv >> chase_joint.csv
grep '/2017",' ~/Desktop/home.csv >> chase_home_card.csv
rm ~/Desktop/joint.csv ~/Desktop/home.csv

