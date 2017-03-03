#!/bin/sh

# Travis CI script

case "$BUILD_TYPE" in
    sanitycheck) find . -type f -name '*.dev' | (
        echo "`date -u`: Sanity-checking the *.dev files..."
        FAILED=""
        PASSED=""
        while read F ; do
            egrep -v '^( *\#.*|.*:.*)$' "$F" | egrep -v '^$' && echo "^^^ $F" && FAILED="$FAILED $F" && continue
            PASSED="$PASSED $F"
        done
        if [ -n "$FAILED" ]; then echo "`date -u`: FAILED sanity-check in following file(s) : $FAILED" >&2; exit 1; fi
        echo "`date -u`: OK : All *.dev files have passed the basic sanity check : $PASSED"
        exit 0
        ) ;;
    *) echo "`date -u`: Unknown BUILD_TYPE='$BUILD_TYPE'" >&2 ; exit 1;; \
esac
