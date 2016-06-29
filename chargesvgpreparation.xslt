<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg" exclude-result-prefixes="xd"
	xmlns:hedml="http://www.sleepingdog.org.uk/heraldry"
	xml:space="default" version="1.0">
	<xsl:import href="copy.xslt" />
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> 2011-01-18</xd:p>
			<xd:p><xd:b>Last modified on:</xd:b> 2011-01-28</xd:p>
			<xd:p><xd:b>Author:</xd:b> SleepingDog</xd:p>
			<xd:p>Takes a Scalable Vector Graphics heraldic charge document and prepares it for combining with the device
			SVG.</xd:p>
			<xd:p>If a tincture parameter value is passed in, this should replace 'proper' in the charge SVG classes.</xd:p>
		</xd:desc>
	</xd:doc>
	<xsl:variable name="properTincture" select="'proper'" />
	<xsl:template match="svg:svg" mode="svg">
		<xsl:param name="tincture" />
		<xsl:param name="deviceType" />
		<xsl:param name="chargeSVGwidth" />
		<xsl:param name="chargeSVGheight" />
		<!-- The shield and lozenge shapes have different space available for the main charge area. -->
		<xsl:variable name="chargeYoffset">
			<xsl:choose>
				<xsl:when test="$deviceType = 'shield'">
					<xsl:value-of select="50"/>
				</xsl:when>
				<xsl:when test="$deviceType = 'lozenge'">
					<xsl:value-of select="80"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- 
		<xsl:element name="svg" namespace="http://www.w3.org/2000/svg">
			<xsl:attribute name="preserveAspectRatio"><xsl:value-of select="'xMidYMid meet'"/></xsl:attribute>
			<xsl:attribute name="x"><xsl:value-of select="50"/></xsl:attribute>
			<xsl:attribute name="y"><xsl:value-of select="$chargeYoffset"/></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="$chargeSVGwidth"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="$chargeSVGheight"/></xsl:attribute>
			<xsl:attribute name="viewBox"><xsl:value-of select="concat('0 0 ',
				translate(string(@width),'px',''),' ', translate(string(@height),'px',''))"/></xsl:attribute>
		-->
			
			<!-- <xsl:value-of select="@viewBox"/> -->
			<xsl:comment>
				<xsl:value-of select="concat('$tincture = ', $tincture)"/></xsl:comment>
			<xsl:comment>
				<xsl:value-of select="concat('$properTincture = ', $properTincture)"/></xsl:comment>
			<xsl:comment>
				<xsl:value-of select="concat('$chargeSVGwidth = ', $chargeSVGwidth)"/></xsl:comment>
			<xsl:comment>
				<xsl:value-of select="concat('$chargeSVGheight = ', $chargeSVGheight)"/></xsl:comment>
		<!-- 
		</xsl:element>
		-->
		<xsl:copy>
		<xsl:apply-templates>
			<xsl:with-param name="tincture" select="$tincture" />
			<xsl:with-param name="deviceType" />
			<xsl:with-param name="chargeSVGwidth" />
			<xsl:with-param name="chargeSVGheight" />
			<xsl:with-param name="chargeYoffset" />
		</xsl:apply-templates>
			
		</xsl:copy>
	</xsl:template>
<!--
	<xsl:template match="svg:svg/@viewBox"><xsl:attribute name="{name()}"><xsl:value-of select="concat('0 0 ',
		parent::svg:svg/@width,' ', parent::svg:svg/@height)"/></xsl:attribute></xsl:template>
-->	
	<xsl:template match="//svg:*/@class">
		<xsl:param name="tincture" />
		<xsl:attribute name="class">
			<xsl:choose>
				<xsl:when test="not($tincture = 'proper') and contains(., $properTincture)">
					<xsl:value-of select="concat(substring-before(., $properTincture), $tincture, substring-after(., $properTincture))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	<!-- Replace attribute values in SVG root element. -->
	<xsl:template match="svg:svg/@preserveAspectRatio">
		<xsl:attribute name="preserveAspectRatio"><xsl:value-of select="'xMidYMid meet'"/></xsl:attribute>	
	</xsl:template>
	<xsl:template match="svg:svg/@x">
		<xsl:attribute name="x"><xsl:value-of select="50"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="svg:svg/@y">
		<xsl:param name="chargeYoffset" />
		<xsl:attribute name="y"><xsl:value-of select="$chargeYoffset"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="svg:svg/@width">
		<xsl:param name="chargeSVGwidth" />
		<xsl:attribute name="width"><xsl:value-of select="$chargeSVGwidth"/></xsl:attribute>
	</xsl:template>
	<xsl:template match="svg:svg/@height">
		<xsl:param name="chargeSVGheight" />
		<xsl:attribute name="height"><xsl:value-of select="$chargeSVGheight"/></xsl:attribute>
	</xsl:template>
	<!-- 
	<xsl:template match="svg:svg/@viewBox">
		<xsl:attribute name="viewBox"><xsl:value-of select="concat('0 0 ',
			translate(string(@width),'px',''),' ', translate(string(@height),'px',''))"/></xsl:attribute>
	</xsl:template>
	-->
	<!-- Remove script elements. -->
	<xsl:template match="//svg:script" />
	<!-- Remove event attributes. -->
	<xsl:template match="//svg:*/@*[starts-with(local-name(.), 'on')]" />
	<!-- Remove extra hedml elements. -->
	<xsl:template match="hedml:*" />
</xsl:stylesheet>
