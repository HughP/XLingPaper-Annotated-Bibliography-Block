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
    <xsl:template match="backMatter"/>    
    <xsl:template match="annotatedBibliographySection">
        <xsl:variable name="annotatedBibliographySection" select="."/>
        <xsl:variable name="refs" select="//references"/>
        <xsl:for-each select="$refs/refAuthor">
           <!-- <xsl:sort select="lower-case(@name)" order="ascending"/>-->
            <!-- This sort is a stopgap, it will need to handle "de", "du", "von", "van", "von der", and "van der" better. And it needs to be set by a variable. -->
            <xsl:for-each select="./refWork">
                <xsl:variable name="currentWork" select="."/>
                <xsl:variable name="currentWorkAnnotations" select="./annotations"/>
                <xsl:variable name="keywordExclusion">
                    <xsl:variable name="excludedWords" select="$annotatedBibliographySection/@excludeKeywords"/>
                    <xsl:for-each select="$excludedWords">
                        <xsl:variable name="currentBadWord" select="."/>
                        <xsl:for-each select="$currentWork/keywords/keyword">
                            <xsl:if test=".=$currentBadWord">
                                <xsl:value-of>false</xsl:value-of>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="languageExclusion">
                    <xsl:choose>
                        <xsl:when test="0=0">false</xsl:when>
                        <xsl:otherwise>true</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$annotatedBibliographySection/@includeKeywords">
                        <xsl:choose>
                            <xsl:when test="./keywords/keyword/text()">
                                <xsl:for-each select="./keywords/keyword">
                                    <xsl:choose>
                                        <xsl:when test="$annotatedBibliographySection/@includeKeywords=./text() and not($keywordExclusion='false')">
                                            <!-- An Annotation would get duplicated if the keyword existed twice -->
                                            <xsl:element name="annotationRef">
                                                <xsl:attribute name="citation">
                                                    <xsl:value-of select="$currentWork/@id"/>
                                                </xsl:attribute>
                                                <xsl:for-each select="$currentWorkAnnotations/annotation">
                                                    <xsl:if test="$annotatedBibliographySection/@includeTypes=./@annotype">
                                                        <xsl:attribute name="annotation">
                                                            <xsl:value-of select="./[@annotype]"/>
                                                        </xsl:attribute>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:element>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                        <!-- Filter -->
                        <!-- if killKeywords match, kwCheck=False -->
                        <!-- Compare, if keywords match, kwCheck=true -->
                        <!-- If Keywords fail, kwCheck=false-->
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Show all -->
                        <!-- kwCheck=true -->
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$annotatedBibliographySection/@includeLanguages">
                        <!-- This filter needs to also exclude on the basis of exclude keywords and exclude languages. So, if there is an excludeKeyword then that applies, but then if there is also a exclude language also apply. And if there is an exclude type then that also applies. sense ISO638-3 codes are similar to keywords in that one can have more than one per citation, then this needs to act like keywords too. -->
                        <!-- Filter -->
                        <!-- if killLangs match, langCheck=False -->
                        <!-- Compare, if langs match, langCheck=true -->
                        <!-- If Keywords fail, langCheck=false-->
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Show all -->
                        <!-- langCheck=true -->
                    </xsl:otherwise>
                </xsl:choose>
                <!--<xsl:choose>
                    <xsl:when test="./keywords/keyword/text()">
                        <xsl:element name="annotationRef">
                            <xsl:attribute name="citation">
                                <xsl:value-of select="./@id"/>
                            </xsl:attribute>
                            <xsl:for-each select="./annotations/annotation">
                                <!-\- This is a temporary equality hack, do a real "contains", deal with multiples in spec -\->
                                <xsl:if test="$annotatedBibliographySection/@includeTypes=./@annotype">
                                    <xsl:attribute name="annotation">
                                        <xsl:value-of select="./[@annotype]"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>-->
            </xsl:for-each>
        </xsl:for-each>
        <!-- references/refAuthor/refWork/keywords/keyword -->
    </xsl:template>
</xsl:stylesheet>
