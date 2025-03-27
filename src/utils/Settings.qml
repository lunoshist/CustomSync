// src/utils/Settings.qml
// Composant pour stocker les préférences persistantes dans Qt 6

pragma Singleton
import QtQuick 6.5
import QtCore 6.5

/**
 * Service de gestion des préférences persistantes
 * Permet de stocker et récupérer des paramètres entre les sessions
 */
QtObject {
    id: root
    
    /**
     * Propriété pour stocker les paramètres globaux de l'application
     * @private
     */
    property var settingsData: ({})
    
    /**
     * Composant persistant pour le stockage
     * @private
     */
    property Settings _internalSettings: Settings {
        category: "CustomSync"
        property string dataJson: "{}"
    }
    
    /**
     * Version du format de données, pour migrations futures
     * @private
     */
    readonly property int _dataVersion: 1
    
    /**
     * Fonction pour charger les données depuis le stockage
     * @private
     */
    function _loadData() {
        try {
            if (_internalSettings.dataJson && _internalSettings.dataJson !== "{}") {
                const parsed = JSON.parse(_internalSettings.dataJson);
                
                // Vérifier la version pour migrations futures
                if (!parsed._version || parsed._version < _dataVersion) {
                    // Migration possible ici
                    parsed._version = _dataVersion;
                }
                
                settingsData = parsed;
            } else {
                // Initialiser avec un objet vide incluant la version
                settingsData = { _version: _dataVersion };
            }
        } catch (e) {
            console.error("Settings._loadData: Erreur lors du chargement des données:", e);
            // En cas d'erreur, initialiser avec des données vides
            settingsData = { _version: _dataVersion };
            
            // Tenter de sauvegarder le nouvel état pour "réparer" les données
            try {
                _saveData();
            } catch (saveErr) {
                console.error("Settings._loadData: Impossible de réparer les données:", saveErr);
            }
        }
    }
    
    /**
     * Fonction pour sauvegarder les données
     * @private
     */
    function _saveData() {
        try {
            // S'assurer que la version est incluse
            if (!settingsData._version) {
                settingsData._version = _dataVersion;
            }
            
            _internalSettings.dataJson = JSON.stringify(settingsData);
        } catch (e) {
            console.error("Settings._saveData: Erreur lors de la sauvegarde des données:", e);
        }
    }
    
    // Initialiser les paramètres au chargement
    Component.onCompleted: {
        _loadData();
    }
    
    /**
     * Fonction pour définir une valeur
     * @param {string} key - Clé identifiant la valeur
     * @param {any} value - Valeur à stocker
     * @param {string} [category="default"] - Catégorie optionnelle
     * @return {boolean} - Vrai si l'opération a réussi
     */
    function setValue(key, value, category) {
        if (!key || typeof key !== "string") {
            console.warn("Settings.setValue: Clé invalide", key);
            return false;
        }
        
        try {
            // Utiliser une catégorie par défaut si non spécifiée
            category = category || "default";
            
            // S'assurer que la catégorie existe
            if (!settingsData[category]) {
                settingsData[category] = {};
            }
            
            // Stocker la valeur
            settingsData[category][key] = value;
            
            // Sauvegarder les changements
            _saveData();
            return true;
        } catch (e) {
            console.error("Settings.setValue: Erreur lors de la définition de la valeur", e);
            return false;
        }
    }
    
    /**
     * Fonction pour obtenir une valeur
     * @param {string} key - Clé identifiant la valeur
     * @param {any} defaultValue - Valeur par défaut si la clé n'existe pas
     * @param {string} [category="default"] - Catégorie optionnelle
     * @return {any} - La valeur stockée ou la valeur par défaut
     */
    function getValue(key, defaultValue, category) {
        if (!key || typeof key !== "string") {
            console.warn("Settings.getValue: Clé invalide", key);
            return defaultValue;
        }
        
        try {
            // Utiliser une catégorie par défaut si non spécifiée
            category = category || "default";
            
            // Vérifier si la catégorie et la clé existent
            if (settingsData[category] && settingsData[category].hasOwnProperty(key)) {
                return settingsData[category][key];
            }
        } catch (e) {
            console.error("Settings.getValue: Erreur lors de la récupération de la valeur", e);
        }
        
        // Retourner la valeur par défaut
        return defaultValue;
    }
    
    /**
     * Fonction pour vérifier si une clé existe
     * @param {string} key - Clé à vérifier
     * @param {string} [category="default"] - Catégorie optionnelle
     * @return {bool} - true si la clé existe, false sinon
     */
    function hasKey(key, category) {
        if (!key || typeof key !== "string") {
            return false;
        }
        
        try {
            // Utiliser une catégorie par défaut si non spécifiée
            category = category || "default";
            
            // Vérifier si la catégorie et la clé existent
            return (settingsData[category] && settingsData[category].hasOwnProperty(key));
        } catch (e) {
            console.error("Settings.hasKey: Erreur lors de la vérification de la clé", e);
            return false;
        }
    }
    
    /**
     * Fonction pour supprimer une clé
     * @param {string} key - Clé à supprimer
     * @param {string} [category="default"] - Catégorie optionnelle
     * @return {bool} - true si l'opération a réussi
     */
    function removeKey(key, category) {
        if (!key || typeof key !== "string") {
            console.warn("Settings.removeKey: Clé invalide", key);
            return false;
        }
        
        try {
            // Utiliser une catégorie par défaut si non spécifiée
            category = category || "default";
            
            // Vérifier si la catégorie existe
            if (settingsData[category] && settingsData[category].hasOwnProperty(key)) {
                // Supprimer la clé
                delete settingsData[category][key];
                
                // Sauvegarder les changements
                _saveData();
                return true;
            }
        } catch (e) {
            console.error("Settings.removeKey: Erreur lors de la suppression de la clé", e);
        }
        
        return false;
    }
    
    /**
     * Fonction pour effacer tous les paramètres d'une catégorie
     * @param {string} [category] - Catégorie optionnelle
     * @return {bool} - true si l'opération a réussi
     */
    function clear(category) {
        try {
            if (category) {
                // Effacer uniquement la catégorie spécifiée
                delete settingsData[category];
            } else {
                // Effacer toutes les données sauf la version
                const version = settingsData._version || _dataVersion;
                settingsData = { _version: version };
            }
            
            // Sauvegarder les changements
            _saveData();
            return true;
        } catch (e) {
            console.error("Settings.clear: Erreur lors de l'effacement des paramètres", e);
            return false;
        }
    }
    
    /**
     * Fonction pour obtenir toutes les données d'une catégorie
     * @param {string} [category="default"] - Catégorie optionnelle
     * @return {Object} - Objet contenant toutes les données de la catégorie
     */
    function getCategoryData(category) {
        try {
            // Utiliser une catégorie par défaut si non spécifiée
            category = category || "default";
            
            // Retourner les données de la catégorie ou un objet vide
            return settingsData[category] ? JSON.parse(JSON.stringify(settingsData[category])) : {};
        } catch (e) {
            console.error("Settings.getCategoryData: Erreur lors de la récupération des données", e);
            return {};
        }
    }
    
    /**
     * Fonction pour définir toutes les données d'une catégorie
     * @param {Object} data - Données à stocker
     * @param {string} [category="default"] - Catégorie optionnelle
     * @return {bool} - true si l'opération a réussi
     */
    function setCategoryData(data, category) {
        if (!data || typeof data !== "object") {
            console.warn("Settings.setCategoryData: Données invalides", data);
            return false;
        }
        
        try {
            // Utiliser une catégorie par défaut si non spécifiée
            category = category || "default";
            
            // Stocker les données (copie pour éviter les références partagées)
            settingsData[category] = JSON.parse(JSON.stringify(data));
            
            // Sauvegarder les changements
            _saveData();
            return true;
        } catch (e) {
            console.error("Settings.setCategoryData: Erreur lors de la définition des données", e);
            return false;
        }
    }
    
    /**
     * Fonction pour obtenir la liste des catégories
     * @return {Array} - Liste des catégories
     */
    function getCategories() {
        try {
            // Filtrer les clés spéciales comme _version
            return Object.keys(settingsData).filter(key => !key.startsWith('_'));
        } catch (e) {
            console.error("Settings.getCategories: Erreur lors de la récupération des catégories", e);
            return [];
        }
    }
    
    /**
     * Exporte toutes les données sous forme de chaîne JSON
     * Utile pour la sauvegarde des préférences
     * @return {string} - Données au format JSON
     */
    function exportData() {
        try {
            return JSON.stringify(settingsData);
        } catch (e) {
            console.error("Settings.exportData: Erreur lors de l'exportation des données", e);
            return "{}";
        }
    }
    
    /**
     * Importe des données à partir d'une chaîne JSON
     * Utile pour la restauration des préférences
     * @param {string} jsonData - Données au format JSON
     * @return {bool} - true si l'importation a réussi
     */
    function importData(jsonData) {
        if (!jsonData) {
            console.warn("Settings.importData: Données JSON vides");
            return false;
        }
        
        try {
            const data = JSON.parse(jsonData);
            
            // Vérifier que c'est un objet
            if (typeof data !== "object") {
                console.warn("Settings.importData: Les données ne sont pas un objet");
                return false;
            }
            
            // Préserver la version actuelle ou utiliser celle des données importées
            const version = Math.max(data._version || 0, _dataVersion);
            
            // Fusionner les données
            settingsData = data;
            settingsData._version = version;
            
            // Sauvegarder les changements
            _saveData();
            return true;
        } catch (e) {
            console.error("Settings.importData: Erreur lors de l'importation des données", e);
            return false;
        }
    }
}