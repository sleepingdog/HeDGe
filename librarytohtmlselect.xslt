<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="xd html hedml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml" 
	xmlns:hedml="http://www.sleepingdog.org.uk/heraldry"
	version="1.0">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="xml" />
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> 2011-01-13</xd:p>
			<xd:p><xd:b>Author:</xd:b> SleepingDog</xd:p>
			<xd:p>Takes a HeDML Basic library XML document and turns it into the inner HTML of a select element.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:template match="/">
		<select>
			<xsl:apply-templates />
		</select>
	</xsl:template>
	<xsl:template match="hedml:library">
		<option value="none">Choose main charge:</option>
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="hedml:charges">
		<optgroup label="{@title}">
			<xsl:apply-templates />
		</optgroup>
	</xsl:template>
	<xsl:template match="hedml:charge">
		<option value="{hedml:svgUrls/hedml:svgUrl[position() = 1]/@href}"><xsl:value-of select="@type"/></option>
	</xsl:template>
</xsl:stylesheet>