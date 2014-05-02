<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:prop="http://schemas.openxmlformats.org/officeDocument/2006/custom-properties"
                xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:dcmitype="http://purl.org/dc/dcmitype/"
                xmlns:iso="http://www.iso.org/ns/1.0"
                xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main"
                xmlns:mv="urn:schemas-microsoft-com:mac:vml"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"
                xmlns="http://www.tei-c.org/ns/1.0"
                version="2.0"
                exclude-result-prefixes="a cp dc dcterms dcmitype prop
            iso m mml mo mv o pic r rel   html    tbx tei teidocx v xs ve w10 w wne wp vt">
  <xsl:import href="../../Stylesheets/docx/from/docxtotei.xsl"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
      <p>TEI Stylesheet para FFyL UNAM</p>
      <p>Personalizando la conversión de DOCX a TEI</p>
    </desc>
  </doc>

  <!-- Variables -->

    
  <!-- Outputs -->
  <xsl:output indent="yes"/>

  <!-- Redefiniendo (overrides) -->
  <xsl:template match="tei:TEI" mode="pass2">
    <xsl:variable name="Doctext">
      <xsl:copy>
        <xsl:apply-templates mode="pass2"/>
      </xsl:copy>
    </xsl:variable>
    <xsl:apply-templates select="$Doctext" mode="pass3"/>
  </xsl:template>

  <!-- Añadiendo Proyecto de investigación -->
  <xsl:template match="tei:encodingDesc" mode="pass3">
    <xsl:if test="//tei:p[@rend='proyecto']">
      <encodingDesc>
        <projectDesc>
          <xsl:value-of select="//tei:p[@rend='proyecto']"/>
        </projectDesc>
      </encodingDesc>
    </xsl:if>
  </xsl:template>

  <!-- Agregando el título de la obra -->
  <xsl:template match="tei:titleStmt/tei:title" mode="pass3">
    <title>
      <xsl:value-of select="//tei:p[@rend='Title']"/>
    </title>
  </xsl:template>

  <!-- Agregando el autor de la obra y no el autor del documento -->
  <xsl:template match="tei:titleStmt/tei:author" mode="pass3">
    <author>
      <xsl:value-of select="//tei:p[@rend='autor']"/>
    </author>
  </xsl:template>

  <!-- Añadiendo responsables: coordinador, compilador, traductor, editor, revisor -->
  <xsl:template match="tei:fileDesc/tei:titleStmt" mode="pass3">
    <titleStmt>
      <!-- Añadiendo lo que ya había antes -->
      <xsl:apply-templates mode="pass3"/>

      <!-- Añadiendo coordinador -->
      <xsl:if test="//tei:hi[@rend='coordinador']">
        <respStmt>
          <resp>Coordinado por</resp>
          <name><xsl:value-of select="//tei:hi[@rend='coordinador']"/></name>
        </respStmt>
      </xsl:if>

      <!-- Añadiendo compilador -->
      <xsl:if test="//tei:hi[@rend='compilador']">
        <respStmt>
          <resp>Compilado por</resp>
          <name><xsl:value-of select="//tei:hi[@rend='compilador']"/></name>
        </respStmt>
      </xsl:if>

      <!-- Añadiendo traductor -->
      <xsl:if test="//tei:hi[@rend='traductor']">
        <respStmt>
          <resp>Traducido por</resp>
          <name><xsl:value-of select="//tei:hi[@rend='traductor']"/></name>
        </respStmt>
      </xsl:if>

      <!-- Añadiendo editor -->
      <xsl:if test="//tei:hi[@rend='editor']">
        <respStmt>
          <resp>Editado por</resp>
          <name><xsl:value-of select="//tei:hi[@rend='editor']"/></name>
        </respStmt>
      </xsl:if>

      <!-- Añadiendo revisor -->
      <xsl:if test="//tei:hi[@rend='revisor']">
        <respStmt>
          <resp>Revisado por</resp>
          <name><xsl:value-of select="//tei:hi[@rend='revisor']"/></name>
        </respStmt>
      </xsl:if>

    </titleStmt>
  </xsl:template>

  <!-- Modificando fecha de edición -->
  <xsl:template match="tei:editionStmt/tei:edition" mode="pass3">
    <edition>
      <date>
        <xsl:choose>
          <xsl:when test="//tei:hi[@rend='fecha-edicion']">
            <xsl:value-of select="//tei:hi[@rend='fecha-edicion']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="current-dateTime()"/>
          </xsl:otherwise>
        </xsl:choose>
      </date>
    </edition>
  </xsl:template>

  <!-- Modificando <publicationStmt> -->
  <xsl:template match="tei:publicationStmt" mode="pass3">
    <publicationStmt>
      <publisher>
        <xsl:choose>
          <xsl:when test="//tei:hi[@rend='editorial']">
            <xsl:value-of select="//tei:hi[@rend='editorial']" />  
          </xsl:when>
          <xsl:otherwise>
            Facultad de Filosofía y Letras, UNAM 
          </xsl:otherwise>
        </xsl:choose>  
      </publisher>

      <pubPlace>Universidad Nacional Autónoma de México</pubPlace>
      <adress>
        <addrLine>Ciudad Universitaria, Delegación Coyoacán. C.P. 04510 México, Distrito Federal</addrLine>
      </adress>

      <!-- ISBN -->
      <xsl:if test="//tei:hi[@rend='ISBN']">
        <idno type="ISBN">
          <xsl:value-of select="//tei:hi[@rend='ISBN']" />
        </idno>
      </xsl:if>

      <!-- ISSN -->
      <xsl:if test="//tei:hi[@rend='ISSN']">
        <idno type="ISSN">
          <xsl:value-of select="//tei:hi[@rend='ISSN']" />
        </idno>
      </xsl:if>

      <!-- Licencia -->
      <availability status="restricted">
        <xsl:choose>
          <xsl:when test="//tei:p[@rend='licencia']">
            <xsl:for-each select="//tei:p[@rend='licencia']">
              <p>
                <xsl:apply-templates mode="pass3"/>
              </p>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <p>
              D.R. © 2013 Universidad Nacional Autónoma de México.
              Avenida Universidad 3000, colonia Universidad Nacional 
              Autónoma de México, C. U., delegación Coyoacán, 
              C. P. 04510, Distrito Federal.
            </p>
            <p>
              Prohibida la reproducción total o parcial
              por cualquier medio sin autorización escrita
              del titular de los derechos patrimoniales.
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </availability>

      <!-- Fecha de publicación -->  
      <xsl:if test="//tei:hi[@rend='fecha-publicacion']">
        <date when="{//tei:hi[@rend='fecha-publicacion']}">
          <xsl:value-of select="//tei:hi[@rend='fecha-publicacion']"/>
        </date>
      </xsl:if>

    </publicationStmt>
  </xsl:template>

  <!-- Modificando <sourceDesc> -->
  <xsl:template match="tei:sourceDesc" mode="pass3">
    <sourceDesc>
      <p>Texto marcado desde un Documento Word</p>
      <xsl:choose>
        <xsl:when test="//tei:hi[@rend='editorial-impresion']">
          <bibl>
            <author>
              <xsl:value-of select="//tei:p[@rend='autor']"/>
            </author>.
            <title level="a">
              <xsl:value-of select="//tei:p[@rend='Title']"/>
            </title>.
            <publisher>
              <xsl:value-of select="//tei:hi[@rend='editorial-impresion']"/>
            </publisher>,
            <date>
              <xsl:value-of select="//tei:hi[@rend='fecha-edicion-impresion']"/>
            </date>.
          </bibl>
        </xsl:when>
        <xsl:otherwise>
          <p>No derivado de un texto impreso.</p>
        </xsl:otherwise>
      </xsl:choose>
    </sourceDesc>
  </xsl:template>

  <!-- Añadiendo portada -->
  <xsl:template match="tei:body" mode="pass3">
    <front>
      <titlePage>
        <docTitle>
          <!-- Añadiendo el título de la obra -->
          <titlePart type="main">
            <xsl:value-of select="//tei:p[@rend='Title']"/>
          </titlePart>

          <!-- Añadiendo el subtítulo, si existe -->
          <xsl:if test="//tei:p[@rend='Subtitle']">
            <titlePart type="sub">
              <xsl:value-of select="//tei:p[@rend='Subtitle']"/>
            </titlePart>
          </xsl:if>
        </docTitle>

        <!-- Añadiendo el autor de la obra -->
        <docAuthor>
          <xsl:value-of select="//tei:p[@rend='autor']"/>
        </docAuthor>

        <!-- Añadiendo información de libro impreso -->
        <xsl:if test="//tei:hi[@rend='editorial-impresion']">
          <docImprint>
            <publisher>
              <xsl:value-of select="//tei:hi[@rend='editorial-impresion']"/>
            </publisher>

            <xsl:if test="//tei:hi[@rend='lugar-impresion']">
              <pubPlace>
                <xsl:value-of select="//tei:hi[@rend='lugar-impresion']"/>
              </pubPlace>
            </xsl:if>

            <xsl:if test="//tei:hi[@rend='fecha-impresion']">
              <docDate>
                <xsl:value-of select="//tei:hi[@rend='fecha-impresion']"/>
              </docDate>
            </xsl:if>
          </docImprint>
        </xsl:if>

      </titlePage>

      <!-- Añadiendo la sinopsis o el resumen, si existe -->
      <xsl:if test="//tei:p[@rend='resumen']">
        <div type="abstract">
          <xsl:for-each select="//tei:p[@rend='resumen']">
            <p>
              <xsl:apply-templates mode="pass3"/>
            </p>
          </xsl:for-each>
        </div>
      </xsl:if>
    </front>
    <body>
      <xsl:apply-templates mode="pass3"/>
    </body>
  </xsl:template>

  <!-- Quitanto divs que tienen heads vacíos o inexistentes -->
  <xsl:template match="tei:body/tei:div" mode="pass3">
    <xsl:choose>
      <xsl:when test="string-length(tei:head) > 0">
        <div>
          <xsl:apply-templates mode="pass3"/>
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <!-- Default XML (desde pass2) -->
  <xsl:template match="@*|comment()|processing-instruction()|text()" mode="pass3">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="*" mode="pass3">
    <xsl:copy>
      <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
