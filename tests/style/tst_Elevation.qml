import QtQuick 6.5
import QtTest 1.0
import Qt5Compat.GraphicalEffects
import "../src/style" as Style

TestCase {
    name: "ElevationTest"
    
    function test_basicProperties() {
        // Vérifier que les propriétés de base sont définies
        verify(Style.Elevation.noShadow !== undefined)
        verify(Style.Elevation.shadowLow !== undefined)
        verify(Style.Elevation.shadowMedium !== undefined)
        verify(Style.Elevation.shadowHigh !== undefined)
        
        // Vérifier que les versions sombres existent
        verify(Style.Elevation.darkShadowLow !== undefined)
        
        // Vérifier que chaque objet d'ombre a les propriétés requises
        verify(Style.Elevation.shadowLow.horizontalOffset !== undefined)
        verify(Style.Elevation.shadowLow.verticalOffset !== undefined)
        verify(Style.Elevation.shadowLow.radius !== undefined)
        verify(Style.Elevation.shadowLow.samples !== undefined)
        verify(Style.Elevation.shadowLow.color !== undefined)
    }
    
    function test_relationBetweenLevels() {
        // Vérifier que l'intensité augmente avec le niveau
        verify(Style.Elevation.shadowLow.radius < Style.Elevation.shadowMedium.radius)
        verify(Style.Elevation.shadowMedium.radius < Style.Elevation.shadowHigh.radius)
        
        // Vérifier que les échantillons augmentent avec le rayon
        verify(Style.Elevation.shadowLow.samples <= Style.Elevation.shadowHigh.samples)
    }
    
    function test_helperFunctions() {
        // Créer un Rectangle avec DropShadow
        var component = Qt.createComponent("data/TestRectangleWithShadow.qml")
        verify(component.status === Component.Ready)
        
        var rect = component.createObject(null)
        verify(rect !== null)
        
        // Appliquer l'ombre basse avec le thème clair
        Style.Elevation.applyDropShadow(rect, "low", false)
        compare(rect.layer.effect.radius, Style.Elevation.shadowLow.radius)
        compare(rect.layer.effect.verticalOffset, Style.Elevation.shadowLow.verticalOffset)
        
        // Appliquer l'ombre haute avec le thème sombre
        Style.Elevation.applyDropShadow(rect, "high", true)
        compare(rect.layer.effect.radius, Style.Elevation.darkShadowHigh.radius)
        compare(rect.layer.effect.verticalOffset, Style.Elevation.darkShadowHigh.verticalOffset)
        
        // Cleanup
        rect.destroy()
    }
    
    function test_errorHandling() {
        // Créer un Rectangle sans effet
        var component = Qt.createComponent("data/TestRectangle.qml")
        verify(component.status === Component.Ready)
        
        var rect = component.createObject(null)
        verify(rect !== null)
        
        // Ceci devrait produire un avertissement mais ne pas planter
        Style.Elevation.applyDropShadow(rect, "medium", false)
        
        // Tester avec un niveau invalide
        var rectWithShadow = Qt.createComponent("data/TestRectangleWithShadow.qml").createObject(null)
        Style.Elevation.applyDropShadow(rectWithShadow, "invalid_level", false)
        // Vérifier qu'il utilise "medium" par défaut
        compare(rectWithShadow.layer.effect.radius, Style.Elevation.shadowMedium.radius)
        
        // Cleanup
        rect.destroy()
        rectWithShadow.destroy()
    }
}