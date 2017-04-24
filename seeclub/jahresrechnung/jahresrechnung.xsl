<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:bk="http://www.bkaiser.com/2017/ns/seeclub"
  version="1.0">
  <xsl:output method="xml" encoding="UTF-8"/>
  <!-- Gesamtoutput -->
  <xsl:template match="bk:memberList">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="A4" page-height="29.7cm" page-width="21cm" margin="1.5cm">
          <fo:region-body/>
          <fo:region-after region-name="footer" extent="2cm"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <xsl:apply-templates select="bk:member"/>
    </fo:root>
  </xsl:template>
  <!-- Rechnung -->
  <xsl:template match="bk:member">
    <fo:page-sequence master-reference="A4">
    <!-- Footer -->
      <fo:static-content flow-name="footer">
        <fo:table font-size="8pt" width="15cm" table-layout="fixed">
          <fo:table-column column-number="1" column-width="40mm"/>
          <fo:table-column column-number="2" column-width="40mm"/>
          <fo:table-column column-number="3" column-width="50mm"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell column-number="1" display-align="after">
                <fo:block>Seeclub Stäfa</fo:block>
                <fo:block>
                  <fo:inline text-decoration="underline">
                    <fo:basic-link>
                      <xsl:attribute name="external-destination">
                        http://www.seeclub-staefa.ch
                      </xsl:attribute>
                      www.seeclub-staefa.ch
                    </fo:basic-link>
                  </fo:inline>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell column-number="2" display-align="after">
                <fo:block>Kurt Pfeiffer</fo:block>
                <fo:block>Eichstrasse 42</fo:block>
                <fo:block>8712 Stäfa</fo:block>
              </fo:table-cell>
              <fo:table-cell column-number="3" display-align="after">
                <fo:block>044 796 3262</fo:block>
                <fo:block>
                <fo:inline text-decoration="underline">
                    <fo:basic-link>
                      <xsl:attribute name="external-destination">
                        mailto:kurtpfeiffer@bluewin.ch
                      </xsl:attribute>
                      kurtpfeiffer@bluewin.ch
                    </fo:basic-link>
                  </fo:inline>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <fo:block text-align="right" margin-bottom="1cm">
          <fo:external-graphic content-width="1.7in" scaling="uniform" src="url(logo100.svg)"/>
        </fo:block>
        <fo:block><xsl:value-of select="bk:address/bk:name"/></fo:block>
        <fo:block><xsl:value-of select="bk:address/bk:street"/></fo:block>
        <fo:block margin-bottom="2em"><xsl:value-of select="bk:address/bk:city"/></fo:block>
        <fo:block margin-bottom="1em">
          Stäfa, <xsl:value-of select="../bk:date"/>
        </fo:block>
        <fo:block font-size="larger" font-weight="bold" space-after="2em">
          <xsl:value-of select="../bk:title"/>
        </fo:block>
        <fo:block margin-bottom="1em">
          <xsl:value-of select="bk:salutation"/>
        </fo:block>
        <fo:block margin-bottom="1em" >Der diesjährige Mitgliederbeitrag setzt sich wie folgt zusammen:</fo:block>
        <xsl:apply-templates select="bk:categoryList" />
        <fo:block margin-top="1em" margin-bottom="2em">Wir bitten dich höflich um Begleichung dieses Betrages bis spätestens       
        <fo:inline font-weight="bold" space-after="1em">
          <xsl:value-of select="../bk:paymentDate" />
        </fo:inline>
        mittels beiliegendem Einzahlungsschein.</fo:block>
        <fo:block margin-bottom="1em">Mit rudersportlichen Grüssen</fo:block>
        <fo:block margin-bottom="2em">Seeclub Stäfa</fo:block>
        <fo:block>Kurt Pfeiffer</fo:block>
        <fo:block margin-bottom="4em">Chef Finanzen</fo:block>
        <fo:block margin-bottom="2em">*) Vom SRV-Beitrag ausgenommen sind Junioren (Jahrgang 1998 und jünger) 
        sowie Doppelmitglieder, welche den Verbandsbeitrag bei einem anderen Ruderclub bezahlen.</fo:block>
        <fo:block>Adressmutationen bitte laufend mitteilen an 
          <fo:inline text-decoration="underline">
            <fo:basic-link>
              <xsl:attribute name="external-destination">mailto:barbara@bkaiser.ch</xsl:attribute>barbara@bkaiser.ch
            </fo:basic-link>
          </fo:inline>.
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  <xsl:template match="bk:categoryList">
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
              <xsl:value-of select="format-number(sum(bk:category/@amount), 'CHF ###.00')"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>
  <xsl:template match="bk:category">
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