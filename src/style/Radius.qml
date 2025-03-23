// src/style/Radius.qml

pragma Singleton
import QtQuick 2.15

QtObject {
    // Coins arrondis
    readonly property int xs: 2      // Pour les éléments petits (badges, tags)
    readonly property int s: 4       // Pour les boutons et champs
    readonly property int m: 6       // Pour les cartes et conteneurs
    readonly property int l: 8       // Pour les dialogues et grands conteneurs
    
    // Fonction utilitaire pour appliquer un rayon à tous les coins
    function applyRadius(item, size) {
        if (!item) return;
        
        // Obtenir la taille de rayon appropriée
        let radiusValue;
        switch (size) {
            case "xs": radiusValue = xs; break;
            case "s": radiusValue = s; break;
            case "m": radiusValue = m; break;
            case "l": radiusValue = l; break;
            default: radiusValue = (typeof size === "number") ? size : s;
        }
        
        // Appliquer le rayon à l'élément
        item.radius = radiusValue;
    }
}