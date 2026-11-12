<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  exclude-result-prefixes="tei xi">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;
</xsl:text>
    
    <!--<xsl:element name="html">
      <xsl:attribute name="lang">
        <xsl:text>fr</xsl:text>
      </xsl:attribute>
    </xsl:element>-->
    
    <html lang="fr">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Carrousel de 1662 : devises et emblèmes</title>
       <!--<link rel="stylesheet" href="style.css"/>-->   
      </head>
      <body>
        <aside id="arbre" aria-label="Sélection">
          <h1>Carrousel de 1662</h1>
          <p class="retour"><a href="index.html">Présentation du texte</a></p>
          <p class="aide">Cocher un quadrille ou un cavalier pour ne garder les cartes correspondantes</p>
          <button type="button" id="tout">Tout afficher</button>
          
          <xsl:apply-templates select="//tei:div[@type='quadrille'] | //xi:include" mode="tree"/>
          
        </aside>
        <main id="cartes">
          
          <xsl:apply-templates select="//tei:div[@type='quadrille'] | //xi:include" mode="cartes"/>
          
        </main>
        <script src="script.js"></script>
      </body>
    </html>
  </xsl:template>

  <!-- Fichiers de quadrille : si l'XInclude n'a pas été résolu par le processeur,
       le XSLT ouvre lui-même chaque fichier. Si c'est déjà fait, ces deux
       templates ne servent pas. L'ordre de master.xml est conservé. -->
  <xsl:template match="xi:include" mode="tree">
    <xsl:apply-templates select="document(@href, .)/tei:div[@type='quadrille']" mode="tree"/>
  </xsl:template>
  <xsl:template match="xi:include" mode="cartes">
    <xsl:apply-templates select="document(@href, .)/tei:div[@type='quadrille']" mode="cartes"/>
  </xsl:template>
  <xsl:template match="tei:div[@type='quadrille']" mode="cartes">
    <xsl:apply-templates select="tei:div[@type='personnage']" mode="carte"/>
  </xsl:template>

  <!-- Arbre : quadrille > personnages -->
  <xsl:template match="tei:div[@type='quadrille']" mode="tree">
    <details open="open" style="--couleur:{@n}">
      <summary>
        <label>
          <input type="checkbox" class="q" value="{@xml:id}"/>
          <xsl:value-of select="tei:head"/>
        </label>
      </summary>
      <ul>
        <xsl:for-each select="tei:div[@type='personnage']">
          <li>
            <label>
              <input type="checkbox" class="p" value="{@xml:id}" data-parent="{../@xml:id}"/>
              <xsl:value-of select="tei:head"/>
            </label>
          </li>
        </xsl:for-each>
      </ul>
    </details>
  </xsl:template>

  <!-- Carte : recto = emblème + devise, verso = description -->
  <xsl:template match="tei:div[@type='personnage']" mode="carte">
    <article class="carte" id="{@xml:id}"
             data-quadrille="{../@xml:id}" data-personnage="{@xml:id}"
             style="--couleur:{../@n}">
      <button type="button" class="carte-inner" aria-pressed="false">
        <span class="face recto">
          <span class="quadrille"><xsl:value-of select="../tei:head"/></span>
          <img src="{tei:figure/tei:graphic/@url}" alt="{tei:figure/tei:figDesc}"/>
          <span class="devise"><xsl:value-of select="tei:q[@type='devise']"/></span>
          <span class="nom"><xsl:value-of select="tei:head"/></span>
        </span>
        <span class="face verso">
          <span class="nom"><xsl:value-of select="tei:head"/></span>
          <xsl:apply-templates select="tei:p[@type='description']"/>
        </span>
      </button>
    </article>
  </xsl:template>

  <xsl:template match="tei:p"><span class="para"><xsl:apply-templates/></span></xsl:template>
  <xsl:template match="tei:lb"><br/></xsl:template>
  <xsl:template match="tei:choice/tei:orig"/>
</xsl:stylesheet>
