DROP DATABASE IF EXISTS ai_vlm;

CREATE DATABASE ai_vlm;

USE ai_vlm;

CREATE TABLE IF NOT EXISTS `Video` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    `Name` TEXT(65535) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `Person` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    `Type` ENUM('person_1') NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `Object` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    `Type` ENUM('Box', 'Tool', 'Package', 'Other') NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `Action` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    `Action` ENUM('moving', 'carrying an object', 'releasing an object', 'empty hands') NOT NULL,
    PRIMARY KEY(`id`)
);

-- 2. Creazione Tabella Intermedia

CREATE TABLE IF NOT EXISTS `Video_Frame` (
    `Frame_Number` INTEGER UNSIGNED NOT NULL,
    `ID_Video` INTEGER UNSIGNED NOT NULL,
    PRIMARY KEY(`Frame_Number`, `ID_Video`)
);

-- 3. Creazione Tabella Figlia (Dipendente)

CREATE TABLE IF NOT EXISTS `Frame_Cell` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    `ID_Video_Frame` INTEGER UNSIGNED NOT NULL, -- Corrisponde a Frame_Number
    `ID_Video` INTEGER UNSIGNED NOT NULL,       -- Corrisponde a ID_Video
    `Cell_Number` INTEGER UNSIGNED NOT NULL,
    `Reasoning` TEXT(65535) NOT NULL,
    `ID_Action` INTEGER UNSIGNED,               -- Deve essere UNSIGNED come Action.id
    `ID_Object` INTEGER UNSIGNED,               -- Deve essere UNSIGNED come Object.id
    `ID_Person` INTEGER UNSIGNED,               -- Deve essere UNSIGNED come Person.id
    PRIMARY KEY(`id`)
    -- Ho rimosso la definizione FK qui per metterla negli ALTER TABLE sotto
);

-- 4. Definizione delle Relazioni (Foreign Keys)

-- Collegamento Video_Frame -> Video
ALTER TABLE `Video_Frame`
ADD CONSTRAINT `fk_videoframe_video`
FOREIGN KEY(`ID_Video`) REFERENCES `Video`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Collegamento Frame_Cell -> Video_Frame (CHIAVE COMPOSITA)
ALTER TABLE `Frame_Cell`
ADD CONSTRAINT `fk_frame_cell_video_frame`
FOREIGN KEY (`ID_Video_Frame`, `ID_Video`)
REFERENCES `Video_Frame`(`Frame_Number`, `ID_Video`)
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Collegamento Frame_Cell -> Object
ALTER TABLE `Frame_Cell`
ADD CONSTRAINT `fk_frame_cell_object`
FOREIGN KEY(`ID_Object`) REFERENCES `Object`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Collegamento Frame_Cell -> Person
ALTER TABLE `Frame_Cell`
ADD CONSTRAINT `fk_frame_cell_person`
FOREIGN KEY(`ID_Person`) REFERENCES `Person`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Collegamento Frame_Cell -> Action
ALTER TABLE `Frame_Cell`
ADD CONSTRAINT `fk_frame_cell_action`
FOREIGN KEY(`ID_Action`) REFERENCES `Action`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;