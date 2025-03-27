import QtQuick 6.5
import QtTest 1.0
import "../src/style" as Style

TestCase {
    name: "ColorPaletteTest"
    
    function test_basicColors() {
        // Vérifier que les couleurs de base sont définies
        verify(Style.ColorPalette.backgroundPrimary !== undefined)
        verify(Style.ColorPalette.textPrimary !== undefined)
        verify(Style.ColorPalette.accent !== undefined)
        
        // Vérifier le format des couleurs (doit être un objet couleur Qt valide)
        compare(typeof Style.ColorPalette.backgroundPrimary.r, "number")
        compare(typeof Style.ColorPalette.backgroundPrimary.g, "number")
        compare(typeof Style.ColorPalette.backgroundPrimary.b, "number")
    }
    
    function test_darkThemeColors() {
        // Vérifier les couleurs du thème sombre
        verify(Style.ColorPalette.darkBackgroundPrimary !== undefined)
        verify(Style.ColorPalette.darkTextPrimary !== undefined)
        
        // Vérifier que les couleurs sombres sont différentes des couleurs claires
        verify(Style.ColorPalette.backgroundPrimary.toString() !== 
               Style.ColorPalette.darkBackgroundPrimary.toString())
    }
    
    function test_utilityFunctions() {
        // Tester withOpacity
        var testColor = Style.ColorPalette.accent
        var transparentColor = Style.ColorPalette.withOpacity(testColor, 0.5)
        compare(transparentColor.a, 0.5)
        compare(transparentColor.r, testColor.r)
        
        // Tester lighter
        var lighterColor = Style.ColorPalette.lighter(testColor, 0.3)
        verify(lighterColor.r >= testColor.r || lighterColor.g >= testColor.g || lighterColor.b >= testColor.b)
        
        // Tester darker
        var darkerColor = Style.ColorPalette.darker(testColor, 0.3)
        verify(darkerColor.r <= testColor.r || darkerColor.g <= testColor.g || darkerColor.b <= testColor.b)
    }
    
    function test_boundaryConditions() {
        // Tester des valeurs limites avec les fonctions utilitaires
        var testColor = Style.ColorPalette.accent
        
        // Opacité 0
        var invisibleColor = Style.ColorPalette.withOpacity(testColor, 0)
        compare(invisibleColor.a, 0)
        
        // Opacité 1
        var opaqueColor = Style.ColorPalette.withOpacity(testColor, 1)
        compare(opaqueColor.a, 1)
        
        // Opacité hors limites (devrait être limité entre 0 et 1)
        var limitedColor = Style.ColorPalette.withOpacity(testColor, 1.5)
        verify(limitedColor.a <= 1.0)
    }
}