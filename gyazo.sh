#!/bin/sh

URL='https://API_ENDPOINT'

TEMP=$(mktemp /tmp/XXXXX.png)
WIDTH=800

if [ $# -eq 0 ]; then
    import ${TEMP}
else
    if [ $(identify -format %w ${1}) -gt ${WIDTH} ]; then
        CONVOPT="-resize ${WIDTH}"
    fi
    convert ${CONVOPT} ${1} $TEMP
fi

IMAGE=$(curl -s -H 'content-type: image/png' --data-binary "@${TEMP}" -X POST ${URL})
if [ $? -eq 0 ]; then
    gnome-www-browser ${IMAGE}
    echo ${IMAGE} | xclip -sel c
fi
rm -f ${TEMP}
