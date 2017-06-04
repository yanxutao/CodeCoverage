#!/bin/bash

gcc -fprofile-arcs -ftest-coverage -o test test.c
./test
gcov -b test.c

lcov --capture --directory . --output-file test.info # --test-name test
genhtml test.info --output-directory output #--title "a simple test" --show-details --legend
#cd output
google-chrome output/index.html
