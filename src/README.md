# CustomSync

Application de sauvegarde et restauration des personnalisations système pour Ubuntu.

## À propos du projet

CustomSync est une application desktop développée avec Qt/QML et Python qui permet aux utilisateurs de sauvegarder et restaurer facilement leurs personnalisations système via une interface graphique intuitive.

## Architecture du projet

Le projet suit une architecture modulaire :

```
CustomSync/
├── src/
│   ├── main.py                  # Point d'entrée Python
│   ├── style/                   # Système de tokens (voir DESIGN_SYSTEM.md)
│   ├── assets/                  # Ressources statiques
│   │   ├── fonts/               # Police Ubuntu
│   │   └── icons/               # Icônes de l'application
│   ├── components/              # Composants réutilisables
│   │   ├── core/                # Composants de base
│   │   ├── layout/              # Composants de mise en page
│   │   ├── navigation/          # Composants de navigation
│   │   └── complex/             # Composants complexes
│   └── screens/                 # Écrans de l'application
│       ├── main.qml             # Écran principal de test
│       └── ...                  # Autres écrans
├── customsync-env/              # Environnement virtuel Python (ignoré par git)
├── test-qml.sh                  # Script pour tester des fichiers QML individuels
├── README.md                    # Ce fichier
├── DESIGN_SYSTEM.md             # Documentation du système de design
└── .gitignore                   # Configuration git
```

## Prérequis

- Python 3.10+
- pip
- Bibliothèques de développement Qt

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
   pip install PySide6
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

## Documentation

Pour les détails sur le système de design et les tokens, consultez [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md).

## Contribution

Pour contribuer au projet :

1. Consultez d'abord la documentation du système de design pour comprendre les principes fondamentaux
2. Assurez-vous que vos composants utilisent les tokens du système de design pour maintenir la cohérence visuelle
3. Testez vos modifications avec le script `test-qml.sh` avant de les intégrer
4. Suivez les conventions de nommage existantes :
   - Composants CustomSync : préfixe `CS` (ex: `CSButton.qml`)
   - Noms de fichiers : PascalCase
   - Propriétés et fonctions : camelCase
