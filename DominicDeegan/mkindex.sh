#!/bin/bash
# $Id: mkindex.sh,v 1.2 2005/05/17 17:40:53 mitch Exp $

#ls *.jpg *.gif *.jpeg | sort | while read FILE; do
ls *.gif *.jpeg | sort | while read FILE; do

    echo -e "${FILE}\t${FILE:6:2}.${FILE:4:2}.${FILE:0:4}";

done > index