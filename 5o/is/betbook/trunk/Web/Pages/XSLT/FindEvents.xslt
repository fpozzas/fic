<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
    <xsl:output method="xml" indent="yes"/>

  <xsl:param name="lclName"/>
  <xsl:param name="lclDate"/>
  <xsl:param name="lclCategory"/>
  <xsl:param name="urlFindBetTypes"/>
  <xsl:param name="lclAddComment"/>
  <xsl:param name="urlAddComment"/>
  <xsl:param name="lclViewComments"/>
  <xsl:param name="urlViewComments"/>
  <xsl:param name="lclFavouriteEvent"/>
  <xsl:param name="urlFavouriteEvent"/>
  <xsl:param name="lclRecommendEvent"/>
  <xsl:param name="urlRecommendEvent"/>
  <xsl:param name="urlPrevious"/>
  <xsl:param name="urlNext"/>
  <xsl:param name="lclNoComments"/>
  <xsl:param name="commentInfo"/>
  <xsl:param name="numberOfResults"/>
  <xsl:param name="Next"/>
  <xsl:param name="Previous"/>
  <xsl:param name="NoResults"/>
  

  <xsl:template match="rsp">
    <xsl:choose>
      <xsl:when test="$numberOfResults &gt; 0">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$NoResults"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="err">
    <span class="errorMessage">Error: <xsl:value-of select="@msg"/></span>
  </xsl:template>

  
  <xsl:template match="events">
      <table class="cooltable">
        <tr>
          <th><xsl:value-of select="$lclName"/></th>
          <th><xsl:value-of select="$lclDate"/></th>
          <th><xsl:value-of select="$lclCategory"/></th>
        </tr>
        <xsl:apply-templates select="event"/>
      </table>

      <!-- "Previous" and "Next" links. -->
      <div class="previousNextLinks">
        <xsl:if test="$urlPrevious">
          <span class="previousLink">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="$urlPrevious"/>
              </xsl:attribute>
              <xsl:value-of select="$Previous"/>
            </a>
          </span>
        </xsl:if>
        <xsl:if test="$urlNext">
          <span class="nextLink">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="$urlNext"/>
              </xsl:attribute>
              <xsl:value-of select="$Next"/>
            </a>
          </span>
        </xsl:if>
      </div>
    </xsl:template>

    <xsl:template match="event">
      <tr>
        <td>
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="$urlFindBetTypes"/>?eventId=<xsl:value-of select="id"/>&amp;eventName=<xsl:value-of select="name"/>
            </xsl:attribute>
            <xsl:value-of select="name"/>
          </a>
        </td>
        <td><xsl:value-of select="date"/></td>
        <td><xsl:value-of select="category"/></td>
        <td>
          
          <ul>
            <li>
              <xsl:choose>
                
                <xsl:when test="$commentInfo">
                  <xsl:choose>
                    <xsl:when test="numberOfComments &gt; 0">
                      <a>
                        <xsl:attribute name="href">
                          <xsl:value-of select="$urlViewComments"/>?eventId=<xsl:value-of select="id"/>
                        </xsl:attribute>
                        <xsl:value-of select="$lclViewComments"/> (<xsl:value-of select="numberOfComments"/>)
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$lclNoComments"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$urlViewComments"/>?eventId=<xsl:value-of select="id"/>
                    </xsl:attribute>
                    <xsl:value-of select="$lclViewComments"/>
                  </a>
                </xsl:otherwise>
                
              </xsl:choose>
            </li>

            <li>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$urlAddComment"/>?eventId=<xsl:value-of select="id"/>
                </xsl:attribute>
                <xsl:value-of select="$lclAddComment"/>
              </a>
            </li>

            <li>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$urlFavouriteEvent"/>?eventId=<xsl:value-of select="id"/>&amp;eventName=<xsl:value-of select="name"/>
                </xsl:attribute>
                <xsl:value-of select="$lclFavouriteEvent"/>
              </a>
            </li>

            <li>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$urlRecommendEvent"/>?eventId=<xsl:value-of select="id"/>&amp;eventName=<xsl:value-of select="name"/>
                </xsl:attribute>
                <xsl:value-of select="$lclRecommendEvent"/>
              </a>
            </li>
          </ul>
          
        </td>
      </tr>
    </xsl:template>

</xsl:stylesheet>