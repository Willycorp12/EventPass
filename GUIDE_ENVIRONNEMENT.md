# EventPass v2 — Guide d'organisation de l'environnement de programmation

## 🖥️ Structure complète du projet

```
C:\xampp\htdocs\EVPASS\
│
├── index.php                          ← Point d'entrée unique (routeur)
├── .htaccess                          ← Réécriture des URLs
├── eventpass_v2.sql                   ← Base de données finale à importer
├── eventpass_v1.sql                   ← Ancienne BD (sauvegarde)
├── EVENTPASS_V2_README.md             ← Documentation technique v2
├── GUIDE_ENVIRONNEMENT.md             ← Ce fichier
│
├── config/
│   ├── base_de_donnees.php            ← Connexion BD + constantes + fonctions globales
│   └── mail.php                       ← Configuration email (PHPMailer)
│
├── lang/
│   ├── fr.php                         ← Traductions françaises
│   └── en.php                         ← Traductions anglaises
│
├── app/
│   ├── controleurs/                   ← Logique métier (MVC — Contrôleur)
│   │   ├── ControleurAccueil.php      ← Page d'accueil + commentaires
│   │   ├── ControleurAuth.php         ← Connexion, inscription, déconnexion, langue
│   │   ├── ControleurVisiteur.php     ← Accès visiteur (lecture seule)
│   │   ├── ControleurEvenement.php    ← CRUD événements + templates
│   │   ├── ControleurPaiement.php     ← Paiement + génération facture
│   │   ├── ControleurBillet.php       ← Génération, distribution, scan, nominatif
│   │   ├── ControleurNotification.php ← Notifications internes
│   │   ├── ControleurCommentaire.php  ← Commentaires page d'accueil
│   │   ├── ControleurRapport.php      ← Rapport (redirige vers analytics)
│   │   ├── ControleurCreateur.php     ← Tableau de bord créateur
│   │   ├── ControleurAdmin.php        ← Tableau de bord administrateur
│   │   ├── ControleurAnalytics.php    ← Analytics avancés + export CSV
│   │   ├── ControleurSupport.php      ← Service client (messagerie)
│   │   ├── ControleurChatbot.php      ← ChatBot IA (API Claude)
│   │   └── ControleurLegal.php        ← Pages CGU et politique de confidentialité
│   │
│   ├── modeles/                       ← Accès aux données (MVC — Modèle)
│   │   ├── Personne.php               ← Utilisateurs (CRUD + validation)
│   │   ├── Administrateur.php         ← Administrateurs
│   │   ├── CreateurEvenement.php      ← Créateurs d'événements
│   │   ├── Evenement.php              ← Événements (CRUD + templates + annulation)
│   │   ├── Billet.php                 ← Billets (génération, scan, nominatif, stats)
│   │   ├── Paiement.php               ← Paiements
│   │   ├── Facture.php                ← Factures (numérotation EVP-FAC-XXX-XX)
│   │   ├── Notification.php           ← Notifications internes
│   │   ├── Commentaire.php            ← Commentaires
│   │   └── MessageSupport.php         ← Messages service client
│   │
│   ├── vues/                          ← Interface utilisateur (MVC — Vue)
│   │   ├── disposition/
│   │   │   ├── entete.php             ← Navbar + langue + flash messages
│   │   │   └── pied_de_page.php       ← Footer + ChatBot flottant
│   │   ├── accueil/
│   │   │   └── index.php              ← Page d'accueil (héro, avantages, commentaires)
│   │   ├── auth/
│   │   │   ├── connexion.php          ← Formulaire connexion
│   │   │   └── inscription.php        ← Formulaire inscription + CGU
│   │   ├── evenement/
│   │   │   ├── creer.php              ← Création événement + templates + aperçu
│   │   │   ├── liste.php              ← Liste des événements du créateur
│   │   │   └── detail.php             ← Détail d'un événement
│   │   ├── billet/
│   │   │   ├── liste.php              ← Liste billets + assignation invité
│   │   │   ├── distribuer.php         ← Distribution (WhatsApp, Email, SMS, Facebook)
│   │   │   ├── scanner.php            ← Scanner QR code (jsQR local)
│   │   │   └── modele_billet.html     ← Template HTML du billet (legacy)
│   │   ├── paiement/
│   │   │   ├── formulaire.php         ← Formulaire paiement (Orange Money, MTN)
│   │   │   └── facture.php            ← Affichage facture imprimable
│   │   ├── createur/
│   │   │   └── tableau_de_bord.php    ← Dashboard créateur (stats, événements, notifs)
│   │   ├── admin/
│   │   │   └── tableau_de_bord.php    ← Dashboard admin (CRUD utilisateurs, événements)
│   │   ├── analytics/
│   │   │   └── index.php              ← Analytics (Chart.js, présents, export CSV)
│   │   ├── support/
│   │   │   ├── index.php              ← Page contact support (utilisateur)
│   │   │   ├── admin_liste.php        ← Liste messages support (admin)
│   │   │   └── voir.php               ← Voir + répondre à un message (admin)
│   │   ├── legal/
│   │   │   ├── cgu.php                ← Conditions Générales d'Utilisation
│   │   │   └── politique.php          ← Politique de confidentialité
│   │   ├── notification/
│   │   │   └── envoyer.php            ← Envoi de notifications
│   │   ├── rapport/
│   │   │   └── index.php              ← Rapport (redirige vers analytics)
│   │   └── commentaire/
│   │       └── index.php              ← Page commentaires
│   │
│   └── helpers/
│       └── MailHelper.php             ← Envoi d'emails (PHPMailer)
│
├── public/
│   ├── bootstrap/
│   │   ├── css/bootstrap.min.css      ← Bootstrap 5 CSS
│   │   └── js/bootstrap.bundle.min.js ← Bootstrap 5 JS
│   ├── css/
│   │   └── style.css                  ← CSS global EventPass (3800+ lignes)
│   ├── js/
│   │   ├── principal.js               ← JS global (animations, flash, Gmail validation)
│   │   ├── paiement.js                ← JS formulaire paiement (totalisateur)
│   │   ├── scanner.js                 ← JS scanner QR (jsQR + canvas)
│   │   └── jsQR.min.js                ← Librairie jsQR locale (256 Ko)
│   └── images/
│       ├── logo.png                   ← Logo EventPass
│       └── ...
│
├── billets/                           ← Billets HTML générés (standalone)
│   ├── 1.html
│   ├── 2.html
│   └── ...
│
├── uploads/
│   └── evenements/                    ← Images uploadées pour les événements
│
└── phpmailer/                         ← Librairie PHPMailer
    └── src/
        ├── PHPMailer.php
        ├── SMTP.php
        └── Exception.php
```

---

## ⚙️ Configuration requise

### Logiciels nécessaires

| Logiciel      | Version  | Rôle                         |
| ------------- | -------- | ---------------------------- |
| XAMPP         | 8.x      | Serveur Apache + MySQL + PHP |
| PHP           | 8.1+     | Langage backend              |
| MySQL         | 8.0+     | Base de données              |
| VS Code       | Dernière | Éditeur de code              |
| Edge / Chrome | Dernière | Navigateur de test           |

### Extensions VS Code recommandées

- PHP Intelephense (support PHP)
- PHP Debug (débogage)
- HTML CSS Support
- Auto Rename Tag
- Prettier (formatage)
- GitLens (gestion Git)

---

## 🚀 Installation pas à pas

### Étape 1 — Démarrer XAMPP

1. Ouvrir XAMPP Control Panel
2. Démarrer **Apache** et **MySQL**
3. Vérifier que les deux sont verts

### Étape 2 — Importer la base de données

1. Aller sur `http://localhost/phpmyadmin`
2. Créer la base `eventpass` si elle n'existe pas
3. Cliquer sur `eventpass` → onglet **SQL**
4. Coller le contenu de `eventpass_v2.sql`
5. Cliquer **Exécuter**

### Étape 3 — Configurer l'application

Ouvrir `config/base_de_donnees.php` et vérifier :

```php
define('URL_BASE', 'http://localhost/EVPASS');  // Nom exact du dossier
define('DB_MOT_PASSE', '');
```

### Étape 4 — Tester

Ouvrir `http://localhost/EVPASS` dans le navigateur.

---

## 🌐 URLs principales

| Page               | URL                                        |
| ------------------ | ------------------------------------------ |
| Accueil            | `http://localhost/EVPASS`                  |
| Connexion          | `http://localhost/EVPASS/auth/connexion`   |
| Inscription        | `http://localhost/EVPASS/auth/inscription` |
| Dashboard créateur | `http://localhost/EVPASS/createur/index`   |
| Dashboard admin    | `http://localhost/EVPASS/admin/index`      |
| Scanner            | `http://localhost/EVPASS/billet/scanner`   |
| Service client     | `http://localhost/EVPASS/support/index`    |
| CGU                | `http://localhost/EVPASS/legal/cgu`        |
| Politique          | `http://localhost/EVPASS/legal/politique`  |

---

## 🤖 Configuration ChatBot IA (optionnel)

1. Créer un compte sur `https://console.anthropic.com`
2. Générer une clé API
3. Dans `config/base_de_donnees.php`, remplacer :

```php
define('CLAUDE_API_KEY', 'VOTRE_CLE_API_CLAUDE_ICI');
```

par votre vraie clé.

Sans clé API, le chatbot utilise des réponses locales prédéfinies.

---

## 📋 Flux utilisateur complet

```
Visiteur
  ↓ S'inscrit (Gmail obligatoire + accepte CGU)
  ↓ Se connecte
  ↓ Clique "Nouvel événement"
  ↓ Effectue le paiement (Orange Money / MTN)
  ↓ Reçoit la facture (EVP-FAC-001-26)
  ↓ Crée l'événement (choisit template + couleurs)
  ↓ Les billets QR sont générés automatiquement
  ↓ Assigne un nom à chaque billet (nominatif)
  ↓ Distribue les billets (WhatsApp / Email / SMS)
  ↓ Le jour J : scanne les billets à l'entrée
  ↓ Consulte les analytics en temps réel
  ↓ Exporte la liste des présents en CSV
```

---

## 🔧 Résolution des problèmes courants

| Problème                       | Solution                                                 |
| ------------------------------ | -------------------------------------------------------- |
| 404 Page introuvable           | Vérifier `AllowOverride All` dans `httpd.conf`           |
| Erreur connexion BD            | Vérifier que MySQL est démarré dans XAMPP                |
| QR code ne s'affiche pas       | jsQR.min.js est local — vérifier `public/js/jsQR.min.js` |
| Icônes Font Awesome manquantes | Télécharger Font Awesome localement                      |
| Email Gmail refusé             | Seules les adresses @gmail.com sont acceptées            |
| Billet vide                    | Vérifier que `billets/` est accessible en écriture       |
| Scanner ne fonctionne pas      | Autoriser la caméra dans les paramètres du navigateur    |
