# Documentation/systeme-design.md

# Système de Design: CustomSync

## Principes fondamentaux

Notre système de design s'articule autour de quatre principes clés:

1. **Élégance fonctionnelle**: Chaque élément sert un objectif clair tout en contribuant à une expérience visuellement harmonieuse.
2. **Respiration équilibrée**: Utilisation judicieuse des espaces vides pour créer un rythme visuel, sans excès ni insuffisance.
3. **Hiérarchie intuitive**: Guider le regard et l'attention de l'utilisateur grâce à des points d'accent stratégiques.
4. **Cohérence subtile**: Maintenir une unité visuelle qui renforce l'identité de l'application sans devenir monotone.

## Fondation visuelle

### Palette de couleurs

Une palette équilibrée avec des accents distinctifs pour une expérience desktop moderne et élégante.

#### Mode clair
**Base:**
- **Fond principal**: #FFFFFF - Blanc pur pour la surface principale
- **Fond secondaire**: #F5F5F7 - Gris très léger inspiration Apple pour les zones secondaires
- **Fond tertiaire**: #EAEAEC - Gris léger pour les éléments interactifs au repos

**Nuances de gris:**
- **Texte principal**: #202020 - Presque noir pour une lisibilité optimale
- **Texte secondaire**: #5E5E5E - Gris moyen pour les informations complémentaires
- **Texte tertiaire**: #8E8E93 - Gris clair pour les éléments moins importants
- **Séparateurs**: #D1D1D6 - Gris clair subtil pour les délimitations

**Accent:**
- **Aubergine**: #772953 - Couleur d'accent principale inspirée d'Ubuntu mais plus sophistiquée
- **Aubergine claire**: #9A3D6E - Pour les états hover et les variations plus légères
- **Aubergine sombre**: #5A1F3F - Pour les états actifs et les variations plus profondes

**États fonctionnels:**
- **Succès**: #2D9D78 - Vert équilibré, ni trop vif ni trop pastel
- **Erreur**: #D64541 - Rouge distinctif mais pas agressif
- **Avertissement**: #E9B949 - Jaune ambre, chaleureux et attentionnel

#### Mode sombre
**Base:**
- **Fond principal**: #1E1E1E - Gris foncé sophistiqué
- **Fond secondaire**: #252528 - Légèrement plus clair pour différenciation
- **Fond tertiaire**: #2D2D30 - Pour les éléments interactifs et cartes

**Nuances de gris:**
- **Texte principal**: #F0F0F0 - Blanc légèrement atténué
- **Texte secondaire**: #B8B8B8 - Gris clair pour hiérarchie visuelle
- **Texte tertiaire**: #757575 - Gris moyen pour les éléments tertiaires
- **Séparateurs**: #3D3D3D - Gris foncé pour les délimitations subtiles

**Accent:**
- **Aubergine claire**: #9A3D6E - Adapté pour meilleur contraste en mode sombre
- **Aubergine plus claire**: #AF5585 - Pour hover/active en mode sombre

### Typographie

Une typographie claire qui privilégie la lisibilité et la cohérence avec l'écosystème Ubuntu.

**Police principale**: Ubuntu - Identité cohérente avec l'écosystème tout en restant neutre
- **Titres (h1)**: Ubuntu Light, 24px/32px, espacement des lettres -0.2px
- **Sous-titres (h2)**: Ubuntu Regular, 20px/28px
- **Titres de section (h3)**: Ubuntu Medium, 16px/24px
- **En-têtes (h4)**: Ubuntu Medium, 14px/20px
- **Corps de texte**: Ubuntu Regular, 14px/20px
- **Texte secondaire**: Ubuntu Light, 13px/18px
- **Petits textes**: Ubuntu Light, 12px/16px

**Hiérarchie typographique**:
- Espacement proportionnel entre paragraphes (min 20px)
- Utilisation stratégique du poids de police pour créer une hiérarchie
- Alignement à gauche privilégié pour la lisibilité

### Grille et espacements

Un système d'espacement équilibré qui crée un rythme visuel agréable:

**Unité de base**: 8px
- **Espacement xs**: 4px
- **Espacement s**: 8px
- **Espacement m**: 16px
- **Espacement l**: 24px
- **Espacement xl**: 32px
- **Espacement xxl**: 48px

**Espacement vertical entre sections**: 32px pour créer une séparation claire sans exagération.

**Marges latérales**: 24px sur mobile, 32px sur desktop avec une largeur maximale de contenu pour éviter l'étirement excessif sur grands écrans.

**Grille**:
- Système de 12 colonnes avec gouttières de 16px
- Utilisation de grilles flexibles adaptées au contexte

### Élévation et ombres

Une approche subtile mais perceptible pour créer une hiérarchie spatiale:

**Niveaux d'élévation**:
1. **Surface de base**: Pas d'ombre, fond principal
2. **Élévation basse**: Composants interactifs, ombre box-shadow: 0 1px 3px rgba(0,0,0,0.08)
3. **Élévation moyenne**: Cartes et éléments flottants, box-shadow: 0 3px 6px rgba(0,0,0,0.1)
4. **Élévation haute**: Modaux et popups, box-shadow: 0 8px 16px rgba(0,0,0,0.12)

### Coins et bordures

Des coins légèrement arrondis pour un style contemporain mais pas trop décontracté:

- **Arrondi xs**: 2px - Pour les éléments petits (badges, tags)
- **Arrondi s**: 4px - Pour les boutons et champs
- **Arrondi m**: 6px - Pour les cartes et conteneurs
- **Arrondi l**: 8px - Pour les dialogues et grands conteneurs

**Bordures**:
- Fines (1px) avec couleur subtile (#D1D1D6)
- Utilisées stratégiquement pour définir des espaces sans surcharger visuellement

## Composants

### Boutons

**Bouton primaire**:
- Fond: #772953 (aubergine)
- Texte: #FFFFFF
- Padding: 8px 16px
- Hauteur: 36px
- Coins arrondis: 4px
- États:
  - Hover: #9A3D6E
  - Active: #5A1F3F
  - Focus: Contour 2px #9A3D6E avec opacité 30%
  - Désactivé: Opacité 50%

**Bouton secondaire**:
- Contour: 1px solid #D1D1D6
- Fond: #F5F5F7
- Texte: #202020
- Mêmes dimensions que le bouton primaire
- États:
  - Hover: Fond #EAEAEC
  - Active: Fond #D1D1D6
  - Focus: Contour 2px #772953 avec opacité 30%
  - Désactivé: Opacité 50%

**Bouton tertiaire**:
- Texte: #772953
- Fond: Transparent
- Pas de bordure
- Mêmes dimensions que les autres boutons
- États:
  - Hover: Fond #F5F5F7
  - Active: Fond #EAEAEC
  - Focus: Contour 2px #772953 avec opacité 30%

**Bouton discret**:
- Texte: #5E5E5E
- Fond: Transparent
- Padding réduit: 4px 8px
- États:
  - Hover: Texte #202020, fond #F5F5F7
  - Active: Fond #EAEAEC

### Champs de saisie

**Champ standard**:
- Hauteur: 36px
- Bordure: 1px solid #D1D1D6
- Coins arrondis: 4px
- Padding horizontal: 12px
- Typographie: Ubuntu Regular, 14px
- Étiquette: Au-dessus du champ, Ubuntu Regular 13px, #5E5E5E
- États:
  - Focus: Bordure 1px #772953, légère ombre intérieure
  - Erreur: Bordure 1px #D64541
  - Désactivé: Fond #F5F5F7, texte #8E8E93

**Zone de texte**:
- Hauteur adaptative (min 80px)
- Autres propriétés identiques au champ standard

**Sélecteur**:
- Apparence similaire au champ standard
- Icône chevron distincte (8px)
- Menu déroulant avec élévation niveau 2

### Cartes et conteneurs

**Carte standard**:
- Fond: #FFFFFF
- Coins arrondis: 6px
- Padding: 16px
- Élévation: Niveau 2 (box-shadow: 0 3px 6px rgba(0,0,0,0.1))
- Bordure: Optionnelle, 1px solid #D1D1D6
- Transition sur hover: Élévation augmentée subtilement

**Groupe de contenus**:
- Fond: #F5F5F7
- Coins arrondis: 6px
- Padding: 16px
- Sans élévation
- En-tête: Titre de section en Ubuntu Medium 16px
- Séparation interne par espacement (16px) plutôt que par bordures

**Panneau latéral**:
- Fond: #F5F5F7
- Bordure latérale: 1px solid #D1D1D6
- Largeur: 240-300px selon contexte
- Padding: 16px
- Navigation interne avec espacement vertical de 8px

### Navigation

**Barre de navigation principale**:
- Fond: #FFFFFF
- Hauteur: 56px
- Bordure inférieure: 1px solid #D1D1D6
- Élévation: Niveau 1 (subtile)
- Logo: À gauche, dimensions contrôlées
- Actions principales: Alignées à droite
- Espacement horizontal entre éléments: 16px

**Navigation par étapes**:
- Design discret mais perceptible
- Ligne horizontale fine (1px) #D1D1D6
- Points d'étape: 6px de diamètre
- Étape active: Point 6px #772953
- Étape complétée: Point 6px #2D9D78 
- Étape inactive: Point 6px #D1D1D6
- Texte d'étape: Petit et discret, Ubuntu Light 12px
- Position: En haut sous le titre, centré horizontalement

**Tabs**:
- Texte actif: #202020, Medium
- Texte inactif: #5E5E5E, Regular
- Indicateur actif: Ligne 2px #772953 en dessous du texte
- Espacement: 24px entre onglets
- Séparateur inférieur global: 1px #D1D1D6

### Listes et tableaux

**Liste standard**:
- Hauteur d'élément: 48px
- Padding horizontal: 16px
- Fond au repos: Transparent
- Séparateur: 1px solid #D1D1D6 (optionnel selon densité)
- États:
  - Hover: Fond #F5F5F7
  - Sélectionné: Fond #F5F5F7, bordure gauche 3px #772953

**Liste de sélection**:
- Élément avec icône ou case à cocher à gauche
- Texte principal aligné à gauche
- Description en texte secondaire en dessous ou alignée à droite
- Espacement vertical: 12px entre éléments

**Tableau de données**:
- En-tête: Fond #F5F5F7, texte #5E5E5E, Medium
- Lignes: Alternance subtile (blanc/#F9F9FB) pour faciliter la lecture
- Bordures horizontales: 1px solid #D1D1D6
- Padding cellule: 12px 16px
- Hover sur ligne: Fond #F5F5F7

### Composants spécifiques

**Carte d'inventaire**:
- Fond: #FFFFFF
- Coins arrondis: 6px
- Padding: 20px
- Élévation: Niveau 2
- En-tête: Titre + métadonnées + actions alignées à droite
- Corps: Contenu principal avec statistiques visuelles
- Pied: Actions secondaires discrètes alignées à droite
- États:
  - Hover: Élévation légèrement augmentée
  - Sélectionné: Bordure gauche 3px #772953

**Indicateur de progression**:
- Barre linéaire: Hauteur 4px, fond #EAEAEC
- Progression: Dégradé de #772953 à #9A3D6E
- Animation: Transition fluide 300ms
- Indication textuelle: Pourcentage à droite, Ubuntu Regular 14px

**Contrôles de sélection**:
- Case non cochée: Contour 1.5px #8E8E93, fond transparent, coins arrondis 2px
- Case cochée: Fond #772953, icône de coche blanche
- Radio non sélectionné: Cercle 16px, contour 1.5px #8E8E93
- Radio sélectionné: Cercle extérieur #772953, cercle intérieur blanc
- Texte: À droite, aligné avec le centre du contrôle

**Badges et étiquettes**:
- Fond: #F5F5F7 pour neutre, ou version très claire de la couleur sémantique
- Texte: Couleur sémantique ou #5E5E5E pour neutre
- Padding: 4px 8px
- Coins arrondis: 2px
- Taille: Compacte, Ubuntu Regular 12px

## Micro-interactions et animations

Des interactions mesurées qui améliorent l'expérience sans distraire:

- **Transitions générales**: Courbes d'accélération naturelles, 200ms
- **Hover sur cartes**: Légère élévation (+1px d'ombre) et très subtile scaling (1.01)
- **Focus**: Apparition progressive de contour (150ms)
- **Expansion/réduction**: Animation de hauteur fluide (200ms)
- **Chargement**: Indicateurs sobres, barres de progression avec animation fluide
- **Feedback**: Animation subtile de confirmation pour les actions réussies

## Iconographie

Système d'icônes cohérent et fonctionnel:

- **Style**: Ligne moyenne (1.5-2px), légèrement arrondie pour adoucir
- **Taille**: 20px standard pour interface desktop
- **Couleur**: Adaptée au contexte (primaire ou secondaire selon importance)
- **Remplissage**: Principalement en contour, remplissage réservé aux états actifs ou éléments importants
- **Animation**: Transitions subtiles pour les changements d'état

## Principes de mise en page

### Utilisation des espaces

- **Respiration stratégique**: Plus d'espace autour des éléments importants
- **Densité adaptative**: Plus dense pour les listes de données, plus aéré pour les zones de focus
- **Marge de protection**: Espacement cohérent entre sections (32px) pour créer une structure sans surcharge
- **Alignements rigoureux**: Grille verticale et horizontale stricte pour une impression d'ordre

### Hiérarchie d'information

- **Position stratégique**: Éléments importants en haut et à gauche
- **Emphase visuelle**: Utilisation de la couleur d'accent, taille et poids typographique pour les éléments clés
- **Zones délimitées**: Regroupements logiques créés par la proximité et délimités subtilement
- **Points de focus**: Un élément principal par écran ou section pour guider l'attention

## Principes d'accessibilité

- **Contraste**: Ratio minimum de 4.5:1 pour le texte principal
- **Taille des touches**: Minimum 36px pour les éléments interactifs
- **Redondance des indications**: Pas uniquement basées sur la couleur
- **Adaptabilité**: Interface réactive aux changements de taille de texte
- **Mode sombre**: Implémenté avec soin pour réduire la fatigue visuelle

## Adaptation aux capacités GTK/Qt

Pour assurer une implémentation technique fluide sur desktop:

- **Widgets natifs**: Utilisation des composants natifs GTK/Qt avec personnalisation visuelle
- **CSS adapté**: Styles compatibles avec les capacités de thèmes GTK
- **Variables de couleur**: Utilisation du système de variables pour faciliter les thèmes
- **Densité desktop**: Interface optimisée pour interaction souris/clavier
- **Cohérence systèmes**: Respect des conventions de l'environnement desktop

## Guide d'implémentation technique

### Variables CSS

```css
:root {
  /* Couleurs principales */
  --color-background: #FFFFFF;
  --color-background-alt: #F5F5F7;
  --color-background-tertiary: #EAEAEC;
  
  /* Texte */
  --color-text-primary: #202020;
  --color-text-secondary: #5E5E5E;
  --color-text-tertiary: #8E8E93;
  
  /* Accent */
  --color-accent: #772953;
  --color-accent-light: #9A3D6E;
  --color-accent-dark: #5A1F3F;
  
  /* États */
  --color-success: #2D9D78;
  --color-error: #D64541;
  --color-warning: #E9B949;
  
  /* Bordures et séparateurs */
  --color-border: #D1D1D6;
  
  /* Espacements */
  --space-xs: 4px;
  --space-s: 8px;
  --space-m: 16px;
  --space-l: 24px;
  --space-xl: 32px;
  --space-xxl: 48px;
  
  /* Éléments arrondis */
  --radius-xs: 2px;
  --radius-s: 4px;
  --radius-m: 6px;
  --radius-l: 8px;
  
  /* Animations */
  --transition-fast: 150ms ease-out;
  --transition-standard: 200ms ease-out;
  --transition-emphasis: 300ms cubic-bezier(0.4, 0, 0.2, 1);

  /* Élévation */
  --shadow-low: 0 1px 3px rgba(0,0,0,0.08);
  --shadow-medium: 0 3px 6px rgba(0,0,0,0.1);
  --shadow-high: 0 8px 16px rgba(0,0,0,0.12);
}

/* Mode sombre */
@media (prefers-color-scheme: dark) {
  :root {
    --color-background: #1E1E1E;
    --color-background-alt: #252528;
    --color-background-tertiary: #2D2D30;
    
    --color-text-primary: #F0F0F0;
    --color-text-secondary: #B8B8B8;
    --color-text-tertiary: #757575;
    
    --color-border: #3D3D3D;
    
    --color-accent: #9A3D6E;
    --color-accent-light: #AF5585;
    --color-accent-dark: #772953;
    
    --shadow-low: 0 1px 3px rgba(0,0,0,0.2);
    --shadow-medium: 0 3px 6px rgba(0,0,0,0.24);
    --shadow-high: 0 8px 16px rgba(0,0,0,0.3);
  }
}
```

## Applications visuelles

### Écran d'accueil

L'écran d'accueil utilise une mise en page claire qui reflète les actions principales:

- En-tête avec titre de l'application en grand (Ubuntu Light, 28px)
- Section de bienvenue avec statistiques système principales sous forme de grandes cartes
- Grille d'inventaires récents avec élévation subtile et espacement généreux
- Action flottante "+" en bas à droite pour la création rapide
- Navigation principale persistante avec icônes distinctives

### Écran d'explorateur d'inventaires

L'interface d'exploration est organisée pour une navigation efficace:

- Panneau latéral pour filtres et catégories avec fond #F5F5F7
- Liste d'inventaires au centre avec cartes à élévation subtile
- Panneau de prévisualisation à droite pour l'élément sélectionné
- Barre d'outils discrète avec actions contextuelles
- Utilisation de la couleur d'accent pour l'élément sélectionné

### Wizard d'assistant de scan

Une approche par étapes claires et visuellement apaisantes:

- Indicateur de progression discret mais visible en haut
- Une question ou tâche principale par écran
- Options ou sélections présentées avec espacement généreux
- Actions principales (Suivant/Précédent) clairement positionnées
- Feedback visuel immédiat pour les sélections

## Conclusion

Ce système de design crée une expérience utilisateur desktop élégante et fonctionnelle qui trouve l'équilibre entre minimalisme et personnalité. En s'inspirant subtilement des designs d'Ubuntu et Apple, nous obtenons une interface qui:

- Reste simple et épurée sans paraître vide
- Offre des points d'accent visuels qui guident l'attention
- Crée une structure claire sans surcharger l'interface
- Maintient une cohérence qui renforce l'identité de l'application
- S'adapte naturellement à un environnement desktop Linux

L'approche équilibrée permet de créer une application qui respire tout en conservant un caractère distinctif et une structure claire qui guide l'utilisateur naturellement à travers les différentes fonctionnalités.
