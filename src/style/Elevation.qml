// src/style/Elevation.qml

pragma Singleton
import QtQuick 2.15

QtObject {
    // Propriétés des ombres pour chaque niveau d'élévation
    
    // Niveau 0 - Surface de base (pas d'ombre)
    readonly property var noShadow: {
        "horizontalOffset": 0,
        "verticalOffset": 0,
        "radius": 0,
        "samples": 17,  // Ajouté pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0),
        "cssValue": "none"
    }
    readonly property var darkNoShadow: noShadow
    
    // Niveau 1 - Élévation basse (composants interactifs)
    readonly property var shadowLow: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 3,
        "samples": 17,  // Ajouté pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.08),
        "cssValue": "0 1px 3px rgba(0,0,0,0.08)"
    }
    
    readonly property var darkShadowLow: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 3,
        "samples": 17,  // Ajouté pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.2),
        "cssValue": "0 1px 3px rgba(0,0,0,0.2)"
    }
    
    // Niveau 2 - Élévation moyenne (cartes et éléments flottants)
    readonly property var shadowMedium: {
        "horizontalOffset": 0,
        "verticalOffset": 3,
        "radius": 6,
        "samples": 17,  // Ajouté pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.1),
        "cssValue": "0 3px 6px rgba(0,0,0,0.1)"
    }
    
    readonly property var darkShadowMedium: {
        "horizontalOffset": 0,
        "verticalOffset": 3,
        "radius": 6,
        "samples": 17,  // Ajouté pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.24),
        "cssValue": "0 3px 6px rgba(0,0,0,0.24)"
    }
    
    // Niveau 3 - Élévation haute (modaux et popups)
    readonly property var shadowHigh: {
        "horizontalOffset": 0,
        "verticalOffset": 8,
        "radius": 16,
        "samples": 25,  // Ajouté pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.12),
        "cssValue": "0 8px 16px rgba(0,0,0,0.12)"
    }
    
    readonly property var darkShadowHigh: {
        "horizontalOffset": 0,
        "verticalOffset": 8,
        "radius": 16,
        "samples": 25,  // Ajouté pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(0, 0, 0, 0.3),
        "cssValue": "0 8px 16px rgba(0,0,0,0.3)"
    }
    
    // Ombre intérieure pour les champs focus
    readonly property var innerShadow: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 2,
        "samples": 17,  // Ajouté pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(119, 41, 83, 0.15), // Aubergine avec opacité
        "cssValue": "inset 0 1px 2px rgba(119,41,83,0.15)"
    }
    
    readonly property var darkInnerShadow: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 2,
        "samples": 17,  // Ajouté pour Qt5Compat.GraphicalEffects
        "color": Qt.rgba(154, 61, 110, 0.2), // Aubergine claire avec opacité
        "cssValue": "inset 0 1px 2px rgba(154,61,110,0.2)"
    }
    
    // Fonctions d'aide
    function applyDropShadow(target, level, isDark) {
        if (!target || !target.layer || !target.layer.effect) 
            return;
            
        const shadow = isDark 
            ? (level === "low" ? darkShadowLow : level === "medium" ? darkShadowMedium : darkShadowHigh)
            : (level === "low" ? shadowLow : level === "medium" ? shadowMedium : shadowHigh);
            
        target.layer.effect.horizontalOffset = shadow.horizontalOffset;
        target.layer.effect.verticalOffset = shadow.verticalOffset;
        target.layer.effect.radius = shadow.radius;
        target.layer.effect.samples = shadow.samples;  // Ajouté pour Qt5Compat.GraphicalEffects
        target.layer.effect.color = shadow.color;
    }
}