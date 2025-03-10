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
    
    // Configuration pré-définie pour les styles courants
    function h1() {
        return {
            "font.family": fontFamily,
            "font.pixelSize": fontSizeH1,
            "font.weight": fontWeightLight,
            "lineHeight": lineHeightH1,
            "font.letterSpacing": letterSpacingH1
        }
    }
    
    function h2() {
        return {
            "font.family": fontFamily,
            "font.pixelSize": fontSizeH2,
            "font.weight": fontWeightRegular,
            "lineHeight": lineHeightH2
        }
    }
    
    function h3() {
        return {
            "font.family": fontFamily,
            "font.pixelSize": fontSizeH3,
            "font.weight": fontWeightMedium,
            "lineHeight": lineHeightH3
        }
    }
    
    function h4() {
        return {
            "font.family": fontFamily,
            "font.pixelSize": fontSizeH4,
            "font.weight": fontWeightMedium,
            "lineHeight": lineHeightH4
        }
    }
    
    function body() {
        return {
            "font.family": fontFamily,
            "font.pixelSize": fontSizeBody,
            "font.weight": fontWeightRegular,
            "lineHeight": lineHeightBody
        }
    }
    
    function secondary() {
        return {
            "font.family": fontFamily,
            "font.pixelSize": fontSizeSecondary,
            "font.weight": fontWeightLight,
            "lineHeight": lineHeightSecondary
        }
    }
    
    function small() {
        return {
            "font.family": fontFamily,
            "font.pixelSize": fontSizeSmall,
            "font.weight": fontWeightLight,
            "lineHeight": lineHeightSmall
        }
    }
}