// src/style/Theme.qml

pragma Singleton
import QtQuick 2.15
import QtQuick.Window 2.15
import QtCore 6.5   // Mise à jour pour Qt 6, remplace Qt.labs.settings

// Importation des autres modules du système de design
import "." as Style

QtObject {
    id: root
    
    // Propriétés de gestion du thème
    property bool isDarkTheme: false
    property bool followSystemTheme: true
    
    // Signal émis lorsque le thème change
    signal themeChanged()
    
    // Couleurs adaptées au thème actif
    readonly property var colors: {
        return {
            "backgroundPrimary": isDarkTheme ? Style.ColorPalette.darkBackgroundPrimary : Style.ColorPalette.backgroundPrimary,
            "backgroundSecondary": isDarkTheme ? Style.ColorPalette.darkBackgroundSecondary : Style.ColorPalette.backgroundSecondary,
            "backgroundTertiary": isDarkTheme ? Style.ColorPalette.darkBackgroundTertiary : Style.ColorPalette.backgroundTertiary,
            
            "textPrimary": isDarkTheme ? Style.ColorPalette.darkTextPrimary : Style.ColorPalette.textPrimary,
            "textSecondary": isDarkTheme ? Style.ColorPalette.darkTextSecondary : Style.ColorPalette.textSecondary,
            "textTertiary": isDarkTheme ? Style.ColorPalette.darkTextTertiary : Style.ColorPalette.textTertiary,
            "separator": isDarkTheme ? Style.ColorPalette.darkSeparator : Style.ColorPalette.separator,
            
            "accent": isDarkTheme ? Style.ColorPalette.darkAccent : Style.ColorPalette.accent,
            "accentLight": isDarkTheme ? Style.ColorPalette.darkAccentLight : Style.ColorPalette.accentLight,
            "accentDark": isDarkTheme ? Style.ColorPalette.darkAccentDark : Style.ColorPalette.accentDark,
            
            "success": Style.ColorPalette.success,
            "error": Style.ColorPalette.error,
            "warning": Style.ColorPalette.warning,
            
            // Couleurs des boutons
            "buttonPrimaryBg": isDarkTheme ? Style.ColorPalette.darkButtonPrimaryBg : Style.ColorPalette.buttonPrimaryBg,
            "buttonPrimaryText": isDarkTheme ? Style.ColorPalette.buttonPrimaryText : Style.ColorPalette.darkButtonPrimaryText,
            "buttonPrimaryHover": isDarkTheme ? Style.ColorPalette.darkButtonPrimaryHover : Style.ColorPalette.buttonPrimaryHover,
            "buttonPrimaryActive": isDarkTheme ? Style.ColorPalette.darkButtonPrimaryActive : Style.ColorPalette.buttonPrimaryActive,
            "buttonPrimaryDisabled": isDarkTheme ? Style.ColorPalette.darkButtonPrimaryDisabled : Style.ColorPalette.buttonPrimaryDisabled,
            
            "buttonSecondaryBg": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryBg : Style.ColorPalette.buttonSecondaryBg,
            "buttonSecondaryText": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryText : Style.ColorPalette.buttonSecondaryText,
            "buttonSecondaryHover": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryHover : Style.ColorPalette.buttonSecondaryHover,
            "buttonSecondaryActive": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryActive : Style.ColorPalette.buttonSecondaryActive,
            "buttonSecondaryBorder": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryBorder : Style.ColorPalette.buttonSecondaryBorder
        }
    }
    
    // Élévations adaptées au thème actif
    readonly property var elevation: {
        return {
            "noShadow": isDarkTheme ? Style.Elevation.darkNoShadow : Style.Elevation.noShadow,
            "shadowLow": isDarkTheme ? Style.Elevation.darkShadowLow : Style.Elevation.shadowLow,
            "shadowMedium": isDarkTheme ? Style.Elevation.darkShadowMedium : Style.Elevation.shadowMedium,
            "shadowHigh": isDarkTheme ? Style.Elevation.darkShadowHigh : Style.Elevation.shadowHigh,
            "innerShadow": isDarkTheme ? Style.Elevation.darkInnerShadow : Style.Elevation.innerShadow
        }
    }
    
    // Références directes aux autres modules
    readonly property var typography: Style.Typography
    readonly property var spacing: Style.Spacing
    readonly property var radius: Style.Radius
    readonly property var animations: Style.Animations
    
    // Composant Settings pour persistance du thème
    property Settings settings: Settings {
        category: "Theme"
        property alias isDarkTheme: root.isDarkTheme
        property alias followSystemTheme: root.followSystemTheme
    }
    
    // Fonction appelée depuis Python pour mettre à jour le thème système
    function setSystemDarkTheme(isDark) {
        // Si on suit le thème système, mettre à jour le thème
        if (root.followSystemTheme && root.isDarkTheme !== isDark) {
            root.isDarkTheme = isDark;
            root.themeChanged();
        }
    }
    
    // Basculer manuellement entre thème clair et sombre
    function toggleDarkMode() {
        root.followSystemTheme = false;
        root.isDarkTheme = !root.isDarkTheme;
        root.themeChanged();
    }
    
    // Activer le suivi du thème système
    function enableFollowSystemTheme() {
        root.followSystemTheme = true;
        // Le thème sera mis à jour par Python
    }
    
    // Vérifier si un élément est en thème sombre
    function isItemDark(item) {
        // Si l'item a une propriété spécifique, l'utiliser, sinon utiliser le thème global
        return (item && item.hasOwnProperty("isDarkTheme")) ? item.isDarkTheme : root.isDarkTheme;
    }
    
    // Appliquer une couleur adaptée au thème à un élément
    function applyThemedColor(item, property, lightColor, darkColor) {
        if (!item) return;
        
        const useDark = isItemDark(item);
        item[property] = useDark ? darkColor : lightColor;
    }
}