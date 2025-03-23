// src/style/Typography.qml

pragma Singleton
import QtQuick 2.15

QtObject {
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
    
    // Fonctions d'application du style
    // Note: Ces fonctions sont conçues pour aider en code, mais les composants
    // devraient utiliser directement les propriétés quand possible
    
    // Applique les propriétés de titre h1 à un Text
    function applyH1Style(textItem) {
        if (!textItem) return;
        textItem.font.family = fontFamily;
        textItem.font.pixelSize = fontSizeH1;
        textItem.font.weight = fontWeightLight;
        textItem.font.letterSpacing = letterSpacingH1;
        textItem.lineHeight = lineHeightH1;
    }
    
    // Applique les propriétés de titre h2 à un Text
    function applyH2Style(textItem) {
        if (!textItem) return;
        textItem.font.family = fontFamily;
        textItem.font.pixelSize = fontSizeH2;
        textItem.font.weight = fontWeightRegular;
        textItem.font.letterSpacing = letterSpacingH2;
        textItem.lineHeight = lineHeightH2;
    }
    
    // Applique les propriétés de titre h3 à un Text
    function applyH3Style(textItem) {
        if (!textItem) return;
        textItem.font.family = fontFamily;
        textItem.font.pixelSize = fontSizeH3;
        textItem.font.weight = fontWeightMedium;
        textItem.font.letterSpacing = letterSpacingH3;
        textItem.lineHeight = lineHeightH3;
    }
    
    // Applique les propriétés de titre h4 à un Text
    function applyH4Style(textItem) {
        if (!textItem) return;
        textItem.font.family = fontFamily;
        textItem.font.pixelSize = fontSizeH4;
        textItem.font.weight = fontWeightMedium;
        textItem.font.letterSpacing = letterSpacingH4;
        textItem.lineHeight = lineHeightH4;
    }
    
    // Applique les propriétés de corps de texte à un Text
    function applyBodyStyle(textItem) {
        if (!textItem) return;
        textItem.font.family = fontFamily;
        textItem.font.pixelSize = fontSizeBody;
        textItem.font.weight = fontWeightRegular;
        textItem.font.letterSpacing = letterSpacingBody;
        textItem.lineHeight = lineHeightBody;
    }
    
    // Applique les propriétés de texte secondaire à un Text
    function applySecondaryStyle(textItem) {
        if (!textItem) return;
        textItem.font.family = fontFamily;
        textItem.font.pixelSize = fontSizeSecondary;
        textItem.font.weight = fontWeightLight;
        textItem.font.letterSpacing = letterSpacingSecondary;
        textItem.lineHeight = lineHeightSecondary;
    }
    
    // Applique les propriétés de petit texte à un Text
    function applySmallStyle(textItem) {
        if (!textItem) return;
        textItem.font.family = fontFamily;
        textItem.font.pixelSize = fontSizeSmall;
        textItem.font.weight = fontWeightLight;
        textItem.font.letterSpacing = letterSpacingSmall;
        textItem.lineHeight = lineHeightSmall;
    }
}