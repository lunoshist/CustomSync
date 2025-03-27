// src/style/Theme.qml

pragma Singleton
import QtQuick 6.0
import QtQuick.Window 6.0
import QtCore 6.0

// Importation des autres modules du système de design et utils
import "." as Style
import "../utils" as Utils

/**
 * Point d'entrée principal du système de design
 * Centralise l'accès à tous les tokens et gère le thème clair/sombre
 */
QtObject {
    id: root
    
    /**
     * Indique si le thème sombre est actuellement actif
     * @property {boolean} isDarkTheme
     */
    property bool isDarkTheme: false
    
    /**
     * Indique si l'application doit suivre le thème du système
     * @property {boolean} followSystemTheme
     */
    property bool followSystemTheme: true
    
    /**
     * Signal émis lorsque le thème change (clair/sombre)
     * À connecter pour réagir aux changements de thème
     */
    signal themeChanged()
    
    // Cache des objets de couleurs et d'élévation
    property var _colorCache: ({})
    property var _elevationCache: ({})
    
    /**
     * Couleurs adaptées au thème actif
     * Fournit les couleurs appropriées selon le thème clair ou sombre actif
     */
    readonly property var colors: _getColors()
    
    /**
     * Élévations adaptées au thème actif
     * Fournit les ombres appropriées selon le thème clair ou sombre actif
     */
    readonly property var elevation: _getElevation()
    
    /**
     * Références directes aux autres modules
     * Ces propriétés ne dépendent pas du thème et sont donc référencées directement
     */
    readonly property var typography: Style.Typography
    readonly property var spacing: Style.Spacing
    readonly property var radius: Style.Radius
    readonly property var animations: Style.Animations
    
    // Chargement initial des préférences
    Component.onCompleted: {
        // Charger les paramètres sauvegardés
        if (Utils.Settings.hasKey("isDarkTheme", "Theme")) {
            root.isDarkTheme = Utils.Settings.getValue("isDarkTheme", false, "Theme");
        }
        
        if (Utils.Settings.hasKey("followSystemTheme", "Theme")) {
            root.followSystemTheme = Utils.Settings.getValue("followSystemTheme", true, "Theme");
        }
        
        // Initialiser les caches
        _colorCache = _createColorObject();
        _elevationCache = _createElevationObject();
    }
    
    // Fonction pour obtenir les couleurs avec gestion de cache
    function _getColors() {
        return _colorCache;
    }
    
    // Fonction pour obtenir les élévations avec gestion de cache
    function _getElevation() {
        return _elevationCache;
    }
    
    // Sauvegarde des changements
    onIsDarkThemeChanged: {
        Utils.Settings.setValue("isDarkTheme", isDarkTheme, "Theme");
        
        // Mettre à jour les caches quand le thème change
        _colorCache = _createColorObject();
        _elevationCache = _createElevationObject();
        
        // Émettre le signal de changement de thème
        root.themeChanged();
    }
    
    onFollowSystemThemeChanged: {
        Utils.Settings.setValue("followSystemTheme", followSystemTheme, "Theme");
    }
    
    // Fonction privée pour créer l'objet de couleurs
    function _createColorObject() {
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
            
            "success": isDarkTheme ? Style.ColorPalette.darkSuccess : Style.ColorPalette.success,
            "error": isDarkTheme ? Style.ColorPalette.darkError : Style.ColorPalette.error,
            "warning": isDarkTheme ? Style.ColorPalette.darkWarning : Style.ColorPalette.warning,
            
            // Couleurs des boutons
            "buttonPrimaryBg": isDarkTheme ? Style.ColorPalette.darkButtonPrimaryBg : Style.ColorPalette.buttonPrimaryBg,
            "buttonPrimaryText": isDarkTheme ? Style.ColorPalette.darkButtonPrimaryText : Style.ColorPalette.buttonPrimaryText,
            "buttonPrimaryHover": isDarkTheme ? Style.ColorPalette.darkButtonPrimaryHover : Style.ColorPalette.buttonPrimaryHover,
            "buttonPrimaryActive": isDarkTheme ? Style.ColorPalette.darkButtonPrimaryActive : Style.ColorPalette.buttonPrimaryActive,
            "buttonPrimaryDisabled": isDarkTheme ? Style.ColorPalette.darkButtonPrimaryDisabled : Style.ColorPalette.buttonPrimaryDisabled,
            
            "buttonSecondaryBg": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryBg : Style.ColorPalette.buttonSecondaryBg,
            "buttonSecondaryText": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryText : Style.ColorPalette.buttonSecondaryText,
            "buttonSecondaryHover": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryHover : Style.ColorPalette.buttonSecondaryHover,
            "buttonSecondaryActive": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryActive : Style.ColorPalette.buttonSecondaryActive,
            "buttonSecondaryBorder": isDarkTheme ? Style.ColorPalette.darkButtonSecondaryBorder : Style.ColorPalette.buttonSecondaryBorder
        };
    }
    
    // Fonction privée pour créer l'objet d'élévation
    function _createElevationObject() {
        return {
            "noShadow": isDarkTheme ? Style.Elevation.darkNoShadow : Style.Elevation.noShadow,
            "shadowLow": isDarkTheme ? Style.Elevation.darkShadowLow : Style.Elevation.shadowLow,
            "shadowMedium": isDarkTheme ? Style.Elevation.darkShadowMedium : Style.Elevation.shadowMedium,
            "shadowHigh": isDarkTheme ? Style.Elevation.darkShadowHigh : Style.Elevation.shadowHigh,
            "innerShadow": isDarkTheme ? Style.Elevation.darkInnerShadow : Style.Elevation.innerShadow
        };
    }
    
    /**
     * Fonction appelée depuis Python pour mettre à jour le thème système
     * @param {bool} isDark - true pour le thème sombre, false pour le thème clair
     */
    function setSystemTheme(isDark) {
        // Si on suit le thème système, mettre à jour le thème
        if (root.followSystemTheme && root.isDarkTheme !== isDark) {
            root.isDarkTheme = isDark;
        }
    }
    
    /**
     * Bascule manuellement entre thème clair et sombre
     * Désactive également le suivi automatique du thème système
     */
    function toggleDarkMode() {
        root.followSystemTheme = false;
        root.isDarkTheme = !root.isDarkTheme;
    }
    
    /**
     * Active le suivi du thème système
     * L'application adoptera automatiquement le thème de l'OS
     */
    function enableFollowSystemTheme() {
        root.followSystemTheme = true;
        // Le thème sera mis à jour par Python
    }
    
    /**
     * Vérifie si un élément est en thème sombre
     * @param {Object} item - L'élément à vérifier (peut avoir sa propre propriété isDarkTheme)
     * @return {bool} - true si l'élément doit utiliser le thème sombre
     */
    function isItemDark(item) {
        // Si l'item a une propriété spécifique, l'utiliser, sinon utiliser le thème global
        if (!item) {
            return root.isDarkTheme;
        }
        
        return item.hasOwnProperty("isDarkTheme") ? item.isDarkTheme : root.isDarkTheme;
    }
    
    /**
     * Applique une couleur adaptée au thème à un élément
     * @param {Object} item - L'élément cible
     * @param {string} property - Nom de la propriété (ex: "color", "border.color")
     * @param {color} lightColor - Couleur pour le thème clair
     * @param {color} darkColor - Couleur pour le thème sombre
     * @return {bool} - true si l'opération a réussi
     */
    function applyThemedColor(item, property, lightColor, darkColor) {
        if (!item || !property) {
            console.warn("Theme.applyThemedColor: paramètres invalides, item=" + item + ", property=" + property);
            return false;
        }
        
        // Éviter les mises à jour inutiles
        const useDark = isItemDark(item);
        const newColor = useDark ? darkColor : lightColor;
        
        try {
            // Gérer les propriétés imbriquées comme "border.color"
            if (property.indexOf(".") !== -1) {
                const parts = property.split(".");
                let obj = item;
                
                // Naviguer jusqu'à l'objet parent de la propriété
                for (let i = 0; i < parts.length - 1; i++) {
                    obj = obj[parts[i]];
                    if (!obj) {
                        console.warn("Theme.applyThemedColor: chemin de propriété invalide '" + property + "'");
                        return false;
                    }
                }
                
                // Affecter la propriété
                const finalProp = parts[parts.length - 1];
                if (obj[finalProp] !== newColor) {
                    obj[finalProp] = newColor;
                }
            } else {
                // Propriété directe
                if (item[property] !== newColor) {
                    item[property] = newColor;
                }
            }
            
            return true;
        } catch (e) {
            console.error("Theme.applyThemedColor: erreur lors de l'affectation de la propriété '" + property + "':", e);
            return false;
        }
    }
}