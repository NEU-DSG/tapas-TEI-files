<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  version="2.0">

  <!-- get_sample_and_template_from_raw.xslt -->
  <!-- Read in a TEI P5 file (or any other XML file, really) that has both content -->
  <!-- and comments; write out 2 extractions of the input file, 1 with everything -->
  <!-- except the comments, the other with everything except the content. Write -->
  <!-- those out to the particular directories we use in TAPAS. -->
  <!-- Written 2017-03-16 by Syd Bauman -->
  <!-- Updated 2017-06-08 by Syd Bauman: keep only the first N of any given sequence of a particular -->
  <!--   element type in output template. N is specified in a processing instruction like: -->
  <!--      <?tapas keepFirst=3 ?> -->
  <!--   A value of '0' (the default) means keep 'em all. Output sample is not affected. This -->
  <!--   allows us to generate samples with a dozen sample entries of some sort, but a template -->
  <!--   that has only 2 or 3. (See e-mail _Re: TAPAS sample & template feature_ of 201-02-16.) -->

  <xsl:output method="text" indent="yes"/>
  <!-- Note: output of both explicit result files is XML, not text -->
  <xsl:param name="debug" select="false()" as="xs:boolean"/>
  <xsl:variable name="inpath" select="document-uri(/)"/>
  <xsl:variable name="template" select="replace( $inpath,'raw_files/','template_files/')"/>
  <xsl:variable name="sample"   select="replace( $inpath,'raw_files/','sample_files/')"/>
  <xsl:param name="keepFirst" as="xs:integer">
    <xsl:choose>
      <xsl:when test="/processing-instruction('tapas')/contains(.,'keepFirst')">
        <xsl:value-of select="/processing-instruction('tapas')/replace( normalize-space(.),'.*keepFirst=.?([0-9]+).*','$1')"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <xsl:template match="/">
    <xsl:variable name="metaInfo">
      <xsl:text>Run information — &#x0A;input: </xsl:text>
      <xsl:value-of select="$inpath"/>
      <xsl:text>&#x0A;out 1: </xsl:text>
      <xsl:value-of select="$sample"/>
      <xsl:text>&#x0A;out 2: </xsl:text>
      <xsl:value-of select="$template"/>
      <xsl:text>&#x0A;keeping </xsl:text>
      <xsl:value-of select="if ($keepFirst eq 0) then 'all' else concat('first ', $keepFirst )"/>
      <xsl:text> of each sequence of siblings of same type for the template&#x0A;timestamp: </xsl:text>
      <xsl:value-of select="current-dateTime()"/>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:variable>
    <xsl:value-of select="$metaInfo"/>
    <xsl:choose>
      <xsl:when test="$inpath = ( $sample, $template )">
        <xsl:message terminate="yes">ERROR: input and one of the outputs are the same file (is input in raw_files/ directory?)</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:result-document href="{$sample}" method="xml">
          <xsl:apply-templates select="node()" mode="sample"/>
        </xsl:result-document>
        <xsl:result-document href="{$template}" method="xml">
          <xsl:apply-templates select="node()" mode="template"/>
        </xsl:result-document>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="node()" mode="#all">
    <xsl:if test="not( ancestor::* )">
      <xsl:text>&#x0A;</xsl:text>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*" mode="#all">
    <xsl:copy/>
  </xsl:template>

  <!-- ***** mode="template" ***** -->

  <!-- for templates, ignore all but the first $keepFirst elements of same type in a row -->
  <xsl:template match="*[ count( preceding-sibling::*[ name(.) eq name( current() )] ) ge $keepFirst]" mode="template" priority="3"/>
  <!-- and ignore whitespace immediately after such nodes -->
  <xsl:template match="text()[normalize-space(.) eq '']" mode="template" priority="3">
    <xsl:variable name="elementIfollow" select="preceding-sibling::*[1]"/>
    <xsl:choose>
      <xsl:when test="count( $elementIfollow/preceding-sibling::*[ name(.) eq name( $elementIfollow )] ) ge $keepFirst"/>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*[$keepFirst eq 0]" mode="template" priority="4">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <!-- remove non-whitespace-only text nodes from templates -->
  <xsl:template match="text()[ not( normalize-space(.) eq '') ]" mode="template" priority="3"/>

  <!-- ***** mode="sample" ***** -->
  
  <!-- remove comments and whitespace preceding a comment when there is also whitespace after said comment -->
  <xsl:template match="comment()" mode="sample" priority="3"/>
  <xsl:template mode="sample" priority="3"
                match="text()                                      (: text nodes :)
                       [ normalize-space(.) eq '']                 (: that are whitespace only :)
                       [following-sibling::node()[1]               (: whose closest following sibling node :)
                         [self::comment()]                         (: is a comment :)
                         ]                                         (: and whose :)
                       [following-sibling::node()[2]               (: 2nd closest following sibling node :)
                         [self::text()[normalize-space(.) eq '']]  (: is also whitespace only :)
                         ]"
                />
  
</xsl:stylesheet>
