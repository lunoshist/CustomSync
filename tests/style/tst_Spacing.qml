import QtQuick 6.5
import QtTest 1.0
import "../src/style" as Style

TestCase {
    name: "SpacingTest"
    
    function test_basicProperties() {
        // Vérifier que les propriétés de base sont définies
        verify(Style.Spacing.unit !== undefined)
        verify(Style.Spacing.xs !== undefined)
        verify(Style.Spacing.s !== undefined)
        verify(Style.Spacing.m !== undefined)
        verify(Style.Spacing.l !== undefined)
        verify(Style.Spacing.xl !== undefined)
        
        // Vérifier les valeurs attendues et les relations
        compare(Style.Spacing.unit, 8)
        compare(Style.Spacing.s, Style.Spacing.unit)
        verify(Style.Spacing.xs < Style.Spacing.s)
        verify(Style.Spacing.s < Style.Spacing.m)
        verify(Style.Spacing.m < Style.Spacing.l)
        verify(Style.Spacing.l < Style.Spacing.xl)
    }
    
    function test_gridFunctions() {
        // Tester columnWidth
        var totalWidth = 1200  // Largeur hypothétique
        
        // Pour 1 colonne
        var oneColWidth = Style.Spacing.columnWidth(totalWidth, 1)
        verify(oneColWidth > 0)
        verify(oneColWidth < totalWidth)
        
        // Pour 12 colonnes (devrait être totalWidth)
        var fullWidth = Style.Spacing.columnWidth(totalWidth, 12)
        verify(Math.abs(fullWidth - totalWidth) < 0.01)  // Tolérance pour les erreurs d'arrondi
        
        // Vérifier la proportionnalité
        var halfWidth = Style.Spacing.columnWidth(totalWidth, 6)
        verify(Math.abs(halfWidth - fullWidth/2) < 0.01)
        
        // Tester columnOffset
        var oneColOffset = Style.Spacing.columnOffset(totalWidth, 1)
        compare(oneColOffset, 0)  // La première colonne devrait avoir un offset de 0
        
        var twoColOffset = Style.Spacing.columnOffset(totalWidth, 2)
        verify(twoColOffset > 0)  // La deuxième colonne devrait avoir un offset positif
    }
    
    function test_multiplyFunction() {
        // Tester la fonction multiply
        compare(Style.Spacing.multiply(1), Style.Spacing.unit)
        compare(Style.Spacing.multiply(2), Style.Spacing.unit * 2)
        compare(Style.Spacing.multiply(0), 0)
        
        // Tester avec des décimales
        var value = Style.Spacing.multiply(1.5)
        compare(value, Style.Spacing.unit * 1.5)
    }
    
    function test_errorHandling() {
        // Tester avec des valeurs invalides
        var result = Style.Spacing.columnWidth(0, 1)
        compare(result, 0)  // Devrait retourner 0 pour une largeur invalide
        
        result = Style.Spacing.columnWidth(100, 0)
        compare(result, 0)  // Devrait retourner 0 pour un nombre de colonnes invalide
        
        result = Style.Spacing.columnWidth(100, 13)
        compare(result, 0)  // Devrait retourner 0 pour un nombre de colonnes > 12
        
        // Tester avec des paramètres non-numériques
        result = Style.Spacing.multiply("test")
        compare(result, Style.Spacing.unit)  // Devrait utiliser 1 par défaut
    }
}