<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <body>
        <table border="1">
          <tr>
            <th>Index_number</th>
            <th>Number (palindrome)</th>
            <th>Square of number (palindrome)</th>
          </tr>
          <xsl:for-each select="objects/object">
            <tr>
              <td><xsl:value-of select="index"/></td>
              <td><xsl:value-of select="def"/></td>
              <td><xsl:value-of select="sqr"/></td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>