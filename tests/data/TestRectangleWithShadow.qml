import QtQuick 6.5
import Qt5Compat.GraphicalEffects

Rectangle {
    width: 100
    height: 100
    color: "white"
    
    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 0
        radius: 8
        samples: 17
        color: "#80000000"
    }
}