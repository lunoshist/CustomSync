// src/screens/main.qml

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

// Import du module Style
import "../style" as Style

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    title: "CustomSync"
    objectName: "mainWindow"
    
    // Définir la couleur de fond en utilisant le système de thème
    color: Style.Theme.colors.background
    
    // Exposer la fonction pour mettre à jour le thème depuis Python
    function setSystemTheme(isDark) {
        Style.Theme.setSystemDarkTheme(isDark);
    }
    
    // Connexion au changement de thème
    Connections {
        target: Style.Theme
        function onThemeChanged() {
            // Animation de transition subtile
            fadeAnimation.start();
        }
    }
    
    // Animation de transition pour le changement de thème
    SequentialAnimation {
        id: fadeAnimation
        
        PropertyAnimation {
            target: centerContent
            property: "opacity"
            to: 0.8
            duration: Style.Animations.durationFast
            easing.type: Style.Animations.easeOut
        }
        
        PropertyAnimation {
            target: centerContent
            property: "opacity"
            to: 1.0
            duration: Style.Animations.durationFast
            easing.type: Style.Animations.easeOut
        }
    }
    
    // Contenu centré avec disposition manuelle (sans Column)
    Item {
        id: centerContent
        anchors.centerIn: parent
        width: 500
        height: 400
        
        // Titre principal
        Text {
            id: titleText
            text: "CustomSync"
            color: Style.Theme.colors.textPrimary
            font.family: Style.Typography.fontFamily
            font.pixelSize: Style.Typography.fontSizeH1
            font.weight: Style.Typography.fontWeightLight
            font.letterSpacing: Style.Typography.letterSpacingH1
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Spacing.m
        }
        
        // Description
        Text {
            id: descriptionText
            text: "Application de sauvegarde et restauration des personnalisations système pour Ubuntu"
            color: Style.Theme.colors.textSecondary
            font.family: Style.Typography.fontFamily
            font.pixelSize: Style.Typography.fontSizeBody
            font.weight: Style.Typography.fontWeightRegular
            width: parent.width - Style.Spacing.xl * 2
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            anchors.top: titleText.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Spacing.m
        }
        
        // Séparateur
        Rectangle {
            id: separator
            width: parent.width - Style.Spacing.xl * 2
            height: 4
            color: Style.Theme.colors.accent
            radius: Style.Radius.xs
            anchors.top: descriptionText.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Spacing.l
        }
        
        // Bouton primaire
        Rectangle {
            id: primaryButton
            width: primaryButtonText.width + Style.Spacing.xl
            height: 40
            color: mouseAreaPrimary.pressed ? Style.Theme.colors.buttonPrimaryActive : 
                   mouseAreaPrimary.containsMouse ? Style.Theme.colors.buttonPrimaryHover : 
                   Style.Theme.colors.accent
            radius: Style.Radius.s
            anchors.top: separator.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Spacing.l
            
            // Effet d'ombre
            layer.enabled: true
            layer.effect: DropShadow {
                id: primaryButtonShadow
                horizontalOffset: Style.Theme.elevation.low.horizontalOffset
                verticalOffset: Style.Theme.elevation.low.verticalOffset
                radius: Style.Theme.elevation.low.radius
                samples: 17
                color: Style.Theme.elevation.low.color
            }
            
            // Animation de transition de couleur
            Behavior on color {
                ColorAnimation {
                    duration: Style.Animations.durationFast
                    easing.type: Style.Animations.easeOut
                }
            }
            
            Text {
                id: primaryButtonText
                text: "Nouvelle sauvegarde"
                color: "white"
                font.family: Style.Typography.fontFamily
                font.pixelSize: Style.Typography.fontSizeBody
                font.weight: Style.Typography.fontWeightMedium
                anchors.centerIn: parent
            }
            
            MouseArea {
                id: mouseAreaPrimary
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: console.log("Nouveau scan")
                
                // Animation de l'état pressé
                onPressed: primaryButton.scale = 0.98
                onReleased: primaryButton.scale = 1.0
            }
            
            // Animation de l'échelle
            Behavior on scale {
                NumberAnimation {
                    duration: Style.Animations.durationFast
                    easing.type: Style.Animations.easeOut
                }
            }
        }
        
        // Bouton secondaire
        Rectangle {
            id: secondaryButton
            width: secondaryButtonText.width + Style.Spacing.xl
            height: 40
            color: mouseAreaSecondary.pressed ? Style.Theme.colors.buttonSecondaryActive : 
                   mouseAreaSecondary.containsMouse ? Style.Theme.colors.buttonSecondaryHover : 
                   Style.Theme.colors.buttonSecondaryBg
            border.width: 1
            border.color: Style.Theme.colors.separator
            radius: Style.Radius.s
            anchors.top: primaryButton.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Spacing.m
            
            // Animation de transition de couleur
            Behavior on color {
                ColorAnimation {
                    duration: Style.Animations.durationFast
                    easing.type: Style.Animations.easeOut
                }
            }
            
            Text {
                id: secondaryButtonText
                text: "Changer de thème"
                color: Style.Theme.colors.textPrimary
                font.family: Style.Typography.fontFamily
                font.pixelSize: Style.Typography.fontSizeBody
                font.weight: Style.Typography.fontWeightRegular
                anchors.centerIn: parent
            }
            
            MouseArea {
                id: mouseAreaSecondary
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Style.Theme.toggleDarkMode()
                
                // Animation de l'état pressé
                onPressed: secondaryButton.scale = 0.98
                onReleased: secondaryButton.scale = 1.0
            }
            
            // Animation de l'échelle
            Behavior on scale {
                NumberAnimation {
                    duration: Style.Animations.durationFast
                    easing.type: Style.Animations.easeOut
                }
            }
        }
        
        // Carte d'information
        Rectangle {
            id: infoCard
            width: parent.width - Style.Spacing.xl * 2
            height: cardContent.implicitHeight + Style.Spacing.xl * 2
            color: Style.Theme.colors.background
            border.width: 1
            border.color: Style.Theme.colors.separator
            radius: Style.Radius.m
            anchors.top: secondaryButton.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Spacing.l
            
            // Propriété pour gérer l'état du hover
            property bool isHovered: false
            
            // Effet d'ombre
            layer.enabled: true
            layer.effect: DropShadow {
                id: cardShadow
                horizontalOffset: infoCard.isHovered ? 0 : 0
                verticalOffset: infoCard.isHovered ? 8 : 3
                radius: infoCard.isHovered ? 16 : 6
                samples: infoCard.isHovered ? 25 : 17
                color: infoCard.isHovered ? 
                       Qt.rgba(0, 0, 0, Style.Theme.isDarkTheme ? 0.3 : 0.12) : 
                       Qt.rgba(0, 0, 0, Style.Theme.isDarkTheme ? 0.24 : 0.1)
                
                // Animation du changement d'ombre
                Behavior on verticalOffset {
                    NumberAnimation {
                        duration: Style.Animations.durationStandard
                        easing.type: Style.Animations.easeOut
                    }
                }
                
                Behavior on radius {
                    NumberAnimation {
                        duration: Style.Animations.durationStandard
                        easing.type: Style.Animations.easeOut
                    }
                }
                
                Behavior on color {
                    ColorAnimation {
                        duration: Style.Animations.durationStandard
                        easing.type: Style.Animations.easeOut
                    }
                }
            }
            
            // Contenu de la carte
            Item {
                id: cardContent
                anchors.fill: parent
                anchors.margins: Style.Spacing.m
                implicitHeight: cardTitle.height + separator2.height + themeText.height + 
                               systemThemeText.height + badge.height + Style.Spacing.s * 4
                
                // Titre de la carte
                Text {
                    id: cardTitle
                    width: parent.width
                    text: "Informations système"
                    color: Style.Theme.colors.textPrimary
                    font.family: Style.Typography.fontFamily
                    font.pixelSize: Style.Typography.fontSizeH3
                    font.weight: Style.Typography.fontWeightMedium
                    anchors.top: parent.top
                    anchors.left: parent.left
                }
                
                // Séparateur
                Rectangle {
                    id: separator2
                    width: parent.width
                    height: 1
                    color: Style.Theme.colors.separator
                    anchors.top: cardTitle.bottom
                    anchors.topMargin: Style.Spacing.s
                }
                
                // Informations sur le thème
                Text {
                    id: themeText
                    width: parent.width
                    text: "Mode sombre: " + (Style.Theme.isDarkTheme ? "Activé" : "Désactivé")
                    color: Style.Theme.colors.textSecondary
                    font.family: Style.Typography.fontFamily
                    font.pixelSize: Style.Typography.fontSizeBody
                    font.weight: Style.Typography.fontWeightRegular
                    anchors.top: separator2.bottom
                    anchors.topMargin: Style.Spacing.s
                }
                
                Text {
                    id: systemThemeText
                    width: parent.width
                    text: "Suivi système: " + (Style.Theme.followSystemTheme ? "Activé" : "Désactivé")
                    color: Style.Theme.colors.textSecondary
                    font.family: Style.Typography.fontFamily
                    font.pixelSize: Style.Typography.fontSizeBody
                    font.weight: Style.Typography.fontWeightRegular
                    anchors.top: themeText.bottom
                    anchors.topMargin: Style.Spacing.s
                }
                
                // Badge d'état
                Rectangle {
                    id: badge
                    width: badgeText.implicitWidth + Style.Spacing.m
                    height: badgeText.implicitHeight + Style.Spacing.xs
                    radius: Style.Radius.xs
                    color: Style.Theme.isDarkTheme 
                        ? Qt.rgba(Style.Theme.colors.accent.r, Style.Theme.colors.accent.g, Style.Theme.colors.accent.b, 0.2) 
                        : Qt.rgba(Style.Theme.colors.accent.r, Style.Theme.colors.accent.g, Style.Theme.colors.accent.b, 0.1)
                    anchors.top: systemThemeText.bottom
                    anchors.topMargin: Style.Spacing.s
                    
                    Text {
                        id: badgeText
                        anchors.centerIn: parent
                        text: "Thème actif"
                        color: Style.Theme.colors.accent
                        font.family: Style.Typography.fontFamily
                        font.pixelSize: Style.Typography.fontSizeSmall
                        font.weight: Style.Typography.fontWeightMedium
                    }
                }
            }
            
            // Gestion des interactions de la carte
            MouseArea {
                id: cardMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: Style.Theme.enableFollowSystemTheme()
                onEntered: infoCard.isHovered = true
                onExited: infoCard.isHovered = false
            }
        }
    }
}