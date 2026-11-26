-- ============================================================
-- EVENTPASS v2 — Base de données complète
-- Fichier : eventpass_v2.sql
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS `eventpass`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `eventpass`;

-- ============================================================
-- TABLE : personne
-- ============================================================
CREATE TABLE IF NOT EXISTS `personne` (
  `id_personne`      INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  `nom`              VARCHAR(120)     NOT NULL,
  `email`            VARCHAR(180)     NOT NULL UNIQUE,
  `nom_utilisateur`  VARCHAR(80)      NOT NULL UNIQUE,
  `mot_de_passe`     VARCHAR(255)     NOT NULL,
  `telephone`        VARCHAR(30)      DEFAULT NULL,
  `role`             ENUM('visiteur','createur','agent_securite','admin') NOT NULL DEFAULT 'visiteur',
  `cgu_acceptee`     TINYINT(1)       NOT NULL DEFAULT 0,
  `date_inscription` DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_personne`),
  KEY `idx_email` (`email`),
  KEY `idx_role`  (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : createur_evenement
-- ============================================================
CREATE TABLE IF NOT EXISTS `createur_evenement` (
  `id_createur`  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_personne`  INT UNSIGNED NOT NULL UNIQUE,
  PRIMARY KEY (`id_createur`),
  CONSTRAINT `fk_createur_personne`
    FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : evenement
-- ============================================================
CREATE TABLE IF NOT EXISTS `evenement` (
  `id_evenement`   INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  `id_createur`    INT UNSIGNED     NOT NULL,
  `nom_evenement`  VARCHAR(200)     NOT NULL,
  `description`    TEXT             DEFAULT NULL,
  `lieu`           VARCHAR(200)     NOT NULL,
  `date_evenement` DATE             NOT NULL,
  `heure`          TIME             NOT NULL,
  `prix_billet`    INT UNSIGNED     NOT NULL DEFAULT 1000,
  `nombre_billets` INT UNSIGNED     NOT NULL DEFAULT 0,
  `image`          VARCHAR(300)     DEFAULT NULL,
  `template`       VARCHAR(50)      NOT NULL DEFAULT 'standard',
  `couleur_fond`   VARCHAR(20)      NOT NULL DEFAULT '#0066FF',
  `couleur_texte`  VARCHAR(20)      NOT NULL DEFAULT '#FFFFFF',
  `police`         VARCHAR(60)      NOT NULL DEFAULT 'Syne',
  `statut`         ENUM('actif','annule','termine') NOT NULL DEFAULT 'actif',
  `date_creation`  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evenement`),
  KEY `idx_createur`      (`id_createur`),
  KEY `idx_date_evenement`(`date_evenement`),
  CONSTRAINT `fk_evenement_createur`
    FOREIGN KEY (`id_createur`) REFERENCES `createur_evenement` (`id_createur`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : billet
-- ============================================================
CREATE TABLE IF NOT EXISTS `billet` (
  `id_billet`       INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `id_evenement`    INT UNSIGNED  NOT NULL,
  `qr_code`         VARCHAR(64)   NOT NULL UNIQUE,
  `statut`          ENUM('valide','en_cours','utilise') NOT NULL DEFAULT 'valide',
  `distribue`       TINYINT(1)    NOT NULL DEFAULT 0,
  `nom_invite`      VARCHAR(150)  DEFAULT NULL,
  `email_invite`    VARCHAR(180)  DEFAULT NULL,
  `date_generation` DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_scan`       DATETIME      DEFAULT NULL,
  PRIMARY KEY (`id_billet`),
  KEY `idx_evenement` (`id_evenement`),
  KEY `idx_qr_code`   (`qr_code`),
  KEY `idx_statut`    (`statut`),
  CONSTRAINT `fk_billet_evenement`
    FOREIGN KEY (`id_evenement`) REFERENCES `evenement` (`id_evenement`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : paiement
-- ============================================================
CREATE TABLE IF NOT EXISTS `paiement` (
  `id_paiement`    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `id_createur`    INT UNSIGNED  NOT NULL,
  `id_transaction` VARCHAR(80)   NOT NULL UNIQUE,
  `montant`        INT UNSIGNED  NOT NULL,
  `mode_paiement`  ENUM('orange_money','mobile_money','carte') NOT NULL,
  `statut`         ENUM('en_attente','valide','echoue','rembourse') NOT NULL DEFAULT 'en_attente',
  `date_paiement`  DATE          NOT NULL,
  `heure`          TIME          NOT NULL,
  PRIMARY KEY (`id_paiement`),
  KEY `idx_createur_paiement` (`id_createur`),
  CONSTRAINT `fk_paiement_createur`
    FOREIGN KEY (`id_createur`) REFERENCES `createur_evenement` (`id_createur`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : facture
-- ============================================================
CREATE TABLE IF NOT EXISTS `facture` (
  `id_facture`     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `numero_facture` VARCHAR(40)   NOT NULL UNIQUE,
  `id_paiement`    INT UNSIGNED  NOT NULL,
  `montant`        INT UNSIGNED  NOT NULL,
  `date_facture`   DATE          NOT NULL,
  PRIMARY KEY (`id_facture`),
  CONSTRAINT `fk_facture_paiement`
    FOREIGN KEY (`id_paiement`) REFERENCES `paiement` (`id_paiement`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : notification
-- ============================================================
CREATE TABLE IF NOT EXISTS `notification` (
  `id_notification`  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `id_personne`      INT UNSIGNED  NOT NULL,
  `message`          TEXT          NOT NULL,
  `statut`           ENUM('non_lu','lu') NOT NULL DEFAULT 'non_lu',
  `date_notification`DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_notification`),
  KEY `idx_personne_notif` (`id_personne`),
  CONSTRAINT `fk_notification_personne`
    FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : commentaire
-- ============================================================
CREATE TABLE IF NOT EXISTS `commentaire` (
  `id_commentaire`  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `id_personne`     INT UNSIGNED  NOT NULL,
  `message`         TEXT          NOT NULL,
  `date_commentaire`DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_commentaire`),
  KEY `idx_personne_com` (`id_personne`),
  CONSTRAINT `fk_commentaire_personne`
    FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : message_support (Service client)
-- ============================================================
CREATE TABLE IF NOT EXISTS `message_support` (
  `id_message`   INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `id_personne`  INT UNSIGNED  NOT NULL,
  `sujet`        VARCHAR(200)  NOT NULL,
  `message`      TEXT          NOT NULL,
  `reponse`      TEXT          DEFAULT NULL,
  `statut`       ENUM('ouvert','en_cours','resolu') NOT NULL DEFAULT 'ouvert',
  `date_envoi`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_reponse` DATETIME      DEFAULT NULL,
  PRIMARY KEY (`id_message`),
  KEY `idx_personne_support` (`id_personne`),
  CONSTRAINT `fk_support_personne`
    FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE : agent_evenement (agents de sécurité par événement)
-- ============================================================
CREATE TABLE IF NOT EXISTS `agent_evenement` (
  `id`           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `id_evenement` INT UNSIGNED  NOT NULL,
  `id_personne`  INT UNSIGNED  NOT NULL,
  `date_ajout`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_agent_evt` (`id_evenement`, `id_personne`),
  CONSTRAINT `fk_agent_evenement`
    FOREIGN KEY (`id_evenement`) REFERENCES `evenement` (`id_evenement`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_agent_personne`
    FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- DONNÉES INITIALES : Compte administrateur
-- Mot de passe : Admin@1234
-- ============================================================
INSERT IGNORE INTO `personne`
  (`nom`, `email`, `nom_utilisateur`, `mot_de_passe`, `telephone`, `role`, `cgu_acceptee`)
VALUES
  (
    'Administrateur EventPass',
    'admin@gmail.com',
    'admin',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    '+237 659 38 36 24',
    'admin',
    1
  );
