#!/bin/sh

EXITCODE=2

LATEST=$(ls | egrep '[0-9]{8}.(gif|jpg)' | tail -1 | cut -c 1-8)
if [ -z ${LATEST} ]; then
    LATEST=20051208  # first strip ever
fi

YS=$(echo ${LATEST} | cut -c 1-4)
MS=$(echo ${LATEST} | cut -c 5-6)
DS=$(echo ${LATEST} | cut -c 7-8)

YE=$(date +%Y)
ME=$(date +%m)
DE=$(date +%d)

echo reading from ${YS}-${MS}-${DS} up to ${YE}-${ME}-${DE}

PAGEBASE="http://digitalunrestcomic.com/index.php?date="
PICBASE="http://digitalunrestcomic.com/strips/"
USERAGENT="Mozilla/4.0 (compatible; MSIE 5.0; Linux) Opera 5.0  [en]"

YS=$(echo ${YS} | sed 's/^0*//')
MS=$(echo ${MS} | sed 's/^0*//')
DS=$(echo ${DS} | sed 's/^0*//')

TMPFILE=pennyarcade.tmp

while true; do
    DATE=$(printf %04d%02d%02d ${YS} ${MS} ${DS})
    URLDATE=$(printf %04d-%02d-%02d ${YS} ${MS} ${DS})

    echo -n "fetching ${DATE}: "

    EXT=jpg
    FILE=${DATE}.${EXT}

    if [ -e ${FILE} -a ! -w ${FILE} ]; then
	echo skipping
    else
	
	wget --user-agent="${USERAGENT}" --referer=${PAGEBASE}${URLDATE} -qO${FILE} ${PICBASE}${URLDATE}.${EXT}
	
	if [ -s ${FILE} ]; then
	    echo OK
	    chmod -w ${FILE}
	    EXITCODE=0
	else
	    test -w ${FILE} && rm ${FILE}
	    echo nok
	fi
    fi
    
    if [ ${DATE} = ${YE}${ME}${DE} ]; then
	rm ${TMPFILE}
	exit ${EXITCODE}
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