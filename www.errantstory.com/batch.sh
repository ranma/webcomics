#!/bin/sh
# $Id: batch.sh,v 1.3 2001-12-22 12:47:01 mitch Exp $

# $Log: batch.sh,v $
# Revision 1.3  2001-12-22 12:47:01  mitch
# Fertig geladene Bilder werden scheibgesch�tzt
#
# Revision 1.2  2001/12/20 18:50:02  mitch
# L�dt automatisch alles ab dem letzten (bzw. ersten) Strip herunter
#
# Revision 1.1  2001/12/20 18:28:31  mitch
# Initial revision
#

LATEST=$(ls | egrep '[0-9]{8}.gif' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    LATEST=20000707  # first strip ever
fi

YS=$(echo ${LATEST} | cut -c 1-4)
MS=$(echo ${LATEST} | cut -c 5-6)
DS=$(echo ${LATEST} | cut -c 7-8)

YE=$(date +%Y)
ME=$(date +%m)
DE=$(date +%d)

echo reading from ${YS}-${MS}-${DS} up to ${YE}-${ME}-${DE}

PAGEBASE="http://www.exploitationnow.com/d/"
PICBASE="http://www.exploitationnow.com/comics/rb"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

YS=$(echo ${YS} | sed 's/^0*//')
MS=$(echo ${MS} | sed 's/^0*//')
DS=$(echo ${DS} | sed 's/^0*//')

while true; do
    DATE=$(printf %04d%02d%02d ${YS} ${MS} ${DS})

    echo -n "fetching ${DATE}: "
    FILE=${DATE}.gif
    wget --user-agent="${USERAGENT}" --use-proxy=off --referer=${PAGEBASE}${DATE}.html -O ${FILE} ${PICBASE}${DATE}.gif 2> /dev/null

    if [ -s ${FILE} ]; then
	echo OK
	chmod -w ${FILE}
    else
	rm ${FILE}
	echo nok
    fi
    
    if [ ${DATE} = ${YE}${ME}${DE} ]; then
	exit
    fi

    DS=$((${DS} + 1))
    if [ ${DS} -gt 31 ]; then
	DS=1
	MS=$((${MS} + 1))
	if [ ${MS} -gt 12 ]; then
	    MS=1
	    YS=$((${YS} + 1))
	fi
    fi

done