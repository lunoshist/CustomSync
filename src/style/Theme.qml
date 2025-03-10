pragma Singleton
import QtQuick 2.15
import QtCore
import QtQuick.Window 2.15

QtObject {
    id: root
    
    // Gestionnaire du thème
    property bool isDarkTheme: false
    property bool followSystemTheme: true
    
    // Propriété pour détecter le thème système
    readonly property bool systemInDarkTheme: false // Valeur par défaut
    
    // Propriétés exposant les tokens actuels en fonction du thème
    readonly property var colors: {
        if (isDarkTheme) {
            return {
                // Couleurs de base
                "background": ColorPalette.darkBackgroundPrimary,
                "backgroundSecondary": ColorPalette.darkBackgroundSecondary,
                "backgroundTertiary": ColorPalette.darkBackgroundTertiary,
                
                // Nuances de texte
                "textPrimary": ColorPalette.darkTextPrimary,
                "textSecondary": ColorPalette.darkTextSecondary, 
                "textTertiary": ColorPalette.darkTextTertiary,
                "separator": ColorPalette.darkSeparator,
                
                // Accents
                "accent": ColorPalette.darkAccentPrimary,
                "accentLight": ColorPalette.darkAccentLight,
                "accentDark": ColorPalette.darkAccentDark,
                
                // États fonctionnels
                "success": ColorPalette.success,
                "error": ColorPalette.error,
                "warning": ColorPalette.warning
            }
        } else {
            return {
                // Couleurs de base
                "background": ColorPalette.backgroundPrimary,
                "backgroundSecondary": ColorPalette.backgroundSecondary,
                "backgroundTertiary": ColorPalette.backgroundTertiary,
                
                // Nuances de texte
                "textPrimary": ColorPalette.textPrimary,
                "textSecondary": ColorPalette.textSecondary,
                "textTertiary": ColorPalette.textTertiary,
                "separator": ColorPalette.separator,
                
                // Accents
                "accent": ColorPalette.accentPrimary,
                "accentLight": ColorPalette.accentLight,
                "accentDark": ColorPalette.accentDark,
                
                // États fonctionnels
                "success": ColorPalette.success,
                "error": ColorPalette.error,
                "warning": ColorPalette.warning
            }
        }
    }
    
    readonly property var typography: Typography
    readonly property var spacing: Spacing
    readonly property var radius: Radius
    readonly property var animations: Animations
    
    readonly property var elevation: {
        if (isDarkTheme) {
            return {
                "shadowLow": Elevation.darkShadowLowValues,
                "shadowMedium": Elevation.darkShadowMediumValues,
                "shadowHigh": Elevation.darkShadowHighValues
            }
        } else {
            return {
                "shadowLow": Elevation.shadowLowValues,
                "shadowMedium": Elevation.shadowMediumValues,
                "shadowHigh": Elevation.shadowHighValues
            }
        }
    }
    
    // Composant Settings pour persistance du thème
    property Settings settings: Settings {
        category: "Theme"
        property alias isDarkTheme: root.isDarkTheme
        property alias followSystemTheme: root.followSystemTheme
    }
    
    // Pour la détection du thème système, déplaçons cette logique dans Python
    // Ajoutons une fonction qui pourra être appelée depuis Python
    function setSystemDarkTheme(isDark) {
        if (root.followSystemTheme) {
            root.isDarkTheme = isDark;
        }
    }
    
    // Méthodes pour manipuler le thème
    function toggleDarkMode() {
        root.isDarkTheme = !root.isDarkTheme;
        root.followSystemTheme = false;
    }
    
    function enableFollowSystemTheme() {
        root.followSystemTheme = true;
        // Le thème sera mis à jour par Python
    }
}