# tapas-TEI-files/
## Samples, templates, and test files for use in TAPAS.

This repository contains files for use in testing TAPAS itself, and
the source files used to generate the samples and templates that may
be used to teach TEI or as a starting point for using TEI.

### General layout

* [Raw files](./raw\_files/): These are the files from which the
  samples and templates (below) are generated. If you want to make
  changes to a sample or template file, make the changes here.

* [Samples](./sample\_files/): These are simple examples of valid TEI
  files and should look reasonably good in at least one TAPAS
  viewpackage. They are generated (from the files in raw\_files/, see
  above), so you probably don’t want to make any changes here. (Note:
  sample files may be hand-tweaked after generation, usually to
  improve whitespace.)

* [Templates](./template\_files/): These are templates of TEI
  files. I.e., they are incomplete TEI files that may be used as a
  starting point and “filled out”. Typically these files have comments
  indicating where you would want to insert data. Because there is
  information missing, these files may be invalid and may not look
  acceptable in TAPAS if used as-is. (But should be valid and look OK
  after having been filled out.) These files are generated (from the
  files in raw\_files/, see above), so you probably don’t want to make
  any changes here. (Note: template files may be hand-tweaked after
  generation, usually to improve whitespace.)

* [Tests](./test\_suite/): Files used internally to test TAPAS. See the
  [README](./test\_suite/README.md) file in that directory for more
  details.

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

##### Parameters
There two parameters you can, but do not need, to set.

1. **debug**: set to the xs:boolean `true()` to see debugging output. Currently there is no debugging output, so this parameter is not used.

1. **keepFirst** (an integer): the number of sibling elements of the
same type that should be copied over into the template output. The
default is "0" which means “all”. The sample output is unaffected.
Thus with the following input:

```XML
<!-- template for a label-item pair list: -->
<list>
  <head>Bacon’s Cipher<!-- put the list heading here --></head>
  <label>A<!-- first label --></label><item>aaaaa<!-- item associated w/ first label --></item>
  <label>B<!-- second label --></label><item>aaaab<!-- item associated w/ second label --></item>
  <label>C<!-- etc. ... --></label><item>aaaba<!-- etc. ... --></item>
  <label>D</label><item>aaabb</item>
  <label>E</label><item>aabaa</item>
  <label>F</label><item>aabab</item>
  <label>G</label><item>aabba</item>
  <label>H</label><item>aabbb</item>
  <label>I,J</label><item>abaaa</item>
  <label>K</label><item>abaab</item>
  <label>L</label><item>ababa</item>
  <label>M</label><item>ababb</item>
  <label>N</label><item>abbaa</item>
  <label>O</label><item>abbab</item>
  <label>P</label><item>abbba</item>
  <label>Q</label><item>abbbb</item>
  <label>R</label><item>baaaa</item>
  <label>S</label><item>baaab</item>
  <label>T</label><item>baaba</item>
  <label>U,V</label><item>baabb</item>
  <label>W</label><item>babaa</item>
  <label>X</label><item>babab</item>
  <label>Y</label><item>babba</item>
  <label>Z</label><item>babbb</item>
</list>
```

the output template file would have 24 label-item pairs by default, of
which the latter 21 would all be empty. But if keepFirst were
specified as "2", the template output would be as follows.

```XML
<!-- template for a label-item pair list: -->
<list>
  <head><!-- put the list heading here --></head>
  <label><!-- first label --></label><item><!-- item associated w/ first label --></item>
  <label><!-- second label --></label><item><!-- item associated w/ second label --></item>
  <label><!-- etc. ... --></label><item><!-- etc. ... --></item>
  </list>
```

Note that there are two ways to set this parameter. Besides the normal
method of specifying a parameter to your XSLT program, you could
instead include a processing instruction before the `<TEI>` start-tag
of your raw document. It would look something like

```XML
<?tapas keepFirst=3 ?>
```  

##### Executing XSLT

As XML and XSLT are completely non-proprietary standards, any XSLT
process should be able to handle this. As most TEIers use either
SaxonHE on the commandline or Saxon as built-in to
[oXygen](https://www.oxygenxml.com/), we are providing instructions
for those environments here.

##### SaxonHE on the commandline

It’s pretty simple. Navigate to this directory, and then issue `java
-jar /PATH/TO/saxon9he.jar -xsl:get_sample_and_template_from_raw.xslt
raw_files/MYDEMO.xml`. The output files will be in
sample\_files/MYDEMO.xml and template\_files/MYDEMO.xml.

##### oXygen

There are several ways to do this in oXygen. Probably the easiest is
to use the XSLT debugger. First, open both
get\_sample\_and\_template\_from\_raw.xslt and the file you wish to
transform (here we’ll use raw\_files/MYDEMO.xml). Then switch to the
XSLT Debugger perspective by clicking on the appropriate icon near the
upper right corner of the oXygen window; it is an icon of a small
window with “XSLT” written against a yellow banner in front of it, and
a ladybug over its upper right corner. You will see three panes: the
XML, the XSLT, and the output. The debugger does not necessarily use
the XML document and XSLT program you see in the panes, it uses those
that you select from the “XML:” and “XSL:” drop-down lists in the
upper left corner. Set those to raw\_files/MYDEMO.xml and
get\_sample\_and\_template\_from\_raw.xslt, and choose Debugger > Run,
or click on the dark blue rightward arrow.

If everything works, the message “Debug execution finished” should
appear in the message area in the center of the bottom edge of the
oXygen window. The output you will see in the Output pane is either
pointless (if you have the option XML / XSLT-FO-XQuery / Debugger /
“Show "xsl:result-document" output” checked) or close to useless (if
you don’t). Either way, the output you actually want is automatically
written to sample\_files/MYDEMO.xml and template\_files/MYDEMO.xml.

If something goes wrong, you should get one or more error messages in
the Results pane.
