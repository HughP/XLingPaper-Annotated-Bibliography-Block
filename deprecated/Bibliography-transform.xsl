<?xml version="1.0"?>
  <xsl:stylesheet version="1.0" 
                  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="annotation">
     <xsl:attribute name="annotationType"><xsl:value-of select="//annotatedBibliographySection/@annotationType"/></xsl:attribute> 
</xsl:variable>



<annotationRef XeLaTeXSpecial="" annotation="$annotation" citation="$citationID" cssSpecial="" xsl-foSpecial=""></annotationRef>





</xsl:stylesheet>
