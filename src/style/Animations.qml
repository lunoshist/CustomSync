pragma Singleton
import QtQuick 2.15

QtObject {
    // Durées d'animation
    readonly property int durationFast: 150        // Transitions rapides
    readonly property int durationStandard: 200    // Transitions générales
    readonly property int durationEmphasis: 300    // Transitions mises en valeur
    
    // Courbes d'animation
    readonly property var easeOut: Easing.OutQuad
    readonly property var easeInOut: Easing.InOutQuad
    readonly property var emphasizedCurve: Easing.Bezier
    readonly property var emphasizedParams: [0.4, 0, 0.2, 1]
    
    // Animations pré-définies
    readonly property var standardTransition: {
        "duration": durationStandard,
        "easing.type": easeOut
    }
    
    readonly property var fastTransition: {
        "duration": durationFast,
        "easing.type": easeOut
    }
    
    readonly property var emphasisTransition: {
        "duration": durationEmphasis,
        "easing.type": emphasizedCurve,
        "easing.bezierCurve": emphasizedParams
    }
}