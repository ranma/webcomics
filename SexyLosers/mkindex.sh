#!/bin/bash

ls | egrep '\.(jpeg|gif)$' | sort | while read FILE; do

    echo -e "${FILE}\thttp://www.sexylosers.com/${FILE:0:3}.html\t[${FILE:0:3}]"

done > index
