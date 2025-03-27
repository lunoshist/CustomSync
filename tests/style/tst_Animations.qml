import QtQuick 6.5
import QtTest 1.0
import "../src/style" as Style

TestCase {
    name: "AnimationsTest"
    
    function test_basicProperties() {
        // Vérifier que les propriétés de base sont définies
        verify(Style.Animations.durationFast !== undefined)
        verify(Style.Animations.durationStandard !== undefined)
        verify(Style.Animations.durationEmphasis !== undefined)
        
        verify(Style.Animations.easeOut !== undefined)
        verify(Style.Animations.easeInOut !== undefined)
        verify(Style.Animations.emphasizedCurve !== undefined)
        
        // Vérifier les valeurs attendues et les relations
        compare(Style.Animations.durationFast, 150)
        compare(Style.Animations.durationStandard, 200)
        compare(Style.Animations.durationEmphasis, 300)
        
        verify(Style.Animations.durationFast < Style.Animations.durationStandard)
        verify(Style.Animations.durationStandard < Style.Animations.durationEmphasis)
    }
    
    function test_animationCreationFunctions() {
        // Tester createNumberAnimation
        var numberAnim = Style.Animations.createNumberAnimation("opacity", "fast")
        verify(numberAnim !== null)
        compare(numberAnim.type, "NumberAnimation")
        compare(numberAnim.properties, "opacity")
        compare(numberAnim.duration, Style.Animations.durationFast)
        
        // Tester createColorAnimation
        var colorAnim = Style.Animations.createColorAnimation("color", "standard")
        verify(colorAnim !== null)
        compare(colorAnim.type, "ColorAnimation")
        compare(colorAnim.properties, "color")
        compare(colorAnim.duration, Style.Animations.durationStandard)
    }
    
    function test_getAnimationCode() {
        // Tester getAnimationCode pour une animation de nombre
        var numberCode = Style.Animations.getAnimationCode("opacity", "number", "standard")
        verify(numberCode.indexOf("NumberAnimation") !== -1)
        verify(numberCode.indexOf("duration: 200") !== -1)
        
        // Tester getAnimationCode pour une animation de couleur
        var colorCode = Style.Animations.getAnimationCode("color", "color", "fast")
        verify(colorCode.indexOf("ColorAnimation") !== -1)
        verify(colorCode.indexOf("duration: 150") !== -1)
    }
    
    function test_createThemeTransition() {
        // Tester la création d'une transition de thème
        var themeTransition = Style.Animations.createThemeTransition()
        verify(themeTransition !== null)
        verify(themeTransition.fadeOut !== undefined)
        verify(themeTransition.fadeIn !== undefined)
        
        // Vérifier les propriétés
        compare(themeTransition.fadeOut.property, "opacity")
        compare(themeTransition.fadeOut.to, 0.8)
        compare(themeTransition.fadeIn.to, 1.0)
    }
    
    function test_errorHandling() {
        // Tester avec des paramètres invalides
        var anim = Style.Animations.createNumberAnimation(null)
        verify(anim === null)
        
        anim = Style.Animations.createNumberAnimation("opacity", "invalid_speed")
        verify(anim !== null)
        // Devrait utiliser "standard" par défaut
        compare(anim.duration, Style.Animations.durationStandard)
        
        var code = Style.Animations.getAnimationCode(null, null)
        verify(code.indexOf("Paramètres incomplets") !== -1)
    }
}