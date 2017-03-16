<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  version="2.0">

  <!-- raw2sample_and_template.xslt -->
  <!-- Read in a TEI P5 file (or any other XML file, really) that has both content -->
  <!-- and comments; write out 2 extractions of the input file, 1 with everything -->
  <!-- except the comments, the other with everything except the content. Write -->
  <!-- those out to the particular dicrectories we use in TAPAS. -->
  <!-- Written 2017-03-16 by Syd Bauman -->
  
  <xsl:variable name="inpath" select="document-uri(/)"/>
  <xsl:variable name="template" select="replace( $inpath,'raw_files/','template_files/')"/>
  <xsl:variable name="sample"   select="replace( $inpath,'raw_files/','sample_files/')"/>
  
  <xsl:template match="/">
    <xsl:message>
      <xsl:text>&#x0A;</xsl:text>
      input: <xsl:value-of select="$inpath"/>
      <xsl:text>&#x0A;</xsl:text>
      out 1: <xsl:value-of select="$sample"/>
      <xsl:text>&#x0A;</xsl:text>
      out 2: <xsl:value-of select="$template"/>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:message>
    <xsl:choose>
      <xsl:when test="$inpath eq $sample  or  $inpath eq $template">
        <xsl:message terminate="yes">ERROR: input and output same file (is input in raw_files/ directory?)</xsl:message>
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
  
  <xsl:template match="text()[ not( normalize-space(.) eq '') ]" mode="template" priority="3"/>

  <xsl:template match="comment()" mode="sample" priority="3"/>
  <xsl:template match="text()[ normalize-space(.) eq '']
                             [following-sibling::node()[1][self::comment()]]
                             [following-sibling::node()[2][self::text()[normalize-space(.) eq '']]]"
                mode="sample" priority="3"/>  
  
</xsl:stylesheet>
