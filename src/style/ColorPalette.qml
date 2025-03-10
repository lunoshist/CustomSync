pragma Singleton
import QtQuick 2.15

QtObject {
    // Couleurs de base - mode clair
    readonly property color backgroundPrimary: "#FFFFFF"      // Fond principal
    readonly property color backgroundSecondary: "#F5F5F7"    // Fond secondaire
    readonly property color backgroundTertiary: "#EAEAEC"     // Fond tertiaire

    // Nuances de gris - mode clair
    readonly property color textPrimary: "#202020"            // Texte principal
    readonly property color textSecondary: "#5E5E5E"          // Texte secondaire  
    readonly property color textTertiary: "#8E8E93"           // Texte tertiaire
    readonly property color separator: "#D1D1D6"              // Séparateurs

    // Couleurs d'accent
    readonly property color accentPrimary: "#772953"          // Aubergine
    readonly property color accentLight: "#9A3D6E"            // Aubergine claire
    readonly property color accentDark: "#5A1F3F"             // Aubergine sombre

    // États fonctionnels
    readonly property color success: "#2D9D78"                // Vert équilibré
    readonly property color error: "#D64541"                  // Rouge distinctif
    readonly property color warning: "#E9B949"                // Jaune ambre

    // Couleurs de base - mode sombre
    readonly property color darkBackgroundPrimary: "#1E1E1E"     // Fond principal
    readonly property color darkBackgroundSecondary: "#252528"   // Fond secondaire
    readonly property color darkBackgroundTertiary: "#2D2D30"    // Fond tertiaire

    // Nuances de gris - mode sombre
    readonly property color darkTextPrimary: "#F0F0F0"           // Texte principal
    readonly property color darkTextSecondary: "#B8B8B8"         // Texte secondaire
    readonly property color darkTextTertiary: "#757575"          // Texte tertiaire
    readonly property color darkSeparator: "#3D3D3D"             // Séparateurs

    // Couleurs d'accent - mode sombre
    readonly property color darkAccentPrimary: "#9A3D6E"         // Aubergine claire 
    readonly property color darkAccentLight: "#AF5585"           // Aubergine plus claire
    readonly property color darkAccentDark: "#772953"            // Adaptation de l'aubergine
}