<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
    <xsl:output method="xml" indent="yes"/>

  <xsl:param name="lclBetTypes" />
  <xsl:param name="lclQuestion" />
  <xsl:param name="lclMultipleWinner" />
  <xsl:param name="lclOptions" />
  <xsl:param name="lclAddComment"/>
  <xsl:param name="urlAddComment"/>
  <xsl:param name="lclViewComments"/>
  <xsl:param name="urlViewComments"/>
  <xsl:param name="lclFavouriteEvent"/>
  <xsl:param name="urlFavouriteEvent"/>
  <xsl:param name="lclRecommendEvent"/>
  <xsl:param name="urlRecommendEvent"/>
  <xsl:param name="eventId"/>
  <xsl:param name="eventName"/>
  <xsl:param name="numberOfComments"/>
  <xsl:param name="numberOfResults"/>
  <xsl:param name="lclNoBetTypes"/>


  <xsl:template match="rsp">
    <xsl:choose>
      <xsl:when test="$numberOfResults &gt; 0">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$lclNoBetTypes"/>
      </xsl:otherwise>
    </xsl:choose>
    
    <!-- Footer links -->
    <p>
      <xsl:if test="$numberOfComments &gt; 0">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$urlViewComments"/>?eventId=<xsl:value-of select="$eventId"/>
          </xsl:attribute>
          <xsl:value-of select="$lclViewComments"/> (<xsl:value-of select="$numberOfComments"/>)
        </a> |
      </xsl:if>

      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$urlAddComment"/>?eventId=<xsl:value-of select="$eventId"/>
        </xsl:attribute>
        <xsl:value-of select="$lclAddComment"/>
      </a> |

      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$urlFavouriteEvent"/>?eventId=<xsl:value-of select="$eventId"/>&amp;eventName=<xsl:value-of select="$eventName"/>
        </xsl:attribute>
        <xsl:value-of select="$lclFavouriteEvent"/>
      </a> |

      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$urlRecommendEvent"/>?eventId=<xsl:value-of select="$eventId"/>&amp;eventName=<xsl:value-of select="$eventName"/>
        </xsl:attribute>
        <xsl:value-of select="$lclRecommendEvent"/>
      </a>
    </p>
  </xsl:template>

  <xsl:template match="err">
    <span class="errorMessage">
      Error: <xsl:value-of select="@msg"/>
    </span>
  </xsl:template>

  <xsl:template match="betTypes">
    <h1><xsl:value-of select="$lclBetTypes"/></h1>
    <h2><xsl:value-of select="$eventName"/></h2>
    <table class="cooltable">
      <tr>
        <th><xsl:value-of select="$lclQuestion"/></th>
        <th><xsl:value-of select="$lclMultipleWinner"/></th>
        <th><xsl:value-of select="$lclOptions"/></th>
      </tr>
      <xsl:apply-templates/>
    </table>

    

  </xsl:template>

  <xsl:template match="betType">
    <tr>
      <td><xsl:value-of select="question"/></td>
      <td><xsl:value-of select="multipleWinner"/></td>
      <td><xsl:apply-templates select="betOptions"/></td>
    </tr>
  </xsl:template>


  <xsl:template match="betOptions">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>


  <xsl:template match="betOption">
    <li><xsl:value-of select="name"/> (<xsl:value-of select="quota"/>)</li>
  </xsl:template>

</xsl:stylesheet>