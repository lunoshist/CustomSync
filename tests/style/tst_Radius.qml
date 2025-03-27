import QtQuick 6.5
import QtTest 1.0
import "../src/style" as Style

TestCase {
    name: "RadiusTest"
    
    function test_basicProperties() {
        // Vérifier que les propriétés de base sont définies
        verify(Style.Radius.xs !== undefined)
        verify(Style.Radius.s !== undefined)
        verify(Style.Radius.m !== undefined)
        verify(Style.Radius.l !== undefined)
        
        // Vérifier les valeurs attendues et les relations
        compare(Style.Radius.xs, 2)
        compare(Style.Radius.s, 4)
        compare(Style.Radius.m, 6)
        compare(Style.Radius.l, 8)
        
        verify(Style.Radius.xs < Style.Radius.s)
        verify(Style.Radius.s < Style.Radius.m)
        verify(Style.Radius.m < Style.Radius.l)
    }
    
    function test_applyRadiusFunction() {
        // Créer un Rectangle pour tester
        var component = Qt.createComponent("data/TestRectangle.qml")
        verify(component.status === Component.Ready)
        
        var rect = component.createObject(null)
        verify(rect !== null)
        
        // Tester avec des chaînes
        Style.Radius.applyRadius(rect, "xs")
        compare(rect.radius, Style.Radius.xs)
        
        Style.Radius.applyRadius(rect, "m")
        compare(rect.radius, Style.Radius.m)
        
        // Tester avec des valeurs numériques
        Style.Radius.applyRadius(rect, 10)
        compare(rect.radius, 10)
        
        // Cleanup
        rect.destroy()
    }
    
    function test_errorHandling() {
        // Tester avec un paramètre null
        Style.Radius.applyRadius(null, "s")
        // Devrait gérer l'erreur sans planter
        
        // Tester avec une taille invalide
        var rect = Qt.createComponent("data/TestRectangle.qml").createObject(null)
        Style.Radius.applyRadius(rect, "invalid_size")
        // Devrait utiliser "s" par défaut
        compare(rect.radius, Style.Radius.s)
        
        // Cleanup
        rect.destroy()
    }
}