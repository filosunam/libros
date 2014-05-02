<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:rng="http://relaxng.org/ns/structure/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:teix="http://www.tei-c.org/ns/Examples" 
    xmlns:xhtml="http://www.w3.org/1999/xhtml" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    exclude-result-prefixes="xlink rng tei teix xhtml a html xs xsl" version="2.0">

  <xsl:import href="../../Stylesheets/epub3/tei-to-epub3.xsl"/>

  <xsl:output method="xml" encoding="utf-8" indent="no"/>
  <xsl:param name="googleAnalytics"/>
  <xsl:param name="lang"/>
  <xsl:param name="doclang"/>
  <xsl:param name="STDOUT">false</xsl:param>
  <xsl:param name="splitLevel">0</xsl:param>
  <xsl:param name="footnoteFile">false</xsl:param>
  <xsl:param name="auto">false</xsl:param>
  <xsl:param name="numberFrontHeadings">true</xsl:param>
  <xsl:param name="displayMode">rnc</xsl:param>
  <xsl:param name="feedbackURL">http://www.tei-c.org/Consortium/contact.xml</xsl:param>
  <xsl:param name="homeLabel">TEI P5 Guidelines</xsl:param>
  <xsl:param name="homeWords">TEI P5</xsl:param>
  <xsl:param name="institution">Facultad de Filosofía y Letras, UNAM</xsl:param>
  <xsl:param name="parentURL">http://www.tei-c.org/Consortium/</xsl:param>
  <xsl:param name="parentWords">TEI Consortium</xsl:param>
  <xsl:param name="cssFile">../../xsl/epub3/styles.css</xsl:param>
  <xsl:param name="cssSecondaryFile">../profiles/tei/epub/odd.css</xsl:param>
  <xsl:param name="cssPrintFile">../profiles/tei/epub/guidelines-print.css</xsl:param>

  <xsl:template name="copyrightStatement">Copyright TEI Consortium 2011</xsl:template>
  
</xsl:stylesheet>
