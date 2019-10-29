<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:obj="urn:ru:ilb:meta:TestApp:Document" 
    xmlns:req="urn:ru:ilb:meta:TestApp:DocumentListRequest" 
    xmlns:res="urn:ru:ilb:meta:TestApp:DocumentListResponse" exclude-result-prefixes="xsl fo req res obj">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Arial" font-weight="bold" font-style="normal" font-size="10pt" language="ru">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4Form" page-height="29.7cm" page-width="21cm" margin="1cm 1.5cm 1cm 1.5cm">
                    <fo:region-body />
                    <fo:region-after extent="10mm" />
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="A4Form" initial-page-number="1">
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="end" font-size="7pt" font-family="sans-serif" line-height="36pt">
                        <fo:page-number />
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <fo:block-container text-align="center" space-after="2mm">
                        <xsl:apply-templates />
                    </fo:block-container>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    <xsl:template match="res:DocumentListResponse">
        <xsl:variable name="req" select="req:DocumentListRequest" />
        <xsl:if test="$req/following-sibling::*">
            <fo:block text-align="center" space-after="2mm">
                <xsl:text>Список документов </xsl:text>
                <xsl:choose>
                    <xsl:when test = "$req/req:docName">
                        <xsl:text>где наименование содержит строку: </xsl:text>
                        <xsl:value-of select="$req/req:docName" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>с </xsl:text>
                        <xsl:value-of select="$req/req:dateStart" />
                        <xsl:text> по </xsl:text>
                        <xsl:value-of select="$req/req:dateEnd" />
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
            <fo:table width="100%">
                <fo:table-column column-width="15%" />
                <fo:table-column column-width="60%" />
                <fo:table-column column-width="15%" />
                <fo:table-column column-width="10%" />
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell text-align="left" border-width="0.5mm">
                            <fo:block font-size="12pt">Дата</fo:block>
                        </fo:table-cell >
                        <fo:table-cell border-width="0.5mm">
                            <fo:block font-size="12pt">Наименование</fo:block>
                        </fo:table-cell >
                        <fo:table-cell border-width="0.5mm">
                            <fo:block font-size="12pt">Ключевые слова</fo:block>
                        </fo:table-cell >
                        <fo:table-cell border-width="0.5mm">
                            <fo:block font-size="12pt">Удален (да/нет)</fo:block>
                        </fo:table-cell >
                    </fo:table-row>
                    <xsl:for-each select="obj:Document">
                        <fo:table-row space-after="2mm">
                            <fo:table-cell text-align="left" border-width="0.5mm">
                                <fo:block >
                                    <xsl:value-of select="obj:docDate" />
                                </fo:block>
                            </fo:table-cell >
                            <fo:table-cell text-align="left" border-width="0.5mm">
                                <fo:block>
                                    <fo:basic-link external-destination="url(document.php?objectId-0={obj:objectId})" color="blue" text-decoration="underline">
                                        <xsl:value-of select="obj:displayName" />
                                    </fo:basic-link>
                                </fo:block>
                            </fo:table-cell >
                            <fo:table-cell border-width="0.5mm">
                                <fo:block font-size="8pt">
                                    <xsl:value-of select="obj:keywords" />
                                </fo:block>
                            </fo:table-cell >
                            <fo:table-cell text-align="righ" border-width="0.5mm">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test = "obj:deleted='true'">
                                            <xsl:text>да</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>нет</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:block>
                            </fo:table-cell >
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
