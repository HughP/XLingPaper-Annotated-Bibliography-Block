<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output omit-xml-declaration="no" indent="yes" method="xml" />
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="annotatedBibliographySection[@id='case0']"/>
        
    <xsl:template match="annotatedBibliographySection">
        <xsl:variable name="annotatedBibliographySection" select="."/>
        <xsl:variable name="refs" select="//references"/>
        <xsl:for-each select="$refs/refAuthor">
            <xsl:sort select="lower-case(@name)" order="ascending"/>
            <!-- This is a stopgap, it will need to handle "de" and "von" better. -->
            <xsl:for-each select="./refWork">
                <xsl:choose>
                    <xsl:when test="./keywords/keyword/text()">
                        <xsl:element name="annotationRef">
                            <xsl:attribute name="citation">
                                <xsl:value-of select="./@id"/>
                            </xsl:attribute>
                            <xsl:for-each select="./annotations/annotation">
                                <!-- This is a temporary equality hack, do a real "contains", deal with multiples in spec -->
                                <xsl:if test="$annotatedBibliographySection/@includeTypes=./@annotype">
                                    <xsl:attribute name="annotation">
                                        <xsl:value-of select="./[@annotype]"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
        <!-- references/refAuthor/refWork/keywords/keyword -->
    </xsl:template>
    
</xsl:stylesheet>