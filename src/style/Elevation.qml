pragma Singleton
import QtQuick 2.15

QtObject {
    // Propriétés des ombres pour chaque niveau d'élévation
    
    // Niveau 1 - Élévation basse (composants interactifs)
    readonly property string shadowLow: "0 1px 3px rgba(0,0,0,0.08)"
    readonly property var shadowLowValues: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 3,
        "color": Qt.rgba(0, 0, 0, 0.08)
    }
    
    // Niveau 2 - Élévation moyenne (cartes et éléments flottants)
    readonly property string shadowMedium: "0 3px 6px rgba(0,0,0,0.1)"
    readonly property var shadowMediumValues: {
        "horizontalOffset": 0,
        "verticalOffset": 3,
        "radius": 6,
        "color": Qt.rgba(0, 0, 0, 0.1)
    }
    
    // Niveau 3 - Élévation haute (modaux et popups)
    readonly property string shadowHigh: "0 8px 16px rgba(0,0,0,0.12)"
    readonly property var shadowHighValues: {
        "horizontalOffset": 0,
        "verticalOffset": 8,
        "radius": 16,
        "color": Qt.rgba(0, 0, 0, 0.12)
    }
    
    // Valeurs pour le mode sombre
    readonly property string darkShadowLow: "0 1px 3px rgba(0,0,0,0.2)"
    readonly property var darkShadowLowValues: {
        "horizontalOffset": 0,
        "verticalOffset": 1,
        "radius": 3,
        "color": Qt.rgba(0, 0, 0, 0.2)
    }
    
    readonly property string darkShadowMedium: "0 3px 6px rgba(0,0,0,0.24)"
    readonly property var darkShadowMediumValues: {
        "horizontalOffset": 0,
        "verticalOffset": 3,
        "radius": 6,
        "color": Qt.rgba(0, 0, 0, 0.24)
    }
    
    readonly property string darkShadowHigh: "0 8px 16px rgba(0,0,0,0.3)"
    readonly property var darkShadowHighValues: {
        "horizontalOffset": 0,
        "verticalOffset": 8,
        "radius": 16,
        "color": Qt.rgba(0, 0, 0, 0.3)
    }
}