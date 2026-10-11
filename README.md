# Workshop2026

# Présentation
Ce workshop est à destination des M1, M2 et enseignants curieux de découvrir le traitement numérique des textes. 
Il repose sur un format de trois heures visant à : 

1. Comprendre les bases d'XML, XPath et HTML
1. Encoder les _Courses de testes et de bague faites par le Roy et par les princes et seigneurs de sa cour en l'année 1662_ de Charles Perrault
1. Comprendre la visualisation web des données ainsi obtenues

# Récupérer les documents de travail
Pour suivre le workshop, il est nécessaire de télécharger l'ensemble du _repository_ en cliquant sur `code` en haut à droite puis sur
`Download ZIP`. Ce fichier ZIP, nous vous conseillons de l'extraire dans un répertoire de travail dédié au workshop (intitulé par exemple "workshop2026") sur le bureau.

Étant donné qu'il s'agit d'un format de découverte du numérique nous nous attachons à n'avoir aucun prérequis, en particulier Git pour le travail sur GitHub. 

Si, toutefois, Git est installé sur votre machine, il suffit d'ouvrir le terminal(MacOs, Linux) / Invite de commande (Windows) dans votre répertoire de travail et d'entrer la commande suivante : 

`git clone https://github.com/lucas-38-L3/Workshop2026.git`

Nous n'utiliserons toutefois pas Git pour collaborer, il y aura donc un second téléchargement à faire une fois les fichiers xml transformés en fichier html.

# Informations utiles
1. Pour le traitement des fichiers xml nous vous conseillons d'utiliser l'éditeur en ligne [XML Online Viewer](https://xml.onlineviewer.net/)
    1. Il faut importer le fichier xml en cliquant sur `Import`
    1. Travailler dessus 
    1. Cliquer sur `Export` (il doit se mettre dans les téléchargements de votre machine)
    1. Le renommer **exactement** comme le fichier d'origine
    1. L'envoyer par mail à `lucas.favier@univ-lyon3.fr`  
1. Le langage XML n'est pas inné ! Si vous avez la moindre question **n'hésitez pas à la poser !**
1. L'arborescence du répertoire dans lequel nous travaillons est la suivante
    1. Vous allez modifier les fichiers Q1/Q2/Q3/Q4 et Q5. Nous tranformerons ensuite les fichiers XML à l'aide d'une fiche XSL qui 
    génèrera un fichier `cartes.html` dans `public` à partir du fichier `master.xml`.
```
.
└── perrault
    ├── public
    │   ├── img
    │   │   ├── 0101.png
    │   │   ├── 0102.png
    │   │   ├── 0103.png
    │   │   ├── 0104.png
    │   │   ├── 0105.png
    │   │   ├── 0106.png
    │   │   ├── 0107.png
    │   │   ├── 0108.png
    │   │   ├── 0109.png
    │   │   ├── 0110.png
    │   │   ├── 0111.png
 [...]
    │   │   ├── 0501.png
    │   │   ├── 0502.png
    │   │   ├── 0503.png
    │   │   ├── 0504.png
    │   │   ├── 0505.png
    │   │   ├── 0506.png
    │   │   ├── 0507.png
    │   │   ├── 0508.png
    │   │   ├── 0509.png
    │   │   ├── 0510.png
    │   │   └── 0511.png
    │   ├── index.html
    │   ├── script.js
    │   └── style.css
    ├── xml
    │   ├── master.xml
    │   └── quadrilles
    │       ├── Q1.xml
    │       ├── Q2.xml
    │       ├── Q3.xml
    │       ├── Q4.xml
    │       └── Q5.xml
    └── xsl
        ├── perrault.xsl
        └── perrault2.xsl
```


