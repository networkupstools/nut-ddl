<!-- Comment:
## Proposing a new NUT Devices Dumps Library (DDL) entry

First of all, thank you for taking the time for preparing this contribution!

Please follow the file naming and content mark-up rules explained at current
https://networkupstools.org/ddl/index.html#_file_naming_convention
section and the text below it.

To report new data for the Devices Dumps Library (DDL), such "data dump"
reports can be best prepared by the
https://raw.githubusercontent.com/networkupstools/nut/master/tools/nut-ddl-dump.sh
script from the main NUT codebase; at a minimum, output of `upsc` helps too.
-->

## Sanity check list

- [ ] This PR is named to help easy searches (identify the vendor, device...)

- [ ] Data dump file name follows this pattern (safely using ASCII characters):
  `<manufacturer>__<model>__<driver-name>__<nut-version>__<report-number>.<extension>`
  (more nuances are documented on site).

- [ ] This file is placed into a sub-directory named same as the `manufacturer`.

- [ ] Was this content prepared with `nut-ddl-dump.sh` script?

- [ ] Information from `upsc` discovered fields is provided un-commented.

- [ ] Additional data about supported RW variables and instant commands is
  prefixed with standardized comment mark-up as documented on site, e.g.:
````
#RW:<var.name>:<type>:<options>
````
and
````
#CMD:<command.name>
````

- [ ] Mark-up for structured comments is followed (as documented on site),
  where applicable.

- [ ] For devices supported only with special settings in their `ups.conf`
  configuration section (e.g. `vendorid` and `productid` required along
  with a USB `subdriver`), example section content is welcome as a comment.

- [ ] For a newly discovered supported device, a sibling PR for the main
  NUT codebase (at least `docs/driver.list.in`, or possibly VID/PID and
  other auto-detection mapping tables in the driver sources) is welcome.

- [ ] This PR is linked to relevant issue(s) and/or PRs in the NUT project
  if applicable.
