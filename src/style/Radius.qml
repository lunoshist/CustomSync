pragma Singleton
import QtQuick 2.15

QtObject {
    // Coins arrondis
    readonly property int xs: 2      // Pour les éléments petits (badges, tags)
    readonly property int s: 4       // Pour les boutons et champs
    readonly property int m: 6       // Pour les cartes et conteneurs
    readonly property int l: 8       // Pour les dialogues et grands conteneurs
}