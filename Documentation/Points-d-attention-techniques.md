# Documentation/Points-d-attention-techniques.md

# Points d'attention techniques

Le projet à déjà connus des problèmes et des solutions, nous vous demenderons donc une attention particulière sur les différents points techniques listés ci-dessous :

### 1. Imports incorrects pour Qt 6

**Problème** : Utiliser les noms de modules de Qt 5 dans Qt 6 génère des erreurs.

**Erreur typique** :
```
module "QtGraphicalEffects" is not installed
```

**Solution** :
- Utiliser `import Qt5Compat.GraphicalEffects` pour les effets visuels
- Utiliser `import QtCore 6.5` pour les Settings
- Consulter la documentation Qt 6 pour les autres modules

### 2. Propriétés manquantes dans les effets

**Problème** : Les effets comme DropShadow nécessitent des propriétés supplémentaires dans Qt 6.

**Erreur typique** :
```
QML DropShadow: Cannot render shadow, unsupported source format
```

**Solution** :
- Toujours inclure la propriété `samples` pour DropShadow
- Vérifier que `layer.enabled` est défini à `true`

### 3. Mauvaises références aux propriétés des effets

**Problème** : Tentative d'accéder directement aux propriétés d'un effet via PropertyChanges sans définir le bon chemin.

**Erreur typique** :
```
QML PropertyChanges: Cannot assign to non-existent property "radius"
```

**Solution** :
- Accéder correctement aux propriétés via leur chemin complet : `target: myItem.layer.effect`
- Ou utiliser une propriété booléenne et des Behaviors pour animer les transitions

### 4. Boucles de layout polish()

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

### 5. Utiliser du scaling pour des effet hover

**Problème** : Utiliser du scaling pour des effets de hover peut rendre les textes flous

**Solution** : Priviligier des changements d'ombres