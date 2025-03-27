# Documentation/Points-d-attention-techniques.md

# Points d'attention techniques

Le projet a déjà connu des problèmes et des solutions, nous vous demandons donc une attention particulière sur les différents points techniques listés ci-dessous :

## 1. Compatibilité Qt 6

### Imports incorrects pour Qt 6

**Problème** : Utiliser les noms de modules de Qt 5 dans Qt 6 génère des erreurs.

**Erreur typique** :
```
module "QtGraphicalEffects" is not installed
```

**Solution** :
- Utiliser `import Qt5Compat.GraphicalEffects` pour les effets visuels
- Utiliser `import QtCore 6.0` pour les Settings
- Privilégier des versions de module minimales (ex: `import QtQuick 6.0`) plutôt que spécifiques
- Consulter la documentation Qt 6 pour les autres modules

### Propriétés manquantes dans les effets

**Problème** : Les effets comme DropShadow nécessitent des propriétés supplémentaires dans Qt 6.

**Erreur typique** :
```
QML DropShadow: Cannot render shadow, unsupported source format
```

**Solution** :
- Toujours inclure la propriété `samples` pour DropShadow
- Vérifier que `layer.enabled` est défini à `true`
- Utiliser les fonctions d'aide comme `applyDropShadow` pour configurer correctement tous les paramètres

## 2. Problèmes d'architecture

### Dépendances circulaires

**Problème** : Importation circulaire entre modules qui peut causer des erreurs d'initialisation.

**Erreur typique** :
```
QML module has no such file 'qmldir'
```

**Solution** :
- Éviter d'importer un module depuis lui-même (ex: `import "." as Style` dans un fichier du dossier style/)
- Créer des interfaces indirectes ou utiliser des signaux/slots pour la communication
- Structurer les dépendances de manière hiérarchique et non circulaire

### Boucles de liaison (binding loops)

**Problème** : Création de boucles de liaison lors de l'accès et de la modification des propriétés calculées.

**Erreur typique** :
```
QML Theme: Binding loop detected for property "colors"
```

**Solution** :
- Utiliser des fonctions d'accès pour renvoyer des objets mis en cache
- Mettre à jour les caches uniquement dans des gestionnaires d'événements (comme `onIsDarkThemeChanged`)
- Éviter de modifier l'état dans les propriétés calculées (readonly)
- Séparer clairement les propriétés de lecture et d'écriture

### Boucles de layout polish()

**Problème** : Les éléments comme `Column` ou `Row` peuvent entrer dans une boucle infinie de calcul de mise en page si leurs dimensions dépendent à la fois de leurs parents et de leurs enfants.

**Erreur typique** :
```
QML Column: possible QQuickItem::polish() loop
QML Column: Column called polish() inside updatePolish() of Column
```

**Solution** :
- Utiliser un positionnement explicite avec des ancres
- Éviter les dépendances circulaires dans les tailles
- Pour les listes complexes, utiliser ListView avec des délégués bien définis
- Spécifier des dimensions explicites plutôt que de laisser Qt les calculer

## 3. Pratiques anti-patterns

### Création dynamique d'objets

**Problème** : Utilisation de `Qt.createQmlObject` ou `Component.createObject` qui peut être fragile.

**Erreur typique** :
```
Error creating object dynamically. No matching component/object found
```

**Solution** :
- Privilégier une approche déclarative avec les composants QML
- Utiliser des fonctions qui retournent des configurations ou du code à copier
- Si nécessaire, utiliser des Loader avec sourceComponent plutôt que createObject
- Réserver la création dynamique pour les cas vraiment nécessaires

### Mauvaises références aux propriétés des effets

**Problème** : Tentative d'accéder directement aux propriétés d'un effet via PropertyChanges sans définir le bon chemin.

**Erreur typique** :
```
QML PropertyChanges: Cannot assign to non-existent property "radius"
```

**Solution** :
- Accéder correctement aux propriétés via leur chemin complet : `target: myItem.layer.effect`
- Utiliser des fonctions d'aide comme `applyDropShadow` et `applyInnerShadow`
- Utiliser des Behavior plutôt que des PropertyChanges pour les animations simples

### Propriétés dynamiques sur QObject

**Problème** : En QML, on ne peut pas assigner des valeurs à des propriétés qui n'existent pas déjà sur un QObject, ce qui est particulièrement problématique avec les singletons et les composants Settings.

**Erreur typique** :
```
QML Settings: Cannot assign to non-existent property "propertyName"
```

**Solution** :
- Pour stocker des paramètres persistants, utiliser l'approche basée sur JSON implémentée dans notre module Settings
- Toujours définir explicitement les propriétés attendues dans les composants QML
- Ne jamais supposer qu'un QObject acceptera des propriétés dynamiques
- Pour les singletons, définir toutes les propriétés à l'avance

## 4. Optimisation et performance

### Recréation excessive d'objets

**Problème** : Création répétée d'objets complexes qui peut affecter les performances.

**Symptômes** :
- Ralentissements lors des changements de thème
- Utilisation mémoire élevée
- Animations saccadées

**Solution** :
- Utiliser un système de cache comme celui implémenté dans Theme.qml
- Créer des objets uniquement lorsque nécessaire (par exemple lors des changements de thème)
- Utiliser des propriétés readonly avec des fonctions d'accès pour contrôler quand les objets sont créés

### Effets visuels coûteux

**Problème** : Utilisation excessive d'effets visuels comme les ombres qui peut affecter les performances.

**Solution** :
- Utiliser des effets visuels avec parcimonie
- Limiter le nombre d'éléments avec des effets complexes (DropShadow, InnerShadow)
- Désactiver les effets sur les appareils à faible puissance
- Utiliser des alternatives légères comme des bordures colorées lorsque possible

### Scaling pour les animations

**Problème** : Utiliser du scaling pour des effets de hover peut rendre les textes flous et consommer des ressources.

**Solution** :
- Privilégier des changements de couleur ou d'opacité pour les effets de hover
- Si un effet de grandissement est nécessaire, l'appliquer à un conteneur plutôt qu'à un élément avec texte
- Limiter les animations à des propriétés performantes (opacité, position, couleur)

## 5. Robustesse et sécurité

### Validation des entrées insuffisante

**Problème** : Fonctions acceptant des paramètres sans validation adéquate.

**Solution** :
- Toujours vérifier la validité des paramètres en entrée des fonctions
- Fournir des valeurs par défaut pour les paramètres optionnels
- Gérer explicitement les cas d'erreur et utiliser console.warn/error pour signaler les problèmes
- Retourner des codes d'erreur ou `false` quand une opération échoue

### Gestion des erreurs insatisfaisante

**Problème** : Manque de gestion des exceptions et des conditions d'erreur.

**Solution** :
- Utiliser des blocs try/catch autour du code pouvant générer des exceptions
- Journaliser les erreurs de façon explicite avec console.error
- Fournir des comportements de secours en cas d'échec
- Vérifier l'existence des objets avant d'accéder à leurs propriétés

### Conservation inadéquate des préférences utilisateur

**Problème** : Perte des préférences utilisateur ou corruption des données.

**Solution** :
- Utiliser un système robuste comme celui implémenté dans Settings.qml
- Ajouter un versionnement des données pour faciliter les migrations futures
- Valider les données lors du chargement
- Prévoir des mécanismes de récupération en cas de corruption

## Conseils de développement

1. **Test systématique des deux thèmes**
   - Vérifier chaque composant dans les thèmes clair et sombre
   - S'assurer que les transitions entre thèmes fonctionnent correctement

2. **Utilisation cohérente des tokens**
   - Toujours référencer les couleurs et les styles via le système de tokens
   - Ne jamais coder en dur des valeurs qui existent dans le système de design

3. **Documentation des composants**
   - Documenter les propriétés et méthodes avec des commentaires explicites
   - Indiquer les limites et cas particuliers
   - Fournir des exemples d'utilisation

4. **Tests de performance**
   - Vérifier le comportement des composants avec beaucoup de données
   - Tester sur différents appareils
   - Surveiller l'utilisation CPU/GPU pendant les animations

5. **Validation visuelle**
   - Comparer les rendus avec les maquettes de design
   - Vérifier l'accessibilité et les contrastes
   - S'assurer que l'interface est cohérente à travers toutes les tailles d'écran