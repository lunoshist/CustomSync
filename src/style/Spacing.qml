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
    
    // Espacement spécifiques
    readonly property int sectionSpacing: 32     // Espacement vertical entre sections
    readonly property int marginMobile: 24       // Marges latérales sur mobile
    readonly property int marginDesktop: 32      // Marges latérales sur desktop
    readonly property int gutterSize: 16         // Taille des gouttières de grille
}