<?xml version="1.0" encoding="UTF-8"?>
<!--
  Transformation par ordre alphabétique de personnage.
  - Clé de tri : l'xml:id sans le préfixe "p-" (p-arthur -> ARTHUR -> lettre A),
    ce qui évite de classer "Roy Artus" sous R et "Messire Lancelot" sous M.
  - Fonctionne sur un seul fichier TEI, ou sur un master.xml avec xi:include
    (le XSLT ouvre lui-même les fichiers si l'XInclude n'est pas résolu).
  - XSLT 1.0 : compatible Saxon, xsltproc, lxml.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  exclude-result-prefixes="tei xi">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:variable name="min" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="maj" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <!-- Tous les personnages, dans le fichier courant et dans les fichiers inclus -->
  <xsl:variable name="persos"
    select="//tei:div[@type='personnage'] | document(//xi:include/@href, /)//tei:div[@type='personnage']"/>

  <xsl:variable name="titre">
    <xsl:choose>
      <xsl:when test="//tei:titleStmt/tei:title">
        <xsl:value-of select="//tei:titleStmt/tei:title[1]"/>
      </xsl:when>
      <xsl:otherwise>Personnages</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ================= Page ================= -->
  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;
</xsl:text>
    <html lang="fr">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="$titre"/></title>
        <link rel="stylesheet" href="style.css"/>
      </head>
      <body class="alpha">

        <!-- Bandeau des 26 lettres -->
        <nav id="rail" aria-label="Lettres">
          <xsl:call-template name="rail"><xsl:with-param name="reste" select="$maj"/></xsl:call-template>
        </nav>

        <!-- Colonne de sélection : lettre > personnage -->
        <aside id="arbre" aria-label="Sélection">
          <h1><xsl:value-of select="$titre"/></h1>
          <p class="retour"><a href="index.html">Présentation du texte</a></p>
          <p class="aide">Cliquer sur une lettre ou cocher des personnages pour ne garder que ces cartes.</p>
          <button type="button" id="tout">Tout afficher</button>
          <xsl:call-template name="arbre"><xsl:with-param name="reste" select="$maj"/></xsl:call-template>
        </aside>

        <!-- Cartes, triées par ordre alphabétique -->
        <main id="cartes">
          <xsl:apply-templates select="$persos" mode="carte">
            <xsl:sort select="substring-after(@xml:id, 'p-')" data-type="text" lang="fr"/>
          </xsl:apply-templates>
        </main>

        <script src="script.js"></script>
      </body>
    </html>
  </xsl:template>

  <!-- ================= Bandeau : une touche par lettre ================= -->
  <xsl:template name="rail">
    <xsl:param name="reste"/>
    <xsl:if test="string-length($reste) &gt; 0">
      <xsl:variable name="L" select="substring($reste, 1, 1)"/>
      <xsl:variable name="n"
        select="count($persos[starts-with(translate(substring-after(@xml:id, 'p-'), $min, $maj), $L)])"/>
      <button type="button" class="lettre" data-lettre="{$L}">
        <xsl:if test="$n = 0"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
        <xsl:value-of select="$L"/>
      </button>
      <xsl:call-template name="rail"><xsl:with-param name="reste" select="substring($reste, 2)"/></xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- ================= Arbre : lettres non vides ================= -->
  <xsl:template name="arbre">
    <xsl:param name="reste"/>
    <xsl:if test="string-length($reste) &gt; 0">
      <xsl:variable name="L" select="substring($reste, 1, 1)"/>
      <xsl:variable name="groupe"
        select="$persos[starts-with(translate(substring-after(@xml:id, 'p-'), $min, $maj), $L)]"/>
      <xsl:if test="$groupe">
        <details open="open" id="lettre-{$L}">
          <summary>
            <label>
              <input type="checkbox" class="q" value="l-{$L}"/>
              <xsl:value-of select="$L"/>
            </label>
          </summary>
          <ul>
            <xsl:for-each select="$groupe">
              <xsl:sort select="substring-after(@xml:id, 'p-')" data-type="text" lang="fr"/>
              <li>
                <label>
                  <input type="checkbox" class="p" value="{@xml:id}" data-parent="l-{$L}"/>
                  <xsl:value-of select="tei:head"/>
                </label>
              </li>
            </xsl:for-each>
          </ul>
        </details>
      </xsl:if>
      <xsl:call-template name="arbre"><xsl:with-param name="reste" select="substring($reste, 2)"/></xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- ================= Carte : recto = image, verso = description ================= -->
  <xsl:template match="tei:div[@type='personnage']" mode="carte">
    <article class="carte" id="{@xml:id}" data-personnage="{@xml:id}"
             data-lettre="{translate(substring(substring-after(@xml:id, 'p-'), 1, 1), $min, $maj)}">
      <button type="button" class="carte-inner" aria-pressed="false">
        <span class="face recto">
          <img src="{tei:figure/tei:graphic/@url}" alt="{tei:head}"/>
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
  <xsl:template match="tei:pb"/>
</xsl:stylesheet>
