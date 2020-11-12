<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output omit-xml-declaration="no" indent="yes" method="xml"/>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="annotatedBibliographySection[@id = 'case0']"/>
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
                    <xsl:text>0</xsl:text>
                    <xsl:variable name="excludedWords"
                        select="$annotatedBibliographySection/@excludeKeywords"/>
                    <xsl:for-each select="$excludedWords">
                        <xsl:variable name="currentBadWord" select="."/>
                        <xsl:for-each select="$currentWork/keywords/keyword">
                            <xsl:choose>
                                <xsl:when test=". = $currentBadWord">
                                    <xsl:text>1</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>0</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:variable name="keywordInclusionSet"
                    select="$annotatedBibliographySection/@includeKeywords"/>

                <xsl:variable name="tokenKeywords">
                    <xsl:call-template name="tokenize">
                        <xsl:with-param name="input" select="normalize-space($keywordInclusionSet)"
                        />
                    </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="keywordGroup">
                    <xsl:for-each select="$tokenKeywords/*">
                        <xsl:element name="group">
                            <xsl:call-template name="tokenize">
                                <xsl:with-param name="delimiter" select="','"/>
                                <xsl:with-param name="input" select="normalize-space(.)"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:variable name="keywordInclusion">
                    <xsl:call-template name="keywordInclusion">
                        <xsl:with-param name="annotationRefKeywords" select="$keywordGroup"/>
                        <xsl:with-param name="citationKeywords"
                            select="$currentWork/keywords/keyword"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="languageExclusion">
                    <xsl:choose>
                        <xsl:when test="0 = 0">false</xsl:when>
                        <xsl:otherwise>true</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$keywordExclusion = 0 and $keywordInclusion &gt; 0">
                        <!-- An Annotation would get duplicated if the keyword existed twice -->
                        <xsl:element name="annotationRef">
                            <xsl:attribute name="citation">
                                <xsl:value-of select="$currentWork/@id"/>
                            </xsl:attribute>
                            <xsl:for-each select="$currentWorkAnnotations/annotation">
                                <xsl:if
                                    test="$annotatedBibliographySection/@includeTypes = ./@annotype">
                                    <xsl:attribute name="annotation">
                                        <xsl:value-of select="./[@annotype]"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="keywordInclusion">
        <xsl:param name="citationKeywords"/>
        <xsl:param name="annotationRefKeywords"/>
        <xsl:for-each select="$annotationRefKeywords/group">
            <xsl:variable name="currentRefGroup" select="./result"/>
            <xsl:variable name="filteredCitationKeywords">
                <xsl:for-each select="$citationKeywords/text()">
                    <xsl:if test=". = $currentRefGroup/text()">
                        <xsl:element name="keyword">
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="distinctCitationKeywords">
                <!-- Dedups Citation Keywords -->
                <xsl:element name="keywords">
                        <xsl:for-each-group select="$filteredCitationKeywords/keyword" group-by="text()">
                            <xsl:element name="keyword">
                            <xsl:copy-of select="current-group()[1]/text()"/>
                            </xsl:element>
                        </xsl:for-each-group>
                </xsl:element>
            </xsl:variable>
            <xsl:choose>
                <xsl:when
                    test="count($distinctCitationKeywords/keywords/keyword/text()) = count($currentRefGroup) and not($filteredCitationKeywords = '')">
                    <xsl:text>1</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>0</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <!-- Need to handle duplicate keywords -->
    </xsl:template>
    <xsl:template name="tokenize">
        <xsl:param name="delimiter" select="'|'"/>
        <xsl:param name="input"/>
        <xsl:choose>
            <xsl:when test="starts-with($input, '&quot;')">
                <xsl:variable name="value"
                    select="substring-before(substring-after($input, '&quot;'), '&quot;')"/>
                <result>
                    <xsl:value-of select="normalize-space($value)"/>
                </result>
                <xsl:call-template name="tokenize">
                    <xsl:with-param name="input"
                        select="normalize-space(substring($input, string-length($value) + 3))"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="value"
                    select="substring-before(concat($input, $delimiter), $delimiter)"/>
                <xsl:if test="string($value)">
                    <result>
                        <xsl:value-of select="normalize-space($value)"/>
                    </result>
                </xsl:if>
                <xsl:if test="string(substring-after($input, $delimiter))">
                    <xsl:call-template name="tokenize">
                        <xsl:with-param name="input"
                            select="normalize-space(substring-after($input, $delimiter))"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
