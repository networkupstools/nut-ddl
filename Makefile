check:
	find . -name '*.dev' | while IFS='' read F ; do \
		MASK="`basename "$$F" | sed 's,^\(..*\)__\(..*\)__\(..*\)__\([0-9]..*\)__\([0-9][0-9]*\)\.\(dev\|nds\),MFG__MOD__DRV__NUTVER__REPNUM,'`" \
		&& [ "$$MASK" = "MFG__MOD__DRV__NUTVER__REPNUM" ] \
		&& echo "FILENAME OK: $$F" \
		|| { echo "FILENAME STRUCTURE FAILED: $$F ; EXPECTED:" >&2; \
			echo "    <manufacturer>__<model>__<driver_name>__<NUT_version>__<report_number>.{dev,nds}" >&2 ; \
			exit 1; } ; \
	done
