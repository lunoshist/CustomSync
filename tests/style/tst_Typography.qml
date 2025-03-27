import QtQuick 6.5
import QtTest 1.0
import "../src/style" as Style

TestCase {
    name: "TypographyTest"
    
    function test_basicProperties() {
        // Vérifier que les propriétés de base sont définies
        verify(Style.Typography.fontFamily !== undefined)
        verify(Style.Typography.fontSizeH1 !== undefined)
        verify(Style.Typography.fontWeightLight !== undefined)
        
        // Vérifier les valeurs attendues
        compare(Style.Typography.fontFamily, "Ubuntu")
        verify(Style.Typography.fontSizeH1 > Style.Typography.fontSizeH2)
        verify(Style.Typography.fontSizeBody > 0)
    }
    
    function test_helperFunctions() {
        // Créer un Text pour tester
        var textComponent = Qt.createComponent("data/TestText.qml")
        verify(textComponent.status === Component.Ready)
        
        var textItem = textComponent.createObject(null)
        verify(textItem !== null)
        
        // Tester applyH1Style
        Style.Typography.applyH1Style(textItem)
        compare(textItem.font.pixelSize, Style.Typography.fontSizeH1)
        compare(textItem.font.family, Style.Typography.fontFamily)
        compare(textItem.font.weight, Style.Typography.fontWeightLight)
        
        // Tester applyBodyStyle
        Style.Typography.applyBodyStyle(textItem)
        compare(textItem.font.pixelSize, Style.Typography.fontSizeBody)
        compare(textItem.font.weight, Style.Typography.fontWeightRegular)
        
        // Cleanup
        textItem.destroy()
    }
    
    function test_errorHandling() {
        // Tester avec un paramètre null
        Style.Typography.applyH1Style(null)
        // Si nous arrivons ici sans erreur, c'est que la gestion d'erreur fonctionne
        
        // Tester avec un objet qui n'est pas un Text
        var rectComponent = Qt.createComponent("data/TestRectangle.qml")
        verify(rectComponent.status === Component.Ready)
        
        var rectItem = rectComponent.createObject(null)
        verify(rectItem !== null)
        
        Style.Typography.applyH1Style(rectItem)
        // Si nous arrivons ici sans erreur, c'est que la gestion d'erreur fonctionne
        
        // Cleanup
        rectItem.destroy()
    }
}