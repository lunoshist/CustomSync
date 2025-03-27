// src/style/Elevation.qml

pragma Singleton
import QtQuick 6.5

/**
 * Système de niveaux d'élévation et d'ombres
 * Définit les ombres standardisées pour créer une hiérarchie spatiale dans l'interface.
 */
QtObject {
    id: root
    
    /**
     * Niveau 0 - Surface de base (pas d'ombre)
     * Utilisé pour les éléments qui sont au niveau de base, sans élévation
     */
    readonly property var noShadow: {
        "horizontalOffset": 0,
        "verticalOffset": 0,
        "radius": 0,
        "samples": 17,  // Requis pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0),
        "cssValue": "none"
    }
    readonly property var darkNoShadow: noShadow
    
    /**
     * Niveau 1 - Élévation basse (composants interactifs)
     * Utilisé pour les boutons, cartes interactives et contrôles basiques
     */
    readonly property var shadowLow: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 3,
        "samples": 17,  // Requis pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.08),
        "cssValue": "0 1px 3px rgba(0,0,0,0.08)"
    }
    readonly property var darkShadowLow: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 3,
        "samples": 17,  // Requis pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.2),
        "cssValue": "0 1px 3px rgba(0,0,0,0.2)"
    }
    
    /**
     * Niveau 2 - Élévation moyenne (cartes et éléments flottants)
     * Utilisé pour les cartes, panneaux et composants détachés du fond
     */
    readonly property var shadowMedium: {
        "horizontalOffset": 0,
        "verticalOffset": 3,
        "radius": 6,
        "samples": 17,  // Requis pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.1),
        "cssValue": "0 3px 6px rgba(0,0,0,0.1)"
    }
    readonly property var darkShadowMedium: {
        "horizontalOffset": 0,
        "verticalOffset": 3,
        "radius": 6,
        "samples": 17,  // Requis pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.24),
        "cssValue": "0 3px 6px rgba(0,0,0,0.24)"
    }
    
    /**
     * Niveau 3 - Élévation haute (modaux et popups)
     * Utilisé pour les dialogues, popups et éléments de premier plan
     */
    readonly property var shadowHigh: {
        "horizontalOffset": 0,
        "verticalOffset": 8,
        "radius": 16,
        "samples": 25,  // Requis pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.12),
        "cssValue": "0 8px 16px rgba(0,0,0,0.12)"
    }
    readonly property var darkShadowHigh: {
        "horizontalOffset": 0,
        "verticalOffset": 8,
        "radius": 16,
        "samples": 25,  // Requis pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.3),
        "cssValue": "0 8px 16px rgba(0,0,0,0.3)"
    }
    
    /**
     * Ombre intérieure pour les champs focus
     * Utilisé pour mettre en évidence les champs de saisie en focus
     */
    readonly property var innerShadow: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 2,
        "samples": 17,  // Requis pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(119, 41, 83, 0.15), // Aubergine avec opacité
        "cssValue": "inset 0 1px 2px rgba(119,41,83,0.15)"
    }
    readonly property var darkInnerShadow: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 2,
        "samples": 17,  // Requis pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(154, 61, 110, 0.2), // Aubergine claire avec opacité
        "cssValue": "inset 0 1px 2px rgba(154,61,110,0.2)"
    }
    
    /**
     * Applique une ombre selon le niveau et le thème à un élément avec effet DropShadow
     * @param {Object} target - élément cible avec layer.effect de type DropShadow
     * @param {string} level - niveau d'ombre ("low", "medium", "high")
     * @param {boolean} isDark - utiliser le thème sombre (true) ou clair (false)
     */
    function applyDropShadow(target, level, isDark) {
        if (!target || !target.layer || !target.layer.effect) {
            console.warn("Elevation.applyDropShadow: cible invalide, l'élément doit avoir layer.enabled=true et un effet DropShadow");
            return;
        }
            
        // Vérification des valeurs de level valides
        if (level !== "low" && level !== "medium" && level !== "high") {
            console.warn("Elevation.applyDropShadow: niveau invalide '" + level + "'. Utilisation de 'medium' par défaut.");
            level = "medium";
        }
            
        const shadow = isDark 
            ? (level === "low" ? darkShadowLow : level === "medium" ? darkShadowMedium : darkShadowHigh)
            : (level === "low" ? shadowLow : level === "medium" ? shadowMedium : shadowHigh);
            
        target.layer.effect.horizontalOffset = shadow.horizontalOffset;
        target.layer.effect.verticalOffset = shadow.verticalOffset;
        target.layer.effect.radius = shadow.radius;
        target.layer.effect.samples = shadow.samples;  // Requis pour Qt5Compat.GraphicalEffects
        target.layer.effect.color = shadow.color;
    }
    
    /**
     * Applique une ombre intérieure à un élément
     * @param {Object} target - élément cible avec layer.effect de type InnerShadow
     * @param {boolean} isDark - utiliser le thème sombre (true) ou clair (false)
     */
    function applyInnerShadow(target, isDark) {
        if (!target || !target.layer || !target.layer.effect) {
            console.warn("Elevation.applyInnerShadow: cible invalide, l'élément doit avoir layer.enabled=true et un effet InnerShadow");
            return;
        }
        
        const shadow = isDark ? darkInnerShadow : innerShadow;
        
        target.layer.effect.horizontalOffset = shadow.horizontalOffset;
        target.layer.effect.verticalOffset = shadow.verticalOffset;
        target.layer.effect.radius = shadow.radius;
        target.layer.effect.samples = shadow.samples;
        target.layer.effect.color = shadow.color;
    }
}