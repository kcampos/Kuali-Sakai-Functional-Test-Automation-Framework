<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

 <xsl:template match="/">
  <html>
    <body>
   <table border="1">
   <tr style="font-weight:bold;color:blue">
  <td>Author Name</td>
   <td>Author Address</td>
   <td>Author City</td>
  <td>Author State</td>
 <td>Author e-mail</td>
 <td>Publisher Name</td>
  <td>Publisher Address</td>
  <td>Publisher Phone</td>
  <td>Current discount percentage</td>
  </tr>
   <xsl:for-each select="Catalog/Book">
     <tr>
    <xsl:apply-templates/>
    <td>
     discount:
    <xsl:eval language="JavaScript">
     pvalue=Math.round (50*Math.random());
   </xsl:eval>
    </td>
    </tr>
    </xsl:for-each>
  </table>
  </body>
  </html>
 </xsl:template>
 
 <xsl:template match="Author">
  <td><xsl:value-of select="Name"/></td>
   <td><xsl:value-of select="Address"/></td>
   <td><xsl:value-of select="City"/></td>
  <td><xsl:value-of select="State"/></td>
  <td><xsl:value-of select="Email"/></td>
 </xsl:template>
 <xsl:template match="Publisher">
   <td><xsl:value-of select="Name"/></td>
  <td><xsl:value-of select="Address"/></td>
   <td><xsl:value-of select="Phone"/></td>
 </xsl:template>
</xsl:stylesheet>

