-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 23 nov. 2026 à 08:08
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `eventpass`
--

-- --------------------------------------------------------

--
-- Structure de la table `agent_evenement`
--

CREATE TABLE `agent_evenement` (
  `id` int(10) UNSIGNED NOT NULL,
  `id_evenement` int(10) UNSIGNED NOT NULL,
  `id_personne` int(10) UNSIGNED NOT NULL,
  `date_ajout` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `billet`
--

CREATE TABLE `billet` (
  `id_billet` int(10) UNSIGNED NOT NULL,
  `id_evenement` int(10) UNSIGNED NOT NULL,
  `qr_code` varchar(64) NOT NULL,
  `statut` enum('valide','en_cours','utilise') NOT NULL DEFAULT 'valide',
  `distribue` tinyint(1) NOT NULL DEFAULT 0,
  `nom_invite` varchar(150) DEFAULT NULL,
  `email_invite` varchar(180) DEFAULT NULL,
  `date_generation` datetime NOT NULL DEFAULT current_timestamp(),
  `date_scan` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `billet`
--

INSERT INTO `billet` (`id_billet`, `id_evenement`, `qr_code`, `statut`, `distribue`, `nom_invite`, `email_invite`, `date_generation`, `date_scan`) VALUES
(1, 1, '7ea3b694b497aef67a8f7dab447cf2b4bebfc599ac05dee7b5b3a346acf26eca', 'en_cours', 1, NULL, NULL, '2026-05-05 16:56:29', '2026-05-05 19:09:01'),
(2, 1, '169b6a9a9fe14706596eb491cf0fcbef366f470940644143d92d2d757de19622', 'en_cours', 0, NULL, NULL, '2026-05-05 16:56:29', '2026-05-06 08:53:18'),
(3, 1, '8cc823137716cd7b3cffa69ac35f23820f60ef464df73d3c3be9f7132317fba1', 'valide', 0, NULL, NULL, '2026-05-05 16:56:29', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `commentaire`
--

CREATE TABLE `commentaire` (
  `id_commentaire` int(10) UNSIGNED NOT NULL,
  `id_personne` int(10) UNSIGNED NOT NULL,
  `message` text NOT NULL,
  `date_commentaire` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `commentaire`
--

INSERT INTO `commentaire` (`id_commentaire`, `id_personne`, `message`, `date_commentaire`) VALUES
(1, 2, 'oui', '2026-05-05 16:44:06');

-- --------------------------------------------------------

--
-- Structure de la table `createur_evenement`
--

CREATE TABLE `createur_evenement` (
  `id_createur` int(10) UNSIGNED NOT NULL,
  `id_personne` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `createur_evenement`
--

INSERT INTO `createur_evenement` (`id_createur`, `id_personne`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Structure de la table `evenement`
--

CREATE TABLE `evenement` (
  `id_evenement` int(10) UNSIGNED NOT NULL,
  `id_createur` int(10) UNSIGNED NOT NULL,
  `nom_evenement` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `lieu` varchar(200) NOT NULL,
  `date_evenement` date NOT NULL,
  `heure` time NOT NULL,
  `prix_billet` int(10) UNSIGNED NOT NULL DEFAULT 1000,
  `nombre_billets` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `image` varchar(300) DEFAULT NULL,
  `template` varchar(50) NOT NULL DEFAULT 'standard',
  `couleur_fond` varchar(20) NOT NULL DEFAULT '#0066FF',
  `couleur_texte` varchar(20) NOT NULL DEFAULT '#FFFFFF',
  `police` varchar(60) NOT NULL DEFAULT 'Syne',
  `statut` enum('actif','annule','termine') NOT NULL DEFAULT 'actif',
  `date_creation` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `evenement`
--

INSERT INTO `evenement` (`id_evenement`, `id_createur`, `nom_evenement`, `description`, `lieu`, `date_evenement`, `heure`, `prix_billet`, `nombre_billets`, `image`, `template`, `couleur_fond`, `couleur_texte`, `police`, `statut`, `date_creation`) VALUES
(1, 1, 'ANIVVer', 'fghjk', 'etoudi', '2026-05-10', '18:56:00', 1500, 1, NULL, 'mariage', '#b04545', '#2e5c33', 'Syne', 'actif', '2026-05-05 16:56:29');

-- --------------------------------------------------------

--
-- Structure de la table `facture`
--

CREATE TABLE `facture` (
  `id_facture` int(10) UNSIGNED NOT NULL,
  `numero_facture` varchar(40) NOT NULL,
  `id_paiement` int(10) UNSIGNED NOT NULL,
  `montant` int(10) UNSIGNED NOT NULL,
  `date_facture` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `facture`
--

INSERT INTO `facture` (`id_facture`, `numero_facture`, `id_paiement`, `montant`, `date_facture`) VALUES
(1, 'EVP-FAC-001-26', 1, 4500, '2026-05-05'),
(2, 'EVP-FAC-002-26', 2, 6000, '2026-05-05'),
(3, 'EVP-FAC-003-26', 3, 1500, '2026-05-06'),
(4, 'EVP-FAC-004-26', 4, 1500, '2026-05-06'),
(5, 'EVP-FAC-005-26', 5, 3000, '2026-05-06');

-- --------------------------------------------------------

--
-- Structure de la table `message_support`
--

CREATE TABLE `message_support` (
  `id_message` int(10) UNSIGNED NOT NULL,
  `id_personne` int(10) UNSIGNED NOT NULL,
  `sujet` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `reponse` text DEFAULT NULL,
  `statut` enum('ouvert','en_cours','resolu') NOT NULL DEFAULT 'ouvert',
  `date_envoi` datetime NOT NULL DEFAULT current_timestamp(),
  `date_reponse` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `message_support`
--

INSERT INTO `message_support` (`id_message`, `id_personne`, `sujet`, `message`, `reponse`, `statut`, `date_envoi`, `date_reponse`) VALUES
(1, 2, 'Problème de paiement', 'vaismau', NULL, 'ouvert', '2026-05-05 16:45:46', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `notification`
--

CREATE TABLE `notification` (
  `id_notification` int(10) UNSIGNED NOT NULL,
  `id_personne` int(10) UNSIGNED NOT NULL,
  `message` text NOT NULL,
  `statut` enum('non_lu','lu') NOT NULL DEFAULT 'non_lu',
  `date_notification` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `paiement`
--

CREATE TABLE `paiement` (
  `id_paiement` int(10) UNSIGNED NOT NULL,
  `id_createur` int(10) UNSIGNED NOT NULL,
  `id_transaction` varchar(80) NOT NULL,
  `montant` int(10) UNSIGNED NOT NULL,
  `mode_paiement` enum('orange_money','mobile_money','carte') NOT NULL,
  `statut` enum('en_attente','valide','echoue','rembourse') NOT NULL DEFAULT 'en_attente',
  `date_paiement` date NOT NULL,
  `heure` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `paiement`
--

INSERT INTO `paiement` (`id_paiement`, `id_createur`, `id_transaction`, `montant`, `mode_paiement`, `statut`, `date_paiement`, `heure`) VALUES
(1, 1, 'TXN-69FA1272D7CA6', 4500, 'orange_money', 'valide', '2026-05-05', '17:53:22'),
(2, 1, 'TXN-69FA2051AEEE3', 6000, 'orange_money', 'valide', '2026-05-05', '18:52:33'),
(3, 1, 'TXN-69FAE36F63FA7', 1500, 'orange_money', 'valide', '2026-05-06', '08:45:03'),
(4, 1, 'TXN-69FAF13CE11BD', 1500, 'orange_money', 'valide', '2026-05-06', '09:43:56'),
(5, 1, 'EVP-69FB336157B9B', 3000, 'mobile_money', 'valide', '2026-05-06', '14:26:23');

-- --------------------------------------------------------

--
-- Structure de la table `personne`
--

CREATE TABLE `personne` (
  `id_personne` int(10) UNSIGNED NOT NULL,
  `nom` varchar(120) NOT NULL,
  `email` varchar(180) NOT NULL,
  `nom_utilisateur` varchar(80) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `telephone` varchar(30) DEFAULT NULL,
  `role` enum('visiteur','createur','agent_securite','admin') NOT NULL DEFAULT 'visiteur',
  `cgu_acceptee` tinyint(1) NOT NULL DEFAULT 0,
  `date_inscription` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `personne`
--

INSERT INTO `personne` (`id_personne`, `nom`, `email`, `nom_utilisateur`, `mot_de_passe`, `telephone`, `role`, `cgu_acceptee`, `date_inscription`) VALUES
(1, 'Josias EVP', 'josiasEVP@gmail.com', 'josiasEVP', '$2y$10$5NFKD5itB1xY21pYZQvtfOGCosOF9lr.RzPFDJrQpWCuDwnSsmt5W', '+237 659 38 36 24', 'admin', 1, '2026-05-05 14:56:16'),
(2, 'joshe', 'josiaskemche@gmail.com', 'joshe', '$2y$10$PpwVGmTO1D2PeyYvjvWvcOEykBtVBnJBoYkkF5dTIHgRozckoa79m', '+237659383624', 'createur', 1, '2026-05-05 16:22:56');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `agent_evenement`
--
ALTER TABLE `agent_evenement`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_agent_evt` (`id_evenement`,`id_personne`),
  ADD KEY `fk_agent_personne` (`id_personne`);

--
-- Index pour la table `billet`
--
ALTER TABLE `billet`
  ADD PRIMARY KEY (`id_billet`),
  ADD UNIQUE KEY `qr_code` (`qr_code`),
  ADD KEY `idx_evenement` (`id_evenement`),
  ADD KEY `idx_qr_code` (`qr_code`),
  ADD KEY `idx_statut` (`statut`);

--
-- Index pour la table `commentaire`
--
ALTER TABLE `commentaire`
  ADD PRIMARY KEY (`id_commentaire`),
  ADD KEY `idx_personne_com` (`id_personne`);

--
-- Index pour la table `createur_evenement`
--
ALTER TABLE `createur_evenement`
  ADD PRIMARY KEY (`id_createur`),
  ADD UNIQUE KEY `id_personne` (`id_personne`);

--
-- Index pour la table `evenement`
--
ALTER TABLE `evenement`
  ADD PRIMARY KEY (`id_evenement`),
  ADD KEY `idx_createur` (`id_createur`),
  ADD KEY `idx_date_evenement` (`date_evenement`);

--
-- Index pour la table `facture`
--
ALTER TABLE `facture`
  ADD PRIMARY KEY (`id_facture`),
  ADD UNIQUE KEY `numero_facture` (`numero_facture`),
  ADD KEY `fk_facture_paiement` (`id_paiement`);

--
-- Index pour la table `message_support`
--
ALTER TABLE `message_support`
  ADD PRIMARY KEY (`id_message`),
  ADD KEY `idx_personne_support` (`id_personne`);

--
-- Index pour la table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id_notification`),
  ADD KEY `idx_personne_notif` (`id_personne`);

--
-- Index pour la table `paiement`
--
ALTER TABLE `paiement`
  ADD PRIMARY KEY (`id_paiement`),
  ADD UNIQUE KEY `id_transaction` (`id_transaction`),
  ADD KEY `idx_createur_paiement` (`id_createur`);

--
-- Index pour la table `personne`
--
ALTER TABLE `personne`
  ADD PRIMARY KEY (`id_personne`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `nom_utilisateur` (`nom_utilisateur`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `agent_evenement`
--
ALTER TABLE `agent_evenement`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `billet`
--
ALTER TABLE `billet`
  MODIFY `id_billet` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `commentaire`
--
ALTER TABLE `commentaire`
  MODIFY `id_commentaire` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `createur_evenement`
--
ALTER TABLE `createur_evenement`
  MODIFY `id_createur` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `evenement`
--
ALTER TABLE `evenement`
  MODIFY `id_evenement` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `facture`
--
ALTER TABLE `facture`
  MODIFY `id_facture` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `message_support`
--
ALTER TABLE `message_support`
  MODIFY `id_message` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `notification`
--
ALTER TABLE `notification`
  MODIFY `id_notification` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `paiement`
--
ALTER TABLE `paiement`
  MODIFY `id_paiement` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `personne`
--
ALTER TABLE `personne`
  MODIFY `id_personne` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `agent_evenement`
--
ALTER TABLE `agent_evenement`
  ADD CONSTRAINT `fk_agent_evenement` FOREIGN KEY (`id_evenement`) REFERENCES `evenement` (`id_evenement`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_agent_personne` FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `billet`
--
ALTER TABLE `billet`
  ADD CONSTRAINT `fk_billet_evenement` FOREIGN KEY (`id_evenement`) REFERENCES `evenement` (`id_evenement`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `commentaire`
--
ALTER TABLE `commentaire`
  ADD CONSTRAINT `fk_commentaire_personne` FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `createur_evenement`
--
ALTER TABLE `createur_evenement`
  ADD CONSTRAINT `fk_createur_personne` FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `evenement`
--
ALTER TABLE `evenement`
  ADD CONSTRAINT `fk_evenement_createur` FOREIGN KEY (`id_createur`) REFERENCES `createur_evenement` (`id_createur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `facture`
--
ALTER TABLE `facture`
  ADD CONSTRAINT `fk_facture_paiement` FOREIGN KEY (`id_paiement`) REFERENCES `paiement` (`id_paiement`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `message_support`
--
ALTER TABLE `message_support`
  ADD CONSTRAINT `fk_support_personne` FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `fk_notification_personne` FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `paiement`
--
ALTER TABLE `paiement`
  ADD CONSTRAINT `fk_paiement_createur` FOREIGN KEY (`id_createur`) REFERENCES `createur_evenement` (`id_createur`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
