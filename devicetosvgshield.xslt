<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	exclude-result-prefixes="xd hedml svg"
	xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:hedml="http://www.sleepingdog.org.uk/heraldry"
	version="1.0">
	<xsl:import href="copy.xslt" />
	<xsl:output omit-xml-declaration="no" media-type="image/svg+xml" indent="yes" method="xml"/>
	<xd:doc scope="stylesheet">
		<xd:desc>
			<xd:p><xd:b>Created on:</xd:b> 2010-12-24</xd:p>
			<xd:p><xd:b>Last modified on:</xd:b> 2013-05-18</xd:p>
			<xd:p><xd:b>Author:</xd:b> SleepingDog</xd:p>
			<xd:p>Takes a Heraldic Device Markup Language, Basic Version (HeDML Basic) 0.1.3 document and outputs a SVG shield.</xd:p>
				<xd:p>Notes:</xd:p>
			<xd:ul>
				<xd:li>device type can be either the default <xd:b>shield</xd:b> (for males) or <xd:b>lozenge</xd:b> for females.</xd:li>
			</xd:ul>
		</xd:desc>
	</xd:doc>
	<xsl:param name="chargeSVGwidth" select="300" />
	<xsl:param name="chargeSVGheight" select="300" />
	<xsl:param name="libraryUrl" select="'library.xml'"/>
	<xsl:variable name="libraryDoc" select="document($libraryUrl)" />
	<xsl:variable name="thisCharge" select="/hedml:device/hedml:charge" />
	<xsl:variable name="matchedCharge" select="$libraryDoc/hedml:library/hedml:charges/hedml:charge[@type = $thisCharge/@type]" />
	<xsl:variable name="matchedChargeUrl" select="$matchedCharge/hedml:svgUrls/hedml:svgUrl/@href" />
	<xsl:variable name="firstMatchedChargeDoc" select="document($matchedChargeUrl[position() = 1])" />
	<xsl:variable name="deviceType" select="hedml:device/@type" />
	<xsl:variable name="properTincture" select="'proper'" />
	<xsl:variable name="tincture" select="/hedml:device/hedml:charge/@tincture" />
	<!-- The shield and lozenge shapes have different space available for the main charge area. -->
	<xsl:variable name="chargeYoffset">
		<xsl:choose>
			<xsl:when test="$deviceType = 'shield'">
				<xsl:value-of select="25"/>
			</xsl:when>
			<xsl:when test="$deviceType = 'lozenge'">
				<xsl:value-of select="80"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="/">
		<svg version="1.1" x="0px" y="0px" width="400px" height="460px" viewBox="0 0 400 460">
			<!-- id="device" style="enable-background:new 0 0 400 460;" -->
			<defs>
				<!-- The shield and the lozenge alternate device types. -->
				<path id="shield" style="stroke:#999999;stroke-miterlimit:10;" d="M398.715,40.996
					c0.249-13.422,0.496-28.496,0.745-40.496c-132.973,0-265.947,0-398.92,0c0.249,12,0.498,26.081,0.747,39.253
					c0.745,30.819,2.485,61.754,5.964,92.823c2.982,30.075,7.457,60.083,13.421,90.157c3.231,15.658,7.955,31.036,14.913,45.698
					c12.427,27.094,28.583,52.178,48.715,75.294c18.144,20.63,37.034,41.004,56.669,60.39c19.387,19.14,39.271,37.526,59.651,55.173
					c20.132-17.149,39.52-35.297,58.408-53.937c19.637-19.387,38.773-39.768,56.672-60.396c19.883-23.116,36.287-48.221,48.713-75.314
					c6.961-14.662,11.932-30.072,14.915-45.731c5.716-30.074,10.437-60.016,13.421-90.09C396.229,102.751,397.969,72.064,398.715,40.996
					z"/>
				<polygon id="lozenge" stroke="#999999" stroke-miterlimit="10" points="200.663,0.762 400.663,230.762 
					200.663,460.762 0.663,230.762 "/>
				<!-- Clip paths for the above so that other shapes are trimmed by their borders. -->
				<clipPath id="shield-clip">
					<use xlink:href="#shield" />
				</clipPath>
				<clipPath id="lozenge-clip">
					<use xlink:href="#lozenge" />
				</clipPath>
				<!-- Divisions. -->
				<rect id="per-pale" x="200" y="0" width="200" height="460"/>
				<rect id="per-fess-shield" x="0" y="205" width="400" height="255"/>
				<rect id="per-fess-lozenge" x="0" y="230" width="400" height="230"/>
				<polygon id="per-bend-shield" points="0 0, 400 410, 400 460, 0 460" />
				<polygon id="per-bend-lozenge" points="0 0, 400 460, 0 460" />
				<polygon id="per-chevron" points="200 205, 400 405, 400 460, 0 460, 0 405" />
				<g id="quarterly-shield">
					<rect x="200" y="0" width="200" height="205" />
					<rect x="0" y="205" width="200" height="255" />
				</g>
				<g id="quarterly-lozenge">
					<rect x="200" y="0" width="200" height="230" />
					<rect x="0" y="230" width="200" height="230" />
				</g>
				<g id="gyronny-shield">
					<polygon points="200 205, 200 0, 400 0" />
					<polygon points="200 205, 400 205, 400 410" />
					<polygon points="200 205, 200 615, -200 615" />
					<polygon points="200 205, 0 205, 0 0" />
				</g>
				<g id="gyronny-lozenge">
					<polygon points="200 230, 200 0, 400 0" />
					<polygon points="200 230, 400 230, 400 460" />
					<polygon points="200 230, 200 460, 0 460" />
					<polygon points="200 230, 0 230, 0 0" />
				</g>
				<g id="per-saltire-shield">
					<polygon points="200 205, 0 410, 0 0" />
					<polygon points="200 205, 400 0, 400 410" />
				</g>
				<g id="per-saltire-lozenge">
					<polygon points="200 230, 0 460, 0 0" />
					<polygon points="200 230, 400 0, 400 460" />
				</g>
				<!-- Furs/patterns -->
				<pattern id="goutty" x="0" y="0" width="100" height="125">
					<path class="{hedml:device/hedml:furpattern/@tincture}" d="M73.915,67.702C69.697,50.966,54.302,25.25,50,25.25S30.304,50.965,26.085,67.702C25.381,70.011,25,72.46,25,75
						c0,13.807,11.193,25,25,25s25-11.193,25-25C75,72.461,74.619,70.011,73.915,67.702z"/>
				</pattern>
				<!-- Ordinaries. -->
				<rect id="chief" x="0" y="0" width="400" height="140" />
				<rect id="pale" x="135" y="0" width="130" height="460" />
				<rect id="fillet-pale" x="180" y="0" width="40" height="460" />
				<rect id="fess-shield" x="0" y="135" width="400" height="140" />
				<rect id="fess-lozenge" x="0" y="160" width="400" height="140" />
				<rect id="barrulet-shield" x="0" y="185" width="400" height="40" />
				<rect id="barrulet-lozenge" x="0" y="210" width="400" height="40" />
				<g id="cross-shield">
					<use xlink:href="#pale" />
					<use xlink:href="#fess-shield" />
				</g>
				<g id="cross-lozenge">
					<use xlink:href="#pale" />
					<use xlink:href="#fess-lozenge" />
				</g>
				<g id="fillet-cross-shield">
					<use xlink:href="#fillet-pale" />
					<use xlink:href="#barrulet-shield" />
				</g>
				<g id="fillet-cross-lozenge">
					<use xlink:href="#fillet-pale" />
					<use xlink:href="#barrulet-lozenge" />
				</g>
				<polygon id="bend-shield" points="0 0, 80 0, 400 330, 400 410, 320 410, 0 80" />
				<polygon id="bend-lozenge" points="0 0, 80 0, 400 380, 400 460, 320 460, 0 80" />
				<polygon id="bend-sinister-shield" points="400 0, 400 80, 80 410, 0 410, 0 330, 320 0" />
				<polygon id="bend-sinister-lozenge" points="400 0, 400 80, 80 460, 0 460, 0 380, 320 0" />
				<polygon id="riband-shield" points="0 0, 28 0, 400 382, 400 410, 382 410, 0 28" />
				<polygon id="riband-lozenge" points="0 0, 28 0, 400 432, 400 460, 382 460, 0 28" />
				<polygon id="riband-sinister-shield" points="400 0, 400 28, 28 410, 0 410, 0 382, 372 0" />
				<polygon id="riband-sinister-lozenge" points="400 0, 400 28, 28 460, 0 460, 0 432, 372 0" />
				<g id="saltire-shield">
					<use xlink:href="#bend-shield" />
					<use xlink:href="#bend-sinister-shield" />
				</g>
				<g id="saltire-lozenge">
					<use xlink:href="#bend-lozenge" />
					<use xlink:href="#bend-sinister-lozenge" />
				</g>
				<g id="fillet-saltire-shield">
					<use xlink:href="#riband-shield" />
					<use xlink:href="#riband-sinister-shield" />
				</g>
				<g id="fillet-saltire-lozenge">
					<use xlink:href="#riband-lozenge" />
					<use xlink:href="#riband-sinister-lozenge" />
				</g>
				<polygon id="chevron" points="200 165, 400 365, 400 445, 200 245, 0 445, 0 365" />
				<!-- Charges. -->
				<g id="charge-main">
					<!-- SVG for optional main charge will go here. Due to current browser (webkit) limitations,
						this was attempted through post-transformation node manipulation instead of XSLT.
						However, the workarounds were more problematic, and this is Firefox + Opera supported.-->
					<!-- If the charge type specified matches one from the available library charges, render it. -->
					<xsl:if test="not($thisCharge/@type = 'none') and not($thisCharge/@tincture = 'none')">
						<xsl:comment>Charge has type and tincture = <xsl:value-of select="$thisCharge/@tincture"/>.</xsl:comment>
						<xsl:if test="$matchedCharge">
							<xsl:comment>test="$matchedCharge"</xsl:comment>
							<xsl:for-each select="$firstMatchedChargeDoc">
								<xsl:apply-templates mode="svg"><!-- select="$firstMatchedChargeDoc"  -->
									<xsl:with-param name="tincture" select="$thisCharge/@tincture" />
									<xsl:with-param name="chargeSVGwidth" select="$chargeSVGwidth" />
									<xsl:with-param name="chargeSVGheight" select="$chargeSVGheight" />
									<xsl:with-param name="deviceType" select="$deviceType" />
								</xsl:apply-templates>
							</xsl:for-each>
						</xsl:if>
					</xsl:if>
				</g>
			</defs>
			<xsl:variable name="furPattern">
				<xsl:if test="not(hedml:device/hedml:furpattern/@type = 'none') and not(hedml:device/hedml:furpattern/@tincture
					= 'none')"><xsl:value-of select="concat('fill: url(#', hedml:device/hedml:furpattern/@type, '); ')"/></xsl:if>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$deviceType = 'shield'">
					<use xlink:href="#shield" class="{/hedml:device[@type='shield']/hedml:field/@tincture}" style="{$furPattern}" />
				</xsl:when>
				<xsl:when test="$deviceType = 'lozenge'">
					<use xlink:href="#lozenge" class="{/hedml:device[@type='lozenge']/hedml:field/@tincture}" style="{$furPattern}" />
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates mode="hedml" />
			<!-- Display main charge (if selected and the charge type matches one from the available library charges) here. -->
			<use xlink:href="#charge-main" style="clip-path: url(#{$deviceType}-clip);" />
		</svg>
	</xsl:template>
	<xsl:template match="hedml:divisions" mode="hedml">
		<xsl:if test="not(@type = 'none') and not(@tincture = 'none')">
			<!-- Match the division type to the SVG shape ID,
				replacing spaces with hyphens (IDs cannot have spaces); and
				tweaking for different shield/lozenge and possibly dexter/sinister variants.-->
			<xsl:variable name="divisionId">
				<xsl:value-of select="translate(@type, ' ', '-')"/>
				<xsl:if test="not(@type = 'per pale') and not(@type = 'per chevron')">
					<xsl:value-of select="concat('-', $deviceType)"/>
				</xsl:if>
			</xsl:variable>
			<use xlink:href="#{$divisionId}" class="{@tincture}" style="clip-path: url(#{$deviceType}-clip);" />
		</xsl:if>
	</xsl:template>
	<xsl:template match="hedml:ordinary" mode="hedml">
		<xsl:if test="not(@type = 'none') and not(@tincture = 'none')">
			<!-- Match the ordinary type to the SVG shape ID,
				replacing spaces with hyphens (IDs cannot have spaces); and
				tweaking for different shield/lozenge and possibly dexter/sinister variants.-->
			<xsl:variable name="ordinaryId">
				<xsl:value-of select="translate(@type, ' ', '-')"/>
				<xsl:if test="not(@type = 'chief') and not(@type = 'pale') and not(@type = 'chevron')">
					<xsl:value-of select="concat('-', $deviceType)"/>
				</xsl:if>
			</xsl:variable>
			<use xlink:href="#{$ordinaryId}" class="{@tincture}" style="clip-path: url(#{$deviceType}-clip);" />
		</xsl:if>
	</xsl:template>
	<xsl:template match="svg:svg" mode="svg">
		<xsl:element name="svg" namespace="http://www.w3.org/2000/svg">
			<xsl:for-each select="@*[not(local-name() = 'x') or not(local-name() = 'y') or not(local-name() = 'preserveAspectRatio') or not(local-name() = 'width') or not(local-name() = 'height') or not(local-name() = 'viewBox')]">
				<xsl:copy-of select="." />
			</xsl:for-each>
			<xsl:attribute name="x"><xsl:value-of select="50"/></xsl:attribute>
			<xsl:attribute name="preserveAspectRatio"><xsl:value-of select="'xMidYMid meet'"/></xsl:attribute>
			<xsl:attribute name="y"><xsl:value-of select="$chargeYoffset"/></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="$chargeSVGwidth"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="$chargeSVGheight"/></xsl:attribute>
			<xsl:attribute name="viewBox"><xsl:value-of select="concat('0 0 ',
				translate(string(@width),'px',''),' ', translate(string(@height),'px',''))"/></xsl:attribute>
				<xsl:apply-templates />
			</xsl:element>
			<xsl:comment>
				<xsl:value-of select="concat('$tincture = ', $tincture)"/></xsl:comment>
			<xsl:comment>
				<xsl:value-of select="concat('$properTincture = ', $properTincture)"/></xsl:comment>
			<xsl:comment>
				<xsl:value-of select="concat('$chargeSVGwidth = ', $chargeSVGwidth)"/></xsl:comment>
			<xsl:comment>
				<xsl:value-of select="concat('$chargeSVGheight = ', $chargeSVGheight)"/></xsl:comment>
		</xsl:template>
	<xsl:template match="//svg:*/@class">
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
	<!-- Remove script elements. -->
	<xsl:template match="//svg:script" />
	<!-- Remove event attributes. -->
	<xsl:template match="//svg:*/@*[starts-with(local-name(.), 'on')]" />
</xsl:stylesheet>
