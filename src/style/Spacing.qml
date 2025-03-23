// src/style/Spacing.qml

pragma Singleton
import QtQuick 2.15

QtObject {
    // Unité de base
    readonly property int unit: 8
    
    // Espacements standardisés
    readonly property int xs: 4             // Espacement extra small
    readonly property int s: 8              // Espacement small
    readonly property int m: 16             // Espacement medium
    readonly property int l: 24             // Espacement large
    readonly property int xl: 32            // Espacement extra large
    readonly property int xxl: 48           // Espacement extra extra large
    
    // Espacements spécifiques
    readonly property int sectionSpacing: 32     // Espacement vertical entre sections
    readonly property int paragraphSpacing: 20   // Espacement minimum entre paragraphes
    readonly property int marginMobile: 24       // Marges latérales sur mobile
    readonly property int marginDesktop: 32      // Marges latérales sur desktop
    
    // Propriétés de grille
    readonly property int columns: 12            // Nombre de colonnes
    readonly property int gutterSize: 16         // Taille des gouttières de grille
    
    // Calcule la largeur d'une colonne en fonction de la largeur totale disponible
    // Prend en compte les gouttières entre les colonnes
    function columnWidth(totalWidth, numColumns) {
        if (numColumns <= 0 || numColumns > columns) 
            return 0;
        
        // Calculer l'espace total pris par les gouttières
        // Il y a (columns - 1) gouttières dans une grille complète
        const totalGutterSpace = gutterSize * (columns - 1);
        
        // Calculer la largeur d'une seule colonne (hors gouttières)
        const singleColWidth = (totalWidth - totalGutterSpace) / columns;
        
        // Calculer la largeur totale de numColumns colonnes + gouttières
        return singleColWidth * numColumns + gutterSize * (numColumns - 1);
    }
    
    // Calcule le décalage (offset) pour commencer à la colonne spécifiée
    function columnOffset(totalWidth, startColumn) {
        if (startColumn <= 0 || startColumn > columns)
            return 0;
        
        return columnWidth(totalWidth, startColumn - 1) + (startColumn > 1 ? gutterSize : 0);
    }
    
    // Multiplie l'unité de base par un facteur
    function multiply(factor) {
        return unit * factor;
    }
}