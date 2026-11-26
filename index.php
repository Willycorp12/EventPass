<?php
// ============================================================
// EVENTPASS v2 — Point d'entrée principal
// Fichier : index.php
// ============================================================

session_start();

// Chargement de la configuration
require_once __DIR__ . '/config/base_de_donnees.php';

// Chargement automatique des contrôleurs et modèles
spl_autoload_register(function (string $classe): void {
    $chemins = [
        __DIR__ . '/app/controleurs/' . $classe . '.php',
        __DIR__ . '/app/modeles/'     . $classe . '.php',
    ];
    foreach ($chemins as $chemin) {
        if (file_exists($chemin)) {
            require_once $chemin;
            return;
        }
    }
});

// Changement de langue via GET
if (isset($_GET['langue']) && in_array($_GET['langue'], ['fr', 'en'])) {
    $_SESSION['langue'] = $_GET['langue'];
    // Rediriger sans le paramètre langue
    $urlSansLangue = strtok($_SERVER['REQUEST_URI'], '?');
    header('Location: ' . URL_BASE . '/');
    exit;
}

// Récupération de l'URL
$url = isset($_GET['url'])
    ? rtrim($_GET['url'], '/')
    : 'accueil';

$segments   = explode('/', filter_var($url, FILTER_SANITIZE_URL));
$controleur = strtolower($segments[0] ?? 'accueil');
// Conserver la casse de l'action pour les méthodes camelCase (ex: traiterScan)
$action     = $segments[1] ?? 'index';
$parametre  = $segments[2] ?? null;

// Table de correspondance URL → classe contrôleur
$carte = [
    'accueil'      => 'ControleurAccueil',
    'auth'         => 'ControleurAuth',
    'visiteur'     => 'ControleurVisiteur',
    'evenement'    => 'ControleurEvenement',
    'paiement'     => 'ControleurPaiement',
    'billet'       => 'ControleurBillet',
    'notification' => 'ControleurNotification',
    'commentaire'  => 'ControleurCommentaire',
    'rapport'      => 'ControleurRapport',
    'createur'     => 'ControleurCreateur',
    'admin'        => 'ControleurAdmin',
    'support'      => 'ControleurSupport',
    'chatbot'      => 'ControleurChatbot',
    'analytics'    => 'ControleurAnalytics',
    'legal'        => 'ControleurLegal',
];

// Résolution du contrôleur
$nomClasse = $carte[$controleur] ?? 'ControleurAccueil';

// Vérification que le fichier contrôleur existe
$fichierControleur = __DIR__ . '/app/controleurs/' . $nomClasse . '.php';

if (!file_exists($fichierControleur)) {
    http_response_code(404);
    echo '<div style="font-family:sans-serif;padding:2rem;color:#DC2626;">';
    echo '<h2>404 — Contrôleur introuvable</h2>';
    echo '<p>Contrôleur demandé : <code>' . htmlspecialchars($nomClasse) . '</code></p>';
    echo '<p>URL reçue : <code>' . htmlspecialchars($url) . '</code></p>';
    echo '<p><a href="' . URL_BASE . '">← Retour à l\'accueil</a></p>';
    echo '</div>';
    exit;
}

require_once $fichierControleur;
$objetControleur = new $nomClasse();

// Vérification que la méthode existe
if (!method_exists($objetControleur, $action)) {
    $action = 'index';
}

// Appel de l'action
if ($parametre !== null) {
    $objetControleur->$action($parametre);
} else {
    $objetControleur->$action();
}
