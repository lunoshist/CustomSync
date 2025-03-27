// src/style/ColorPalette.qml

pragma Singleton
import QtQuick 6.5

/**
 * Système de couleurs
 * Définit toutes les couleurs utilisées dans l'application,
 * organisées par paires clair/sombre
 */
QtObject {
    id: root
    
    //
    // COULEURS DE BASE
    //
    
    /**
     * Couleur de fond principale
     * Utilisée pour le fond des écrans et conteneurs principaux
     */
    readonly property color backgroundPrimary: "#FFFFFF"
    readonly property color darkBackgroundPrimary: "#1E1E1E"
    
    /**
     * Couleur de fond secondaire
     * Utilisée pour les zones distinctes, panneaux latéraux, etc.
     */
    readonly property color backgroundSecondary: "#F5F5F7"
    readonly property color darkBackgroundSecondary: "#252528"
    
    /**
     * Couleur de fond tertiaire
     * Utilisée pour les éléments interactifs au repos, arrière-plans de contrôles
     */
    readonly property color backgroundTertiary: "#EAEAEC"
    readonly property color darkBackgroundTertiary: "#2D2D30"
    
    //
    // TEXTE ET SÉPARATEURS
    //
    
    /**
     * Couleur de texte principale
     * Utilisée pour les titres et textes importants
     */
    readonly property color textPrimary: "#202020"
    readonly property color darkTextPrimary: "#F0F0F0"
    
    /**
     * Couleur de texte secondaire
     * Utilisée pour les descriptions, labels, textes moins importants
     */
    readonly property color textSecondary: "#5E5E5E"
    readonly property color darkTextSecondary: "#B8B8B8"
    
    /**
     * Couleur de texte tertiaire
     * Utilisée pour les textes désactivés, placeholders, informations contextuelles
     */
    readonly property color textTertiary: "#8E8E93"
    readonly property color darkTextTertiary: "#757575"
    
    /**
     * Couleur des séparateurs
     * Utilisée pour les lignes, bordures et délimiteurs
     */
    readonly property color separator: "#D1D1D6"
    readonly property color darkSeparator: "#3D3D3D"
    
    //
    // COULEURS D'ACCENT
    //
    
    /**
     * Couleur d'accent principale
     * Aubergine inspirée d'Ubuntu mais plus sophistiquée
     */
    readonly property color accent: "#772953"
    readonly property color darkAccent: "#9A3D6E"
    
    /**
     * Couleur d'accent claire
     * Utilisée pour les états hover et les variations plus légères
     */
    readonly property color accentLight: "#9A3D6E"
    readonly property color darkAccentLight: "#AF5585"
    
    /**
     * Couleur d'accent sombre
     * Utilisée pour les états actifs et les variations plus profondes
     */
    readonly property color accentDark: "#5A1F3F"
    readonly property color darkAccentDark: "#772953"
    
    //
    // COULEURS SÉMANTIQUES
    //
    
    /**
     * Couleur de succès
     * Vert équilibré pour les confirmations, validations, succès
     */
    readonly property color success: "#2D9D78"
    readonly property color darkSuccess: "#3DB389"
    
    /**
     * Couleur d'erreur
     * Rouge distinctif pour les erreurs, alertes critiques
     */
    readonly property color error: "#D64541"
    readonly property color darkError: "#E05E5A"
    
    /**
     * Couleur d'avertissement
     * Jaune ambre pour les avertissements, précautions
     */
    readonly property color warning: "#E9B949"
    readonly property color darkWarning: "#F0C266"
    
    //
    // COULEURS DES BOUTONS
    //
    
    //
    // Bouton Primaire
    //
    
    /**
     * Couleur de fond du bouton primaire
     */
    readonly property color buttonPrimaryBg: accent
    readonly property color darkButtonPrimaryBg: darkAccent
    
    /**
     * Couleur du texte du bouton primaire
     */
    readonly property color buttonPrimaryText: "#FFFFFF"
    readonly property color darkButtonPrimaryText: "#FFFFFF"
    
    /**
     * Couleur de survol du bouton primaire
     */
    readonly property color buttonPrimaryHover: accentLight
    readonly property color darkButtonPrimaryHover: darkAccentLight
    
    /**
     * Couleur active du bouton primaire
     */
    readonly property color buttonPrimaryActive: accentDark
    readonly property color darkButtonPrimaryActive: darkAccentDark
    
    /**
     * Couleur désactivée du bouton primaire
     */
    readonly property color buttonPrimaryDisabled: Qt.rgba(accent.r, accent.g, accent.b, 0.5)
    readonly property color darkButtonPrimaryDisabled: Qt.rgba(darkAccent.r, darkAccent.g, darkAccent.b, 0.5)
    
    //
    // Bouton Secondaire
    //
    
    /**
     * Couleur de fond du bouton secondaire
     */
    readonly property color buttonSecondaryBg: backgroundSecondary
    readonly property color darkButtonSecondaryBg: darkBackgroundSecondary
    
    /**
     * Couleur du texte du bouton secondaire
     */
    readonly property color buttonSecondaryText: textPrimary
    readonly property color darkButtonSecondaryText: darkTextPrimary
    
    /**
     * Couleur de survol du bouton secondaire
     */
    readonly property color buttonSecondaryHover: backgroundTertiary
    readonly property color darkButtonSecondaryHover: darkBackgroundTertiary
    
    /**
     * Couleur active du bouton secondaire
     */
    readonly property color buttonSecondaryActive: separator
    readonly property color darkButtonSecondaryActive: darkSeparator
    
    /**
     * Couleur de bordure du bouton secondaire
     */
    readonly property color buttonSecondaryBorder: separator
    readonly property color darkButtonSecondaryBorder: darkSeparator
    
    /**
     * Génère une version semi-transparente d'une couleur
     * @param {color} baseColor - Couleur de base
     * @param {real} opacity - Opacité (0-1)
     * @return {color} - Couleur semi-transparente
     */
    function withOpacity(baseColor, opacity) {
        if (opacity < 0 || opacity > 1) {
            console.warn("ColorPalette.withOpacity: opacité hors limites:", opacity);
            opacity = Math.max(0, Math.min(1, opacity));
        }
        
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, opacity);
    }
    
    /**
     * Crée une teinte plus claire d'une couleur
     * @param {color} baseColor - Couleur de base
     * @param {real} factor - Facteur d'éclaircissement (0-1)
     * @return {color} - Couleur éclaircie
     */
    function lighter(baseColor, factor) {
        if (factor < 0 || factor > 1) {
            console.warn("ColorPalette.lighter: facteur hors limites:", factor);
            factor = Math.max(0, Math.min(1, factor));
        }
        
        // Utiliser la fonction native de Qt
        return Qt.lighter(baseColor, 1 + factor);
    }
    
    /**
     * Crée une teinte plus sombre d'une couleur
     * @param {color} baseColor - Couleur de base
     * @param {real} factor - Facteur d'assombrissement (0-1)
     * @return {color} - Couleur assombrie
     */
    function darker(baseColor, factor) {
        if (factor < 0 || factor > 1) {
            console.warn("ColorPalette.darker: facteur hors limites:", factor);
            factor = Math.max(0, Math.min(1, factor));
        }
        
        // Utiliser la fonction native de Qt
        return Qt.darker(baseColor, 1 + factor);
    }
}