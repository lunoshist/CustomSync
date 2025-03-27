# Documentation/System-token.md

# Système de Design CustomSync - Documentation technique

Cette documentation détaille le système de tokens QML pour l'application desktop CustomSync, compatible avec **Qt 6.8.2**.

## Table des matières

1. [Introduction](#introduction)
2. [Architecture du système](#architecture-du-système)
3. [Installation et importation](#installation-et-importation)
4. [Tokens de design](#tokens-de-design)
   - [ColorPalette](#colorpalette)
   - [Typography](#typography)
   - [Spacing](#spacing)
   - [Elevation](#elevation)
   - [Radius](#radius)
   - [Animations](#animations)
   - [Theme](#theme)
5. [Problèmes courants à éviter](#problèmes-courants-à-éviter)

## Introduction

Ce système fournit des tokens (variables de design) pour tous les aspects visuels, assurant :
- Une expérience cohérente
- Un support natif des thèmes clair et sombre
- Une adaptabilité aux différentes tailles d'écran
- Une base solide pour tous les composants de l'application

### Principes fondamentaux

Le système de design CustomSync repose sur quatre principes clés :

1. **Élégance fonctionnelle** : Chaque élément sert un objectif clair tout en contribuant à une expérience visuellement harmonieuse.
2. **Respiration équilibrée** : Utilisation judicieuse des espaces vides pour créer un rythme visuel, sans excès ni insuffisance.
3. **Hiérarchie intuitive** : Guider le regard et l'attention de l'utilisateur grâce à des points d'accent stratégiques.
4. **Cohérence subtile** : Maintenir une unité visuelle qui renforce l'identité de l'application sans devenir monotone.

### Objectifs du système

Le système de tokens QML vise à :

- **Centraliser** les valeurs de design pour assurer la cohérence
- **Standardiser** l'apparence de tous les composants
- **Faciliter** les mises à jour globales du design
- **Automatiser** la gestion des thèmes clair et sombre
- **Simplifier** le développement des composants d'interface

## Architecture du système

### Structure des fichiers

Le système de tokens est organisé en 8 fichiers QML singleton dans `src/style/` :

```
src/style/
├── qmldir               # Registre des modules QML
├── ColorPalette.qml     # Couleurs (mode clair et sombre)
├── Typography.qml       # Typographie (famille, tailles, poids)
├── Spacing.qml          # Espacements et grille
├── Elevation.qml        # Ombres et élévations
├── Radius.qml           # Coins arrondis
├── Animations.qml       # Durées et courbes d'animation
└── Theme.qml            # Point d'entrée centralisant tous les tokens avec gestion du thème
```

L'architecture est conçue pour être :

- **Modulaire** : Chaque aspect du design est encapsulé dans son propre fichier
- **Extensible** : Facile à étendre avec de nouveaux tokens
- **Adaptative** : Supporte les thèmes clair et sombre
- **Réactive** : Les changements de thème sont propagés à l'interface
- **Performante** : Utilisation de caches pour optimiser les performances
- **Persistante** : Les préférences de thème sont sauvegardées entre les sessions

### Modèle de singleton

Chaque fichier (sauf qmldir) utilise `pragma Singleton` pour déclarer un singleton QML, permettant l'accès global à ses propriétés sans instanciation. Chaque singleton encapsule un `QtObject` contenant des propriétés et fonctions.

`Theme.qml` sert de point d'entrée centralisé, exposant les propriétés des autres modules adaptées au thème actuel (clair ou sombre) via un système de cache optimisé pour éviter les boucles de liaison.

### Système de caching

Pour optimiser les performances, en particulier lors des changements de thème :

1. **Theme.qml** utilise un système de caching intelligent qui :
   - Initialise des objets de cache au démarrage
   - Met à jour les caches uniquement lors des changements de thème
   - Utilise des fonctions d'accès pour éviter les boucles de liaison (binding loops)

2. Le caching est particulièrement important pour :
   - Les objets volumineux comme `colors` et `elevation`
   - Les changements fréquents comme les basculements de thème

## Installation et importation

### Configuration du fichier qmldir

Le fichier `qmldir` enregistre les modules comme singletons accessibles via l'espace de noms `Style` :

```qml
module Style

singleton ColorPalette 1.0 ColorPalette.qml
singleton Typography 1.0 Typography.qml
singleton Spacing 1.0 Spacing.qml
singleton Elevation 1.0 Elevation.qml
singleton Radius 1.0 Radius.qml
singleton Animations 1.0 Animations.qml
singleton Theme 1.0 Theme.qml
```

### Importation dans les fichiers QML

Dans vos fichiers QML, importez le système avec :

```qml
import QtQuick 6.5
// Autres imports nécessaires

import "../style" as Style
```

Le chemin relatif doit être ajusté en fonction de la structure de votre projet. L'alias `Style` est utilisé pour accéder aux modules.

### Deux approches d'utilisation

Le système offre deux approches d'accès :

1. **Accès direct** (ignore le thème actuel) :
```qml
Rectangle {
    color: Style.ColorPalette.backgroundSecondary  // Toujours la version claire
    radius: Style.Radius.m
}
```

2. **Via Theme** (s'adapte au thème actuel **RECOMMANDÉ**) :
```qml
Rectangle {
    color: Style.Theme.colors.backgroundSecondary  // S'adapte au thème actif
    radius: Style.Theme.radius.m  // Équivalent à Style.Radius.m
}
```

L'approche recommandée est de toujours utiliser `Style.Theme.XXX` que ce soit pour les couleurs ou pour les autres propriétés (car on ne sait jamais si elles seront dépendantes du thème dans le futur, par exemple si on décide d'implémenter un thème festif pour Noël qui changerait aussi la typographie).

## Tokens de design

Cette section détaille chaque module du système de tokens, ses propriétés et fonctions, ainsi que des exemples d'utilisation.

### ColorPalette

Définit toutes les couleurs du système pour les modes clair et sombre.

#### Propriétés principales (mode clair)

```qml
// Couleurs de base
readonly property color backgroundPrimary: "#FFFFFF"      // Fond principal
readonly property color backgroundSecondary: "#F5F5F7"    // Fond secondaire
readonly property color backgroundTertiary: "#EAEAEC"     // Fond tertiaire

// Nuances de gris
readonly property color textPrimary: "#202020"            // Texte principal
readonly property color textSecondary: "#5E5E5E"          // Texte secondaire  
readonly property color textTertiary: "#8E8E93"           // Texte tertiaire
readonly property color separator: "#D1D1D6"              // Séparateurs

// Couleurs d'accent
readonly property color accent: "#772953"                 // Aubergine
readonly property color accentLight: "#9A3D6E"            // Aubergine claire
readonly property color accentDark: "#5A1F3F"             // Aubergine sombre

// États fonctionnels
readonly property color success: "#2D9D78"                // Vert équilibré
readonly property color error: "#D64541"                  // Rouge distinctif
readonly property color warning: "#E9B949"                // Jaune ambre

// États des boutons
readonly property color buttonPrimaryBg: accent
readonly property color buttonPrimaryText: "#FFFFFF"
readonly property color buttonPrimaryHover: accentLight
readonly property color buttonPrimaryActive: accentDark
readonly property color buttonPrimaryDisabled: Qt.rgba(accent.r, accent.g, accent.b, 0.5)

readonly property color buttonSecondaryBg: backgroundSecondary
readonly property color buttonSecondaryText: textPrimary
readonly property color buttonSecondaryHover: backgroundTertiary
readonly property color buttonSecondaryActive: separator
readonly property color buttonSecondaryBorder: separator
```

#### Mode sombre

Toutes les propriétés du mode sombre sont préfixées par "dark" et correspondent à leurs équivalents clairs :

```qml
readonly property color darkBackgroundPrimary: "#1E1E1E"
readonly property color darkTextPrimary: "#F0F0F0"
readonly property color darkSuccess: "#3DB389"
// etc.
```

#### Fonctions utilitaires

ColorPalette offre des fonctions utilitaires pour manipuler les couleurs :

```qml
/**
 * Génère une version semi-transparente d'une couleur
 * @param {color} baseColor - Couleur de base
 * @param {real} opacity - Opacité (0-1)
 * @return {color} - Couleur semi-transparente
 */
function withOpacity(baseColor, opacity)

/**
 * Crée une teinte plus claire d'une couleur
 * @param {color} baseColor - Couleur de base
 * @param {real} factor - Facteur d'éclaircissement (0-1)
 * @return {color} - Couleur éclaircie
 */
function lighter(baseColor, factor)

/**
 * Crée une teinte plus sombre d'une couleur
 * @param {color} baseColor - Couleur de base
 * @param {real} factor - Facteur d'assombrissement (0-1)
 * @return {color} - Couleur assombrie
 */
function darker(baseColor, factor)
```

#### Utilisation

```qml
Rectangle {
    color: Style.Theme.colors.backgroundSecondary
    border.color: Style.Theme.colors.separator
    
    Text {
        color: Style.Theme.colors.textPrimary
        text: "Exemple"
    }
    
    // Utilisation des fonctions utilitaires
    Rectangle {
        color: Style.Theme.colorPalette.withOpacity(Style.Theme.colors.accent, 0.3)
        // Crée une version semi-transparente de la couleur d'accent
    }
}
```

### Typography

Gère tous les aspects typographiques du système.

#### Propriétés principales

```qml
// Famille de police
readonly property string fontFamily: "Ubuntu"

// Poids de police
readonly property int fontWeightLight: Font.Light
readonly property int fontWeightRegular: Font.Normal
readonly property int fontWeightMedium: Font.Medium

// Tailles de police
readonly property int fontSizeH1: 24         // Titres (h1)
readonly property int fontSizeH2: 20         // Sous-titres (h2)
readonly property int fontSizeH3: 16         // Titres de section (h3)
readonly property int fontSizeH4: 14         // En-têtes (h4)
readonly property int fontSizeBody: 14       // Corps de texte
readonly property int fontSizeSecondary: 13  // Texte secondaire
readonly property int fontSizeSmall: 12      // Petits textes

// Hauteurs de ligne
readonly property int lineHeightH1: 32       // Pour titres h1
readonly property int lineHeightH2: 28       // Pour sous-titres h2
readonly property int lineHeightH3: 24       // Pour titres de section h3
readonly property int lineHeightH4: 20       // Pour en-têtes h4
readonly property int lineHeightBody: 20     // Pour corps de texte
readonly property int lineHeightSecondary: 18 // Pour texte secondaire
readonly property int lineHeightSmall: 16    // Pour petits textes

// Espacement des lettres
readonly property real letterSpacingH1: -0.2
readonly property real letterSpacingH2: -0.1
readonly property real letterSpacingH3: 0
readonly property real letterSpacingH4: 0
readonly property real letterSpacingBody: 0
readonly property real letterSpacingSecondary: 0
readonly property real letterSpacingSmall: 0

// Espacement entre paragraphes
readonly property int paragraphSpacing: 20    // Espacement minimum entre paragraphes
```

#### Fonctions d'aide

Typography propose des fonctions d'aide pour appliquer rapidement tous les styles :

```qml
/**
 * Applique les propriétés de titre h1 à un Text
 * @param {Text} textItem - L'élément Text à styliser
 */
function applyH1Style(textItem)

/**
 * Applique les propriétés de titre h2 à un Text
 * @param {Text} textItem - L'élément Text à styliser
 */
function applyH2Style(textItem)

// ... autres fonctions similaires pour h3, h4, body, secondary, small
```

#### Utilisation

```qml
// Utilisation directe des propriétés
Text {
    font.family: Style.Theme.typography.fontFamily
    font.pixelSize: Style.Theme.typography.fontSizeH1
    font.weight: Style.Theme.typography.fontWeightLight
    font.letterSpacing: Style.Theme.typography.letterSpacingH1
    lineHeight: Style.Theme.typography.lineHeightH1
    text: "Titre principal"
}

// Utilisation des fonctions d'aide
Text {
    id: monTitre
    text: "Titre principal"
    Component.onCompleted: {
        Style.Theme.typography.applyH1Style(monTitre)
    }
}

// Espacement entre paragraphes
Column {
    spacing: Style.Theme.typography.paragraphSpacing
    
    Text {
        text: "Premier paragraphe..."
        width: parent.width
        wrapMode: Text.WordWrap
    }
    
    Text {
        text: "Second paragraphe..."
        width: parent.width
        wrapMode: Text.WordWrap
    }
}
```

### Spacing

Définit un système d'espacement cohérent basé sur une unité de 8px et une grille à 12 colonnes.

#### Propriétés principales

```qml
readonly property int unit: 8        // Unité de base
readonly property int xs: 4          // Extra small
readonly property int s: 8           // Small
readonly property int m: 16          // Medium
readonly property int l: 24          // Large
readonly property int xl: 32         // Extra large
readonly property int xxl: 48        // Extra extra large

// Espacements spécifiques
readonly property int sectionSpacing: 32     // Espacement vertical entre sections
readonly property int paragraphSpacing: 20   // Espacement minimum entre paragraphes
readonly property int marginMobile: 24       // Marges latérales sur mobile
readonly property int marginDesktop: 32      // Marges latérales sur desktop

// Grille
readonly property int columns: 12    // Nombre de colonnes
readonly property int gutterSize: 16 // Gouttières
```

#### Fonctions d'aide

```qml
/**
 * Calcule la largeur d'une colonne en fonction de la largeur totale disponible
 * @param {real} totalWidth - Largeur totale disponible
 * @param {int} numColumns - Nombre de colonnes à calculer (1-12)
 * @return {real} - Largeur en pixels pour le nombre de colonnes spécifié
 */
function columnWidth(totalWidth, numColumns)

/**
 * Calcule le décalage (offset) pour commencer à la colonne spécifiée
 * @param {real} totalWidth - Largeur totale disponible
 * @param {int} startColumn - Colonne de départ (1-12)
 * @return {real} - Décalage en pixels pour commencer à la colonne spécifiée
 */
function columnOffset(totalWidth, startColumn)

/**
 * Multiplie l'unité de base par un facteur
 * @param {real} factor - Facteur de multiplication
 * @return {real} - Valeur en pixels (unit * factor)
 */
function multiply(factor)
```

#### Utilisation

```qml
// Utilisation des espacements prédéfinis
Column {
    spacing: Style.Theme.spacing.m  // 16px d'espacement vertical
    
    Rectangle {
        width: Style.Theme.spacing.columnWidth(parent.width, 3)
        height: 50
        color: "green"
    }
    
    Rectangle {
        width: Style.Theme.spacing.columnWidth(parent.width, 3)
        height: 50
        color: "blue"
    }
}

// Utilisation de la fonction multiply
Item {
    width: Style.Theme.spacing.multiply(30)  // 30 * 8 = 240px
    height: Style.Theme.spacing.multiply(20) // 20 * 8 = 160px
}
```

### Elevation

Définit les ombres pour créer une hiérarchie spatiale dans l'interface.

#### Propriétés principales

```qml
// Niveau 0 - Surface de base (pas d'ombre)
readonly property var noShadow: {
    "horizontalOffset": 0,
    "verticalOffset": 0,
    "radius": 0,
    "samples": 17,  // Requis pour Qt5Compat.GraphicalEffects
    "color": Qt.rgba(0, 0, 0, 0),
    "cssValue": "none"
}

// Niveau 1 - Élévation basse (composants interactifs)
readonly property var shadowLow: {
    "horizontalOffset": 0,
    "verticalOffset": 1,
    "radius": 3,
    "samples": 17,  // Requis pour Qt5Compat.GraphicalEffects
    "color": Qt.rgba(0, 0, 0, 0.08),
    "cssValue": "0 1px 3px rgba(0,0,0,0.08)"
}

// Niveau 2 - Élévation moyenne (cartes et éléments flottants)
readonly property var shadowMedium: { ... }

// Niveau 3 - Élévation haute (modaux et popups)
readonly property var shadowHigh: { ... }

// Ombre intérieure pour les champs focus
readonly property var innerShadow: { ... }

// Mode sombre équivalent
readonly property var darkNoShadow: noShadow
readonly property var darkShadowLow: { ... }
readonly property var darkShadowMedium: { ... }
readonly property var darkShadowHigh: { ... }
readonly property var darkInnerShadow: { ... }
```

#### Fonctions d'aide

```qml
/**
 * Applique une ombre selon le niveau et le thème à un élément avec effet DropShadow
 * @param {Object} target - élément cible avec layer.effect de type DropShadow
 * @param {string} level - niveau d'ombre ("low", "medium", "high")
 * @param {boolean} isDark - utiliser le thème sombre (true) ou clair (false)
 */
function applyDropShadow(target, level, isDark)

/**
 * Applique une ombre intérieure à un élément
 * @param {Object} target - élément cible avec layer.effect de type InnerShadow
 * @param {boolean} isDark - utiliser le thème sombre (true) ou clair (false)
 */
function applyInnerShadow(target, isDark)
```

#### Utilisation

```qml
// Utilisation avec DropShadow
import Qt5Compat.GraphicalEffects

Rectangle {
    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: Style.Theme.elevation.shadowMedium.horizontalOffset
        verticalOffset: Style.Theme.elevation.shadowMedium.verticalOffset
        radius: Style.Theme.elevation.shadowMedium.radius
        samples: Style.Theme.elevation.shadowMedium.samples  // Important ! Requis dans Qt 6
        color: Style.Theme.elevation.shadowMedium.color
    }
}

// Utilisation avec la fonction d'aide
Component.onCompleted: {
    Style.Theme.elevation.applyDropShadow(card, "medium", Style.Theme.isDarkTheme)
}

// Ombre intérieure pour un champ en focus
Rectangle {
    id: inputField
    property bool isFocused: false
    
    border.width: isFocused ? 1 : 1
    border.color: isFocused ? Style.Theme.colors.accent : Style.Theme.colors.separator
    
    // Appliquer l'ombre intérieure uniquement en focus
    layer.enabled: isFocused
    layer.effect: InnerShadow {
        // Propriétés initialisées vides
    }
    
    onIsFocusedChanged: {
        if (isFocused) {
            Style.Theme.elevation.applyInnerShadow(inputField, Style.Theme.isDarkTheme)
        }
    }
}
```

### Radius

Fournit les rayons standard pour les coins arrondis.

#### Propriétés principales

```qml
readonly property int xs: 2  // Badges, tags
readonly property int s: 4   // Boutons, champs
readonly property int m: 6   // Cartes, conteneurs
readonly property int l: 8   // Dialogues, grands conteneurs
```

#### Fonctions d'aide

```qml
/**
 * Applique un rayon à un élément
 * @param {Object} item - élément cible
 * @param {string|number} size - taille du rayon ("xs", "s", "m", "l" ou valeur numérique)
 */
function applyRadius(item, size)
```

#### Utilisation

```qml
Rectangle {
    radius: Style.Theme.radius.s  // 4px pour les boutons
}

Rectangle {
    radius: Style.Theme.radius.m  // 6px pour les cartes
}

// Utilisation avec la fonction d'aide
Component.onCompleted: {
    Style.Theme.radius.applyRadius(myButton, "s")
    Style.Theme.radius.applyRadius(myCard, "m")
}

// Utilisation avec valeur numérique
Component.onCompleted: {
    Style.Theme.radius.applyRadius(customElement, 10)  // 10px
}
```

### Animations

Définit les durées et courbes d'animation standards avec une approche déclarative plutôt que dynamique.

#### Propriétés principales

```qml
// Durées
readonly property int durationFast: 150        // Transitions rapides
readonly property int durationStandard: 200    // Transitions générales
readonly property int durationEmphasis: 300    // Transitions mises en valeur

// Courbes
readonly property int easeOut: Easing.OutQuad
readonly property int easeInOut: Easing.InOutQuad
readonly property int emphasizedCurve: Easing.BezierSpline
readonly property var emphasizedParams: [0.4, 0, 0.2, 1]

// Configurations prédéfinies pour les transitions
readonly property var standardTransitionParams: {
    "duration": durationStandard,
    "easing": easeOut
}

readonly property var fastTransitionParams: {
    "duration": durationFast,
    "easing": easeOut
}

readonly property var emphasisTransitionParams: {
    "duration": durationEmphasis,
    "easing": emphasizedCurve,
    "bezierCurve": emphasizedParams
}

// Modèles prédéfinis pour différentes propriétés
readonly property var behaviorTemplates: { /* Templates pour opacity, position, size, color */ }
```

#### Fonctions d'aide

```qml
/**
 * Crée un objet de configuration pour une NumberAnimation
 * @param {string} property - propriété à animer (ex: "opacity", "x,y,z")
 * @param {string} [speed="standard"] - vitesse d'animation ("fast", "standard", "emphasis")
 * @return {Object} - objet de configuration pour NumberAnimation
 */
function createNumberAnimation(property, speed)

/**
 * Crée un objet de configuration pour une ColorAnimation
 * @param {string} property - propriété à animer (ex: "color", "border.color")
 * @param {string} [speed="standard"] - vitesse d'animation ("fast", "standard", "emphasis")
 * @return {Object} - objet de configuration pour ColorAnimation
 */
function createColorAnimation(property, speed)

/**
 * Génère du code QML pour un Behavior standardisé
 * Approche déclarative plutôt que dynamique
 * 
 * @param {string} property - nom de la propriété à animer
 * @param {string} type - type d'animation ("number", "color")
 * @param {string} [speed="standard"] - vitesse d'animation ("fast", "standard", "emphasis")
 * @return {string} - code QML à utiliser dans un fichier QML
 */
function getAnimationCode(property, type, speed)

/**
 * Génère une configuration d'animation pour les transitions de thème
 * @return {Object} - Objet de configuration pour les transitions de thème
 */
function createThemeTransition()
```

#### Utilisation

```qml
// Approche déclarative recommandée
Behavior on opacity {
    NumberAnimation {
        duration: Style.Theme.animations.durationStandard
        easing.type: Style.Theme.animations.easeOut
    }
}

// Animation de couleur
Behavior on color {
    ColorAnimation {
        duration: Style.Theme.animations.durationFast
    }
}

// Animation avec courbe bézier personnalisée
NumberAnimation {
    property: "scale"
    from: 0.8; to: 1.0
    duration: Style.Theme.animations.durationEmphasis
    easing.type: Style.Theme.animations.emphasizedCurve
    easing.bezierCurve: Style.Theme.animations.emphasizedParams
}

// Générer et copier du code d'animation
/*
// Exemple de code généré par getAnimationCode("opacity", "number", "standard")
Behavior on opacity {
    NumberAnimation {
        duration: 200
        easing.type: Easing.OutQuad
    }
}
*/

// Utilisation de la configuration de transition de thème
SequentialAnimation {
    id: themeChangeAnimation
    
    PropertyAnimation {
        target: mainContent
        property: "opacity"
        to: 0.8
        duration: Style.Theme.animations.durationFast
        easing.type: Style.Theme.animations.easeOut
    }
    
    PropertyAnimation {
        target: mainContent
        property: "opacity"
        to: 1.0
        duration: Style.Theme.animations.durationFast
        easing.type: Style.Theme.animations.easeOut
    }
}

// Lancer l'animation lors du changement de thème
Connections {
    target: Style.Theme
    function onThemeChanged() {
        themeChangeAnimation.start()
    }
}
```

### Theme

Point d'entrée qui expose les tokens adaptés au thème actuel avec un système de cache optimisé pour éviter les boucles de liaison.

#### Propriétés principales

```qml
// État du thème
property bool isDarkTheme: false          // Mode sombre activé
property bool followSystemTheme: true     // Suivre le thème du système

// Signal émis lors du changement de thème
signal themeChanged()

// Objets de cache pour optimiser la création
property var _colorCache: ({})
property var _elevationCache: ({})

// Couleurs adaptées au thème (renvoie le cache)
readonly property var colors: _getColors()

// Élévations adaptées au thème (renvoie le cache)
readonly property var elevation: _getElevation()

// Références aux autres modules
readonly property var typography: Typography
readonly property var spacing: Spacing
readonly property var radius: Radius
readonly property var animations: Animations
```

#### Fonctions principales

```qml
/**
 * Fonction d'accès au cache des couleurs
 * @private
 * @return {Object} - Cache de couleurs
 */
function _getColors()

/**
 * Fonction d'accès au cache des élévations
 * @private
 * @return {Object} - Cache d'élévations
 */
function _getElevation()

/**
 * Crée l'objet de couleurs complet
 * @private
 * @return {Object} - Objet avec toutes les couleurs adaptées au thème
 */
function _createColorObject()

/**
 * Crée l'objet d'élévation complet
 * @private
 * @return {Object} - Objet avec toutes les élévations adaptées au thème
 */
function _createElevationObject()

/**
 * Fonction appelée depuis Python pour mettre à jour le thème système
 * @param {bool} isDark - true pour le thème sombre, false pour le thème clair
 */
function setSystemTheme(isDark)

/**
 * Bascule manuellement entre thème clair et sombre
 */
function toggleDarkMode()

/**
 * Active le suivi du thème système
 */
function enableFollowSystemTheme()

/**
 * Vérifie si un élément est en thème sombre
 * @param {Object} item - élément à vérifier (peut avoir sa propre propriété isDarkTheme)
 * @return {bool} - true si l'élément doit utiliser le thème sombre
 */
function isItemDark(item)

/**
 * Applique une couleur adaptée au thème à un élément
 * @param {Object} item - élément cible
 * @param {string} property - nom de la propriété (ex: "color", "border.color")
 * @param {color} lightColor - couleur pour le thème clair
 * @param {color} darkColor - couleur pour le thème sombre
 * @return {bool} - true si l'opération a réussi
 */
function applyThemedColor(item, property, lightColor, darkColor)
```

#### Utilisation

```qml
// Utilisation des couleurs adaptées au thème
Rectangle {
    color: Style.Theme.colors.backgroundPrimary
    
    Text {
        color: Style.Theme.colors.textPrimary
        // ...
    }
}

// Changement manuel de thème
Button {
    text: "Changer de thème"
    onClicked: Style.Theme.toggleDarkMode()
}

// Activation du suivi du thème système
Button {
    text: "Suivre le thème système"
    onClicked: Style.Theme.enableFollowSystemTheme()
}

// Réaction au changement de thème
Connections {
    target: Style.Theme
    function onThemeChanged() {
        // Faire quelque chose quand le thème change
        console.log("Thème actuel:", Style.Theme.isDarkTheme ? "sombre" : "clair")
        
        // Animation de transition
        themeTransition.start()
    }
}

// Application d'une couleur adaptée au thème
Component.onCompleted: {
    Style.Theme.applyThemedColor(rectangle, "color", "#F5F5F7", "#252528")
}
```

## Problèmes courants à éviter

### 1. Imports incorrects pour Qt 6

**Problème** : Utiliser les noms de modules de Qt 5 dans Qt 6 génère des erreurs.

**Erreur typique** :
```
module "QtGraphicalEffects" is not installed
```

**Solution** :
- Utiliser `import Qt5Compat.GraphicalEffects` pour les effets visuels
- Utiliser `import QtCore 6.5` pour les Settings
- Consulter la documentation Qt 6 pour les autres modules

### 2. Propriétés manquantes dans les effets

**Problème** : Les effets comme DropShadow nécessitent des propriétés supplémentaires dans Qt 6.

**Erreur typique** :
```
QML DropShadow: Cannot render shadow, unsupported source format
```

**Solution** :
- Toujours inclure la propriété `samples` pour DropShadow
- Vérifier que `layer.enabled` est défini à `true`

### 3. Mauvaises références aux propriétés des effets

**Problème** : Tentative d'accéder directement aux propriétés d'un effet via PropertyChanges sans définir le bon chemin.

**Erreur typique** :
```
QML PropertyChanges: Cannot assign to non-existent property "radius"
```

**Solution** :
- Accéder correctement aux propriétés via leur chemin complet : `target: myItem.layer.effect`
- Ou utiliser une propriété booléenne et des Behaviors pour animer les transitions

### 4. Boucles de layout polish()

**Problème** : Les éléments comme `Column` ou `Row` peuvent entrer dans une boucle infinie de calcul de mise en page si leurs dimensions dépendent à la fois de leurs parents et de leurs enfants.

**Erreur typique** :
```
QML Column: possible QQuickItem::polish() loop
QML Column: Column called polish() inside updatePolish() of Column
```

**Solution** :
- Utiliser un positionnement explicite avec des ancres
- Éviter les dépendances circulaires dans les tailles
- Pour les listes complexes, utiliser ListView avec des délégués bien définis

### 5. Utiliser du scaling pour des effets hover

**Problème** : Utiliser du scaling pour des effets de hover peut rendre les textes flous

**Solution** : Privilégier des changements d'ombres ou d'autres propriétés visuelles qui n'affectent pas la netteté du texte

## Intégration avec Python

Le système de tokens est conçu pour s'intégrer avec Python pour la détection du thème système d'Ubuntu. Le fichier `main.py` contient une fonction pour détecter le thème système et le communiquer au QML :

```python
def detect_system_dark_theme():
    """Détecte si le thème système est sombre."""
    # Cette fonction est spécifique à la plateforme
    
    # Sur Linux avec GNOME
    if sys.platform.startswith("linux"):
        try:
            import subprocess
            # Pour GNOME
            result = subprocess.run(
                ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"],
                capture_output=True, text=True
            )
            if "dark" in result.stdout.lower():
                return True
            
            # Pour GNOME plus ancien ou autres environnements
            result = subprocess.run(
                ["gsettings", "get", "org.gnome.desktop.interface", "gtk-theme"],
                capture_output=True, text=True
            )
            return "dark" in result.stdout.lower()
        except:
            pass
    
    # Autres plateformes...
    
    return False
```

Cette fonction est appelée périodiquement pour mettre à jour l'interface en fonction des préférences système.

## Bonnes pratiques d'utilisation

1. **Toujours utiliser le module Theme**
   - Privilégier `Style.Theme.colors.backgroundPrimary` plutôt que `Style.ColorPalette.backgroundPrimary`
   - Cela garantit que les couleurs s'adaptent automatiquement au thème actif

2. **Structures adaptées pour les éléments répétitifs**
   - Créer des composants réutilisables qui tirent parti du système de tokens
   - Définir les propriétés de style dans des objets QtObject pour une meilleure organisation

3. **Réaction aux changements de thème**
   - Se connecter au signal `Style.Theme.themeChanged()` pour mettre à jour les éléments dynamiques
   - Utiliser des animations de transition pour adoucir les changements de thème

4. **Utilisation des effets visuels**
   - Toujours définir `layer.enabled: true` sur les éléments avec effets
   - Toujours spécifier le paramètre `samples` pour les effets Drop/InnerShadow
   - Utiliser les fonctions d'aide comme `applyDropShadow` et `applyInnerShadow`

5. **Documentation des composants**
   - Documenter clairement quels tokens sont utilisés dans chaque composant personnalisé
   - Créer une documentation visuelle montrant les variations de thème

6. **Test des deux thèmes**
   - Tester régulièrement les composants dans les deux thèmes pour assurer la compatibilité
   - Vérifier les contrastes et la lisibilité dans les deux modes

## Conclusion

Ce système de tokens fournit une base solide et cohérente pour l'interface utilisateur de CustomSync. En centralisant toutes les propriétés visuelles et en gérant automatiquement les thèmes, il permet de développer plus rapidement tout en maintenant une expérience utilisateur de haute qualité.

L'approche optimisée avec caching et l'évitement des boucles de liaison assure une performance fluide même lors des changements de thème.

Pour toute question ou suggestion d'amélioration concernant ce système, veuillez consulter la documentation du projet ou contacter l'équipe de développement.