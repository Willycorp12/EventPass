<?php
// ============================================================
// EVENTPASS — Script de régénération des billets HTML
// Accès : http://localhost/EVPASS/regenerer_billets.php
// SUPPRIMER CE FICHIER APRÈS UTILISATION
// ============================================================

session_start();
require_once __DIR__ . '/config/base_de_donnees.php';

// Vérification sécurité basique
if (!isset($_SESSION['utilisateur']) || $_SESSION['utilisateur']['role'] !== 'admin') {
    die('<p style="color:red;font-family:sans-serif;padding:2rem;">Accès refusé. Connectez-vous en tant qu\'admin d\'abord.</p>');
}

$bd = ConnexionBD::obtenirInstance();

// Récupérer tous les billets avec leurs événements et créateurs
$requete = $bd->query("
    SELECT b.*,
           e.nom_evenement, e.date_evenement, e.lieu, e.heure,
           e.template, e.couleur_fond, e.couleur_texte, e.police, e.image,
           p.nom AS nom_createur
    FROM billet b
    JOIN evenement e ON b.id_evenement = e.id_evenement
    JOIN createur_evenement c ON e.id_createur = c.id_createur
    JOIN personne p ON c.id_personne = p.id_personne
    ORDER BY b.id_billet ASC
");
$billets = $requete->fetchAll();

$templates = [
    'standard'     => ['couleur_fond' => '#0066FF', 'couleur_texte' => '#FFFFFF', 'emoji' => '🎫'],
    'mariage'      => ['couleur_fond' => '#F8F0E3', 'couleur_texte' => '#5C3D2E', 'emoji' => '💍'],
    'anniversaire' => ['couleur_fond' => '#FF6B9D', 'couleur_texte' => '#FFFFFF', 'emoji' => '🎂'],
    'gala'         => ['couleur_fond' => '#1A1A2E', 'couleur_texte' => '#FFD700', 'emoji' => '✨'],
    'concert'      => ['couleur_fond' => '#0D0D0D', 'couleur_texte' => '#FF4500', 'emoji' => '🎵'],
    'conference'   => ['couleur_fond' => '#2C3E50', 'couleur_texte' => '#ECF0F1', 'emoji' => '🎤'],
];

function eclaircirCouleur(string $hex): string
{
    $hex = ltrim($hex, '#');
    if (strlen($hex) === 3) $hex = $hex[0] . $hex[0] . $hex[1] . $hex[1] . $hex[2] . $hex[2];
    $r = (int)(hexdec(substr($hex, 0, 2)) * 0.1 + 255 * 0.9);
    $g = (int)(hexdec(substr($hex, 2, 2)) * 0.1 + 255 * 0.9);
    $b = (int)(hexdec(substr($hex, 4, 2)) * 0.1 + 255 * 0.9);
    return sprintf('#%02x%02x%02x', $r, $g, $b);
}

$dossier = __DIR__ . DIRECTORY_SEPARATOR . 'billets' . DIRECTORY_SEPARATOR;
$nb = 0;
$erreurs = [];

foreach ($billets as $billet) {
    $template     = $billet['template'] ?? 'standard';
    $styleInfo    = $templates[$template] ?? $templates['standard'];
    $couleurFond  = $billet['couleur_fond']  ?? $styleInfo['couleur_fond'];
    $couleurTexte = $billet['couleur_texte'] ?? $styleInfo['couleur_texte'];
    $police       = $billet['police']        ?? 'Syne';
    $emoji        = $styleInfo['emoji'];
    $couleurClair = eclaircirCouleur($couleurFond);

    $nomCreateur  = $billet['nom_createur'] ?? 'Organisateur';
    $nomInvite    = $billet['nom_invite']   ?? '';
    $idBilletPad  = str_pad($billet['id_billet'], 4, '0', STR_PAD_LEFT);
    $qrCode       = $billet['qr_code'];
    $qrUrl        = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=' . urlencode($qrCode);

    $blocInvite = $nomInvite
        ? '<div class="billet-invite" style="background:' . $couleurClair . ';border-left-color:' . $couleurFond . ';color:' . $couleurFond . '">👤 ' . htmlspecialchars($nomInvite) . '</div>'
        : '';

    // Bandeau "Déjà distribué" si le billet a été envoyé
    $blocDistribue = $billet['distribue']
        ? '<div style="background:#FEF3C7;border-left:4px solid #D97706;border-radius:8px;padding:0.7rem 1rem;margin-bottom:1rem;font-weight:700;color:#92400E;font-size:0.9rem;">📤 Ce billet a déjà été distribué</div>'
        : '';

    $html = <<<HTML
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Billet #{$idBilletPad} — {$billet['nom_evenement']}</title>
<link href="https://fonts.googleapis.com/css2?family={$police}:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'DM Sans', sans-serif; background: #f0f4ff; display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 2rem; }
  .billet { background: white; border-radius: 20px; overflow: hidden; max-width: 480px; width: 100%; box-shadow: 0 20px 60px rgba(0,0,0,0.15); }
  .billet-entete { background: {$couleurFond}; color: {$couleurTexte}; padding: 2rem; text-align: center; position: relative; }
  .billet-entete::after { content: ''; position: absolute; bottom: -20px; left: 0; right: 0; height: 40px; background: white; border-radius: 50% 50% 0 0; }
  .billet-emoji { font-size: 3rem; margin-bottom: 0.5rem; }
  .billet-titre { font-family: '{$police}', sans-serif; font-size: 1.5rem; font-weight: 800; margin-bottom: 0.3rem; }
  .billet-organisateur { font-size: 0.85rem; opacity: 0.85; }
  .billet-corps { padding: 2.5rem 2rem 2rem; }
  .billet-invite { border-radius: 8px; padding: 0.8rem 1rem; margin-bottom: 1.5rem; font-weight: 700; font-size: 1.05rem; border-left: 4px solid; }
  .billet-infos { display: grid; gap: 0.8rem; margin-bottom: 1.5rem; }
  .billet-info-ligne { display: flex; align-items: center; gap: 10px; font-size: 0.92rem; color: #444; }
  .billet-info-icone { width: 32px; height: 32px; background: {$couleurClair}; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 1rem; flex-shrink: 0; }
  .billet-separateur { border: none; border-top: 2px dashed #e0e7ff; margin: 1.5rem 0; }
  .billet-qr { text-align: center; }
  .billet-qr img { width: 180px; height: 180px; border: 3px solid {$couleurFond}; border-radius: 12px; padding: 8px; }
  .billet-qr-code { font-family: monospace; font-size: 0.7rem; color: #999; margin-top: 0.5rem; word-break: break-all; }
  .billet-id { text-align: center; margin-top: 1rem; font-size: 0.8rem; color: #999; }
  .billet-statut { background: #dcfce7; color: #166534; border-radius: 50px; padding: 0.4rem 1rem; font-weight: 700; font-size: 0.85rem; display: inline-flex; align-items: center; gap: 6px; margin-top: 1rem; }
  .billet-pied { background: {$couleurFond}; color: {$couleurTexte}; padding: 1rem; text-align: center; font-size: 0.8rem; }
  @media print { body { background: white; padding: 0; } .billet { box-shadow: none; max-width: 100%; } }
</style>
</head>
<body>
<div class="billet">
  <div class="billet-entete">
    <div class="billet-emoji">{$emoji}</div>
    <div class="billet-titre">{$billet['nom_evenement']}</div>
    <div class="billet-organisateur">Organisé par {$nomCreateur}</div>
  </div>
  <div class="billet-corps">
    {$blocDistribue}
    {$blocInvite}
    <div class="billet-infos">
      <div class="billet-info-ligne"><div class="billet-info-icone">📅</div><div><strong>Date :</strong> {$billet['date_evenement']}</div></div>
      <div class="billet-info-ligne"><div class="billet-info-icone">🕐</div><div><strong>Heure :</strong> {$billet['heure']}</div></div>
      <div class="billet-info-ligne"><div class="billet-info-icone">📍</div><div><strong>Lieu :</strong> {$billet['lieu']}</div></div>
    </div>
    <hr class="billet-separateur">
    <div class="billet-qr">
      <img src="{$qrUrl}" alt="QR Code" onerror="this.style.display='none'">
      <div class="billet-qr-code">{$qrCode}</div>
      <div class="billet-statut">✅ Billet valide</div>
    </div>
    <div class="billet-id">Billet N° {$idBilletPad}</div>
  </div>
  <div class="billet-pied">🎫 EventPass — Plateforme de gestion des billets d'invitation</div>
</div>
</body>
</html>
HTML;

    $fichier = $dossier . $billet['id_billet'] . '.html';
    if (file_put_contents($fichier, $html) !== false) {
        $nb++;
    } else {
        $erreurs[] = 'Billet #' . $billet['id_billet'];
    }
}
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <title>Régénération billets — EventPass</title>
    <style>
        body {
            font-family: sans-serif;
            padding: 2rem;
            background: #f0f4ff;
        }

        .carte {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            max-width: 500px;
            margin: 0 auto;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #003399;
        }

        .ok {
            color: #16a34a;
            font-weight: 700;
            font-size: 1.5rem;
        }

        .err {
            color: #dc2626;
        }

        a {
            color: #0066FF;
        }
    </style>
</head>

<body>
    <div class="carte">
        <h2>🎫 Régénération des billets</h2>
        <p class="ok">✅ <?= $nb ?> billet(s) régénéré(s) avec succès.</p>
        <?php if ($erreurs): ?>
            <p class="err">❌ Erreurs : <?= implode(', ', $erreurs) ?></p>
        <?php endif; ?>
        <p style="margin-top:1.5rem;">
            <a href="<?= URL_BASE ?>/billet/liste">← Retour à mes billets</a>
        </p>
        <p style="color:#dc2626;font-size:0.85rem;margin-top:1rem;">
            ⚠️ Supprimez ce fichier <code>regenerer_billets.php</code> maintenant.
        </p>
    </div>
</body>

</html>