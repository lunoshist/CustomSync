# Système de Design CustomSync

Documentation technique du système de tokens QML pour l'application desktop CustomSync.

## Table des matières

1. [Introduction](#introduction)
2. [Architecture du système](#architecture-du-système)
3. [Tokens de design](#tokens-de-design)
   - [ColorPalette.qml](#colorpaletteqml)
   - [Typography.qml](#typographyqml)
   - [Spacing.qml](#spacingqml)
   - [Elevation.qml](#elevationqml)
   - [Radius.qml](#radiusqml)
   - [Animations.qml](#animationsqml)
   - [Theme.qml](#themeqml)
4. [Utilisation pratique](#utilisation-pratique)
5. [Exemples d'intégration](#exemples-dintégration)
6. [Gestion du thème clair/sombre](#gestion-du-thème-clairsombre)

## Introduction

Le système de design CustomSync a été développé pour assurer une cohérence visuelle à travers l'application. Il s'inspire du document de spécification design-system-v2.md et implémente les principes fondamentaux:

- **Élégance fonctionnelle**: Chaque élément sert un objectif clair tout en contribuant à une expérience visuellement harmonieuse
- **Respiration équilibrée**: Utilisation judicieuse des espaces vides pour créer un rythme visuel
- **Hiérarchie intuitive**: Guider le regard et l'attention de l'utilisateur
- **Cohérence subtile**: Maintenir une unité visuelle qui renforce l'identité de l'application

## Architecture du système

Le système de tokens est organisé en 7 fichiers QML singleton situés dans le dossier `src/style/`:

```
src/style/
├── qmldir               # Registre des modules QML
├── ColorPalette.qml     # Couleurs
├── Typography.qml       # Typographie
├── Spacing.qml          # Espacements
├── Elevation.qml        # Ombres et élévations
├── Radius.qml           # Coins arrondis
├── Animations.qml       # Animations et transitions
└── Theme.qml            # Point d'entrée principal
```

Le fichier `qmldir` enregistre tous les modules en tant que singletons QML:

```
module Style
singleton ColorPalette 1.0 ColorPalette.qml
singleton Typography 1.0 Typography.qml
singleton Spacing 1.0 Spacing.qml
singleton Elevation 1.0 Elevation.qml
singleton Radius 1.0 Radius.qml
singleton Animations 1.0 Animations.qml
singleton Theme 1.0 Theme.qml
```

### Import du système de tokens

Dans vos fichiers QML, importez le système de design avec:

```qml
import "../style" as Style
```

Puis accédez aux tokens selon deux approches:

1. **Accès direct** (ignore le thème sombre/clair):
   ```qml
   Rectangle {
       color: Style.ColorPalette.backgroundSecondary
       radius: Style.Radius.m
   }
   ```

2. **Accès via Theme** (s'adapte au thème sombre/clair):
   ```qml
   Rectangle {
       color: Style.Theme.colors.backgroundSecondary
       radius: Style.Theme.radius.m
   }
   ```

## Tokens de design

### ColorPalette.qml

Contient toutes les couleurs du système de design, avec des variantes pour le mode clair et sombre.

#### Propriétés importantes

**Mode clair:**
```qml
// Couleurs de base
backgroundPrimary: "#FFFFFF"      // Fond principal
backgroundSecondary: "#F5F5F7"    // Fond secondaire
backgroundTertiary: "#EAEAEC"     // Fond tertiaire

// Nuances de gris
textPrimary: "#202020"            // Texte principal
textSecondary: "#5E5E5E"          // Texte secondaire  
textTertiary: "#8E8E93"           // Texte tertiaire
separator: "#D1D1D6"              // Séparateurs

// Couleurs d'accent
accentPrimary: "#772953"          // Aubergine
accentLight: "#9A3D6E"            // Aubergine claire
accentDark: "#5A1F3F"             // Aubergine sombre

// États fonctionnels
success: "#2D9D78"                // Vert équilibré
error: "#D64541"                  // Rouge distinctif
warning: "#E9B949"                // Jaune ambre
```

**Mode sombre:**
```qml
// Préfixées par 'dark'
darkBackgroundPrimary: "#1E1E1E"     // Fond principal
darkBackgroundSecondary: "#252528"   // Fond secondaire
darkBackgroundTertiary: "#2D2D30"    // Fond tertiaire
darkTextPrimary: "#F0F0F0"           // etc.
```

#### Exemple d'utilisation

```qml
Rectangle {
    color: Style.ColorPalette.backgroundSecondary
    border.color: Style.ColorPalette.separator
    
    Text {
        color: Style.ColorPalette.textPrimary
        text: "Exemple"
    }
}
```

### Typography.qml

Gère tous les aspects typographiques définis dans le système de design.

#### Propriétés importantes

```qml
// Famille de police
fontFamily: "Ubuntu"

// Poids de police
fontWeightLight: Font.Light
fontWeightRegular: Font.Normal
fontWeightMedium: Font.Medium

// Tailles de police
fontSizeH1: 24         // Titres (h1)
fontSizeH2: 20         // Sous-titres (h2)
fontSizeH3: 16         // Titres de section (h3)
fontSizeH4: 14         // En-têtes (h4)
fontSizeBody: 14       // Corps de texte
fontSizeSecondary: 13  // Texte secondaire
fontSizeSmall: 12      // Petits textes

// Hauteurs de ligne
lineHeightH1: 32       // Pour titres h1
lineHeightH2: 28       // etc.
```

#### Fonctions d'aide

Typography propose des fonctions d'aide pour appliquer rapidement les styles:

```qml
// Retourne un objet avec toutes les propriétés pour un titre h1
h1() => {
    "font.family": fontFamily,
    "font.pixelSize": fontSizeH1,
    "font.weight": fontWeightLight,
    "lineHeight": lineHeightH1,
    "font.letterSpacing": letterSpacingH1
}

// De même pour h2(), h3(), h4(), body(), secondary(), small()
```

#### Exemple d'utilisation

```qml
// Utilisation des propriétés individuelles
Text {
    font.family: Style.Typography.fontFamily
    font.pixelSize: Style.Typography.fontSizeH1
    font.weight: Style.Typography.fontWeightLight
    lineHeight: Style.Typography.lineHeightH1
    text: "Titre principal"
}

// Alternative avec les fonctions d'aide
Text {
    font {
        family: Style.Typography.h1()["font.family"]
        pixelSize: Style.Typography.h1()["font.pixelSize"]
        weight: Style.Typography.h1()["font.weight"]
        letterSpacing: Style.Typography.h1()["font.letterSpacing"]
    }
    lineHeight: Style.Typography.h1()["lineHeight"]
    text: "Titre principal"
}
```

### Spacing.qml

Définit un système d'espacement cohérent basé sur une unité de 8px.

#### Propriétés importantes

```qml
unit: 8                // Unité de base
xs: 4                  // Extra small
s: 8                   // Small
m: 16                  // Medium
l: 24                  // Large
xl: 32                 // Extra large
xxl: 48                // Extra extra large
sectionSpacing: 32     // Entre sections
marginMobile: 24       // Marges latérales mobiles
marginDesktop: 32      // Marges latérales desktop
gutterSize: 16         // Gouttières de grille
```

#### Exemple d'utilisation

```qml
Column {
    spacing: Style.Spacing.m  // 16px d'espacement vertical
    
    Rectangle {
        anchors.margins: Style.Spacing.s  // 8px de marge
    }
}
```

### Elevation.qml

Définit les ombres pour créer une hiérarchie spatiale dans l'interface.

#### Propriétés importantes

```qml
// En format CSS (string)
shadowLow: "0 1px 3px rgba(0,0,0,0.08)"
shadowMedium: "0 3px 6px rgba(0,0,0,0.1)"
shadowHigh: "0 8px 16px rgba(0,0,0,0.12)"

// En objets décomposés pour DropShadow
shadowLowValues: {
    "horizontalOffset": 0,
    "verticalOffset": 1,
    "radius": 3,
    "color": Qt.rgba(0, 0, 0, 0.08)
}
// etc.

// Versions pour mode sombre
darkShadowLow: "0 1px 3px rgba(0,0,0,0.2)"
// etc.
```

#### Exemple d'utilisation

```qml
import QtGraphicalEffects 1.15

Rectangle {
    // ...
    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: Style.Elevation.shadowMediumValues.horizontalOffset
        verticalOffset: Style.Elevation.shadowMediumValues.verticalOffset
        radius: Style.Elevation.shadowMediumValues.radius
        color: Style.Elevation.shadowMediumValues.color
    }
}
```

### Radius.qml

Fournit les rayons standard pour les coins arrondis.

#### Propriétés importantes

```qml
xs: 2      // Pour badges, tags
s: 4       // Pour boutons, champs
m: 6       // Pour cartes, conteneurs
l: 8       // Pour dialogues, grands conteneurs
```

#### Exemple d'utilisation

```qml
// Bouton
Rectangle {
    radius: Style.Radius.s  // 4px
}

// Carte
Rectangle {
    radius: Style.Radius.m  // 6px
}
```

### Animations.qml

Définit les durées et courbes d'animation standards.

#### Propriétés importantes

```qml
// Durées
durationFast: 150        // Transitions rapides
durationStandard: 200    // Transitions générales
durationEmphasis: 300    // Transitions mises en valeur

// Courbes
easeOut: Easing.OutQuad
easeInOut: Easing.InOutQuad
emphasizedCurve: Easing.Bezier
emphasizedParams: [0.4, 0, 0.2, 1]

// Configurations pré-définies
standardTransition: {
    "duration": durationStandard,
    "easing.type": easeOut
}
// etc.
```

#### Exemple d'utilisation

```qml
Behavior on opacity {
    NumberAnimation {
        duration: Style.Animations.durationStandard
        easing.type: Style.Animations.easeOut
    }
}
```

### Theme.qml

Point d'entrée central qui expose les tokens adaptés au thème actuel (clair/sombre).

#### Propriétés importantes

```qml
// État du thème
isDarkTheme: false
followSystemTheme: true

// Tokens adaptés au thème actif
colors: { ... }  // Couleurs adaptées
elevation: { ... }  // Ombres adaptées

// Références directes aux autres tokens
typography: Typography
spacing: Spacing
radius: Radius
animations: Animations
```

#### Méthodes importantes

```qml
// Bascule entre thème clair et sombre
toggleDarkMode()

// Active le suivi du thème système
enableFollowSystemTheme()

// Définit le thème selon la détection système (appelé depuis Python)
setSystemDarkTheme(isDark)
```

#### Exemple d'utilisation

```qml
Rectangle {
    // S'adapte automatiquement au thème
    color: Style.Theme.colors.background
    
    Text {
        color: Style.Theme.colors.textPrimary
        // ...
    }
}

Button {
    text: "Changer de thème"
    onClicked: Style.Theme.toggleDarkMode()
}
```

## Utilisation pratique

### Création d'un composant de base

Exemple de création d'un bouton personnalisé:

```qml
// src/components/core/CSButton.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../style" as Style

Button {
    id: control
    
    // Propriétés personnalisées
    property bool isPrimary: true
    
    // Style du texte
    contentItem: Text {
        text: control.text
        font {
            family: Style.Typography.fontFamily
            pixelSize: Style.Typography.fontSizeBody
            weight: Style.Typography.fontWeightMedium
        }
        color: isPrimary ? "white" : Style.Theme.colors.textPrimary
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    // Fond du bouton
    background: Rectangle {
        color: {
            if (!control.enabled) {
                return isPrimary ? Qt.alpha(Style.Theme.colors.accent, 0.5) : Style.Theme.colors.backgroundTertiary
            } else if (control.pressed) {
                return isPrimary ? Style.Theme.colors.accentDark : Style.Theme.colors.backgroundTertiary
            } else if (control.hovered) {
                return isPrimary ? Style.Theme.colors.accentLight : Style.Theme.colors.backgroundSecondary
            } else {
                return isPrimary ? Style.Theme.colors.accent : "transparent"
            }
        }
        
        border.width: isPrimary ? 0 : 1
        border.color: isPrimary ? "transparent" : Style.Theme.colors.separator
        
        radius: Style.Radius.s
        
        // Animation au hover
        Behavior on color {
            ColorAnimation {
                duration: Style.Animations.durationFast
                easing.type: Style.Animations.easeOut
            }
        }
    }
    
    // Espacement interne
    padding: Style.Spacing.s
    topPadding: Style.Spacing.xs
    bottomPadding: Style.Spacing.xs
    
    // Animation de l'état pressé
    scale: control.pressed ? 0.98 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: Style.Animations.durationFast
            easing.type: Style.Animations.easeOut
        }
    }
}
```

## Exemples d'intégration

### Création d'une carte d'inventaire

```qml
// src/components/layout/CSCard.qml
import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../../style" as Style

Rectangle {
    id: root
    
    // Propriétés personnalisables
    property string title: "Titre de la carte"
    property string subtitle: "Sous-titre"
    property var content: null
    
    // Style visuel
    color: Style.Theme.colors.background
    radius: Style.Radius.m
    border.width: 1
    border.color: Style.Theme.colors.separator
    
    // Ombre
    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: Style.Theme.elevation.shadowLow.horizontalOffset
        verticalOffset: Style.Theme.elevation.shadowLow.verticalOffset
        radius: Style.Theme.elevation.shadowLow.radius
        color: Style.Theme.elevation.shadowLow.color
    }
    
    // Contenu
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.Spacing.m
        spacing: Style.Spacing.s
        
        // En-tête
        Item {
            Layout.fillWidth: true
            height: titleText.implicitHeight + subtitleText.implicitHeight + Style.Spacing.xs
            
            Text {
                id: titleText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                
                text: root.title
                color: Style.Theme.colors.textPrimary
                font {
                    family: Style.Typography.fontFamily
                    pixelSize: Style.Typography.fontSizeH3
                    weight: Style.Typography.fontWeightMedium
                }
                elide: Text.ElideRight
            }
            
            Text {
                id: subtitleText
                anchors.top: titleText.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: Style.Spacing.xs
                
                text: root.subtitle
                color: Style.Theme.colors.textSecondary
                font {
                    family: Style.Typography.fontFamily
                    pixelSize: Style.Typography.fontSizeSecondary
                    weight: Style.Typography.fontWeightLight
                }
                elide: Text.ElideRight
            }
        }
        
        // Séparateur
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Style.Theme.colors.separator
        }
        
        // Contenu principal
        Item {
            id: contentContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Si un contenu personnalisé a été fourni, l'utiliser
            children: root.content ? [root.content] : []
            
            // Configurer l'ancrage pour le contenu personnalisé
            onChildrenChanged: {
                if (children.length > 0) {
                    children[0].anchors.fill = contentContainer
                }
            }
        }
    }
    
    // Animation au hover
    states: State {
        name: "hovered"
        when: mouseArea.containsMouse
        PropertyChanges {
            target: root.layer.effect
            horizontalOffset: Style.Theme.elevation.shadowMedium.horizontalOffset
            verticalOffset: Style.Theme.elevation.shadowMedium.verticalOffset
            radius: Style.Theme.elevation.shadowMedium.radius
        }
    }
    
    transitions: Transition {
        from: ""; to: "hovered"; reversible: true
        PropertyAnimation {
            properties: "horizontalOffset,verticalOffset,radius"
            duration: Style.Animations.durationStandard
            easing.type: Style.Animations.easeOut
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
    
    // Signal émis au clic
    signal clicked()
}
```

## Gestion du thème clair/sombre

Le système de thème permet de basculer entre les modes clair et sombre, et peut suivre automatiquement le thème du système d'exploitation.

### Basculer le thème manuellement

```qml
Button {
    text: "Changer de thème"
    onClicked: Style.Theme.toggleDarkMode()
}
```

### Suivre le thème système

```qml
Button {
    text: "Suivre le thème système"
    onClicked: Style.Theme.enableFollowSystemTheme()
}
```

### Communication entre Python et QML

Le système utilise une approche hybride pour la détection du thème:

1. **Détection côté Python**
   ```python
   def detect_system_dark_theme():
       """Détecte si le thème système est sombre."""
       # Implémentation spécifique à la plateforme
       if sys.platform.startswith("linux"):
           # Logique pour Linux/GNOME
       elif sys.platform == "win32":
           # Logique pour Windows
       elif sys.platform == "darwin":
           # Logique pour macOS
       return False  # Par défaut: thème clair
   ```

2. **Transmission à QML**
   ```python
   # Dans main.py
   def update_system_theme():
       is_dark = detect_system_dark_theme()
       root_window = engine.rootObjects()[0]
       root_window.setSystemTheme(is_dark)
   ```

3. **Réception dans QML**
   ```qml
   // Dans main.qml
   function setSystemTheme(isDark) {
       Style.Theme.setSystemDarkTheme(isDark)
   }
   ```

4. **Application dans Theme.qml**
   ```qml
   // Dans Theme.qml
   function setSystemDarkTheme(isDark) {
       if (root.followSystemTheme) {
           root.isDarkTheme = isDark
       }
   }
   ```

Cette approche permet d'avoir une interface qui s'adapte automatiquement aux préférences du système, tout en laissant à l'utilisateur la possibilité de définir manuellement son thème préféré.
