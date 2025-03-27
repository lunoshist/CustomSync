// src/style/Animations.qml

pragma Singleton
import QtQuick 6.5


/**
 * Système d'animations standardisées
 * Définit les durées, courbes et configurations pour les animations de l'interface
 */
QtObject {
    id: root
    
    /**
     * Durée pour les transitions rapides (hover, focus, etc.)
     */
    readonly property int durationFast: 150
    
    /**
     * Durée pour les transitions standard (apparition, disparition, etc.)
     */
    readonly property int durationStandard: 200
    
    /**
     * Durée pour les transitions mises en valeur (ouverture de modales, etc.)
     */
    readonly property int durationEmphasis: 300
    
    /**
     * Courbe d'accélération pour les sorties (ralentissement en fin d'animation)
     */
    readonly property int easeOut: Easing.OutQuad
    
    /**
     * Courbe d'accélération combinée entrée/sortie (ralentissement début et fin)
     */
    readonly property int easeInOut: Easing.InOutQuad
    
    /**
     * Courbe d'accélération personnalisée pour les animations d'emphase
     */
    readonly property int emphasizedCurve: Easing.BezierSpline
    
    /**
     * Paramètres de la courbe de Bézier pour emphasizedCurve
     */
    readonly property var emphasizedParams: [0.4, 0, 0.2, 1]
    
    /**
     * Configuration standard pour les transitions courantes
     */
    readonly property var standardTransitionParams: {
        "duration": durationStandard,
        "easing": easeOut
    }
    
    /**
     * Configuration rapide pour les interactions immédiates
     */
    readonly property var fastTransitionParams: {
        "duration": durationFast,
        "easing": easeOut
    }
    
    /**
     * Configuration d'emphase pour les transitions importantes
     */
    readonly property var emphasisTransitionParams: {
        "duration": durationEmphasis,
        "easing": emphasizedCurve,
        "bezierCurve": emphasizedParams
    }
    
    /**
     * Modèles prédéfinis de Behavior pour différentes propriétés
     * Ces objets servent de référence pour créer des Behavior cohérents
     */
    readonly property var behaviorTemplates: ({
        // Opacité
        "opacity": {
            "standard": {
                "duration": durationStandard,
                "easing": easeOut
            },
            "fast": {
                "duration": durationFast,
                "easing": easeOut
            },
            "emphasis": {
                "duration": durationEmphasis,
                "easing": emphasizedCurve,
                "bezierCurve": emphasizedParams
            }
        },
        
        // Position
        "position": {
            "standard": {
                "duration": durationStandard,
                "easing": easeOut
            },
            "fast": {
                "duration": durationFast,
                "easing": easeOut
            },
            "emphasis": {
                "duration": durationEmphasis,
                "easing": emphasizedCurve,
                "bezierCurve": emphasizedParams
            }
        },
        
        // Taille
        "size": {
            "standard": {
                "duration": durationStandard,
                "easing": easeOut
            },
            "fast": {
                "duration": durationFast,
                "easing": easeOut
            },
            "emphasis": {
                "duration": durationEmphasis,
                "easing": emphasizedCurve,
                "bezierCurve": emphasizedParams
            }
        },
        
        // Couleur
        "color": {
            "standard": {
                "duration": durationStandard
            },
            "fast": {
                "duration": durationFast
            },
            "emphasis": {
                "duration": durationEmphasis
            }
        }
    })
    
    /**
     * Crée un objet de configuration pour une NumberAnimation standard
     * @param {string} property - propriété à animer (ex: "opacity", "x,y,z")
     * @param {string} [speed="standard"] - vitesse d'animation ("fast", "standard", "emphasis")
     * @return {Object} - objet de configuration pour NumberAnimation
     */
    function createNumberAnimation(property, speed) {
        if (!property) {
            console.warn("Animations.createNumberAnimation: propriété manquante");
            return null;
        }
        
        speed = speed || "standard";
        
        if (speed !== "fast" && speed !== "standard" && speed !== "emphasis") {
            console.warn("Animations.createNumberAnimation: vitesse invalide '" + speed + "', utilisation de 'standard'");
            speed = "standard";
        }
        
        const template = speed === "fast" ? fastTransitionParams : 
                         speed === "emphasis" ? emphasisTransitionParams : 
                         standardTransitionParams;
        
        const animation = {
            "type": "NumberAnimation",
            "properties": property,
            "duration": template.duration,
            "easing.type": template.easing
        };
        
        // Ajouter la courbe de Bézier si nécessaire
        if (template.easing === emphasizedCurve && template.bezierCurve) {
            animation["easing.bezierCurve"] = template.bezierCurve;
        }
        
        return animation;
    }
    
    /**
     * Crée un objet de configuration pour une ColorAnimation
     * @param {string} property - propriété à animer (ex: "color", "border.color")
     * @param {string} [speed="standard"] - vitesse d'animation ("fast", "standard", "emphasis")
     * @return {Object} - objet de configuration pour ColorAnimation
     */
    function createColorAnimation(property, speed) {
        if (!property) {
            console.warn("Animations.createColorAnimation: propriété manquante");
            return null;
        }
        
        speed = speed || "standard";
        
        if (speed !== "fast" && speed !== "standard" && speed !== "emphasis") {
            console.warn("Animations.createColorAnimation: vitesse invalide '" + speed + "', utilisation de 'standard'");
            speed = "standard";
        }
        
        const template = behaviorTemplates.color[speed];
        
        return {
            "type": "ColorAnimation",
            "properties": property,
            "duration": template.duration
        };
    }
    
    /**
     * Applique un Behavior standard à une propriété d'un Item
     * Cette fonction utilise une approche déclarative plutôt que dynamique
     * 
     * @param {Object} target - élément cible
     * @param {string} property - nom de la propriété à animer
     * @param {string} type - type d'animation ("number", "color")
     * @param {string} [speed="standard"] - vitesse d'animation ("fast", "standard", "emphasis")
     * @return {string} - code QML à utiliser dans un fichier QML
     * 
     * Note: Cette fonction génère du code QML à copier dans votre fichier
     * plutôt que de créer un Behavior dynamiquement, ce qui est plus robuste
     */
    function getAnimationCode(property, type, speed) {
        if (!property || !type) {
            console.warn("Animations.getAnimationCode: paramètres manquants");
            return "// Paramètres incomplets - vérifiez les arguments";
        }
        
        speed = speed || "standard";
        
        if (speed !== "fast" && speed !== "standard" && speed !== "emphasis") {
            console.warn("Animations.getAnimationCode: vitesse invalide '" + speed + "', utilisation de 'standard'");
            speed = "standard";
        }
        
        // Animation de nombre (positions, taille, opacité)
        if (type === "number") {
            const template = speed === "fast" ? fastTransitionParams : 
                            speed === "emphasis" ? emphasisTransitionParams : 
                            standardTransitionParams;
            
            let code = `Behavior on ${property} {\n    NumberAnimation {\n        duration: ${template.duration}\n        easing.type: ${template.easing}`;
            
            // Ajouter la courbe de Bézier si nécessaire
            if (template.easing === emphasizedCurve && template.bezierCurve) {
                code += `\n        easing.bezierCurve: [${template.bezierCurve.join(", ")}]`;
            }
            
            code += `\n    }\n}`;
            return code;
        }
        
        // Animation de couleur
        else if (type === "color") {
            const duration = behaviorTemplates.color[speed].duration;
            return `Behavior on ${property} {\n    ColorAnimation {\n        duration: ${duration}\n    }\n}`;
        }
        
        return "// Type d'animation non pris en charge";
    }
    
    /**
     * Génère une configuration d'animation pour les transitions de thème
     * @return {Object} - Objet de configuration pour les transitions de thème
     */
    function createThemeTransition() {
        return {
            // L'opacité est une bonne propriété pour les transitions de thème
            fadeOut: {
                property: "opacity",
                to: 0.8,
                duration: durationFast,
                easing: easeOut
            },
            fadeIn: {
                property: "opacity",
                to: 1.0,
                duration: durationFast,
                easing: easeOut
            }
        };
    }
}