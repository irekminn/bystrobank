<?xml version="1.0" encoding="UTF-8"?>
<!-- Шаблон формы -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:obj="urn:ru:ilb:meta:TestApp:Document" 
	xmlns:req="urn:ru:ilb:meta:TestApp:DocumentListRequest" 
	xmlns:res="urn:ru:ilb:meta:TestApp:DocumentListResponse" exclude-result-prefixes="xsl req res obj" version="1.0">

	<xsl:output media-type="application/xhtml+xml" method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" />

	<xsl:strip-space elements="*" />

	<xsl:template match="/">
		<html xml:lang="ru">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<title>Список документов</title>
			</head>
			<body onload="">
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>

	<xsl:template match="res:DocumentListResponse">
		<xsl:variable name="req" select="req:DocumentListRequest" />
		<form action="documentList.php">
			<fieldset>
				<input type="hidden" name="run" value="1" />
				<legend>Список документов</legend>
				<div>
					<label title="ГГГГ-ММ-ДД">
						Дата с
						<input size="10" type="text" name="dateStart-0" value="{$req/req:dateStart}" />
					</label>
					<label title="ГГГГ-ММ-ДД">
						по
						<input size="10" type="text" name="dateEnd-0" value="{$req/req:dateEnd}" />
					</label>
				</div>
				<div>
					<label title="Поиск по названию">
						<xsl:text>Содержит: </xsl:text>
						<xsl:element name="input">
							<xsl:attribute name="name">docName-0</xsl:attribute>
							<xsl:attribute name="type">text</xsl:attribute>
							<xsl:attribute name="size">80</xsl:attribute>
							<xsl:if test = "$req/req:docName">
								<xsl:attribute name="value">
									<xsl:value-of select="$req/req:docName" />
								</xsl:attribute>
							</xsl:if>
						</xsl:element>
					</label>
				</div>
				<div>
					<label title="Поиск по названию и без учета даты">
						<xsl:element name="input">
							<xsl:attribute name="name">searchNoDate-0</xsl:attribute>
							<xsl:attribute name="type">checkbox</xsl:attribute>
							<xsl:if test = "$req/req:searchNoDate='on'">
								<xsl:attribute name="checked"></xsl:attribute>
							</xsl:if>
						</xsl:element>
						<xsl:text>поиск без даты</xsl:text>
					</label>
				</div>
				<div>
					<xsl:text>формат отчета: </xsl:text>
					<label title="Формат отчета">
						<xsl:element name="input">
							<xsl:attribute name="name">outputFormat-0</xsl:attribute>
							<xsl:attribute name="type">radio</xsl:attribute>
							<xsl:attribute name="value">html</xsl:attribute>
							<xsl:if test = "$req/req:outputFormat='html'">
								<xsl:attribute name="checked"></xsl:attribute>
							</xsl:if>
						</xsl:element>
						<xsl:text>html</xsl:text>
						<xsl:element name="input">
							<xsl:attribute name="name">outputFormat-0</xsl:attribute>
							<xsl:attribute name="type">radio</xsl:attribute>
							<xsl:attribute name="value">pdf</xsl:attribute>
							<xsl:if test = "$req/req:outputFormat='pdf'">
								<xsl:attribute name="checked"></xsl:attribute>
							</xsl:if>
						</xsl:element>
						<xsl:text>pdf</xsl:text>
					</label>
				</div>
				<div>
					<button type="submit">Отправить</button>
				</div>
			</fieldset>
		</form>
		<xsl:if test="$req/following-sibling::*">
			<table class="report" summary="Тестовый отчет">
				<caption>
					<xsl:text>Список документов </xsl:text>
					<xsl:choose>
						<xsl:when test = "$req/req:docName">
							<xsl:text>где наименование содержит строку: </xsl:text>
							<xsl:value-of select="$req/req:docName" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>с </xsl:text>
							<xsl:value-of select="req:DocumentListRequest/req:dateStart" />
							<xsl:text> по </xsl:text>
							<xsl:value-of select="req:DocumentListRequest/req:dateEnd" />
						</xsl:otherwise>
					</xsl:choose>
				</caption>
				<tr>
					<th>Дата</th>
					<th>Наименование</th>
					<th>Ключевые слова</th>
					<th>Удален (да/нет)</th>
				</tr>
				<xsl:for-each select="obj:Document">
					<tr>
						<td>
							<xsl:value-of select="obj:docDate" />
						</td>
						<td>
							<a href="document.php?objectId-0={obj:objectId}">
								<xsl:value-of select="obj:displayName" />
							</a>
						</td>
						<td>
							<xsl:value-of select="obj:keywords" />
						</td>
						<td>
							<xsl:choose>
								<xsl:when test = "obj:deleted='true'">
									<xsl:text>да</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>нет</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
