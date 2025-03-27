# Documentation du framework de test de CustomSync

Ce document explique comment utiliser le framework de test pour valider le système de style et les composants de l'application CustomSync.

## Table des matières

- [Documentation du framework de test de CustomSync](#documentation-du-framework-de-test-de-customsync)
  - [Table des matières](#table-des-matières)
  - [Vue d'ensemble](#vue-densemble)
  - [Installation et configuration](#installation-et-configuration)
    - [Prérequis](#prérequis)
    - [Structure des répertoires](#structure-des-répertoires)
  - [Exécution des tests](#exécution-des-tests)
    - [Tests complets](#tests-complets)
    - [Tests ciblés](#tests-ciblés)
    - [Comprendre les résultats](#comprendre-les-résultats)
  - [Ajout de nouveaux tests](#ajout-de-nouveaux-tests)
    - [Tests de composants](#tests-de-composants)
    - [Tests personnalisés](#tests-personnalisés)
  - [Structure du framework](#structure-du-framework)
  - [Bonnes pratiques](#bonnes-pratiques)
    - [Pour les tests de composants](#pour-les-tests-de-composants)
    - [Pour l'organisation des tests](#pour-lorganisation-des-tests)
  - [Dépannage](#dépannage)
    - [Problèmes courants et solutions](#problèmes-courants-et-solutions)
    - [Débugger les tests](#débugger-les-tests)

## Vue d'ensemble

Le framework de test de CustomSync permet de tester automatiquement:

- **Le système de style**: Vérifie que tous les modules de style (ColorPalette, Typography, etc.) fonctionnent correctement et peuvent être importés.
- **Les composants**: Vérifie que chaque composant QML peut être chargé et instancié sans erreur.

Ce framework utilise PySide6 et QML pour créer un environnement de test qui simule l'application réelle, garantissant ainsi que tout fonctionnera correctement dans l'application finale.

## Installation et configuration

### Prérequis

- Python 3.6 ou supérieur
- PySide6 installé dans votre environnement virtuel

### Structure des répertoires

Le framework de test s'attend à la structure suivante:

```
CustomSync/
├── src/
│   ├── style/         # Système de style (*.qml, qmldir)
│   └── components/    # Composants QML à tester
└── tests/
    ├── run_tests.py   # Script principal de test
    ├── style/         # Tests spécifiques au style (optionnel)
    └── components/    # Tests spécifiques aux composants (optionnel)
```

## Exécution des tests

### Tests complets

Pour exécuter tous les tests disponibles:

```bash
python tests/run_tests.py
```

### Tests ciblés

Pour exécuter uniquement des tests spécifiques:

```bash
# Tests du système de style uniquement
python tests/run_tests.py style

# Tests de tous les composants
python tests/run_tests.py components

# Test d'un composant spécifique (ex: CSButton)
python tests/run_tests.py component:CSButton
```

### Comprendre les résultats

Les résultats des tests s'affichent avec des indicateurs visuels:

- ✅ Test réussi
- ❌ Test échoué
- 💥 Erreur pendant l'exécution du test
- ⏭️ Test ignoré

À la fin de l'exécution, un résumé indique le nombre total de tests réussis et échoués.

## Ajout de nouveaux tests

### Tests de composants

Pour tester vos composants, placez-les simplement dans le répertoire `src/components/`. Par exemple:

```
src/components/CSButton.qml
```

Le framework détectera automatiquement ce composant et vérifiera qu'il peut être chargé et instancié.

Si vous avez des sous-composants qui ne doivent pas être testés individuellement, placez-les dans des sous-répertoires:

```
src/components/internal/CSButtonIcon.qml
```

### Tests personnalisés

Pour des tests plus avancés, vous pouvez créer des fichiers de test QML personnalisés dans le répertoire `tests/components/`.

Exemple de test personnalisé pour un bouton (`tests/components/test_CSButton.qml`):

```qml
import QtQuick 6.5
import "../../src/style" as Style
import "../../src/components"

Rectangle {
    id: testRoot
    width: 400
    height: 300
    color: "white"
    
    // Signal pour communiquer avec Python
    signal testCompleted(string name, bool passed, string message)
    signal allTestsCompleted()
    
    CSButton {
        id: testButton
        text: "Test Button"
        anchors.centerIn: parent
    }
    
    Timer {
        interval: 500
        running: true
        onTriggered: {
            // Test 1: Vérifier les propriétés par défaut
            testRoot.testCompleted("CSButton-DefaultProps", 
                                  testButton.text === "Test Button", 
                                  "Propriété text incorrecte");
            
            // Test 2: Vérifier le changement d'état
            testButton.hovered = true;
            testRoot.testCompleted("CSButton-HoverState", 
                                  testButton.state === "hovered", 
                                  "L'état hover n'est pas appliqué");
            
            // Signaler la fin des tests
            testRoot.allTestsCompleted();
        }
    }
}
```

Pour exécuter ce test personnalisé, modifiez `run_tests.py` pour qu'il détecte et exécute ces fichiers.

## Structure du framework

Le framework est composé de plusieurs classes:

- `ProjectConfig`: Gère la configuration et la structure du projet
- `TestResult`: Représente le résultat d'un test individuel
- `TestCollector`: Collecte les résultats des tests QML
- `SharedQmlApp`: Singleton pour gérer une unique instance de QGuiApplication
- `Tester`: Classe de base pour tous les testeurs
- `StyleTester`: Teste le système de style
- `ComponentTester`: Teste les composants

## Bonnes pratiques

### Pour les tests de composants

1. **Isolation**: Chaque test doit être isolé et ne pas dépendre d'autres tests
2. **Précision**: Testez une seule chose à la fois avec des messages d'erreur clairs
3. **Exhaustivité**: Testez les cas normaux et les cas limites
4. **Rapidité**: Les tests doivent s'exécuter rapidement pour favoriser l'itération

### Pour l'organisation des tests

1. **Nommage cohérent**: Utilisez des noms clairs et descriptifs pour vos tests
2. **Structure logique**: Organisez vos tests de manière à refléter la structure de votre application
3. **Documentation**: Documentez le but de chaque test pour faciliter la maintenance

## Dépannage

### Problèmes courants et solutions

1. **"Aucun composant à tester"**
   - Vérifiez que vos composants sont placés directement dans `src/components/` et non dans un sous-répertoire
   - Exécutez uniquement les tests de style avec `python tests/run_tests.py style`

2. **"Impossible de charger le composant"**
   - Vérifiez que le composant est valide syntaxiquement
   - Vérifiez les dépendances du composant (importations)
   - Examinez les erreurs spécifiques dans la sortie

3. **"QML Settings: Failed to initialize QSettings instance"**
   - Cette erreur est normale lors des tests car l'application n'est pas complètement initialisée
   - Elle n'affecte pas les résultats des tests

4. **"Please destroy the QGuiApplication singleton"**
   - Si cette erreur apparaît, c'est que le pattern Singleton pour QGuiApplication ne fonctionne pas correctement
   - Vérifiez que vous utilisez la dernière version du script `run_tests.py`

### Débugger les tests

Pour un débogage plus approfondi, ajoutez des instructions `console.log()` dans vos fichiers QML de test:

```qml
Timer {
    interval: 500
    running: true
    onTriggered: {
        console.log("Début des tests");
        // Tests...
        console.log("Valeur obtenue:", someValue);
    }
}
```

Ces messages apparaîtront dans la sortie du script de test.

---

Pour toute question ou problème non couvert dans cette documentation, n'hésitez pas à consulter la documentation de PySide6 ou à poser des questions à l'équipe de développement.