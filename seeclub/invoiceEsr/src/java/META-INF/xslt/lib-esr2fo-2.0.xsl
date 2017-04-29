<?xml version="1.0" encoding="UTF-8"?>
<!--

World Of Documents - Generic ESR Stylesheet for XSL-FO Output
Original Author: Jeremias Märki, Switzerland, info@jeremias-maerki.ch
Website: http://wod.jeremias-maerki.ch

This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Switzerland License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ch/.

$Id: lib-esr2fo-2.0.xsl 5122 2016-05-12 08:46:16Z jeremias $

-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:common="http://exslt.org/common"
  xmlns:str="http://exslt.org/strings"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:func="http://exslt.org/functions">
  
  <!-- Template for ESR values: <esr code="10" account="01-999999-7" ref="012345" amount="123.45"/> -->
  
  <xsl:variable name="esr-height" select="'106mm'"/>
  <xsl:variable name="esr-minimal-border" select="'3mm'"/>
  <xsl:variable name="esr-font-size-444.01" select="'8pt'"/>
  <xsl:variable name="esr-recipient-font-size-444.01" select="'10pt'"/>

  <xsl:variable name="esr-text-font" select="'Frutiger 45 Light, sans-serif'"/>
  <xsl:variable name="esr-ocrb-font" select="'OCR-B 10 BT, OCR-B, OCRB'"/>
  
  <xsl:attribute-set name="esr-text-box">
    <xsl:attribute name="background-color">transparent</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="esr-ocr-font" use-attribute-sets="esr-text-box">
    <xsl:attribute name="font-family"><xsl:value-of select="$esr-ocrb-font"/></xsl:attribute>
    <xsl:attribute name="font-size">1in div 6</xsl:attribute>
    <xsl:attribute name="line-height">1.0</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="esr-account-font" use-attribute-sets="esr-ocr-font"> 
    <xsl:attribute name="font-size">1in div 8</xsl:attribute>   
  </xsl:attribute-set>
    
  <xsl:attribute-set name="esr-normal-font" use-attribute-sets="esr-text-box">
    <xsl:attribute name="font-family"><xsl:value-of select="$esr-text-font"/></xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">8pt</xsl:attribute>
    <xsl:attribute name="line-height">1.2</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="esr-recipient-font" use-attribute-sets="esr-normal-font"/>
  <xsl:attribute-set name="esr-payer-font" use-attribute-sets="esr-recipient-font"/>
  <xsl:attribute-set name="esr-payer-receipt-font" use-attribute-sets="esr-normal-font"/>
  <xsl:attribute-set name="esr-reference-line-font" use-attribute-sets="esr-ocr-font"/>
  
  <xsl:attribute-set name="esr-normal-font-444.01" use-attribute-sets="esr-normal-font">
    <xsl:attribute name="font-size"><xsl:value-of select="$esr-font-size-444.01"/></xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="esr-account-font-444.01" use-attribute-sets="esr-normal-font-444.01"/> 
  
  <!-- Special treatment for recipient addresses to fit text on the pre-printed lines -->
  <xsl:attribute-set name="esr-recipient-font-444.01" use-attribute-sets="esr-normal-font-444.01">
    <xsl:attribute name="font-size"><xsl:value-of select="$esr-recipient-font-size-444.01"/></xsl:attribute>
    <xsl:attribute name="line-height">8mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="esr-recipient-receipt-font-444.01" use-attribute-sets="esr-normal-font-444.01">
    <xsl:attribute name="line-height">5mm</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Override to adjust for smaller printable areas -->
  <xsl:attribute-set name="esr-left-margin-adjustment">
    <xsl:attribute name="start-indent"><xsl:value-of select="$esr-minimal-border"/> - 3mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="esr-right-margin-adjustment">
    <xsl:attribute name="end-indent"><xsl:value-of select="$esr-minimal-border"/> - 3mm</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="esr-left-margin-adjustment-444.01">
    <xsl:attribute name="start-indent"><xsl:value-of select="$esr-minimal-border"/> - 3mm</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="esr-right-margin-adjustment-444.01">
    <!-- xsl:attribute name="end-indent"><xsl:value-of select="$esr-minimal-border"/> - 5mm</xsl:attribute-->
  </xsl:attribute-set>
  
  <xsl:attribute-set name="esr-444.01-box" use-attribute-sets="esr-text-box">
    <xsl:attribute name="font-family"><xsl:value-of select="$esr-ocrb-font"/>, <xsl:value-of select="$esr-text-font"/></xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="padding-top">2pt</xsl:attribute>
    <xsl:attribute name="start-indent">2mm + inherited-property-value()</xsl:attribute>
    <xsl:attribute name="end-indent">2mm + inherited-property-value()</xsl:attribute>
    <xsl:attribute name="background-color">transparent</xsl:attribute>
  </xsl:attribute-set>
    
  <xsl:attribute-set name="missing">
    <xsl:attribute name="color">red</xsl:attribute>
    <xsl:attribute name="text-decoration">line-through</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- ==================================================================== Checksums -->
  
  <xsl:variable name="checksum-modulo10-table" select="str:split('0,9,4,6,8,2,7,1,3,5', ',')"/>
  <xsl:template name="checksum-modulo10">
    <xsl:param name="numbers"/>
    <xsl:param name="prevval" select="0"/>
    <xsl:variable name="digit" select="number(substring($numbers, 1, 1))"/>
    <xsl:choose>
      <xsl:when test="string-length($numbers) &gt; 0">
        <xsl:call-template name="checksum-modulo10">
          <xsl:with-param name="numbers" select="substring($numbers, 2)"/>
          <xsl:with-param name="prevval" select="$checksum-modulo10-table[(($prevval + $digit) mod 10) + 1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="(10 - $prevval) mod 10"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ==================================================================== Applied templates -->
  
  <xsl:decimal-format name="esr" decimal-separator="." grouping-separator="|"/>
  
  <xsl:template match="esr" mode="esr-coding-line">
    <xsl:variable name="accsplit" select="str:split(@account, '-')"/>
    <xsl:variable name="code-padded" select="str:align(@code, '00', 'right')"/>
    
    <xsl:variable name="part1">
      <xsl:choose>
        <xsl:when test="@amount">
          <xsl:variable name="amount-formatted" select="format-number(@amount, '0.00', 'esr')"/>
          <xsl:variable name="amountint">
            <xsl:choose>
              <xsl:when test="contains(@amount, '.')">
                <xsl:value-of select="substring-before($amount-formatted, '.')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$amount-formatted"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="amountdec">
            <xsl:choose>
              <xsl:when test="contains(@amount, '.')">
                <xsl:value-of select="substring-after($amount-formatted, '.')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="0"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="amountint-padded" select="str:align($amountint, '00000000', 'right')"/>
          <xsl:variable name="amountdec-padded" select="str:align($amountdec, '00', 'right')"/>
          <xsl:value-of select="concat($code-padded, $amountint-padded, $amountdec-padded)"/>
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:value-of select="$code-padded"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable> 
    
    <xsl:value-of select="$part1"/>
    <xsl:call-template name="checksum-modulo10">
      <xsl:with-param name="numbers" select="$part1"/>
    </xsl:call-template>
    <xsl:text>&gt;</xsl:text>
    <xsl:value-of select="str:align(@ref, '000000000000000000000000000', 'right')"/>
    <xsl:text>+&#160;</xsl:text>
    <xsl:value-of select="str:align($accsplit[1], '00', 'right')"/>
    <xsl:value-of select="str:align($accsplit[2], '000000', 'right')"/>
    <xsl:value-of select="str:align($accsplit[3], '0', 'right')"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="token" mode="esr-blocking-right">
    <xsl:param name="blocking-char" select="'&#160;'"/>
    <xsl:param name="block-size" select="5"/>
    <xsl:variable name="rpos" select="last() - position() + 1"></xsl:variable>
    <xsl:if test="($rpos mod $block-size) = 0">
      <xsl:value-of select="$blocking-char"/>
    </xsl:if>
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="token" mode="esr-blocking-left">
    <xsl:param name="blocking-char" select="'&#160;'"/>
    <xsl:param name="block-size" select="4"/>
    <xsl:variable name="rpos" select="position() - 1"></xsl:variable>
    <xsl:value-of select="."/>
    <xsl:if test="($rpos mod $block-size) = $block-size - 1">
      <xsl:value-of select="$blocking-char"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="esr" mode="esr-reference-line-blocked">
    <xsl:variable name="aligned" select="str:align(normalize-space(@ref), '000000000000000000000000000', 'right')"/>
    <xsl:variable name="tokenized" select="str:tokenize($aligned, '')"/>
    <xsl:apply-templates select="$tokenized" mode="esr-blocking-right"/>
  </xsl:template>

  <xsl:template match="esr" mode="esr-account">
    <xsl:value-of select="@account"/>
  </xsl:template>
  
  <xsl:template match="esr" mode="esr-currency">
    <xsl:value-of select="@currency"/>
  </xsl:template>
  
  <xsl:template match="esr/@account" mode="esr-iban">
    <xsl:variable name="accsplit" select="str:split(., '-')"/>
    <xsl:text>CH9109000000</xsl:text>
    <xsl:value-of select="str:align($accsplit[1], '00', 'right')"/>
    <xsl:value-of select="str:align($accsplit[2], '000000', 'right')"/>
    <xsl:value-of select="str:align($accsplit[3], '0', 'right')"/>
  </xsl:template>
  
  <xsl:template match="esr" mode="esr-iban">
    <xsl:value-of select="biller/iban"/>
  </xsl:template>
  <xsl:template match="esr" mode="esr-iban-blocked">
    <xsl:choose>
      <xsl:when test="biller/iban">
        <xsl:variable name="tokenized" select="str:tokenize(biller/iban, '')"/>
        <xsl:apply-templates select="$tokenized" mode="esr-blocking-left"/>
      </xsl:when>
      <xsl:when test="@account">
        <xsl:variable name="derived-iban">
          <xsl:apply-templates select="@account" mode="esr-iban"/>
        </xsl:variable>
        <xsl:variable name="tokenized" select="str:tokenize($derived-iban, '')"/>
        <xsl:apply-templates select="$tokenized" mode="esr-blocking-left"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">esr-iban-blocked mode template is missing either biller/iban or @account.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="esr" mode="esr-amount-integer">
    <xsl:variable name="amount-formatted" select="format-number(@amount, '0.00', 'esr')"/>
    <xsl:value-of select="substring-before($amount-formatted, '.')"/>
  </xsl:template>
  
  <xsl:template match="esr" mode="esr-amount-cents">
    <xsl:variable name="amount-formatted" select="format-number(@amount, '0.00', 'esr')"/>
    <xsl:value-of select="substring-after($amount-formatted, '.')"/>
  </xsl:template>
  
  <xsl:template name="esr-create-qr-message">
    <xsl:text>BV01&#x0A;</xsl:text>
    <xsl:choose>
      <xsl:when test="biller/iban">
        <xsl:value-of select="substring(biller/iban, 1, 34)"/><xsl:text>&#x0A;</xsl:text>
      </xsl:when>
      <xsl:when test="@account">
        <xsl:variable name="derived-iban">
          <xsl:apply-templates select="@account" mode="esr-iban"/>
        </xsl:variable>
        <xsl:value-of select="substring($derived-iban, 1, 34)"/><xsl:text>&#x0A;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">esr-iban-blocked mode template is missing either biller/iban or @account.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="substring(biller/name, 1, 35)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="substring(biller/zip, 1, 10)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="substring(biller/city, 1, 25)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:choose>
      <xsl:when test="string-length(biller/country) = 2">
        <xsl:value-of select="biller/country"/>
      </xsl:when>
      <xsl:otherwise>CH</xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:if test="@amount">
      <xsl:value-of select="format-number(@amount, '0.00', 'esr')"/>
    </xsl:if>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:choose>
      <xsl:when test="string-length(@currency) = 3">
        <xsl:value-of select="@currency"/>
      </xsl:when>
      <xsl:otherwise>CHF</xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#x0A;</xsl:text>
    
    <xsl:value-of select="substring(recipient/name, 1, 35)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="substring(recipient/street-name, 1, 30)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="substring(recipient/civic-number, 1, 5)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="substring(recipient/zip, 1, 10)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="substring(recipient/city, 1, 25)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="substring(recipient/country, 1, 2)"/><xsl:text>&#x0A;</xsl:text>
    
    <xsl:value-of select="substring(@ref, 1, 27)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="substring(payment-purpose, 1, 140)"/><xsl:text>&#x0A;</xsl:text>
    <xsl:if test="execution-date">
      <xsl:value-of select="date:format-date(execution-date, 'yyyMMdd')"/>
    </xsl:if>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:value-of select="substring(custom-data, 1, 35)"/><xsl:text>&#x0A;</xsl:text>
  </xsl:template>
  
  <!-- ==================================================================== Named templates -->

  <xsl:template name="esr-coding-line">
    <xsl:choose>
      <xsl:when test="@ref">
        <fo:block>
          <xsl:apply-templates select="." mode="esr-coding-line"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="missing">0100000000000&gt;000000000000000000000000000+ 010000000&gt;</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="esr-reference-line">
    <xsl:choose>
      <xsl:when test="@ref">
        <fo:block>
          <xsl:apply-templates select="." mode="esr-reference-line-blocked"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="missing">00 00000 00000 00000 00000 00000</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="esr-reference-receipt-line">
    <xsl:param name="esr"/>
    <!--fo:block font-size="65%" line-height="1in div 6" alignment-baseline="middle"-->
    <fo:block font-size="60%" line-height="1in div 6" alignment-baseline="middle">
      <xsl:call-template name="esr-reference-line"/>
    </fo:block>
  </xsl:template>
    
  <xsl:template name="esr-reference-line-444.01">
    <fo:block xsl:use-attribute-sets="esr-444.01-box">
      <xsl:choose>
        <xsl:when test="@ref">
          <xsl:apply-templates select="." mode="esr-reference-line-blocked"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>--------------------------------</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  
  
  <xsl:template name="esr-account">
    <xsl:choose>
      <xsl:when test="@account">
        <fo:block>
          <xsl:apply-templates select="." mode="esr-account"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="missing">01-000000-0</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="esr-account-444.01">
    <xsl:choose>
      <xsl:when test="biller/iban|@account">
        <fo:block xsl:use-attribute-sets="esr-account-font-444.01">
          <xsl:apply-templates select="." mode="esr-iban-blocked"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="esr-account-font-444.01 missing">CH11 2233 4455 6677 8899 0</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="esr-currency-444.01">
    <xsl:choose>
      <xsl:when test="@currency">
        <fo:block xsl:use-attribute-sets="esr-account-font-444.01">
          <xsl:apply-templates select="." mode="esr-currency"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="esr-account-font-444.01 missing">CHF</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="esr-amount">
    <xsl:choose>
      <xsl:when test="@amount">
        <fo:block>
          <xsl:apply-templates select="." mode="esr-amount-integer"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="missing">00000000</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="esr-amount-444.01">
    <xsl:choose>
      <xsl:when test="@amount">
        <fo:block xsl:use-attribute-sets="esr-444.01-box">
          <xsl:apply-templates select="." mode="esr-amount-integer"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="esr-444.01-box missing">00000000</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="esr-amount-cents">
    <xsl:choose>
      <xsl:when test="@amount">
        <fo:block>
          <xsl:apply-templates select="." mode="esr-amount-cents"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="missing">00</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="esr-amount-cents-444.01">
    <xsl:choose>
      <xsl:when test="@amount">
        <fo:block xsl:use-attribute-sets="esr-444.01-box">
          <xsl:apply-templates select="." mode="esr-amount-cents"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="esr-444.01-box missing">00</fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ==================================================================== Addresses -->
  
  <xsl:template name="esr-format-city">
    <fo:block>
      <xsl:if test="country and country != 'CH'">
        <xsl:value-of select="country"/>
        <xsl:text>-</xsl:text>
      </xsl:if>
      <xsl:value-of select="zip"/>
      <xsl:text>&#160;</xsl:text>
      <xsl:value-of select="city"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="esr-format-address">
    <fo:block><xsl:value-of select="name"/></fo:block>
    <xsl:for-each select="address-line">
      <fo:block><xsl:value-of select="."/></fo:block>
    </xsl:for-each>
    <xsl:call-template name="esr-format-city"/>
  </xsl:template>
  
  <xsl:template match="bank" mode="form">
    <fo:block role="bank">
      <fo:block><xsl:value-of select="name"/></fo:block>
      <xsl:call-template name="esr-format-city"/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="biller" mode="form">
    <fo:block role="biller">
      <xsl:call-template name="esr-format-address"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="recipient" mode="form">
    <fo:block role="recipient">
      <fo:block><xsl:value-of select="name"/></fo:block>
      <xsl:choose>
        <xsl:when test="address-line">
          <xsl:for-each select="address-line">
            <fo:block><xsl:value-of select="."/></fo:block>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <fo:block>
            <xsl:value-of select="street-name"/>
            <xsl:if test="civic-number">
              <xsl:text>&#160;</xsl:text>
              <xsl:value-of select="civic-number"/>
            </xsl:if>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="esr-format-city"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="esr-default-bank-address">
    <fo:block>
      <fo:block>PostFinance AG</fo:block>
      <fo:block>3030 Bern</fo:block>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="esr-sample-biller-address">
    <fo:block xsl:use-attribute-sets="missing">
      <fo:block>H. Muster AG</fo:block>
      <fo:block>Musterhaus</fo:block>
      <fo:block>Musterstrasse 77</fo:block>
      <fo:block>0000 Musterhausen</fo:block>
    </fo:block>
  </xsl:template>
  
  <xsl:template name="esr-sample-recipient-address">
    <fo:block xsl:use-attribute-sets="missing">
      <fo:block>Hans Muster</fo:block>
      <fo:block>Mustergasse 13</fo:block>
      <fo:block>0000 Musterhausen</fo:block>
    </fo:block>
  </xsl:template>
  
  <!-- ==================================================================== Override points -->
  <!-- Override points for painting custom address parts. -->
  
  <xsl:template name="esr-bank-address">
    <xsl:choose>
      <xsl:when test="bank">
        <xsl:apply-templates select="bank" mode="form"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="esr-default-bank-address"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="esr-biller-address">
    <xsl:choose>
      <xsl:when test="biller">
        <xsl:apply-templates select="biller" mode="form"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="esr-sample-biller-address"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="esr-recipient-address">
    <xsl:choose>
      <xsl:when test="recipient">
        <xsl:apply-templates select="recipient" mode="form"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="esr-sample-recipient-address"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="esr-recipient-address-444.01">
    <!-- Compensate for Apache FOP's missing treatment of half the leading as conditional space -->
    <fo:block padding-top="(8mm - {$esr-recipient-font-size-444.01}) div 2">
      <xsl:choose>
        <xsl:when test="recipient">
          <xsl:apply-templates select="recipient" mode="form"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="esr-sample-recipient-address"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  <xsl:template name="esr-recipient-receipt-address-444.01">
    <!-- Compensate for Apache FOP's missing treatment of half the leading as conditional space -->
    <fo:block padding-top="(5mm - {$esr-font-size-444.01}) div 2">
      <xsl:choose>
        <xsl:when test="recipient">
          <xsl:apply-templates select="recipient" mode="form"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="esr-sample-recipient-address"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  
  
  <!-- Main template: use mode="form" -->
  
  <xsl:template match="esr" mode="form">
    <xsl:param name="debug" select="false()"/>
    <xsl:param name="raster" select="false()"/>
    <xsl:param name="top" select="concat('297mm - ', $esr-height)"/>
    <xsl:param name="left" select="'0mm'"/>
    <xsl:param name="form" select="'442.05'"/>
    <xsl:param name="plus-form" select="$form = '442.06' or $form = '442.41'"/>
    
    <fo:block-container absolute-position="fixed" top="{$top}" left="{$left}" width="210mm" height="106mm" font-size="0" line-height="1.0">
      <xsl:if test="$debug">
        <!-- ESR debug form -->
        <fo:block-container absolute-position="absolute" width="100%" height="100%">
          <fo:block>
            <xsl:choose>
              <xsl:when test="$form = '442.06' or $form = '442.41'">
                <fo:external-graphic src="442_06_ESRplus_CHF_quer.svg"/>
              </xsl:when>
              <xsl:otherwise>
                <fo:external-graphic src="442_05_LAC_609_quer_Bank.svg"/>
              </xsl:otherwise>
            </xsl:choose>
          </fo:block>
        </fo:block-container>
      </xsl:if>
      
      <xsl:if test="$raster">
        <fo:block-container absolute-position="absolute" top="0" left="0" width="210mm" height="106mm">
          <fo:block font-size="0" line-height="0">
            <fo:instream-foreign-object width="210mm" height="106mm">
              <xsl:call-template name="esr-raster"/>
            </fo:instream-foreign-object>
          </fo:block>
        </fo:block-container>
      </xsl:if>
      
      <fo:block-container absolute-position="absolute" width="100%" height="100%">
        <!-- ESR Coding Line -->
        <fo:block-container absolute-position="absolute" top="20 * 1in div 6" right="(3 * 1in div 10)" width="(54 * 1in div 10)" height="1in div 6" xsl:use-attribute-sets="esr-ocr-font" text-align="end" display-align="after">
          <xsl:call-template name="esr-coding-line"/>
        </fo:block-container>
        
        <!-- ESR Reference Number -->
        <fo:block-container absolute-position="absolute" top="8 * 1in div 6" right="(2 * 1in div 10)" width="(32 * 1in div 10) + 1pt" height="1in div 6" xsl:use-attribute-sets="esr-reference-line-font esr-right-margin-adjustment" text-align="end" display-align="after">
          <xsl:call-template name="esr-reference-line"/>
        </fo:block-container>
        <fo:block-container absolute-position="absolute" top="14 * 1in div 6" left="3mm" width="22 * 1in div 10" height="1in div 6" xsl:use-attribute-sets="esr-ocr-font esr-left-margin-adjustment">
          <xsl:call-template name="esr-reference-receipt-line"/>
        </fo:block-container>

        <!-- Account -->
        <fo:block-container absolute-position="absolute" top="10 * 1in div 6" left="210mm - (48 * 1in div 10)" width="12 * 1in div 10" height="1in div 6" xsl:use-attribute-sets="esr-account-font" display-align="after">
          <xsl:call-template name="esr-account"/>
        </fo:block-container>
        <fo:block-container absolute-position="absolute" top="10 * 1in div 6" left="210mm - (72 * 1in div 10)" width="12 * 1in div 10" height="1in div 6" xsl:use-attribute-sets="esr-account-font" display-align="after">
          <xsl:call-template name="esr-account"/>
        </fo:block-container>
        
        <xsl:variable name="digit-spacing" select="'1in div 10'"/>
        <xsl:variable name="amount-letter-spacing">
          <xsl:choose>
            <xsl:when test="$plus-form">1in div 10</xsl:when>
            <xsl:otherwise>normal</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="left-shift">
          <xsl:choose>
            <xsl:when test="$plus-form">0.2 * 1in div 10</xsl:when>
            <xsl:otherwise>1 * 1in div 10</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:if test="@amount">
          <!-- Amounts -->
          <fo:block-container absolute-position="absolute" top="12 * 1in div 6" left="210mm - (57 * 1in div 10) - {$left-shift}" width="15 * 1in div 10" letter-spacing="{$amount-letter-spacing}" height="1in div 6" xsl:use-attribute-sets="esr-ocr-font" text-align="end">
            <xsl:call-template name="esr-amount"/>
          </fo:block-container>
          <fo:block-container absolute-position="absolute" top="12 * 1in div 6" left="210mm - (39 * 1in div 10) - {$left-shift}" width="3 * 1in div 10" letter-spacing="{$amount-letter-spacing}" height="1in div 6" xsl:use-attribute-sets="esr-ocr-font" text-align="end">
            <xsl:call-template name="esr-amount-cents"/>
          </fo:block-container>
          
          <fo:block-container absolute-position="absolute" top="12 * 1in div 6" left="210mm - (81 * 1in div 10) - {$left-shift}" width="15 * 1in div 10" letter-spacing="{$amount-letter-spacing}" height="1in div 6" xsl:use-attribute-sets="esr-ocr-font" text-align="end">
            <xsl:call-template name="esr-amount"/>
          </fo:block-container>
          <fo:block-container absolute-position="absolute" top="12 * 1in div 6" left="210mm - (63 * 1in div 10) - {$left-shift}" width="3 * 1in div 10" letter-spacing="{$amount-letter-spacing}" height="1in div 6" xsl:use-attribute-sets="esr-ocr-font" text-align="end">
            <xsl:call-template name="esr-amount-cents"/>
          </fo:block-container>
        </xsl:if>
        
        <xsl:choose>
          <xsl:when test="bank">
            <fo:block-container absolute-position="absolute" top="2 * 1in div 6" left="210mm - (58 * 1in div 10)" width="22 * 1in div 10" height="2 * 1in div 6" xsl:use-attribute-sets="esr-recipient-font">
              <xsl:call-template name="esr-bank-address"/>
            </fo:block-container>
            <fo:block-container absolute-position="absolute" top="5 * 1in div 6" left="210mm - (58 * 1in div 10)" width="22 * 1in div 10" height="5 * 1in div 6" xsl:use-attribute-sets="esr-recipient-font">
              <xsl:call-template name="esr-biller-address"/>
            </fo:block-container>
            
            <fo:block-container absolute-position="absolute" top="2 * 1in div 6" left="3mm" width="22 * 1in div 10" height="2 * 1in div 6" xsl:use-attribute-sets="esr-recipient-font esr-left-margin-adjustment">
              <xsl:call-template name="esr-bank-address"/>
            </fo:block-container>
            <fo:block-container absolute-position="absolute" top="5 * 1in div 6" left="3mm" width="22 * 1in div 10" height="5 * 1in div 6" xsl:use-attribute-sets="esr-recipient-font esr-left-margin-adjustment">
              <xsl:call-template name="esr-biller-address"/>
            </fo:block-container>
          </xsl:when>
          
          <xsl:otherwise>
            <fo:block-container absolute-position="absolute" top="2 * 1in div 6" left="210mm - (58 * 1in div 10)" width="22 * 1in div 10" height="8 * 1in div 6" xsl:use-attribute-sets="esr-recipient-font">
              <xsl:call-template name="esr-biller-address"/>
            </fo:block-container>
            <fo:block-container absolute-position="absolute" top="2 * 1in div 6" left="3mm" width="22 * 1in div 10" height="8 * 1in div 6" xsl:use-attribute-sets="esr-recipient-font esr-left-margin-adjustment">
              <xsl:call-template name="esr-biller-address"/>
            </fo:block-container>
          </xsl:otherwise>
        </xsl:choose>

        <!-- Payer/Recipient -->
        <fo:block-container absolute-position="absolute" top="12 * 1in div 6" left="210mm - (34 * 1in div 10)" width="32 * 1in div 10" height="6 * 1in div 6" xsl:use-attribute-sets="esr-payer-font">
          <xsl:call-template name="esr-recipient-address"/>
        </fo:block-container>
        <fo:block-container absolute-position="absolute" top="15 * 1in div 6" left="3mm" width="22 * 1in div 10" height="5 * 1in div 6" xsl:use-attribute-sets="esr-payer-receipt-font esr-left-margin-adjustment">
          <xsl:call-template name="esr-recipient-address"/>
        </fo:block-container>
        
      </fo:block-container>
    </fo:block-container>
  </xsl:template>

  <xsl:template match="esr" mode="form-444.01">
    <xsl:param name="debug" select="false()"/>
    <xsl:param name="raster" select="false()"/>
    <xsl:param name="top" select="concat('297mm - ', $esr-height)"/>
    <xsl:param name="left" select="'0mm'"/>
    
    <fo:block-container absolute-position="fixed" top="{$top}" left="{$left}" width="210mm" height="106mm" font-size="0" line-height="1.0">
      <xsl:if test="$debug">
        <!-- ESR debug form -->
        <fo:block-container absolute-position="absolute" width="100%" height="100%">
          <fo:block>
            <fo:external-graphic src="esr-444.01.svg"/>
          </fo:block>
        </fo:block-container>
      </xsl:if>
      
      <xsl:if test="$raster">
        <fo:block-container absolute-position="absolute" top="0" left="0" width="210mm" height="106mm">
          <fo:block font-size="0" line-height="0">
            <fo:instream-foreign-object width="210mm" height="106mm">
              <xsl:call-template name="esr-raster-444_01"/>
            </fo:instream-foreign-object>
          </fo:block>
        </fo:block-container>
      </xsl:if>
      
      <fo:block-container absolute-position="absolute" width="100%" height="100%">
        
        <!-- ESR Reference Number -->
        <fo:block-container absolute-position="absolute" top="34.5mm" right="5mm" width="82mm" height="6mm" xsl:use-attribute-sets="esr-ocr-font esr-right-margin-adjustment-444.01" text-align="end" display-align="center">
          <xsl:call-template name="esr-reference-line-444.01"/>
        </fo:block-container>
        
        <!-- Account -->
        <fo:block-container absolute-position="absolute" top="41.5mm" left="3mm" width="53.5mm" height="4mm" xsl:use-attribute-sets="esr-normal-font-444.01 esr-left-margin-adjustment-444.01" display-align="after">
          <xsl:call-template name="esr-account-444.01"/>
        </fo:block-container>
        <fo:block-container absolute-position="absolute" top="41.5mm" left="63mm" width="53.5mm" height="4mm" xsl:use-attribute-sets="esr-normal-font-444.01" display-align="after">
          <xsl:call-template name="esr-account-444.01"/>
        </fo:block-container>
        
        <!-- Currency -->
        <fo:block-container absolute-position="absolute" top="47mm" left="3mm" width="53.5mm" height="4mm" xsl:use-attribute-sets="esr-normal-font-444.01 esr-left-margin-adjustment-444.01" display-align="after">
          <xsl:call-template name="esr-currency-444.01"/>
        </fo:block-container>
        <fo:block-container absolute-position="absolute" top="47mm" left="63mm" width="53.5mm" height="4mm" xsl:use-attribute-sets="esr-normal-font-444.01" display-align="after">
          <xsl:call-template name="esr-currency-444.01"/>
        </fo:block-container>
        
        <xsl:if test="@amount">
          <!-- Amounts -->
          <fo:block-container absolute-position="absolute" top="52mm" left="3mm" width="41mm" height="6mm" xsl:use-attribute-sets="esr-ocr-font" text-align="end" display-align="center">
            <xsl:call-template name="esr-amount-444.01"/>
          </fo:block-container>
          <fo:block-container absolute-position="absolute" top="52mm" left="47.5mm" width="9.5mm" height="6mm" xsl:use-attribute-sets="esr-ocr-font" text-align="start" display-align="center">
            <xsl:call-template name="esr-amount-cents-444.01"/>
          </fo:block-container>
          
          <fo:block-container absolute-position="absolute" top="52mm" left="63mm" width="41mm" height="6mm" xsl:use-attribute-sets="esr-ocr-font" text-align="end" display-align="center">
            <xsl:call-template name="esr-amount-444.01"/>
          </fo:block-container>
          <fo:block-container absolute-position="absolute" top="52mm" left="107.5mm" width="9.5mm" height="6mm" xsl:use-attribute-sets="esr-ocr-font" text-align="start" display-align="center">
            <xsl:call-template name="esr-amount-cents-444.01"/>
          </fo:block-container>
        </xsl:if>
        
        <fo:block-container absolute-position="absolute" top="10mm" left="3mm" width="53.5mm" height="7mm" xsl:use-attribute-sets="esr-normal-font-444.01 esr-left-margin-adjustment-444.01">
          <xsl:call-template name="esr-bank-address"/>
        </fo:block-container>
        <fo:block-container absolute-position="absolute" top="22mm" left="3mm" width="53.5mm" height="16mm" xsl:use-attribute-sets="esr-normal-font-444.01 esr-left-margin-adjustment-444.01">
          <xsl:call-template name="esr-biller-address"/>
        </fo:block-container>
        
        <fo:block-container absolute-position="absolute" top="10mm" left="63mm" width="53.5mm" height="7mm" xsl:use-attribute-sets="esr-normal-font-444.01">
          <xsl:call-template name="esr-bank-address"/>
        </fo:block-container>
        <fo:block-container absolute-position="absolute" top="22mm" left="63mm" width="53.5mm" height="16mm" xsl:use-attribute-sets="esr-normal-font-444.01">
          <xsl:call-template name="esr-biller-address"/>
        </fo:block-container>
        
        <!-- Payer/Recipient -->
        <fo:block-container absolute-position="absolute" top="71.5mm - 5mm" left="3mm" width="53.5mm" height="14mm" xsl:use-attribute-sets="esr-recipient-receipt-font-444.01 esr-left-margin-adjustment-444.01">
          <xsl:call-template name="esr-recipient-receipt-address-444.01"/>
        </fo:block-container>
        <fo:block-container absolute-position="absolute" top="58mm - 8mm" left="123mm" width="80mm" height="28mm" xsl:use-attribute-sets="esr-recipient-font-444.01">
          <xsl:call-template name="esr-recipient-address-444.01"/>
        </fo:block-container>

        <fo:block-container absolute-position="absolute" top="63mm" left="65mm" width="51mm" height="36mm">
          <fo:block font-size="0pt" line-height="0">
            <fo:instream-foreign-object width="51mm" content-width="36mm" height="36mm" content-height="36mm" fox:conversion-mode="bitmap">
              <xsl:variable name="barcode-message">
                <xsl:call-template name="esr-create-qr-message"/>
              </xsl:variable>
              <barcode xmlns="http://barcode4j.krysalis.org/ns" message="{$barcode-message}">
                <qr>
                  <module-width><xsl:value-of select="concat(string(1 div 150), 'in')"/></module-width> <!-- 150dpi -->
                  <quiet-zone enabled="false"/>
                  <encoding>ISO-8859-1</encoding>
                  <ec-level>L</ec-level> 
                </qr>
              </barcode>
            </fo:instream-foreign-object>
          </fo:block>
        </fo:block-container>
        
      </fo:block-container>
    </fo:block-container>
  </xsl:template>
  
  <xsl:template name="esr-raster">
    <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="210mm" height="106mm" viewBox="0 0 210 106">
      <g style="stroke: black; stroke-width: 0.01; stroke-dasharray:0.2,0.2" transform="scale({210 div (59 + (59 - 35))}, {106 div 25})"> <!-- 83x25 -->
        <line x1="0" y1="0" x2="83" y2="25" display="none"/>
        
        <!-- horizontal -->
        <line x1="0" y1="2" x2="83" y2="2"/>
        
        <line x1="0" y1="8" x2="83" y2="8"/>
        <line x1="0" y1="9" x2="83" y2="9"/>
        
        <line x1="0" y1="10" x2="83" y2="10"/>
        <line x1="0" y1="11" x2="83" y2="11"/>
        <line x1="0" y1="12" x2="83" y2="12"/>
        <line x1="0" y1="13" x2="83" y2="13"/>
        
        <line x1="0" y1="20" x2="83" y2="20"/>
        <line x1="0" y1="21" x2="83" y2="21"/>
        
        <!-- vertical -->
        <line x1="1" y1="0" x2="1" y2="25"/>
        <line x1="16" y1="0" x2="16" y2="25"/>
        <line x1="19" y1="0" x2="19" y2="25"/>
        <line x1="22" y1="0" x2="22" y2="25"/>

        <line x1="25" y1="0" x2="25" y2="25"/>
        <line x1="40" y1="0" x2="40" y2="25"/>
        <line x1="43" y1="0" x2="43" y2="25"/>
        <line x1="46" y1="0" x2="46" y2="25"/>

        <line x1="49" y1="0" x2="49" y2="25"/>
        
        <line x1="81" y1="0" x2="81" y2="25"/>
        <line x1="80" y1="0" x2="80" y2="25"/>
        
        <line x1="27" y1="19" x2="27" y2="25"/>
      </g>
      
      <g style="stroke: red; stroke-width:0.2; stroke-dasharray:1,1; fill:none">
        <path d="M 5,0 L 5,91 15,91 15,101 205,101 205,0"/>
        
      </g>
    </svg>
  </xsl:template>

  <xsl:template name="esr-raster-444_01">
    <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="210mm" height="106mm" viewBox="0 0 210 106">
      <g style="stroke: black; stroke-width: 0.01; stroke-dasharray:0.2,0.2">
        <line x1="0" y1="0" x2="210" y2="106" display="none"/>
        
        <!-- horizontal -->
        <line x1="0" y1="10" x2="210" y2="10"/>
        
        <line x1="0" y1="22" x2="210" y2="22"/>
        
        <line x1="0" y1="36" x2="210" y2="36"/>
        <line x1="0" y1="39" x2="210" y2="39"/>
        
        <line x1="0" y1="44.5" x2="210" y2="44.5"/>
        <line x1="0" y1="50.5" x2="210" y2="50.5"/>
        
        <line x1="0" y1="53" x2="210" y2="53"/>
        <line x1="0" y1="56" x2="210" y2="56"/>
        
        <line x1="0" y1="58" x2="210" y2="58"/>
        
        <line x1="63" y1="63" x2="119" y2="63"/>
        <line x1="63" y1="99" x2="119" y2="99"/>

        <line x1="0" y1="66.5" x2="210" y2="66.5"/>
        <line x1="0" y1="71.5" x2="210" y2="71.5"/>
        
        <!-- vertical -->
        <line x1="3" y1="0" x2="3" y2="106"/>
        <line x1="56.5" y1="0" x2="56.5" y2="106"/>
      
        <line x1="63" y1="0" x2="63" y2="106"/>
        <line x1="65" y1="61" x2="65" y2="101"/>
        <line x1="117" y1="61" x2="117" y2="101"/>
        <line x1="103" y1="61" x2="103" y2="101"/>
      
        <line x1="123" y1="0" x2="123" y2="106"/>
        <line x1="203" y1="0" x2="203" y2="106"/>
      
        <line x1="204" y1="0" x2="204" y2="106"/>
      </g>
      
      <g style="stroke: red; stroke-width:0.2; stroke-dasharray:1,1; fill:none">
        <path d="M 5,0 L 5,91 15,91 15,101 205,101 205,0"/>
        
      </g>
    </svg>
  </xsl:template>
  
</xsl:stylesheet>
