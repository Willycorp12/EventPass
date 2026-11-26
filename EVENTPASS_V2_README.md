# EventPass v2 — Guide de mise à jour

## 🚀 Nouvelles fonctionnalités v2

### 1. Concepteur de billets avec templates

- 6 templates : Standard, Mariage, Anniversaire, Gala, Concert, Conférence
- Personnalisation des couleurs de fond et de texte
- Choix de la police (Syne, Playfair, Raleway, Montserrat, Dancing Script)
- Aperçu en temps réel dans le formulaire de création

### 2. Billets nominatifs

- Champ `nom_invite` et `email_invite` sur chaque billet
- Assignation depuis la liste des billets
- Nom affiché sur le billet HTML généré
- Nom affiché lors du scan QR

### 3. Scanner QR fiable avec jsQR local

- Utilise jsQR (bibliothèque locale, pas de dépendance externe)
- Canvas HTML5 pour l'analyse des frames vidéo
- Vibration sur détection (mobile)
- Compteur de billets validés en temps réel

### 4. Service client (messagerie)

- Formulaire de contact avec sujets prédéfinis
- Historique des messages pour l'utilisateur
- Interface admin pour répondre aux messages
- Statuts : ouvert, en_cours, résolu

### 5. ChatBot IA (bouton flottant)

- Bouton flottant en bas à droite
- Appel API Claude (claude-haiku-4-5)
- Réponses locales de secours si pas de clé API
- Contexte EventPass intégré

### 6. Analytics avancés (Chart.js)

- Graphique barres : scans par heure
- Graphique doughnut : taux de présence
- Liste des présents avec heure de scan
- Export CSV des présents
- Rafraîchissement automatique (30s)

### 7. Multi-rôles

- visiteur, createur, agent_securite, admin
- Les agents de sécurité peuvent scanner sans être créateurs
- Redirection automatique selon le rôle à la connexion

### 8. Politique de confidentialité + CGU

- Pages `/legal/politique` et `/legal/cgu`
- Checkbox obligatoire à l'inscription
- Liens dans le footer

### 9. Changement de langue FR/EN

- Sélecteur FR/EN dans la navbar
- Fichiers `lang/fr.php` et `lang/en.php`
- Fonction `t('cle')` pour les traductions
- Stockage en session

### 10. Billets valides si non distribués/scannés

- Annulation d'événement : statut `annule` sur l'événement
- Les billets `valide` et non distribués restent valides
- Seuls les billets `en_cours` sont clôturés

### 11. Validation email Gmail uniquement

- Vérification côté serveur ET côté client
- Fonction `estGmail()` dans config
- Message d'erreur clair

---

## 📁 Nouveaux fichiers créés

```
config/base_de_donnees.php          ← Mis à jour (Claude API, langue, fonctions)
lang/fr.php                         ← Nouveau
lang/en.php                         ← Nouveau
eventpass_v2.sql                    ← BD complète v2
index.php                           ← Mis à jour (nouvelles routes)

app/modeles/
  Billet.php                        ← Mis à jour (nom_invite, date_scan, stats)
  Evenement.php                     ← Mis à jour (template, couleurs, annulation)
  Personne.php                      ← Mis à jour (cgu_acceptee, agents)
  MessageSupport.php                ← Nouveau
  Commentaire.php                   ← Mis à jour (limite paramètre)

app/controleurs/
  ControleurAuth.php                ← Mis à jour (CGU, langue, agent_securite)
  ControleurBillet.php              ← Mis à jour (templates, nominatif, agent)
  ControleurEvenement.php           ← Mis à jour (templates, annulation)
  ControleurAdmin.php               ← Mis à jour (stats v2, support)
  ControleurCreateur.php            ← Mis à jour
  ControleurSupport.php             ← Nouveau
  ControleurChatbot.php             ← Nouveau
  ControleurAnalytics.php           ← Nouveau
  ControleurLegal.php               ← Nouveau
  ControleurRapport.php             ← Mis à jour (redirige vers analytics)
  ControleurAccueil.php             ← Mis à jour

app/vues/
  disposition/entete.php            ← Mis à jour (langue, rôles, chatbot)
  disposition/pied_de_page.php      ← Mis à jour (chatbot flottant, liens légaux)
  accueil/index.php                 ← Mis à jour (templates section)
  auth/connexion.php                ← Mis à jour (alerte Gmail, liens légaux)
  auth/inscription.php              ← Mis à jour (CGU checkbox, alerte Gmail)
  evenement/creer.php               ← Mis à jour (templates, couleurs, aperçu)
  evenement/liste.php               ← Mis à jour (template badge, annulation)
  evenement/detail.php              ← Nouveau
  billet/liste.php                  ← Mis à jour (nominatif, stats)
  billet/distribuer.php             ← Mis à jour (nom invité)
  billet/scanner.php                ← Mis à jour (jsQR canvas, lien analytics)
  createur/tableau_de_bord.php      ← Mis à jour (support, analytics)
  admin/tableau_de_bord.php         ← Mis à jour (stats v2, support)
  analytics/index.php               ← Nouveau
  support/index.php                 ← Nouveau
  support/admin_liste.php           ← Nouveau
  support/voir.php                  ← Nouveau
  legal/politique.php               ← Nouveau
  legal/cgu.php                     ← Nouveau

public/css/style.css                ← Mis à jour (chatbot, templates, analytics...)
public/js/principal.js              ← Mis à jour (Gmail validation, drag&drop)
public/js/scanner.js                ← Mis à jour (jsQR canvas, vibration)
```

---

## 🗄️ Migration base de données

Importez `eventpass_v2.sql` dans phpMyAdmin ou exécutez :

```bash
mysql -u root -p eventpass < eventpass_v2.sql
```

**Ou si vous avez déjà la BD v1**, exécutez ces ALTER TABLE :

```sql
-- Personne : ajouter cgu_acceptee
ALTER TABLE personne
  ADD COLUMN cgu_acceptee TINYINT(1) NOT NULL DEFAULT 0 AFTER role,
  MODIFY COLUMN role ENUM('visiteur','createur','agent_securite','admin') NOT NULL DEFAULT 'visiteur';

-- Evenement : ajouter template, couleurs, statut
ALTER TABLE evenement
  ADD COLUMN template VARCHAR(50) NOT NULL DEFAULT 'standard' AFTER image,
  ADD COLUMN couleur_fond VARCHAR(20) NOT NULL DEFAULT '#0066FF' AFTER template,
  ADD COLUMN couleur_texte VARCHAR(20) NOT NULL DEFAULT '#FFFFFF' AFTER couleur_fond,
  ADD COLUMN police VARCHAR(60) NOT NULL DEFAULT 'Syne' AFTER couleur_texte,
  ADD COLUMN statut ENUM('actif','annule','termine') NOT NULL DEFAULT 'actif' AFTER police;

-- Billet : ajouter nom_invite, email_invite, date_scan
ALTER TABLE billet
  ADD COLUMN nom_invite VARCHAR(150) DEFAULT NULL AFTER distribue,
  ADD COLUMN email_invite VARCHAR(180) DEFAULT NULL AFTER nom_invite,
  ADD COLUMN date_scan DATETIME DEFAULT NULL AFTER email_invite;

-- Nouvelles tables
CREATE TABLE IF NOT EXISTS message_support (
  id_message   INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  id_personne  INT UNSIGNED  NOT NULL,
  sujet        VARCHAR(200)  NOT NULL,
  message      TEXT          NOT NULL,
  reponse      TEXT          DEFAULT NULL,
  statut       ENUM('ouvert','en_cours','resolu') NOT NULL DEFAULT 'ouvert',
  date_envoi   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_reponse DATETIME      DEFAULT NULL,
  PRIMARY KEY (id_message),
  FOREIGN KEY (id_personne) REFERENCES personne(id_personne) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS agent_evenement (
  id           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  id_evenement INT UNSIGNED  NOT NULL,
  id_personne  INT UNSIGNED  NOT NULL,
  date_ajout   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_agent_evt (id_evenement, id_personne),
  FOREIGN KEY (id_evenement) REFERENCES evenement(id_evenement) ON DELETE CASCADE,
  FOREIGN KEY (id_personne) REFERENCES personne(id_personne) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## ⚙️ Configuration ChatBot Claude

Dans `config/base_de_donnees.php`, remplacez :

```php
define('CLAUDE_API_KEY', 'VOTRE_CLE_API_CLAUDE_ICI');
```

par votre vraie clé API Anthropic.

Sans clé API, le chatbot utilise des réponses locales prédéfinies.

---

## 🔐 Compte admin par défaut

- Email : `admin@gmail.com`
- Mot de passe : `password` (hash bcrypt dans le SQL)

**Changez ce mot de passe immédiatement après installation !**

---

## 🌐 URL de l'application

`http://localhost/EVPASS`

Modifiez `URL_BASE` dans `config/base_de_donnees.php` si nécessaire.
