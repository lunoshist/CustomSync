# Documentation/Recap-Apprentissage.md

# Récapitulatif des apprentissages sur le développement avec Qt 6

## Problèmes identifiés et solutions

### 1. Compatibilité Qt 6
- **Problème**: QtGraphicalEffects 1.15 n'est pas compatible avec Qt 6
- **Solution**: Utiliser QtQuick.Effects à la place, ou simplifier les effets visuels (ombres, etc.)
- **Problème**: Certaines propriétés (padding) ne sont pas disponibles sur tous les composants
- **Solution**: Vérifier la disponibilité des propriétés pour chaque type de composant

### 2. Importation des composants
- **Problème**: Les composants personnalisés ne sont pas trouvés lors de l'importation
- **Solution**: 
  - Créer un fichier qmldir dans le dossier des composants
  - Ajouter correctement les chemins d'importation dans le script de test
  - Utiliser les chemins relatifs adaptés à la structure du projet

### 3. Conflit de nommage
- **Problème**: Conflit avec des propriétés natives comme "icon"
- **Solution**: Renommer en "iconSource" ou un autre nom qui ne crée pas de conflit
- **Problème**: Redéfinition de signaux natifs (toggled, textChanged)
- **Solution**: Utiliser directement les signaux existants ou choisir des noms différents

### 4. Méthode de développement
- **Problème**: Difficulté à isoler les sources d'erreurs dans un fichier complexe
- **Solution**: Développer et tester un composant à la fois
- **Problème**: Accumulation d'erreurs lors de tests combinés
- **Solution**: Valider chaque composant individuellement avant de les intégrer

## Structure d'un composant compatible Qt 6

```qml
Button {
    id: root  // Toujours nommer le composant racine "root"
    
    // Propriétés publiques avec noms non-conflictuels
    property string variant: "primary"
    property url iconSource: ""  // Pas "icon" qui entre en conflit
    
    // Propriétés calculées marquées comme "readonly"
    readonly property color backgroundColor: {
        // Logique de calcul de couleur selon les états
    }
    
    // Éviter de redéfinir les signaux existants
    // Ne PAS faire:  signal toggled(bool checked)
    
    // Contenu stylisé
    contentItem: Text { /* ... */ }
    background: Rectangle { /* ... */ }
}
```

## Importance du fichier qmldir
Le fichier qmldir est **essentiel** pour que QML trouve les composants. Sans lui, les importations échoueront même si les chemins sont corrects.

## Approche de test recommandée
1. Tester chaque composant séparément avec un fichier de test dédié
2. Ne passer au composant suivant que lorsque le premier fonctionne
3. Intégrer tous les composants dans un test global uniquement lorsque tous les tests individuels fonctionnent
```

### ExempleFileQmldir.md
```markdown
# Exemple de fichier qmldir et son importance

## Qu'est-ce qu'un fichier qmldir ?
Un fichier qmldir est un fichier spécial qui définit un module QML et enregistre les composants qu'il contient. Sans ce fichier, QML ne peut pas trouver les composants importés, même si les chemins d'importation sont corrects.

## Structure d'un fichier qmldir
La structure de base est la suivante:
```
module [nom_du_module]

[NomComposant] [version] [fichier.qml]
[NomComposant2] [version] [fichier2.qml]
...
```

## Exemple pour notre projet
Voici le contenu du fichier `qmldir` à placer dans le dossier `src/components/core/`:

```
module components.core

CSButton 1.0 CSButton.qml
CSCheckbox 1.0 CSCheckbox.qml
CSInput 1.0 CSInput.qml
CSRadio 1.0 CSRadio.qml
CSSelect 1.0 CSSelect.qml
CSSwitch 1.0 CSSwitch.qml
```

## Importation des composants après avoir créé le fichier qmldir
Une fois le fichier qmldir en place, vous pouvez importer les composants de plusieurs façons:

1. **Importation de tout le module**:
```qml
import "components/core" as Core

Core.CSButton { /* ... */ }
```

2. **Importation directe**:
```qml
import "components/core"

CSButton { /* ... */ }
```

## Erreurs communes liées au fichier qmldir
- Oublier de créer le fichier qmldir
- Nommer incorrectement le module
- Spécifier des versions incompatibles
- Ne pas lister tous les composants du module
