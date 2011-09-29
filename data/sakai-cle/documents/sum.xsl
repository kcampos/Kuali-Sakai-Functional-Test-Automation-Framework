<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
<xsl:output method="html" indent="yes" />
  
<xsl:template match="/root">  
  <xsl:apply-templates select="currentnode" />
</xsl:template>
  
<xsl:template match="currentnode">
  <p><xsl:value-of select="sum(preceding-sibling::sibling/@value)" /></p>
  <!--<p><xsl:value-of select="sum(xalan:nodeset($Total)/SubTotal)"/><br/></p>-->
</xsl:template>

<xsl:variable name="Total">
     <xsl:for-each select="preceding-sibling::sibling[@value]">
 	    <SubTotal>
 	      <xsl:value-of select="(@value)"/>
 	    </SubTotal>
 	  </xsl:for-each>
</xsl:variable>
  
</xsl:stylesheet>