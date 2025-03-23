# README.md

# CustomSync

Application de sauvegarde et restauration des personnalisations système pour Ubuntu, développée avec Qt 6.8.2 et Python.

## À propos du projet

CustomSync est une application desktop qui permet aux utilisateurs de sauvegarder et restaurer facilement leurs personnalisations système via une interface graphique intuitive.

## ⚠️ Note importante sur l'environnement technique

Ce projet utilise **Qt 6.8.2** avec PySide6, et non Qt 5.x comme beaucoup de tutoriels et exemples disponibles en ligne. Cette distinction est cruciale car :

- Les modules et imports sont différents entre Qt 5 et Qt 6
- Certaines fonctionnalités ont été déplacées ou renommées
- Certaines API ont changé

Par exemple :
- Les effets graphiques (ombres, etc.) utilisent `Qt5Compat.GraphicalEffects` et non `QtGraphicalEffects`
- Les paramètres persistants utilisent `import QtCore 6.0` et non `Qt.labs.settings`
- Certains types d'animations ont été renommés (par exemple `Easing.BezierSpline` à la place de `Easing.BezierCurve`)

## Architecture du projet

Le projet suit une architecture modulaire :

```
CustomSync/
├── customsync-env/                            # Environnement virtuel Python (ignoré par git)
├── Documentation/
│   ├── Architecture-UX.md                     # Documentation UX
│   ├── Points-d-attention-techniques.md       # Solution aux problèmes techniques déjà rencontré
│   ├── System-token.md                        # Documentation du système de tokens
│   └── System-design.md                       # L'ADN des normes de design du projet
├── Maquettes/
│   ├── accueil.svg                            # Maquette de l'écran d'accueil
│   └── ...                                    # Autres écrans
├── src/
│   ├── assets/                                # Ressources statiques
│   │   ├── fonts/                             # Police Ubuntu
│   │   └── icons/                             # Icônes de l'application
│   ├── components/                            # Composants réutilisables
│   │   ├── core/                              # Composants de base
│   │   ├── layout/                            # Composants de mise en page
│   │   ├── navigation/                        # Composants de navigation
│   │   └── complex/                           # Composants complexes
│   ├── controllers/                           # Contrôleurs de l'application
│   ├── models/                                # Modèles de données
│   ├── screens/                               # Écrans de l'application
│   |   ├── main.qml                           # Écran principal
│   |   └── ...                                # Autres écrans
│   ├── style/                                 # Système de tokens
│   │   ├── Animations.qml                     # Animation et transitions
│   │   ├── ColorPalette.qml                   # Palette de couleurs
│   │   ├── Elevation.qml                      # Ombres et élévations
│   │   ├── Radius.qml                         # Rayons des coins
│   │   ├── Spacing.qml                        # Espacements et grille
│   │   ├── Theme.qml                          # Gestion des thèmes (clair/sombre)
│   │   ├── Typography.qml                     # Typographie
│   │   └── qmldir                             # Registre des modules QML
│   ├── utils/                                 # Utilitaires
│   └── main.py                                # Point d'entrée Python
├── test-qml.sh                                # Script pour tester des fichiers QML individuellement
├── GUIDELINE.md                               # Direrctives à suivre absolument
├── README.md                                  # Ce fichier
└── .gitignore                                 # Configuration git
```

## Prérequis techniques

- **Python 3.10+** (testé avec Python 3.12.3)
- **PySide6 6.8+** (pour Qt 6.8.2)
- **Bibliothèques Qt6**
- **Ubuntu** ou autre distribution Linux compatible 

## Modules Qt utilisés

Basé sur notre environnement actuel avec Qt 6.8.2, les modules suivants sont utilisés :

- **QtCore** - Fonctionnalités de base
- **QtGui** - Interface utilisateur graphique de base
- **QtQml** - Moteur QML
- **QtQuick** - Framework d'interface utilisateur
- **QtQuickControls2** - Contrôles d'interface utilisateur pour Qt Quick
- **Qt5Compat.GraphicalEffects** - Effets visuels (ombres, flou, etc.)

## Installation

1. **Cloner le dépôt :**
   ```bash
   git clone <url-du-repo>
   cd CustomSync
   ```

2. **Créer un environnement virtuel :**
   ```bash
   python3 -m venv customsync-env
   source customsync-env/bin/activate
   ```

3. **Installer les dépendances :**
   ```bash
   pip install PySide6==6.8.2
   ```

## Lancement de l'application

### Lancement complet

Pour démarrer l'application complète :

```bash
source customsync-env/bin/activate  # Activer l'environnement virtuel
python src/main.py
```

### Tester un fichier QML individuel

Pour tester un composant ou un écran QML individuel :

```bash
./test-qml.sh chemin/vers/fichier.qml
```

## Système de design

L'application utilise un système de design complet basé sur des tokens. Ce système comprend :

- Une palette de couleurs avec support des thèmes clair et sombre
- Une typographie standardisée
- Un système d'espacement cohérent
- Des élévations et ombres
- Des rayons d'angles arrondis standardisés
- Des animations et transitions

Pour plus de détails, consultez [SYSTEM_TOKENS.md](SYSTEM_TOKENS.md).

## Documentation

Avant de contribuer au projet, consulter les [Lignes directives](GUIDELINE) du projet.

Le projet à déjà connus des problèmes et des solutions, listées par le document [Points d'attention techniques](Documentation/Points-d-attention-techniques.md)

- Pour les détails de l'architecture UX : [Architecture-UX.md](Documentation/Architecture-UX.md)
- Pour le système de design : [system-design.md](Documentation/System-design.md)
- Pour le système de tokens : [SYSTEM_TOKENS.md](Documentation/System-token.md)