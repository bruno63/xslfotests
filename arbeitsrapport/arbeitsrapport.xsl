<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
  <xsl:output method="xml" encoding="UTF-8"/>
  <xsl:template match="worklog">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="A4" page-height="29.7cm" page-width="21cm" margin="2cm">
          <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-reference="A4">
        <fo:flow flow-name="xsl-region-body">
          <fo:block font-size="larger" font-weight="bold" space-after="1em">Arbeitsrapport für             
            <xsl:value-of select="name"/>
          </fo:block>
          <xsl:apply-templates select="entries"/>
            <fo:block>Dies ist ein dritter Test. Asdf ölkj ölkj ölakj asdöflkj asödlkh aösdkfh asdflkajsd fölakj ölkjasöd flkajsdf aösldkfj aösldkfj öalksdjf 
  ölaskdjföalskdj ölkjas döflkja öslkjaölskdjf öalksj ölasjf öalskdjf aösdlkfja sd föasldkfjö aslkdfj aösdlfkja södflkja sdflkajs dföalaksdjf 
  öaslkdfja ösdlkj aölskdjf aösldkjf aösldkfj öalksdjf aölskfjkl jlöjaölsdjkflasdkjföalskdfj  saölfj asdöflkj </fo:block>

        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>
  <xsl:template match="entries">
    <fo:table table-layout="fixed" inline-progression-dimension="100%">
      <fo:table-column column-width="3cm"/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column column-width="2.5cm"/>
      <fo:table-header>
        <fo:table-row>
          <fo:table-cell xsl:use-attribute-sets="cell">
            <fo:block>Datum</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="cell">
            <fo:block>Text</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="cell right">
            <fo:block>Dauer (h)</fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-body>
        <xsl:apply-templates/>
        <fo:table-row font-weight="bold">
          <fo:table-cell xsl:use-attribute-sets="cell" number-columns-spanned="2">
            <fo:block>Total</fo:block>
          </fo:table-cell>
          <fo:table-cell xsl:use-attribute-sets="cell right">
            <fo:block>
              <xsl:value-of select="sum(entry/@duration)"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <xsl:template match="entry">
    <fo:table-row>
      <fo:table-cell xsl:use-attribute-sets="cell">
        <fo:block>
          <xsl:value-of select="@date"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="cell">
        <fo:block>
          <xsl:value-of select="."/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="cell right">
        <fo:block>
          <xsl:value-of select="@duration"/>
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