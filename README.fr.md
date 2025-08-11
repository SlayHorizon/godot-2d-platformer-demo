# Démo de jeu de plateforme 2D (Godot 4.4+)

Une **démo open-source de jeu de plateforme 2D**, créée à l’origine comme **matériel pédagogique** pour un cours.  
Elle est maintenant disponible gratuitement pour être explorée, étudiée, modifié ou même transformée à votre guise.

![Capture d'écran](https://github.com/user-attachments/assets/c0ff6526-d402-4b85-a378-53434a0f8e15)

---

## Fonctionnalités et concepts abordés

### Joueur
- **Machine à états** simple via des **fonctions de rappel** (callbacks)
- Mécaniques du joueur: **double saut**, **glissade murale**, **saut mural**
- **Personnages personnalisés** définis via des fichiers de ressources Godot

### Systèmes de jeu
- **Objets à collecter**
- **Plateformes mobiles**
- **Caméra en grille**
- **HUD** : affichage du score + boutons pour **contrôle de la musique** et **redémarrage de niveau**
- **Lecteur de musique**
- **Shaders** : transitions de scène, textures défilantes

### Spécificités Godot
- Divers cas d’usage de **scripts `@tool`**
- **Plugin maison** pour placer facilement des objets à collecter (similaire à l’utilisation d’un TileMap)
- **Bus d’événements (Autoload EventsBus)** pour une gestion des événements centralisée

### Bonus
- **Build et déploiement automatisés** vers **itch.io** via **GitHub Actions**

---

## Licence

Code source sous **licence MIT**.  
Les licences et crédits spécifiques aux assets sont indiqués dans leurs dossiers respectifs.

> N’hésitez pas à contribuer ou à proposer des améliorations.
