<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:structure="http://www.jeremias-maerki.ch/ns/document/structure"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:func="http://exslt.org/functions"
  xmlns:exslt="http://exslt.org/common"
  xmlns:f="http://local-functions"
  xmlns:l10n="http://jeremias-maerki.ch/l10n"
  xmlns:jm="http://www.jeremias-maerki.ch/ns/xpath"
  extension-element-prefixes="func exslt jm">
  
  <xsl:import href="../../src/java/META-INF/XSLT/lib-esr2fo-2.0.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" />
  
  <xsl:variable name="esr-minimal-border">3mm</xsl:variable>
  
  <xsl:template match="invoices">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="A4" page-height="29.7cm" page-width="21cm" margin="2cm">
          <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <xsl:apply-templates select="invoice"/>
    </fo:root>
  </xsl:template>
  <xsl:template match="invoice">
    <fo:page-sequence master-reference="A4">
      <fo:flow flow-name="xsl-region-body">
        <fo:block text-align="right" margin-bottom="1cm">
          <fo:external-graphic content-width="1.7in" scaling="uniform" src="url(logo100.svg)"/>
        </fo:block>
        <fo:block><xsl:value-of select="esr/recipient/name"/></fo:block>
        <fo:block>
          <xsl:value-of select="esr/recipient/street-name"/>
          <xsl:value-of select="esr/recipient/civic-number"/>
        </fo:block>
        <fo:block margin-bottom="2em">
          <xsl:value-of select="esr/recipient/zip"/>
          <xsl:value-of select="esr/recipient/city"/>
        </fo:block>
        <fo:block margin-bottom="1em">
          Stäfa, <xsl:value-of select="../invoiceDate"/>
        </fo:block>
        <fo:block font-size="larger" font-weight="bold" space-after="1em">
          <xsl:value-of select="../title"/>
        </fo:block>
        <fo:block margin-bottom="1em">
          <xsl:value-of select="salutation"/>
        </fo:block>
        <fo:block margin-bottom="1em" >Dein diesjähriger Mitgliederbeitrag setzt sich wie folgt zusammen:</fo:block>
        <xsl:apply-templates select="categoryList" />
        <fo:block margin-top="1em" margin-bottom="2em">Wir bitten dich höflich um Begleichung dieses Betrages bis spätestens       
        <fo:inline font-weight="bold" space-after="1em">
          <xsl:value-of select="../paymentDate" />
        </fo:inline>
        mittels beiliegendem Einzahlungsschein.</fo:block>
        <fo:block margin-bottom="1em">Mit rudersportlichen Grüssen</fo:block>
        <fo:block margin-bottom="1em">Seeclub Stäfa, Chef Finanzen, Kurt Pfeiffer</fo:block>
        <!--fo:block margin-bottom="2em">*) Vom SRV-Beitrag ausgenommen sind Junioren (Jahrgang 1998 und jünger) 
        sowie Doppelmitglieder, welche den Verbandsbeitrag bei einem anderen Ruderclub bezahlen.</fo:block-->
        <!--fo:block>Adressmutationen bitte laufend mitteilen an 
          <fo:inline text-decoration="underline">
            <fo:basic-link>
              <xsl:attribute name="external-destination">mailto:barbara@bkaiser.ch</xsl:attribute>barbara@bkaiser.ch
            </fo:basic-link>
          </fo:inline>.
        </fo:block-->
        <xsl:apply-templates select="esr" mode="form">
          <xsl:with-param name="top" select="concat('297mm - 1 * ', $esr-height)"/>
          <xsl:with-param name="left" select="'0mm'"/>
          <xsl:with-param name="form" select="'442.05'"/>
          <xsl:with-param name="debug" select="1"/>
          <xsl:with-param name="raster" select="0"/>
        </xsl:apply-templates>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  <xsl:template match="categoryList">
    <fo:table table-layout="fixed" inline-progression-dimension="100%">
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="4cm"/>
      <fo:table-header>
        <fo:table-row>
          <fo:table-cell xsl:use-attribute-sets="cell">
            <fo:block>Kategorie</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="cell right">
            <fo:block>Betrag</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-body>
        <xsl:apply-templates/>
        <fo:table-row font-weight="bold">
          <fo:table-cell xsl:use-attribute-sets="cell">
            <fo:block>Total</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="cell right">
            <fo:block>
              <xsl:value-of select="format-number(sum(category/@amount), 'CHF ###.00')"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <xsl:template match="category">
  <fo:table-row>
    <fo:table-cell xsl:use-attribute-sets="cell">
      <fo:block>
        <xsl:value-of select="@name"/>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="cell right">
      <fo:block>
        <xsl:value-of select="format-number(@amount, 'CHF ###.00')" />
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
</xsl:template>
  <xsl:attribute-set name="cell">
    <xsl:attribute name="padding">1mm</xsl:attribute>
    <xsl:attribute name="border">solid 1pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="right">
    <xsl:attribute name="text-align">end</xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>
