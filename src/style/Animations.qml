// src/style/Animations.qml

pragma Singleton
import QtQuick 2.15

QtObject {
    // Durées d'animation
    readonly property int durationFast: 150        // Transitions rapides
    readonly property int durationStandard: 200    // Transitions générales
    readonly property int durationEmphasis: 300    // Transitions mises en valeur
    
    // Courbes d'animation
    readonly property int easeOut: Easing.OutQuad
    readonly property int easeInOut: Easing.InOutQuad
    readonly property int emphasizedCurve: Easing.BezierSpline  // Modification: BezierCurve -> BezierSpline
    readonly property var emphasizedParams: [0.4, 0, 0.2, 1]
    
    // Configurations prédéfinies pour les transitions
    readonly property var standardTransitionParams: {
        "duration": durationStandard,
        "easing": easeOut
    }
    
    readonly property var fastTransitionParams: {
        "duration": durationFast,
        "easing": easeOut
    }
    
    readonly property var emphasisTransitionParams: {
        "duration": durationEmphasis,
        "easing": emphasizedCurve,
        "bezierCurve": emphasizedParams
    }
    
    // Crée un objet NumberAnimation avec les paramètres standards
    function createStandardAnimation(property) {
        return {
            "type": "NumberAnimation",
            "properties": property,
            "duration": durationStandard,
            "easing.type": easeOut
        };
    }
    
    // Crée un objet NumberAnimation avec les paramètres rapides
    function createFastAnimation(property) {
        return {
            "type": "NumberAnimation",
            "properties": property,
            "duration": durationFast,
            "easing.type": easeOut
        };
    }
    
    // Crée un objet NumberAnimation avec les paramètres d'emphase
    function createEmphasisAnimation(property) {
        return {
            "type": "NumberAnimation",
            "properties": property,
            "duration": durationEmphasis,
            "easing.type": emphasizedCurve,
            "easing.bezierCurve": emphasizedParams
        };
    }
    
    // Applique une animation standard à une propriété de l'objet cible
    function applyStandardBehavior(target, property) {
        if (!target) return;
        
        // Crée et attache un Behavior dynamiquement
        const behaviorComponent = Qt.createQmlObject(
            'import QtQuick 2.15; Behavior on ' + property + ' { NumberAnimation { duration: ' + 
            durationStandard + '; easing.type: ' + easeOut + ' } }',
            target, "dynamicBehavior");
            
        return behaviorComponent;
    }
}