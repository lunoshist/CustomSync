import QtQuick 6.5
import QtTest 1.0
import "../src/style" as Style

TestCase {
    name: "ThemeTest"
    
    function test_themeProperties() {
        // Vérifier que les propriétés sont définies
        verify(Style.Theme.isDarkTheme !== undefined)
        verify(Style.Theme.followSystemTheme !== undefined)
        verify(Style.Theme.colors !== undefined)
        verify(Style.Theme.elevation !== undefined)
        verify(Style.Theme.typography !== undefined)
        verify(Style.Theme.spacing !== undefined)
        verify(Style.Theme.radius !== undefined)
        verify(Style.Theme.animations !== undefined)
    }
    
    function test_colors() {
        // Vérifier quelques couleurs essentielles
        verify(Style.Theme.colors.backgroundPrimary !== undefined)
        verify(Style.Theme.colors.textPrimary !== undefined)
        verify(Style.Theme.colors.accent !== undefined)
        
        // Vérifier que les couleurs changent avec le thème
        var initialBg = Style.Theme.colors.backgroundPrimary
        
        // Changer de thème
        Style.Theme.toggleDarkMode()
        
        // Les couleurs devraient être différentes
        verify(Style.Theme.colors.backgroundPrimary.toString() !== initialBg.toString())
        
        // Restaurer le thème initial
        Style.Theme.toggleDarkMode()
    }
    
    function test_elevations() {
        // Vérifier quelques élévations essentielles
        verify(Style.Theme.elevation.shadowLow !== undefined)
        verify(Style.Theme.elevation.shadowMedium !== undefined)
        
        // Vérifier que les élévations changent avec le thème
        var initialShadow = Style.Theme.elevation.shadowLow.color
        
        // Changer de thème
        Style.Theme.toggleDarkMode()
        
        // Les couleurs d'ombre devraient être différentes
        verify(Style.Theme.elevation.shadowLow.color.toString() !== initialShadow.toString())
        
        // Restaurer le thème initial
        Style.Theme.toggleDarkMode()
    }
    
    function test_themeChangedSignal() {
        let signalSpy = Qt.createComponent("data/SignalSpy.qml").createObject(null, { target: Style.Theme, signalName: "themeChanged" })
        
        // Le signal devrait être émis lors du changement de thème
        Style.Theme.toggleDarkMode()
        compare(signalSpy.count, 1)
        
        // Restaurer le thème initial
        Style.Theme.toggleDarkMode()
        compare(signalSpy.count, 2)
        
        // Cleanup
        signalSpy.destroy()
    }
    
    function test_themeToggleFunctions() {
        // Tester toggleDarkMode
        var initialState = Style.Theme.isDarkTheme
        Style.Theme.toggleDarkMode()
        compare(Style.Theme.isDarkTheme, !initialState)
        compare(Style.Theme.followSystemTheme, false)
        
        // Tester enableFollowSystemTheme
        Style.Theme.enableFollowSystemTheme()
        compare(Style.Theme.followSystemTheme, true)
        
        // Restaurer l'état initial
        if (Style.Theme.isDarkTheme !== initialState) {
            Style.Theme.toggleDarkMode()
        }
    }
    
    function test_isItemDarkFunction() {
        // Tester avec le thème global
        var globalTheme = Style.Theme.isDarkTheme
        compare(Style.Theme.isItemDark(null), globalTheme)
        
        // Tester avec un objet ayant sa propre propriété isDarkTheme
        var obj = { isDarkTheme: !globalTheme }
        compare(Style.Theme.isItemDark(obj), !globalTheme)
        
        // Tester avec un objet sans propriété isDarkTheme
        var objWithout = {}
        compare(Style.Theme.isItemDark(objWithout), globalTheme)
    }
    
    function test_applyThemedColorFunction() {
        // Créer un Rectangle pour tester
        var rect = Qt.createComponent("data/TestRectangle.qml").createObject(null)
        verify(rect !== null)
        
        // Appliquer une couleur adaptée au thème
        var lightColor = "#FFFFFF"
        var darkColor = "#000000"
        
        Style.Theme.applyThemedColor(rect, "color", lightColor, darkColor)
        compare(rect.color.toString(), Style.Theme.isDarkTheme ? darkColor : lightColor)
        
        // Tester avec une propriété imbriquée
        Style.Theme.applyThemedColor(rect, "border.color", lightColor, darkColor)
        compare(rect.border.color.toString(), Style.Theme.isDarkTheme ? darkColor : lightColor)
        
        // Cleanup
        rect.destroy()
    }
}