import QtQuick 6.5
import QtTest 1.0
import "../src/style" as Style

TestCase {
    name: "IntegrationTest"
    
    // Composant de test qui utilise plusieurs aspects du système de style
    Component {
        id: testComponent
        Rectangle {
            id: testItem
            width: 200
            height: 100
            color: Style.Theme.colors.backgroundPrimary
            radius: Style.Theme.radius.m
            border.width: 1
            border.color: Style.Theme.colors.separator
            
            property bool isHovered: false
            
            Text {
                id: titleText
                anchors.centerIn: parent
                text: "Test Component"
                font.family: Style.Theme.typography.fontFamily
                font.pixelSize: Style.Theme.typography.fontSizeH3
                font.weight: Style.Theme.typography.fontWeightMedium
                color: Style.Theme.colors.textPrimary
            }
            
            // Transitions
            Behavior on color {
                ColorAnimation {
                    duration: Style.Theme.animations.durationStandard
                }
            }
            
            // États
            states: [
                State {
                    name: "hovered"
                    when: isHovered
                    PropertyChanges {
                        target: testItem
                        color: Style.Theme.colors.backgroundSecondary
                    }
                }
            ]
        }
    }
    
    function test_componentCreation() {
        // Vérifier que le composant peut être créé correctement
        var item = testComponent.createObject(null)
        verify(item !== null)
        
        // Vérifier que les propriétés de style sont appliquées
        compare(item.color, Style.Theme.colors.backgroundPrimary)
        compare(item.radius, Style.Theme.radius.m)
        
        var titleText = item.children[0]
        compare(titleText.font.family, Style.Theme.typography.fontFamily)
        compare(titleText.font.pixelSize, Style.Theme.typography.fontSizeH3)
        
        // Cleanup
        item.destroy()
    }
    
    function test_themeChangePropagation() {
        // Créer le composant
        var item = testComponent.createObject(null)
        
        // Enregistrer les couleurs initiales
        var initialBg = item.color
        var initialText = item.children[0].color
        
        // Changer le thème
        Style.Theme.toggleDarkMode()
        
        // Vérifier que les couleurs ont changé
        verify(item.color.toString() !== initialBg.toString())
        verify(item.children[0].color.toString() !== initialText.toString())
        
        // Restaurer le thème
        Style.Theme.toggleDarkMode()
        
        // Cleanup
        item.destroy()
    }
    
    function test_stateChanges() {
        // Créer le composant
        var item = testComponent.createObject(null)
        
        // Enregistrer la couleur initiale
        var initialBg = item.color
        
        // Changer l'état
        item.isHovered = true
        
        // Vérifier que la couleur a changé (état "hovered")
        verify(item.color.toString() !== initialBg.toString())
        compare(item.color, Style.Theme.colors.backgroundSecondary)
        
        // Restaurer l'état
        item.isHovered = false
        
        // La couleur devrait revenir à l'état initial
        compare(item.color, Style.Theme.colors.backgroundPrimary)
        
        // Cleanup
        item.destroy()
    }
}