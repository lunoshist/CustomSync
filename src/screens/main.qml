// src/screens/main.qml

import QtQuick 6.5
import QtQuick.Controls 6.5
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
    color: Style.Theme.colors.backgroundPrimary
    
    // Exposer la fonction pour mettre à jour le thème depuis Python
    function setSystemTheme(isDark) {
        Style.Theme.setSystemTheme(isDark);
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
            duration: Style.Theme.animations.durationFast
            easing.type: Style.Theme.animations.easeOut
        }
        
        PropertyAnimation {
            target: centerContent
            property: "opacity"
            to: 1.0
            duration: Style.Theme.animations.durationFast
            easing.type: Style.Theme.animations.easeOut
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
            font.family: Style.Theme.typography.fontFamily
            font.pixelSize: Style.Theme.typography.fontSizeH1
            font.weight: Style.Theme.typography.fontWeightLight
            font.letterSpacing: Style.Theme.typography.letterSpacingH1
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Theme.spacing.m
        }
        
        // Description
        Text {
            id: descriptionText
            text: "Application de sauvegarde et restauration des personnalisations système pour Ubuntu"
            color: Style.Theme.colors.textSecondary
            font.family: Style.Theme.typography.fontFamily
            font.pixelSize: Style.Theme.typography.fontSizeBody
            font.weight: Style.Theme.typography.fontWeightRegular
            width: parent.width - Style.Theme.spacing.xl * 2
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            anchors.top: titleText.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Theme.spacing.m
        }
        
        // Séparateur
        Rectangle {
            id: separator
            width: parent.width - Style.Theme.spacing.xl * 2
            height: 4
            color: Style.Theme.colors.accent
            radius: Style.Theme.radius.xs
            anchors.top: descriptionText.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Theme.spacing.l
        }
        
        // Bouton primaire
        Rectangle {
            id: primaryButton
            width: primaryButtonText.width + Style.Theme.spacing.xl
            height: 40
            color: mouseAreaPrimary.pressed ? Style.Theme.colors.buttonPrimaryActive : 
                   mouseAreaPrimary.containsMouse ? Style.Theme.colors.buttonPrimaryHover : 
                   Style.Theme.colors.buttonPrimaryBg
            radius: Style.Theme.radius.s
            anchors.top: separator.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Theme.spacing.l
            
            // Effet d'ombre
            layer.enabled: true
            layer.effect: DropShadow {
                id: primaryButtonShadow
                horizontalOffset: Style.Theme.elevation.shadowLow.horizontalOffset
                verticalOffset: Style.Theme.elevation.shadowLow.verticalOffset
                radius: Style.Theme.elevation.shadowLow.radius
                samples: Style.Theme.elevation.shadowLow.samples
                color: Style.Theme.elevation.shadowLow.color
            }
            
            // Animation de transition de couleur
            Behavior on color {
                ColorAnimation {
                    duration: Style.Theme.animations.durationFast
                    easing.type: Style.Theme.animations.easeOut
                }
            }
            
            Text {
                id: primaryButtonText
                text: "Nouvelle sauvegarde"
                color: Style.Theme.colors.buttonPrimaryText
                font.family: Style.Theme.typography.fontFamily
                font.pixelSize: Style.Theme.typography.fontSizeBody
                font.weight: Style.Theme.typography.fontWeightMedium
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
                    duration: Style.Theme.animations.durationFast
                    easing.type: Style.Theme.animations.easeOut
                }
            }
        }
        
        // Bouton secondaire
        Rectangle {
            id: secondaryButton
            width: secondaryButtonText.width + Style.Theme.spacing.xl
            height: 40
            color: mouseAreaSecondary.pressed ? Style.Theme.colors.buttonSecondaryActive : 
                   mouseAreaSecondary.containsMouse ? Style.Theme.colors.buttonSecondaryHover : 
                   Style.Theme.colors.buttonSecondaryBg
            border.width: 1
            border.color: Style.Theme.colors.separator
            radius: Style.Theme.radius.s
            anchors.top: primaryButton.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Theme.spacing.m
            
            // Animation de transition de couleur
            Behavior on color {
                ColorAnimation {
                    duration: Style.Theme.animations.durationFast
                    easing.type: Style.Theme.animations.easeOut
                }
            }
            
            Text {
                id: secondaryButtonText
                text: "Changer de thème"
                color: Style.Theme.colors.buttonSecondaryText
                font.family: Style.Theme.typography.fontFamily
                font.pixelSize: Style.Theme.typography.fontSizeBody
                font.weight: Style.Theme.typography.fontWeightRegular
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
                    duration: Style.Theme.animations.durationFast
                    easing.type: Style.Theme.animations.easeOut
                }
            }
        }
        
        // Carte d'information
        Rectangle {
            id: infoCard
            width: parent.width - Style.Theme.spacing.xl * 2
            height: cardContent.implicitHeight + Style.Theme.spacing.xl * 2
            color: Style.Theme.colors.backgroundPrimary
            border.width: 1
            border.color: Style.Theme.colors.separator
            radius: Style.Theme.radius.m
            anchors.top: secondaryButton.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Style.Theme.spacing.l
            
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
                        duration: Style.Theme.animations.durationStandard
                        easing.type: Style.Theme.animations.easeOut
                    }
                }
                
                Behavior on radius {
                    NumberAnimation {
                        duration: Style.Theme.animations.durationStandard
                        easing.type: Style.Theme.animations.easeOut
                    }
                }
                
                Behavior on color {
                    ColorAnimation {
                        duration: Style.Theme.animations.durationStandard
                        easing.type: Style.Theme.animations.easeOut
                    }
                }
            }
            
            // Contenu de la carte
            Item {
                id: cardContent
                anchors.fill: parent
                anchors.margins: Style.Theme.spacing.m
                implicitHeight: cardTitle.height + separator2.height + themeText.height + 
                               systemThemeText.height + badge.height + Style.Theme.spacing.s * 4
                
                // Titre de la carte
                Text {
                    id: cardTitle
                    width: parent.width
                    text: "Informations système"
                    color: Style.Theme.colors.textPrimary
                    font.family: Style.Theme.typography.fontFamily
                    font.pixelSize: Style.Theme.typography.fontSizeH3
                    font.weight: Style.Theme.typography.fontWeightMedium
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
                    anchors.topMargin: Style.Theme.spacing.s
                }
                
                // Informations sur le thème
                Text {
                    id: themeText
                    width: parent.width
                    text: "Mode sombre: " + (Style.Theme.isDarkTheme ? "Activé" : "Désactivé")
                    color: Style.Theme.colors.textSecondary
                    font.family: Style.Theme.typography.fontFamily
                    font.pixelSize: Style.Theme.typography.fontSizeBody
                    font.weight: Style.Theme.typography.fontWeightRegular
                    anchors.top: separator2.bottom
                    anchors.topMargin: Style.Theme.spacing.s
                }
                
                Text {
                    id: systemThemeText
                    width: parent.width
                    text: "Suivi système: " + (Style.Theme.followSystemTheme ? "Activé" : "Désactivé")
                    color: Style.Theme.colors.textSecondary
                    font.family: Style.Theme.typography.fontFamily
                    font.pixelSize: Style.Theme.typography.fontSizeBody
                    font.weight: Style.Theme.typography.fontWeightRegular
                    anchors.top: themeText.bottom
                    anchors.topMargin: Style.Theme.spacing.s
                }
                
                // Badge d'état
                Rectangle {
                    id: badge
                    width: badgeText.implicitWidth + Style.Theme.spacing.m
                    height: badgeText.implicitHeight + Style.Theme.spacing.xs
                    radius: Style.Theme.radius.xs
                    color: Style.Theme.isDarkTheme 
                        ? Qt.rgba(Style.Theme.colors.accent.r, Style.Theme.colors.accent.g, Style.Theme.colors.accent.b, 0.2) 
                        : Qt.rgba(Style.Theme.colors.accent.r, Style.Theme.colors.accent.g, Style.Theme.colors.accent.b, 0.1)
                    anchors.top: systemThemeText.bottom
                    anchors.topMargin: Style.Theme.spacing.s
                    
                    Text {
                        id: badgeText
                        anchors.centerIn: parent
                        text: "Thème actif"
                        color: Style.Theme.colors.accent
                        font.family: Style.Theme.typography.fontFamily
                        font.pixelSize: Style.Theme.typography.fontSizeSmall
                        font.weight: Style.Theme.typography.fontWeightMedium
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