# tapas-TEI-files/
## Samples, templates, and test files for use in TAPAS.

This repository contains files for use in testing TAPAS itself, and
the source files used to generate the samples and templates that may
be used to teach TEI or as a starting point for using TEI.

### General layout

* [Samples](./sample\_files/): These are simple examples of valid TEI
  files and should look reasonably good in at least one TAPAS
  viewpackage. They are generated (from the files in raw\_files/, see
  below), so you probably don’t want to make any changes here. (Note:
  sample files may be hand-tweaked after generation, usually to
  improve whitespace.)

* [Templates](./template\_files/): These are templates of TEI
  files. I.e., they are incomplete TEI files that may be used as a
  starting point and “filled out”. Typically these files have comments
  indicating where you would want to insert data. Because there is
  information missing, these files may be invalid and may not look
  acceptable in TAPAS if used as-is. (But should be valid and look OK
  after having been filled out.) These files are generated (from the
  files in raw\_files/, see below), so you probably don’t want to make
  any changes here. (Note: template files may be hand-tweaked after
  generation, usually to improve whitespace.)

* [Tests](./test\_suite/): Files used internally to test TAPAS. See the
  [README](./test\_suite/README.md) file in that directory for more
  details.

* [Raw files](./raw\_files/): These are the files from which the
  samples and templates are generated. 

### Generation

Generally speaking, a **template** has an element structure, but does
not have any text _inside_ the elements. Instead, it has comments in
various places to advise you what kind of text should be inserted
where. Conversely, a **sample** has an element structure with sample
text, and thus does not need (and typically does not have) comments
that tell a user where to put content.

Since the underlying structure of a template and a sample for a
particular type of encoding could be exactly the same, we generate our
templates and samples from source “raw” files. These raw files contain
both the comments you would find in a template, and the content you
would find in a sample. An [XSLT
program](./get\_sample\_and\_template\_from\_raw.xslt) reads in a raw file
and writes out a sample based on it (with the comments stripped out)
and a template based on it (with the content stripped out).

If you would like to modify the templates and samples we have
provided, or create entirely new ones of your own, you can edit the
files in the [raw\_files/](./raw\_files) directory or put a new source
file there. Then run the XSLT program
[get\_sample\_and\_template\_from\_raw.xslt](./get\_sample\_and\_template\_from\_raw.xslt)
with your modified or new file as input. The output will be put
directly into the [sample\_files/](./sample\_files) and
[template\_files/](./template\_files) folders.

#### Using get\_sample\_and\_template\_from\_raw.xslt

Talk about parameters here

#### Excuting XSLT

As XML and XSLT are completely non-proprietary standards, any XSLT
process should be able to handle this. As most TEIers use either
SaxonHE on the commandline or Saxon as built-in to [oXygen](), we are
providing instructions for those environments here.

### SaxonHE on the commandline

It’s pretty simple. Navigate to this directory, and then issue `java
-jar /PATH/TO/saxon9he.jar -xsl:get_sample_and_template_from_raw.xslt
raw\_files/MYDEMO.xml`. The output files will be in
sample\_files/MYDEMO.xml and template\_files/MYDEMO.xml.

### oXygen

There are several ways to do this in oXygen. Probably the easiest is
to use the XSLT debugger. First, open both
get\_sample\_and\_template\_from\_raw.xslt and the file you wish to
transform (here we’ll use raw\_files/MYDEMO.xml). Then switch to the
XSLT Debugger perspective by clicking on the small window icon with
“XSLT” written against a yellow banner in front of it, and a ladybug
over its upper right corner. You will see three panes: the XML, the
XSLT, and the output. The debugger does not necessarily use the XML
document and XSLT program you see in the panes, it uses those that you
select from the “XML:” and “XSL:” drop-down lists in the upper right
corner. Set those to raw\_files/MYDEMO.xml and
get\_sample\_and\_template\_from\_raw.xslt, and choose Debugger > Run, or
click on the dark blue rightward arrow.

The output you will see in the Output pane is either pointless (if you
have the XML / XSLT-FO-XQuery / Debugger option “Show
"xsl:result-document" output” checked) or close to useless (if you
don’t). Either way, the output you actually want is automatically
written to sample\_files/MYDEMO.xml and template\_files/MYDEMO.xml.

