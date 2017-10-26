<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  version="2.0">

  <!-- get_sample_and_template_from_raw.xslt -->
  <!-- Read in a TEI P5 file (or any other XML file, really) that has both content -->
  <!-- and comments; write out 2 extractions of the input file, 1 with everything -->
  <!-- except the comments, the other with everything except the content. Write -->
  <!-- those out to the particular dicrectories we use in TAPAS. -->
  <!-- Written 2017-03-16 by Syd Bauman -->
  <!-- Updated 2017-06-08 by Syd Bauman: keep only the first N of any given sequence of a particular -->
  <!-- element type. N is specified in a processing instruction like: -->
  <!-- <?tapas keep-first=3 ?> -->
  <!-- A value of '0' (the default) meands keep 'em all. -->

  <xsl:param name="debug" select="false()" as="xs:boolean"/>
  <xsl:variable name="inpath" select="document-uri(/)"/>
  <xsl:variable name="template" select="replace( $inpath,'raw_files/','template_files/')"/>
  <xsl:variable name="sample"   select="replace( $inpath,'raw_files/','sample_files/')"/>
  <xsl:variable name="elide" as="xs:integer">
    <xsl:choose>
      <xsl:when test="/processing-instruction('tapas')/contains(.,'keep-first')">
        <xsl:value-of select="/processing-instruction('tapas')/replace( normalize-space(.),'.*keep-first=.?([0-9]+).*','$1')"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:template match="/">
    <xsl:if test="$debug">
      <xsl:message>
        <xsl:text>&#x0A;</xsl:text>
        input: <xsl:value-of select="$inpath"/>
        <xsl:text>&#x0A;</xsl:text>
        out 1: <xsl:value-of select="$sample"/>
        <xsl:text>&#x0A;</xsl:text>
        out 2: <xsl:value-of select="$template"/>
        <xsl:text>&#x0A;</xsl:text>
        keeping first <xsl:value-of select="$elide"/> if each sequence of siblings of same type
        <xsl:text>&#x0A;</xsl:text>
      </xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$inpath eq $sample  or  $inpath eq $template">
        <xsl:message terminate="yes">ERROR: input and one of the outputs are the same file (is input in raw_files/ directory?)</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:result-document href="{$template}">
          <xsl:apply-templates select="node()" mode="template"/>
        </xsl:result-document>
        <xsl:result-document href="{$sample}">
          <xsl:apply-templates select="node()" mode="sample"/>
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

  <!-- for templates, ignore all but the first $elide elements of same type in a row -->
  <xsl:template match="*[ count( preceding-sibling::*[ name(.) eq name( current() )] ) ge $elide]" mode="template" priority="3"/>
  <xsl:template match="*[$elide eq 0]" mode="template" priority="4">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <!-- remove non-whitespace-only text nodes from templates -->
  <xsl:template match="text()[ not( normalize-space(.) eq '') ]" mode="template" priority="3"/>

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
