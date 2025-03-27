# Documentation/Module-Setting.md

# Module Utils.Settings - Documentation

## Vue d'ensemble

Le module `Utils.Settings` est un service robuste qui gère la persistance des préférences utilisateur entre les sessions. Il utilise une approche basée sur JSON avec versionnement pour stocker de manière fiable et flexible toutes les préférences de l'application.

## Emplacement

Le module Settings est situé dans :

```
src/utils/Settings.qml
```

## Architecture

Le module utilise une architecture par sérialisation JSON où :

1. Toutes les données sont organisées dans un objet JavaScript structuré par catégories
2. Les données incluent un numéro de version pour faciliter les futures migrations
3. Les données sont sérialisées en JSON et stockées dans une propriété unique du composant QML Settings
4. Les opérations de lecture/écriture se font sur l'objet en mémoire, avec validation et gestion d'erreurs
5. Les modifications sont sauvegardées immédiatement pour éviter les pertes de données

Cette approche évite les problèmes de propriétés dynamiques en QML et offre une grande flexibilité.

## Fonctionnalités

- Organisation des préférences par catégories
- Stockage de valeurs de n'importe quel type compatible JSON
- Persistance entre les sessions de l'application
- Validation des entrées et gestion robuste des erreurs
- Versionnement des données pour faciliter les migrations futures
- API simple et cohérente
- Robustesse face aux erreurs de désérialisation
- Manipulation groupée des paramètres par catégorie
- Fonctions d'exportation et d'importation pour la sauvegarde/restauration

## Import et utilisation

### Importation du module

```qml
import "../utils" as Utils
```

Ajustez le chemin selon la structure de votre projet.

### Utilisation basique

```qml
// Stocker une valeur avec une catégorie
Utils.Settings.setValue("fontSize", 14, "UI");

// Récupérer une valeur avec valeur par défaut
var fontSize = Utils.Settings.getValue("fontSize", 12, "UI");

// Vérifier l'existence d'une clé
if (Utils.Settings.hasKey("userPreference", "Profile")) {
    // La clé existe
}

// Supprimer une clé
Utils.Settings.removeKey("temporaryData", "Cache");

// Effacer tous les paramètres d'une catégorie
Utils.Settings.clear("Cache");
```

## Structure des données

Les données sont organisées hiérarchiquement par catégories, avec une métadonnée de version :

```javascript
{
  "_version": 1,  // Version du format de données pour migrations futures
  "Theme": {
    "isDarkTheme": false,
    "followSystemTheme": true
  },
  "UI": {
    "fontSize": 14,
    "compactMode": false
  },
  "Profile": {
    "username": "User",
    "email": "user@example.com"
  }
}
```

## Catégories de paramètres recommandées

Pour organiser efficacement les paramètres de l'application, il est recommandé d'utiliser des catégories distinctes :

| Catégorie     | Description                   | Exemples de paramètres                  |
| ------------- | ----------------------------- | --------------------------------------- |
| `Theme`       | Paramètres liés à l'apparence | Mode sombre, suivre le système          |
| `Application` | Paramètres généraux           | Langue, comportement par défaut         |
| `Files`       | Gestion des fichiers          | Dossier par défaut, fichiers récents    |
| `Backup`      | Paramètres de sauvegarde      | Fréquence, cibles, exclusions           |
| `UI`          | Interface utilisateur         | Taille des polices, densité d'affichage |
| `Profile`     | Informations utilisateur      | Nom, préférences personnelles           |

## API détaillée

### Méthodes de base

#### `setValue(key, value, category)`

Stocke une valeur dans les paramètres persistants.

**Paramètres:**
- `key` (string): Clé identifiant la valeur
- `value` (any): Valeur à stocker (tout type supporté par JSON)
- `category` (string, optionnel): Catégorie pour organiser les paramètres (défaut: "default")

**Retourne:** `true` si l'opération a réussi, `false` sinon

**Exemple:**
```qml
Utils.Settings.setValue("fontSize", 14, "UI");
Utils.Settings.setValue("isDarkTheme", true, "Theme");
Utils.Settings.setValue("recentFiles", ["file1.txt", "file2.txt"], "Files");
```

#### `getValue(key, defaultValue, category)`

Récupère une valeur des paramètres persistants.

**Paramètres:**
- `key` (string): Clé identifiant la valeur
- `defaultValue` (any): Valeur à retourner si la clé n'existe pas
- `category` (string, optionnel): Catégorie de la valeur (défaut: "default")

**Retourne:** La valeur stockée ou la valeur par défaut

**Exemple:**
```qml
var fontSize = Utils.Settings.getValue("fontSize", 12, "UI");
var isDark = Utils.Settings.getValue("isDarkTheme", false, "Theme");
var files = Utils.Settings.getValue("recentFiles", [], "Files");
```

#### `hasKey(key, category)`

Vérifie si une clé existe dans les paramètres.

**Paramètres:**
- `key` (string): Clé à vérifier
- `category` (string, optionnel): Catégorie à vérifier (défaut: "default")

**Retourne:** `true` si la clé existe, `false` sinon

**Exemple:**
```qml
if (Utils.Settings.hasKey("customSetting", "Profile")) {
    console.log("La personnalisation existe");
}
```

#### `removeKey(key, category)`

Supprime une clé des paramètres.

**Paramètres:**
- `key` (string): Clé à supprimer
- `category` (string, optionnel): Catégorie de la clé (défaut: "default")

**Retourne:** `true` si la clé a été supprimée, `false` sinon

**Exemple:**
```qml
Utils.Settings.removeKey("temporaryData", "Cache");
```

#### `clear(category)`

Efface tous les paramètres d'une catégorie ou toutes les catégories si aucune n'est spécifiée. Préserve la version des données.

**Paramètres:**
- `category` (string, optionnel): Catégorie à effacer. Si non spécifié, efface toutes les catégories.

**Retourne:** `true` si l'opération a réussi, `false` sinon

**Exemple:**
```qml
// Effacer uniquement la catégorie "Cache"
Utils.Settings.clear("Cache");

// Effacer toutes les données
Utils.Settings.clear();
```

### Méthodes avancées

#### `getCategoryData(category)`

Récupère toutes les données d'une catégorie. Retourne une copie des données pour éviter les modifications accidentelles.

**Paramètres:**
- `category` (string, optionnel): Catégorie à récupérer (défaut: "default")

**Retourne:** Un objet contenant toutes les données de la catégorie

**Exemple:**
```qml
var themeSettings = Utils.Settings.getCategoryData("Theme");
console.log("Mode sombre:", themeSettings.isDarkTheme);
console.log("Suivi système:", themeSettings.followSystemTheme);
```

#### `setCategoryData(data, category)`

Définit toutes les données d'une catégorie en une seule opération. Les données sont clonées pour éviter les références partagées.

**Paramètres:**
- `data` (Object): Objet contenant les données à stocker
- `category` (string, optionnel): Catégorie où stocker les données (défaut: "default")

**Retourne:** `true` si l'opération a réussi, `false` sinon

**Exemple:**
```qml
Utils.Settings.setCategoryData({
    fontSize: 14,
    compactMode: true,
    colorScheme: "light"
}, "UI");
```

#### `getCategories()`

Récupère la liste de toutes les catégories disponibles, en excluant les métadonnées internes.

**Retourne:** Un tableau contenant les noms des catégories

**Exemple:**
```qml
var categories = Utils.Settings.getCategories();
console.log("Catégories disponibles:", categories.join(", "));
```

### Nouvelles méthodes (version améliorée)

#### `exportData()`

Exporte toutes les données sous forme de chaîne JSON. Utile pour la sauvegarde des préférences.

**Retourne:** Une chaîne JSON contenant toutes les données

**Exemple:**
```qml
var settingsBackup = Utils.Settings.exportData();
console.log("Données exportées:", settingsBackup);

// On peut stocker cette chaîne dans un fichier
saveToFile("settings_backup.json", settingsBackup);
```

#### `importData(jsonData)`

Importe des données à partir d'une chaîne JSON. Utile pour la restauration des préférences.

**Paramètres:**
- `jsonData` (string): Chaîne JSON contenant les données à importer

**Retourne:** `true` si l'importation a réussi, `false` sinon

**Exemple:**
```qml
var jsonData = loadFromFile("settings_backup.json");
var success = Utils.Settings.importData(jsonData);

if (success) {
    console.log("Paramètres restaurés avec succès");
} else {
    console.error("Erreur lors de la restauration des paramètres");
}
```

## Gestion des erreurs

Le module Settings a été amélioré avec une gestion robuste des erreurs :

1. **Validation des entrées** : Toutes les fonctions vérifient la validité des paramètres d'entrée
2. **Journalisation** : Les erreurs sont journalisées avec des messages explicites
3. **Valeurs de retour** : Les fonctions retournent des valeurs booléennes pour indiquer le succès/échec
4. **Blocs try/catch** : Toutes les opérations susceptibles d'échouer sont entourées de blocs try/catch
5. **Récupération automatique** : En cas de corruption des données, le système tente de les réinitialiser

Exemple de gestion d'erreur :

```qml
try {
    var result = Utils.Settings.setValue("complexObject", myObject, "App");
    if (!result) {
        console.warn("Échec de l'enregistrement des paramètres");
        // Fallback...
    }
} catch (e) {
    console.error("Exception lors de l'enregistrement des paramètres:", e);
    // Gestion de l'erreur...
}
```

## Versionnement des données

Le module implémente désormais un système de versionnement des données pour faciliter les migrations futures :

1. La propriété `_version` est ajoutée à la racine de l'objet de données
2. Lors du chargement, cette version est vérifiée
3. Si une ancienne version est détectée, une migration peut être effectuée
4. La structure actuelle est à la version 1

Ce mécanisme permet d'évoluer le format de données sans casser la compatibilité avec les versions précédentes.

## Intégration avec le module Theme

Le module `Theme` utilise `Utils.Settings` pour stocker les préférences de thème, avec une gestion robuste :

```qml
// Dans Theme.qml
Component.onCompleted: {
    // Charger les paramètres sauvegardés avec vérification d'existence
    if (Utils.Settings.hasKey("isDarkTheme", "Theme")) {
        root.isDarkTheme = Utils.Settings.getValue("isDarkTheme", false, "Theme");
    }
    
    if (Utils.Settings.hasKey("followSystemTheme", "Theme")) {
        root.followSystemTheme = Utils.Settings.getValue("followSystemTheme", true, "Theme");
    }
    
    // Initialiser les caches
    _colorCache = _createColorObject();
    _elevationCache = _createElevationObject();
}

// Sauvegarde des changements
onIsDarkThemeChanged: {
    Utils.Settings.setValue("isDarkTheme", isDarkTheme, "Theme");
    // ...
}

onFollowSystemThemeChanged: {
    Utils.Settings.setValue("followSystemTheme", followSystemTheme, "Theme");
}
```

## Patterns d'utilisation recommandés

### 1. Wrapper pour simplifier l'accès

```qml
// AppSettings.qml
import QtQuick 6.5
import "../utils" as Utils

QtObject {
    id: root
    
    // API simplifiée pour les paramètres UI
    readonly property int fontSize: Utils.Settings.getValue("fontSize", 14, "UI")
    readonly property bool compactMode: Utils.Settings.getValue("compactMode", false, "UI")
    
    // Fonctions de mise à jour
    function setFontSize(size) {
        return Utils.Settings.setValue("fontSize", size, "UI");
    }
    
    function setCompactMode(enabled) {
        return Utils.Settings.setValue("compactMode", enabled, "UI");
    }
    
    // Méthode pour réinitialiser une catégorie
    function resetUISettings() {
        if (Utils.Settings.clear("UI")) {
            // Notifier le changement
            fontSizeChanged();
            compactModeChanged();
            return true;
        }
        return false;
    }
}
```

### 2. Chargement et sauvegarde groupés

Pour les opérations avec de nombreux paramètres liés, il est plus efficace et plus sûr de charger et sauvegarder en bloc :

```qml
// Chargement groupé
Component.onCompleted: {
    var uiSettings = Utils.Settings.getCategoryData("UI");
    
    if (Object.keys(uiSettings).length > 0) {
        // Utiliser les valeurs stockées avec validation
        root.fontSize = typeof uiSettings.fontSize === 'number' ? uiSettings.fontSize : 14;
        root.compactMode = typeof uiSettings.compactMode === 'boolean' ? uiSettings.compactMode : false;
        root.sidebarWidth = typeof uiSettings.sidebarWidth === 'number' ? uiSettings.sidebarWidth : 240;
    } else {
        // Utiliser les valeurs par défaut
        root.fontSize = 14;
        root.compactMode = false;
        root.sidebarWidth = 240;
    }
}

// Sauvegarde groupée
function saveUISettings() {
    return Utils.Settings.setCategoryData({
        fontSize: root.fontSize,
        compactMode: root.compactMode,
        sidebarWidth: root.sidebarWidth
    }, "UI");
}
```

### 3. Sauvegarde/restauration complète des paramètres

Utiliser les nouvelles fonctions d'exportation/importation pour la gestion complète des paramètres :

```qml
// Fonction pour sauvegarder tous les paramètres dans un fichier
function backupSettings(filePath) {
    try {
        var settingsJson = Utils.Settings.exportData();
        // Code pour sauvegarder dans un fichier (dépendant de l'implémentation)
        saveToFile(filePath, settingsJson);
        return true;
    } catch (e) {
        console.error("Erreur lors de la sauvegarde des paramètres:", e);
        return false;
    }
}

// Fonction pour restaurer tous les paramètres depuis un fichier
function restoreSettings(filePath) {
    try {
        // Code pour charger depuis un fichier (dépendant de l'implémentation)
        var settingsJson = loadFromFile(filePath);
        if (Utils.Settings.importData(settingsJson)) {
            // Recharger l'interface après restauration
            refreshUI();
            return true;
        }
        return false;
    } catch (e) {
        console.error("Erreur lors de la restauration des paramètres:", e);
        return false;
    }
}
```

### 4. Gestion des erreurs proactive

```qml
function saveUserProfile(username, email) {
    try {
        if (!username || username.length < 2) {
            console.warn("Nom d'utilisateur invalide");
            return false;
        }
        
        // Valider l'email avec une expression régulière
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email || !emailRegex.test(email)) {
            console.warn("Adresse email invalide");
            return false;
        }
        
        // Sauvegarder les données validées
        var success = Utils.Settings.setCategoryData({
            username: username,
            email: email,
            lastUpdated: new Date().toISOString()
        }, "Profile");
        
        // Journaliser le résultat
        if (success) {
            console.log("Profil utilisateur sauvegardé avec succès");
        } else {
            console.warn("Échec de la sauvegarde du profil utilisateur");
        }
        
        return success;
    } catch (e) {
        console.error("Exception lors de la sauvegarde du profil:", e);
        return false;
    }
}
```

## Limites et considérations

1. **Types de données** : Seuls les types supportés par JSON peuvent être stockés (nombres, chaînes, booléens, tableaux, objets, null)
2. **Objets complexes** : Les objets avec des méthodes ou des références circulaires ne peuvent pas être sérialisés directement
3. **Taille des données** : Bien que théoriquement illimitée, il est recommandé de ne pas stocker de très grandes quantités de données pour des raisons de performance
4. **Catégories** : L'utilisation de catégories bien définies est fortement recommandée pour maintenir l'organisation des paramètres
5. **Gestion des versions** : La migration des données entre versions doit être soigneusement planifiée lorsque vous modifiez la structure des données

## Exemple complet d'un service de paramètres

```qml
// src/services/AppSettings.qml
import QtQuick 6.5
import "../utils" as Utils

Item {
    id: root
    
    // Propriétés et signaux
    signal settingsChanged(string category)
    
    // ===== Propriétés liées aux paramètres généraux =====
    
    readonly property string language: Utils.Settings.getValue("language", "fr", "General")
    readonly property bool firstRun: Utils.Settings.getValue("firstRun", true, "General")
    readonly property var recentFiles: Utils.Settings.getValue("recentFiles", [], "General")
    
    // ===== Propriétés liées à l'interface =====
    
    readonly property int fontSize: Utils.Settings.getValue("fontSize", 14, "UI")
    readonly property bool compactMode: Utils.Settings.getValue("compactMode", false, "UI")
    
    // ===== Propriétés liées à la sauvegarde =====
    
    readonly property bool autoBackup: Utils.Settings.getValue("autoBackup", true, "Backup")
    readonly property int backupInterval: Utils.Settings.getValue("backupInterval", 60, "Backup") // minutes
    readonly property string backupLocation: Utils.Settings.getValue("backupLocation", "", "Backup")
    
    // ===== Méthodes utilitaires =====
    
    // Ajouter un fichier à la liste des fichiers récents
    function addRecentFile(filePath) {
        if (!filePath) return false;
        
        try {
            // Éviter les doublons
            let files = recentFiles.filter(path => path !== filePath);
            
            // Ajouter au début
            files.unshift(filePath);
            
            // Limiter à 10 fichiers
            if (files.length > 10) {
                files = files.slice(0, 10);
            }
            
            // Sauvegarder et émettre le signal si réussi
            if (Utils.Settings.setValue("recentFiles", files, "General")) {
                // Déclencher manuellement le signal de changement
                root.recentFilesChanged();
                root.settingsChanged("General");
                return true;
            }
            return false;
        } catch (e) {
            console.error("Erreur lors de l'ajout du fichier récent:", e);
            return false;
        }
    }
    
    // Fonction pour mettre à jour les paramètres
    function updateSetting(key, value, category) {
        if (Utils.Settings.setValue(key, value, category)) {
            // Émettre un signal personnalisé
            root.settingsChanged(category);
            return true;
        }
        return false;
    }
    
    // Réinitialiser une catégorie de paramètres
    function resetUISettings() {
        if (Utils.Settings.clear("UI")) {
            // Déclencher les signaux de changement
            root.fontSizeChanged();
            root.compactModeChanged();
            root.settingsChanged("UI");
            return true;
        }
        return false;
    }
    
    // Réinitialiser tous les paramètres
    function resetAllSettings() {
        if (Utils.Settings.clear()) {
            // Déclencher les signaux de changement pour toutes les propriétés
            root.languageChanged();
            root.firstRunChanged();
            root.recentFilesChanged();
            root.fontSizeChanged();
            root.compactModeChanged();
            root.autoBackupChanged();
            root.backupIntervalChanged();
            root.backupLocationChanged();
            
            // Émettre un signal global
            root.settingsChanged("all");
            return true;
        }
        return false;
    }
    
    // Exporter les paramètres au format JSON
    function exportSettings() {
        return Utils.Settings.exportData();
    }
    
    // Importer les paramètres depuis un JSON
    function importSettings(jsonString) {
        if (Utils.Settings.importData(jsonString)) {
            // Déclencher les signaux de changement
            root.languageChanged();
            root.firstRunChanged();
            root.recentFilesChanged();
            root.fontSizeChanged();
            root.compactModeChanged();
            root.autoBackupChanged();
            root.backupIntervalChanged();
            root.backupLocationChanged();
            
            // Émettre un signal global
            root.settingsChanged("all");
            return true;
        }
        return false;
    }
    
    // Vérification du premier lancement
    Component.onCompleted: {
        // Si c'est le premier lancement, faire quelque chose
        if (firstRun) {
            console.log("Premier lancement de l'application, initialisation...");
            // Effectuer l'initialisation
            
            // Marquer comme non-premier lancement
            Utils.Settings.setValue("firstRun", false, "General");
        }
    }
}
```

## Conclusion

Le module `Utils.Settings` offre une solution robuste et flexible pour la gestion des paramètres persistants dans l'application. Les améliorations apportées (versionnement, validation, gestion d'erreurs, exportation/importation) en font un composant fiable pour toutes les fonctionnalités nécessitant une persistance entre les sessions.

En utilisant ce module de manière cohérente à travers l'application, vous pouvez facilement maintenir les préférences utilisateur entre les sessions et assurer une expérience personnalisée et cohérente.