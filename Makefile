all: check

# Optional, might not exist; can be set by caller to another location
# (e.g. with GitHub Actions self-test)
NUT_WEBSITE_DIR=..

# Optionally allow the caller to customize the python interpreter to
# use for nut-ddl.py:
NUT_DDL_PYTHON=

# NOTE: The checks below are rudimentary, just to filter away the most
# blatant issues. More diligent ones are in nut-website:nut-ddl.py parser.
check: check-filename-structure check-content-markup

html: index.html

index.html: .DUMMY
	[ -s $(NUT_WEBSITE_DIR)/Makefile ] && [ -x $(NUT_WEBSITE_DIR)/tools/nut-ddl.py ] # error out if not building along with nut-website
	D="`pwd`" && D="`basename \"$$D\"`" && [ -n "$$D" ] || D="ddl" ; \
	cd .. && $(MAKE) $(MAKE_FLAGS) $(AM_FLAGS) "$$D/index.html"

check-filename-structure:
	LANG=C; LC_ALL=C; TZ=UTC; \
	export LANG LC_ALL TZ ; \
	( find . -name '*.dev*' -o -name '*.nds*' | grep -E -v '\.(dev|nds)\.txt$$' | sort -n | while IFS='' read F ; do \
		MASK="`basename \"$$F\" | sed 's,^\(..*\)__\(..*\)__\(..*\)__\([0-9]..*\)__\([0-9][0-9]*\)\.\(dev\|nds\),MFG__MOD__DRV__NUTVER__REPNUM,'`" \
		&& [ "$$MASK" = "MFG__MOD__DRV__NUTVER__REPNUM" ] \
		&& echo "FILENAME OK: $$F" \
		|| { echo "FILENAME STRUCTURE FAILED: $$F ; EXPECTED:" >&2; \
			echo "    <manufacturer>__<model>__<driver_name>__<NUT_version>__<report_number>.{dev,nds}" >&2 ; \
			exit 1; } ; \
	done )

check-content-markup:
	LANG=C; LC_ALL=C; TZ=UTC; \
	export LANG LC_ALL TZ ; \
	NUT_DDL_PEDANTIC_DECLARATIONS=True ; \
	NUT_DDL_REQUIRE_MANPAGES=False ; \
	export NUT_DDL_PEDANTIC_DECLARATIONS NUT_DDL_REQUIRE_MANPAGES; \
	find . -type f -name '*.dev' | ( \
		echo "`date -u`: Sanity-checking the *.dev files..." >&2 ; \
		if [ -x $(NUT_WEBSITE_DIR)/tools/nut-ddl.py ] ; then \
			echo "`date -u`: will use $(NUT_DDL_PYTHON) $(NUT_WEBSITE_DIR)/tools/nut-ddl.py for deeper checks" >&2 ; \
		fi ; \
		FAILED=""; \
		PASSED=""; \
		while read F ; do \
			if [ -x $(NUT_WEBSITE_DIR)/tools/nut-ddl.py ] ; then \
				RES=0 ; $(NUT_DDL_PYTHON) $(NUT_WEBSITE_DIR)/tools/nut-ddl.py "$$F" "$$F.tmp.html" </dev/null >&2 || RES=$$? ; \
				rm -f "$$F.tmp.html" ; \
				if [ "$$RES" != 0 ] ; then \
					echo "^^^ $$F" >&2 && FAILED="$$FAILED $$F" && continue; \
				fi ; \
			fi ; \
			egrep -v '^( *\#.*|.*:.*)$$' "$$F" | egrep -v '^$$' >&2 && echo "^^^ $$F" >&2 && FAILED="$$FAILED $$F" && continue; \
			PASSED="$$PASSED $$F"; \
		done; \
		if [ -n "$$FAILED" ]; then echo "`date -u`: FAILED sanity-check (got RES=$$RES) in following file(s) : $$FAILED" >&2; exit 1; fi; \
		if [ x"$$RES" != x0 ]; then echo "`date -u`: FAILED sanity-check : got RES=$$RES" >&2; exit $$RES; fi; \
		echo "`date -u`: OK : All *.dev files have passed the basic sanity check : $$PASSED"; \
		exit 0; \
	)

.DUMMY:
