# tapas-TEI-files/
## Samples, templates, and test files for use in TAPAS.

This repository contains files for use in testing TAPAS itself, and
the source files used to generate the samples and templates that may
be used to teach TEI or as a starting point for using TEI.

### General layout

* [Samples](./sample_files/): These are simple examples of valid TEI
  files and should look reasonably good in at least one TAPAS
  viewpackage. They are generated (from the files in raw_files/, see
  below), so you probably don't want to make any changes here. (Note:
  sample files may be hand-tweaked after generation, usually to
  improve whitespace.)

* [Templates](./template_files/): These are templates of TEI
  files. I.e., they are incomplete TEI files that may be used as a
  starting point and “filled out”. Typically these files have comments
  indicating where you would want to insert data. Because there is
  information missing, these files may be invalid and may not look
  acceptable in TAPAS if used as-is. (But should be valid and look OK
  after having been filled out.) These files are generated (from the
  files in raw_files/, see below), so you probably don't want to make
  any changes here. (Note: template files may be hand-tweaked after
  generation, usually to improve whitespace.)

* [Tests](./test_suite/): Files used internally to test TAPAS.

* [Raw files](./raw_files/): These are the files from which the
  samples and templates are generated. 

### Generation

Generally speaking, a **template** has an element structure, but does
not have any text _inside_ the elements. Instead, it has comments in
various places to advise you what kind of text should be inserted
where. Conversely, a **sample** has an element structure with sample
text, and thus does not need (and typically does not have) comments
that tell a user where to put content.


(note-to-self: for XML WF tests, see
https://www.oasis-open.org/committees/xml-conformance/index.html)

