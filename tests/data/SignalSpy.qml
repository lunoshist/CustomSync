import QtQuick 6.5

QtObject {
    property var target: null
    property string signalName: ""
    property int count: 0
    
    property var connections: Connections {
        target: parent.target
        ignoreUnknownSignals: false
        onObjectNameChanged: { /* Éviter l'erreur du signal manquant */ }
    }
    
    Component.onCompleted: {
        // Créer dynamiquement le gestionnaire de signal
        const handler = function() { count++; };
        connections["on" + signalName[0].toUpperCase() + signalName.substring(1)] = handler;
    }
}