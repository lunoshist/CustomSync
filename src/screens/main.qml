// src/screens/main.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Import du module Style
import "../style" as Style

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    title: "CustomSync"
    objectName: "mainWindow"  // Nom d'objet pour faciliter la référence
    
    // Exposer les fonctions au contexte Python
    function setSystemTheme(isDark) {
        // console.log("Appel de setSystemTheme avec valeur: " + isDark);
        Style.Theme.setSystemDarkTheme(isDark);
    }
    
    // Utilisation du thème
    color: Style.Theme.colors.background
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: Style.Spacing.m
        width: parent.width * 0.8
        
        Text {
            text: "CustomSync"
            Layout.alignment: Qt.AlignHCenter
            color: Style.Theme.colors.textPrimary
            font {
                family: Style.Typography.fontFamily
                pixelSize: Style.Typography.fontSizeH1
                weight: Style.Typography.fontWeightLight
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: Style.Spacing.xl
            color: Style.Theme.colors.accent
            radius: Style.Radius.m
        }
        
        Button {
            text: "Changer de thème"
            Layout.alignment: Qt.AlignHCenter
            onClicked: Style.Theme.toggleDarkMode()
        }
        
        Button {
            text: "Suivre thème système"
            Layout.alignment: Qt.AlignHCenter
            onClicked: Style.Theme.enableFollowSystemTheme()
        }
        
        Text {
            text: "Thème sombre: " + (Style.Theme.isDarkTheme ? "Activé" : "Désactivé")
            Layout.alignment: Qt.AlignHCenter
            color: Style.Theme.colors.textSecondary
        }
        
        Text {
            text: "Suivi système: " + (Style.Theme.followSystemTheme ? "Activé" : "Désactivé")
            Layout.alignment: Qt.AlignHCenter
            color: Style.Theme.colors.textSecondary
        }
    }
}