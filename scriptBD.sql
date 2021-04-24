-- CREATE TABLES
-- Users table
CREATE TABLE IF NOT EXISTS Users (
	`uid` INT PRIMARY KEY, 
    `email` VARCHAR(40) CHARACTER SET utf8 UNIQUE NOT NULL, 
    `username` VARCHAR(30) CHARACTER SET utf8 UNIQUE NOT NULL, 
    `firstName` VARCHAR(40) CHARACTER SET utf8 NOT NULL, 
    `lastName` VARCHAR(40) CHARACTER SET utf8 NOT NULL, 
    `birthdate` DATE NOT NULL, 
    `telephone` VARCHAR(12)
);

-- Passwords table
CREATE TABLE IF NOT EXISTS Passwords (
          `uid` INT PRIMARY KEY NOT NULL,
          `password` VARCHAR(80) NOT NULL,
           FOREIGN KEY(`uid`) REFERENCES Users(`uid`) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Breweries table
CREATE TABLE IF NOT EXISTS Breweries (
    `id` INT PRIMARY KEY,
    `name` VARCHAR(40) CHARACTER SET utf8,
    `adress` VARCHAR(40) CHARACTER SET utf8,
    `city` VARCHAR(25) CHARACTER SET utf8,
    `postal_code` VARCHAR(7) CHARACTER SET utf8,
    `province` VARCHAR(6) CHARACTER SET utf8,
    `latitude` FLOAT(8, 6),
    `longitude` FLOAT(8, 6),
    `country` VARCHAR(6) CHARACTER SET utf8,
    `foundation_year` INT,
    `picture` VARCHAR(300) CHARACTER SET utf8,
    `website` VARCHAR(45) CHARACTER SET utf8,
    `email` VARCHAR(40) CHARACTER SET utf8,
    `telephone` VARCHAR(12) CHARACTER SET utf8,
    `facebook` VARCHAR(80) CHARACTER SET utf8,
    `ratebeer` VARCHAR(80) CHARACTER SET utf8,
    `untappd` VARCHAR(80) CHARACTER SET utf8,
    `menu` VARCHAR(80) CHARACTER SET utf8,
    `instagram` VARCHAR(80) CHARACTER SET utf8
);

-- Beer table
CREATE TABLE IF NOT EXISTS Beers (
    `id` INT PRIMARY KEY,
    `name` VARCHAR(29) CHARACTER SET utf8,
    `type` VARCHAR(8) CHARACTER SET utf8,
    `alcool` FLOAT(4, 2),
    `price` FLOAT(4, 2),
    `size` INT,
    `micro_id` INT,
    `picture` VARCHAR(342) CHARACTER SET utf8,
    FOREIGN KEY(`micro_id`) REFERENCES Breweries(`id`) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE INDEX ind_micro ON Beers(micro_id);

-- Aromas table
CREATE TABLE IF NOT EXISTS Aromas (
    `beer_id` INT,
    `aroma` VARCHAR(30) CHARACTER SET utf8,
    PRIMARY KEY (`beer_id`, `aroma`),
    FOREIGN KEY(`beer_id`) REFERENCES Beers(`id`) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Carts table
CREATE TABLE IF NOT EXISTS Carts (
	`uid` INT, 
	`beer_id` INT, 
    `quantity` INT, 
    PRIMARY KEY (`uid`, `beer_id`), 
    FOREIGN KEY(`uid`) REFERENCES Users(`uid`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(`beer_id`) REFERENCES Beers(`id`) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Purchases table
CREATE TABLE IF NOT EXISTS Purchases (
	`uid` INT, 
	`beer_id` INT, 
    `quantity` INT, 
    PRIMARY KEY (`uid`, `beer_id`), 
    FOREIGN KEY(`uid`) REFERENCES Users(`uid`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(`beer_id`) REFERENCES Beers(`id`) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Favorites table
CREATE TABLE IF NOT EXISTS Favorites (
	`uid` INT, 
	`beer_id` INT, 
    PRIMARY KEY (`uid`, `beer_id`), 
    FOREIGN KEY(`uid`) REFERENCES Users(`uid`) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(`beer_id`) REFERENCES Beers(`id`) ON UPDATE CASCADE ON DELETE CASCADE
);


-- Triggers
DELIMITER //
CREATE TRIGGER userMinAge
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
	IF (DATEDIFF(CURDATE(), NEW.birthdate) < 6570)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User is under 18 years old";
    END IF;
END;//
DELIMITER ;


DELIMITER //
CREATE TRIGGER minBeerQuantityOnAdd
BEFORE INSERT ON Carts
FOR EACH ROW
BEGIN
	IF (NEW.quantity <= 0)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Quantity of beer has to be > 0";
    END IF;
END;//
DELIMITER ;


DELIMITER //
CREATE TRIGGER minBeerQuantityOnUpdate 
AFTER UPDATE ON Carts
FOR EACH ROW
BEGIN
	IF (NEW.quantity <= 0)
    THEN DELETE FROM Carts WHERE 'uid' = NEW.uid AND 'beer_id' = NEW.beer_id;
    END IF;
END;//
DELIMITER ;


-- Procedures

DROP procedure IF EXISTS `add_user_purchase`;
DELIMITER //
CREATE PROCEDURE `add_user_purchase` (IN p_uid INT, IN p_beer_id INT, IN p_quantity INT )
BEGIN
	IF (p_uid IN (SELECT uid FROM Purchases WHERE uid = p_uid AND beer_id = p_beer_id)) THEN 
		UPDATE Purchases 
		SET quantity = quantity + p_quantity WHERE uid = p_uid AND beer_id = p_beer_id;
	ELSE 
		INSERT INTO Purchases (uid, beer_id, quantity)
		VALUES (p_uid, p_beer_id, p_quantity);
	END IF;
END//

DROP procedure IF EXISTS `add_user_favorite`;
DELIMITER //
CREATE PROCEDURE `add_user_favorite` (IN p_uid INT, IN p_beer_id INT )
BEGIN
	INSERT INTO Favorites (uid, beer_id)
    VALUES (p_uid, p_beer_id);
END//

DROP procedure IF EXISTS `delete_user_favorite`;
DELIMITER //
CREATE PROCEDURE `delete_user_favorite` (IN p_uid INT, IN p_beer_id INT )
BEGIN
	DELETE FROM Favorites WHERE uid = p_uid AND beer_id = p_beer_id;
END//

DROP procedure IF EXISTS `add_beer_to_cart`;
DELIMITER //
CREATE PROCEDURE `add_beer_to_cart` (IN p_uid INT, IN p_beer_id INT, IN p_quantity INT )
BEGIN
	IF (p_uid IN (SELECT uid FROM Carts WHERE uid = p_uid AND beer_id = p_beer_id)) THEN 
		UPDATE Carts 
		SET quantity = quantity + p_quantity WHERE uid = p_uid AND beer_id = p_beer_id;
	ELSE 
		INSERT INTO Carts (uid, beer_id, quantity)
		VALUES (p_uid, p_beer_id, p_quantity);
	END IF;
END//

DROP procedure IF EXISTS `delete_beer_from_cart`;
DELIMITER //
CREATE PROCEDURE `delete_beer_from_cart` (IN p_uid INT, IN p_beer_id INT )
BEGIN
	DELETE FROM Carts WHERE uid = p_uid AND beer_id = p_beer_id;
END//

DROP procedure IF EXISTS `update_beer_in_cart`;
DELIMITER //
CREATE PROCEDURE `update_beer_in_cart` (IN p_uid INT, IN p_beer_id INT, IN p_quantity INT )
BEGIN
    UPDATE Carts SET quantity = quantity - p_quantity WHERE uid = p_uid AND beer_id = p_beer_id;
    IF (SELECT quantity FROM Carts WHERE uid = p_uid AND beer_id = p_beer_id) < 1 THEN 
		DELETE FROM Carts WHERE uid = p_uid AND beer_id = p_beer_id;
	END IF;
END//


-- INSERT VALUES
-- Users
INSERT INTO Users VALUES
	(3333333, 'user1@hotmail.com', 'user1', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333334, 'user2@hotmail.com', 'user2', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333335, 'user3@hotmail.com', 'user3', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333336, 'user4@hotmail.com', 'user4', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333337, 'user5@hotmail.com', 'user5', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333338, 'user6@hotmail.com', 'user6', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333339, 'user7@hotmail.com', 'user7', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333330, 'user8@hotmail.com', 'user8', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333331, 'user9@hotmail.com', 'user9', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333332, 'user10@hotmail.com', 'user10', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (33333, 'user11@hotmail.com', 'user11', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (33334, 'user12@hotmail.com', 'user12', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (33335, 'user13@hotmail.com', 'user13', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (33336, 'user14@hotmail.com', 'user14', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (33337, 'user15@hotmail.com', 'user15', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (33338, 'user16@hotmail.com', 'user16', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (33339, 'user17@hotmail.com', 'user17', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (33330, 'user18@hotmail.com', 'user18', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333245, 'user19@hotmail.com', 'user19', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333789, 'user20@hotmail.com', 'user20', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333987, 'user21@hotmail.com', 'user21', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (333788, 'user22@hotmail.com', 'user22', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222222, 'user23@hotmail.com', 'user23', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (311222, 'user24@hotmail.com', 'user24', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222223, 'user25@hotmail.com', 'user25', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222224, 'user26@hotmail.com', 'user26', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222225, 'user27@hotmail.com', 'user27', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222226, 'user28@hotmail.com', 'user28', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222227, 'user29@hotmail.com', 'user29', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222228, 'user30@hotmail.com', 'user30', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222229, 'user31@hotmail.com', 'user31', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222220, 'user32@hotmail.com', 'user32', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222221, 'user33@hotmail.com', 'user33', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222333, 'user34@hotmail.com', 'user34', 'user1', 'user1', '1998-01-10', '418-123-4567'),
    (222345, 'user35@hotmail.com', 'user35', 'user1', 'user1', '1998-01-10', '418-123-4567');

INSERT INTO Passwords VALUES
	(3333333, 'sgdjsgfjsfj'),
    (333334, 'asjnlkajrg'),
    (333335, 'argaer'),
    (333336, 'aerhaeth'),
    (333337, 'sryjsrtj'),
    (333338, 'srtjsrtj'),
    (333339, 'srjarkja'),
    (333330, 'artjb'),
    (333331, 'AWRYAER'),
    (333332, 'srjurs'),
    (33333, 'stjaerh'),
    (33334, 'aettjsryjs'),
    (33335, 'aetjaare'),
    (33336, 'artjsryk'),
    (33337, 'ysjytksty'),
    (33338, 'kartyhaet'),
    (33339, 'aetjr'),
    (33330, 'sryaer'),
    (333245, 'artjaet'),
    (333789, 'artjatr'),
    (333987, 'aryjartta'),
    (333788, 'rytsyn'),
    (222222, 'trynrt'),
    (311222, 'tynst'),
    (222223, 'stynstyn'),
    (222224, 'rtsynsrt'),
    (222225, 'ynstyn'),
    (222226, 'rtynrtn'),
    (222227, 'eryfghj'),
    (222228, 'sgjsrtjs'),
    (222229, 'srtjsrtj'),
    (222220, 'srtjtj'),
    (222221, 'stenw5y'),
    (222333, 'setynstyn'),
    (222345, 'rysnetymsrt');
		      
-- Breweries
INSERT INTO Breweries VALUES
    (0,'Cheval Blanc','809, rue Ontario Est','Montréal','H2L 1P1','Québec',45.518207,-73.564277,'Canada',1987,'http://lechevalblanc.ca/wp-content/uploads/2015/04/Le-cheval-blanc-2-134-750x460.jpg','http://www.lechevalblanc.ca/','fmartel@lechevalblanc.ca','514-522-0211','https://www.facebook.com/Le-Cheval-Blanc-104725816258577','http://www.ratebeer.com/brewers/le-cheval-blanc/1111/','https://untappd.com/LeChevalBlancCo','https://www.aumenu.info/le-cheval-blanc-brasseur-artisan-bar-b/','https://www.instagram.com/chevalblancmtl/'),
    (1,'Benelux','245, rue Sherbrooke Ouest','Montréal','H2X 1X7','Québec',45.509506,-73.570918,'Canada',2006,'https://cabinetbb.com/wp-content/uploads/2013/06/DSC_1164-low.jpg','http://www.brasseriebenelux.com/','info@brasseriebenelux.com','514-543-9750','https://www.facebook.com/BrasserieArtisanaleBENELUX','http://www.ratebeer.com/brewers/benelux-brasserie-artisanale/6830/','https://untappd.com/w/benelux-brasserie-artisanale/4092','https://www.aumenu.info/benelux-b/','?'),
    (2,'H.E.L.M.','273, rue Bernard Ouest','Montréal','H2V 1T5','Québec',45.524018,-73.605372,'Canada',2006,'https://ssmscdn.yp.ca/image/resize/61dfcaac-d758-466a-abe3-1c7b614f0efb/ypui-d-mp-pic-gal-lg/microbrasserie-helm-4.jpg','http://helmmicrobrasserie.ca/','webmail@helm-mtl.ca','514-276-0473','https://www.facebook.com/Helmmicrobrasseriesurbernard','http://www.ratebeer.com/brewers/helm-brasseur-gourmand/8373/','https://untappd.com/w/helm-microbrasserie/33965','https://www.aumenu.info/helm-microbrasserie-sur-bernard/','https://www.instagram.com/helmmicrobrasserie/'),
    (3,'Pub la Voie Maltée','777, boulevard Talbot','Chicoutimi','G7H 4B3','Québec',48.41731,-71.045159,'Canada',2008,'https://cms-images.cominar.com/convert?key=mDCrU%2BvMgyHVg61WaVrX5C2BQk7xaSZvP3brZ8xJtrFBxxzYK%2F0HwHw%2Bq0oIGg2K&nocrop=true&quality=90&stripmeta=true&type=jpeg&url=https%3A%2F%2Fcms-assets.cominar.com%2Fcominar-website-api-assets%2Fcms%2FQK8JAotYZ5Aw1LIPylwFaQ.jpg','http://www.lavoiemaltee.com/','publavoiemaltee@hotmail.com','418-549-4141','https://www.facebook.com/voiemaltee','http://www.ratebeer.com/brewers/la-voie-maltee/3253/','https://untappd.com/w/la-voie-malt-e/10366','https://www.aumenu.info/la-voie-maltee-chicoutimi/','?'),
    (4,'Brasseur du moulin','991, rue Richelieu - suite 101 et 102','BELOEIL','J3G 4P8','Québec',45.569724,-73.199197,'Canada',2015,'https://www.tourisme-monteregie.qc.ca/wp-content/uploads/member/810/20191029145656-dsc-5477-78-79-80-81.jpg','http://brasseursdumoulin.com/','info@brasseursdumoulin.com','450-527-1133','https://www.facebook.com/brasseursdumoulin/','http://www.ratebeer.com/brewers/brasseurs-du-moulin/25223/','https://untappd.com/w/brasseurs-du-moulin/209204','https://www.aumenu.info/brasseurs-du-moulin/','https://www.instagram.com/brasseursdumoulin/'),
    (5,'Noctem Artisans Brasseurs','438, RUE DU PARVIS','Québec','G1K 6H8','Québec',46.81409,-71.223395,'Canada',2015,'http://monsaintroch.com/wp-content/anciensmedias/msr/2015/11/1082498-noctem-pose-ancien-yuzu-saint.jpg','http://www.noctem.ca/','info@noctem.ca','581-742-7979','https://www.facebook.com/noctemartisansbrasseurs','http://www.ratebeer.com/brewers/noctem-artisans-brasseurs/24901/','https://untappd.com/NoctemArtisansBrasseurs','https://www.aumenu.info/noctem-artisans-brasseurs/','https://www.instagram.com/noctem.artisans.brasseurs/'),
    (6,'Korrigane','380, RUE DORCHESTER','Québec','G1K 6A7','Québec',46.813801,-71.226946,'Canada',2010,'https://www.quebec-cite.com/sites/otq/files/styles/gallery_desktop/public/simpleview/_MG_5875_4305CD25-1B6E-4099-8F2C09741608A979_277583b0-c42b-4905-ba8b7638ea3d8335.jpg?itok=UZCF54cV','http://www.korrigane.ca/','info@korrigane.ca','418-614-0932','https://www.facebook.com/LaKorrigane','http://www.ratebeer.com/brewers/la-korrigane/5995/','https://untappd.com/w/brasserie-la-korrigane/12734','https://www.aumenu.info/brasserie-artisanale-la-korrigane/','?'),
    (7,'Microbrasserie le coureur des bois','1551, boulevard Wallberg','Dolbeau-Mistassini','G8L 1H5','Québec',48.883188,-72.233521,'Canada',2011,'https://microlecoureurdesbois.com/app/uploads/2018/06/boutique_interieur_coureur_des_bois-855x565.jpg','http://www.lecoureurdesbois.com/','lecoureurdesbois.com@gmail.com','418-979-1197','https://www.facebook.com/lecoureurdesbois','http://www.ratebeer.com/brewers/microbrasserie-le-coureur-des-bois/14045/','https://untappd.com/w/microbrasserie-le-coureur-des-bois/20682','https://www.aumenu.info/microbrasserie-le-coureur-des-bois-b/','?'),
    (8,'Microbrasserie La Boite à malt','585, route 116 - local 402','Saint-Nicolas','G7A 2P6','Québec',46.711315,-71.290112,'Canada',2014,'https://static.wixstatic.com/media/f0b10a_1525d2f1694e4f26bfe6b9b9e223ddf7~mv2.jpg/v1/fill/w_560,h_420,al_c,q_80,usm_0.66_1.00_0.01/BAM-StNic-inte%C3%8C%C2%81rieur.webp','http://www.boiteamalt.com/','info@boiteamalt.com','418-836-1000','https://www.facebook.com/boiteamalt/?fref=ts','http://www.ratebeer.com/brewers/microbrasserie-la-boite-a-malt/18787/','https://untappd.com/BoiteaMalt','https://www.aumenu.info/microbrasserie-la-boite-a-malt/','?'),
    (9,'Brasserie artisanale L''Amère à boire','2049, rue Saint-Denis','Montréal','H2X 3K9','Québec',45.516375,-73.566117,'Canada',1996,'https://bieresetplaisirs.com/wp-content/uploads/2020/06/102717213_3274725145891356_4891663694167379000_o-1-1024x611.jpg','http://www.amereaboire.com/','info@amereaboire.com','514-282-7448','https://www.facebook.com/amereaboire','http://www.ratebeer.com/brewers/lamere-a-boire/912/','https://untappd.com/w/lamere-a-boire/6335','https://www.aumenu.info/brasserie-artisanale-lamere-a-boire-b/','X'),
    (10,'Brasserie Dieu du ciel','29, rue Laurier Ouest','Montréal','H2T 2N2','Québec',45.522515,-73.5933,'Canada',1998,'https://media.tastet.ca/2018/10/dieu-du-ciel-microbrasserie-montreal-03-1024x683.jpg','http://www.dieuduciel.com/','info@dieuduciel.com','514-490-9555','https://www.facebook.com/BrasserieDieuduCiel/','http://www.ratebeer.com/brewers/dieu-du-ciel/364/','https://untappd.com/w/brasserie-dieu-du-ciel/1674','https://www.aumenu.info/dieu-du-ciel-montreal/','https://www.instagram.com/brasseriedieuduciel/'),
    (11,'Brasserie artisanale la Souche','801, chemin de la Canardière','Québec','G1J 2B8','Québec',46.828713,-71.225838,'Canada',2011,'https://lh3.googleusercontent.com/proxy/ir67bPwui-46pUgWCF01McESeqEwCRfTXt1lWOHNj8yI-wcVy4d3wro7zzKbNlNlW8FC9DCw9ykg33o38MlpOBtDxW9GcFE5GKkzeb33Gpwac1w','http://www.lasouche.ca/','info@lasouche.ca','581-742-1144','https://www.facebook.com/brasserieartisanalelasouche','http://www.ratebeer.com/brewers/la-souche/15628/','https://untappd.com/LaSoucheBrasserieArtisanale','https://www.aumenu.info/la-souche/','?'),
    (12,'La Barberie','310, rue Saint-Roch','Québec','G1K 6S2','Québec',46.818009,-71.218074,'Canada',1997,'https://imagesvc.meredithcorp.io/v3/mm/image?q=85&c=sc&poi=face&url=https%3A%2F%2Fcdn-image.travelandleisure.com%2Fsites%2Fdefault%2Ffiles%2F1473891883%2Fla-barberie-quebec-city-qc0916.jpg','http://www.labarberie.com/','info@labarberie.com','418-522-4373','https://www.facebook.com/labarberie','http://www.ratebeer.com/brewers/la-barberie/906/','https://untappd.com/LaBarberie','https://www.aumenu.info/la-barberie/','https://www.instagram.com/barberie/'),
    (13,'Archibald Microbrasserie','1021, boulevard DU Lac, Local 200','Lac-Beauport','G0A 2C0','Québec',46.944234,-71.296792,'Canada',2005,'https://media-cdn.tripadvisor.com/media/photo-s/07/95/b0/cc/archibald-microbrasserie.jpg','http://www.archibaldmicrobrasserie.ca/','info@archibaldmicrobrasserie.ca','418-841-2224','https://www.facebook.com/ArchibaldMicrobrasserieQC','http://www.ratebeer.com/brewers/microbrasserie-archibald-ab-inbev/5994/','https://untappd.com/Archibaldmicrobrasserie','https://www.aumenu.info/archibald-microbrasserie-bh/','https://www.instagram.com/archibaldmicrobrasserie/'),
    (14,'Les Brasseurs du Nord','875, boulevard Michèle-Bohec','Blainville','J7C 5J6','Québec',45.663306,-73.887209,'Canada',1988,'https://www.infopresse.com/Uploads/images/Article/Body/Boreale_lg2_Relais_04_15032018.jpg','http://www.boreale.com/','info@boreale.com','450-979-8400','https://www.facebook.com/pages/Les-Brasseurs-du-Nord/109394965745163','http://www.ratebeer.com/brewers/brasseurs-du-nord/335/','https://untappd.com/LesBrasseursduNord','https://www.aumenu.info/les-brasseurs-du-nord-boreale-b/','https://www.instagram.com/biereboreale/');

-- Beers
INSERT INTO Beers VALUES
    (0,'La Double Malheur','IPA',8.0,6.50,500,0,'https://untappd.akamaized.net/photos/2021_02_13/9bcc733215fcc3b6b52e87e4351ab8fd_640x640.jpg'),
    (1,'Darth Lager','Noire',6.9,12.00,750,0,'https://untappd.akamaized.net/photo/2020_01_17/d3f8b26d7736ec032831a0e8e942d9ad_c_855692285_640x640.jpg'),
    (2,'Zwickelbier','Blonde',4.9,5.50,500,0,'https://untappd.akamaized.net/photos/2021_02_22/a2b0087f91edbab7e8f0abb270e98f92_640x640.jpeg'),
    (3,'Une Prune','Blonde',5.3,12.00,750,0,'https://untappd.akamaized.net/photos/2021_02_28/0b613b731db2acc3cdb9cff444ddf272_640x640.jpg'),
    (4,'TI-POP','IPA',6.0,5.50,500,0,'https://untappd.akamaized.net/photos/2019_12_01/72cb363354934059e1081cdeea644632_640x640.jpg'),
    (5,'Framboise','Ale',6.5,12.00,750,0,'https://untappd.akamaized.net/photos/2020_12_24/00381a5c7fedc061e85a2cbc6ecd1321_640x640.jpg'),
    (6,'La Sour Soif','Blonde',3.9,8.00,750,0,'https://untappd.akamaized.net/photos/2020_09_21/2c3fa8c96fb29445bf18ad429bf91ce6_640x640.jpg'),
    (7,'Ponette Argousier','Blonde',6.9,14.50,750,0,'https://untappd.akamaized.net/photos/2020_12_16/186cbcac0bbf2f2f4a22a7b2a8d87f25_640x640.jpg'),
    (8,'Saison Barriquée à l''Hibiscus','Blonde',5.5,14.50,750,0,'https://untappd.akamaized.net/photos/2021_02_14/f168c76d10e83837e319a9263a6e3590_640x640.jpg'),
    (9,'La Pêche','Blonde',5.0,12.00,750,0,'https://untappd.akamaized.net/photos/2021_01_22/2a4374b449d7f8a66a94f2f8675b4842_640x640.jpg'),
    (10,'Brut IPA','IPA',7.4,12.00,750,0,'https://untappd.akamaized.net/photos/2020_11_13/0d5b167e01587e13ef07560fc2e805bf_640x640.jpeg'),
    (11,'Lapsus','Brune',6.6,8.25,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1587147258862-S33RRI9LX66K57866M85/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpzAFzFJoCInLPKyj9AG8yKe7-Q2aFvP177fkO9TY_-rz5WoqqTEZpmj4yDEOdwKV68/te%25CC%2581le%25CC%2581chargement%2B%25283%2529.jpg?format=750w'),
    (12,'Canular','Noire',5.1,9.57,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1603738544247-IAVCWIOO08JIFFJNS02M/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwkCFOLgzJj4yIx-vIIEbyWWRd0QUGL6lY_wBICnBy59Ye9GKQq6_hlXZJyaybXpCc/Bouteille+Canular.png?format=750w'),
    (13,'Maltéhops 5','Brune',6.6,7.75,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1604084947758-LVEGGJ27UKFNOXJW7VD0/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwkCFOLgzJj4yIx-vIIEbyWWRd0QUGL6lY_wBICnBy59Ye9GKQq6_hlXZJyaybXpCc/Bouteille+Malt%C3%A9hops+5.png?format=750w'),
    (14,'Passori','Pale Ale',6.7,8.83,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1590093078366-QECRYVK90I9S972H8U2B/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwkCFOLgzJj4yIx-vIIEbyWWRd0QUGL6lY_wBICnBy59Ye9GKQq6_hlXZJyaybXpCc/passori.png?format=750w'),
    (15,'Magnalux','Pale Ale',5.5,7.87,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1611070737786-RJ6TUVJCPV7TJBW3V3BJ/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwkCFOLgzJj4yIx-vIIEbyWWRd0QUGL6lY_wBICnBy59Ye9GKQq6_hlXZJyaybXpCc/magnalux2020.png?format=750w'),
    (16,'Nébulose','Pale Ale',6.9,6.59,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1603738403268-KHPMQ7LQ46QYP4B3GLCP/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwkCFOLgzJj4yIx-vIIEbyWWRd0QUGL6lY_wBICnBy59Ye9GKQq6_hlXZJyaybXpCc/Bouteille+Nebulose.png?format=750w'),
    (17,'Chronique de mai','Pale Ale',5.5,8.98,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1603382553884-Z6CXRMCDHRMT9BVDHGTS/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwkCFOLgzJj4yIx-vIIEbyWWRd0QUGL6lY_wBICnBy59Ye9GKQq6_hlXZJyaybXpCc/Bouteille+Chronique+de+Mai.png?format=750w'),
    (18,'Chronique de mars','Pale Ale',7,8.83,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1592598127460-3IFEGT5O1FYTGSQKQYT5/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwkCFOLgzJj4yIx-vIIEbyWWRd0QUGL6lY_wBICnBy59Ye9GKQq6_hlXZJyaybXpCc/Chronique+de+Mars.png?format=750w'),
    (19,'Grande Armada 2018 réserve','Brune',10.1,8.14,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1603739556312-PPZHM19ABMEHCU6XG1B5/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwkCFOLgzJj4yIx-vIIEbyWWRd0QUGL6lY_wBICnBy59Ye9GKQq6_hlXZJyaybXpCc/Bouteille+Gr+Armada+2018.png?format=750w'),
    (20,'Grande Armada 2019 réserve','Brune',10.1,9.45,500,1,'https://images.squarespace-cdn.com/content/v1/5e78aeb60317543ce8f4aaef/1603739441842-FZQGMYFUX8KTQSIA106O/ke17ZwdGBToddI8pDm48kAf-OpKpNsh_OjjU8JOdDKBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwkCFOLgzJj4yIx-vIIEbyWWRd0QUGL6lY_wBICnBy59Ye9GKQq6_hlXZJyaybXpCc/Bouteille+Gr+Armada+2019.png?format=750w'),
    (21,'Hutchie Blondie','IPA',7.0,8.44,750,2,'https://storage.googleapis.com/ueat-assets/d12e7879-e625-424f-b36b-2002013a8891.png'),
    (22,'James et la pêche Niagara','Blonde',5.7,10.18,750,2,'https://storage.googleapis.com/ueat-assets/6f4c2748-23ec-409a-ab83-798a35dd2a0a.png'),
    (23,'Hutchie Frutti','IPA',6.2,8.44,750,2,'https://storage.googleapis.com/ueat-assets/ec1e0911-bd51-425d-8b39-8a7546645d33.png'),
    (24,'La Bamba','Blonde',8.5,8.44,750,2,'https://storage.googleapis.com/ueat-assets/7945ce92-f510-4e32-ab5f-d22858817540.png'),
    (25,'Ginger B','IPA',4.8,8.44,750,2,'https://storage.googleapis.com/ueat-assets/1b03bed0-59ea-4aab-a5de-6c3d3a58a2e8.png'),
    (26,'Rouler su'' l''Or','IPA',5.5,8.44,750,2,'https://storage.googleapis.com/ueat-assets/a2d3b86f-eee0-4b96-b36f-4542044cc20d.png'),
    (27,'La Libertine','Blonde',4.0,3.29,473,3,'https://univerre.beer/wp-content/uploads/2018/10/laVoieMaltee-laLibertine_web04.jpg'),
    (28,'L''Ambigue','Rousse',4.5,3.29,473,3,'https://univerre.beer/wp-content/uploads/2017/11/laVoieMaltee-ambigue_web02.jpg'),
    (29,'La Malcommode','Blanche',4.6,3.29,473,3,'https://univerre.beer/wp-content/uploads/2018/10/laVoieMaltee-laMalcommode_web01.jpg'),
    (30,'La Faisant-Malt','Pale Ale',5.2,3.29,473,3,'https://univerre.beer/wp-content/uploads/2018/10/laVoieMaltee-laFaisantMalt_web01.jpg'),
    (31,'La Racoleuse','IPA',6.2,3.29,473,3,'https://univerre.beer/wp-content/uploads/2019/10/laVoieMaltee-laRacoleuse_web03.jpg'),
    (32,'La Soutien-Gorge','IPA',8.2,5.49,473,3,'https://cdn.shopify.com/s/files/1/0505/7026/4755/products/Voiemaltee_Soutien-Gorge-5_1800x1800.jpg?v=1606069468'),
    (33,'La Graincheuse','Ambrée',8.5,6.29,473,3,'https://univerre.beer/wp-content/uploads/2018/10/laVoieMaltee-laGraincheuse_web01.jpg'),
    (34,'La Criminelle','Noire',9.5,6.29,473,3,'https://univerre.beer/wp-content/uploads/2018/10/laVoieMaltee-laCriminelle_web01.jpg'),
    (35,'La Polissonne','Rousse',10.0,6.29,473,3,'https://univerre.beer/wp-content/uploads/2018/10/laVoieMaltee-laPolissonne_web01.jpg'),
    (36,'Jenny-Amelanches et Litchi','Ambrée',5.0,10.44,950,4,'https://storage.googleapis.com/ueat-assets/e7c6970f-7d74-4ef4-b80d-96dc6e51287d.jpg'),
    (37,'L''Acéphale','Blonde',6.0,10.44,950,4,'https://storage.googleapis.com/ueat-assets/5797bb33-9328-4e67-8f8d-f3327c5492ee.jpg'),
    (38,'La Matsi','Ambrée',4.6,10.44,950,4,'https://storage.googleapis.com/ueat-assets/57437423-39bc-4d81-8670-e27acdbf0bbc.jpg'),
    (39,'Douce Caroline','Blonde',5.0,10.44,950,4,'https://storage.googleapis.com/ueat-assets/3ddaf0e0-f841-42cc-88b1-912bf0792603.jpg'),
    (40,'Sir Gallery','Blonde',3.7,10.44,950,4,'https://storage.googleapis.com/ueat-assets/0db45a26-2850-4952-9211-55a8906b5739.jpg'),
    (41,'Mlle Mathilde','Rousse',5.0,10.44,950,4,'https://storage.googleapis.com/ueat-assets/11292c1f-27cd-4cb5-9545-97ffb3ec3d96.jpg'),
    (42,'La Trafalgar','IPA',5.6,10.44,950,4,'https://storage.googleapis.com/ueat-assets/9e47ad40-bbb9-425d-83a5-a8a7965f1036.jpg'),
    (43,'Micro Morgan','IPA',5.0,10.44,950,4,'https://storage.googleapis.com/ueat-assets/746c38a6-6325-4285-9696-25bb2e2f3baf.jpg'),
    (44,'La Carcajou Moqueur','Pale Ale',8.5,17.40,950,4,'https://storage.googleapis.com/ueat-assets/f71994ac-6f06-4676-bd61-014468343813.jpg'),
    (45,'Richelieu Frappée','Pale Ale',4.3,10.44,950,4,'https://storage.googleapis.com/ueat-assets/ceb5417c-e6ba-4f16-944e-eebf3d452f42.jpg'),
    (46,'ECCE CATTUS','IPA',6.5,5.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/image0_MODIF_900x.jpg?v=1616075749'),
    (47,'SÉRÉNITÉ','Blonde',5.0,4.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/DSCF6497_2_900x.jpg?v=1606426369'),
    (48,'CATNIP','IPA',7.5,5.29,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/RSNJ8668_900x.jpg?v=1588865477'),
    (49,'HOP RUSH','IPA',4.5,4.79,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/GBTA6088_900x.jpg?v=1588865409'),
    (50,'HERBOSOPHIE','Pale Ale',6.0,4.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/YDZQ7513_900x.jpg?v=1588873623'),
    (51,'OSKAR KMS BISMARCK','IPA',7.0,5.29,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/KZFX9331_900x.jpg?v=1588867064'),
    (52,'OSKAR HMS COSSACK','IPA',7.0,5.29,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/DXNB0756_900x.jpg?v=1588867188'),
    (53,'OSKAR HMS ARK ROYAL','IPA',7.0,5.29,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/HJYG6639_900x.jpg?v=1588867381'),
    (54,'HUMULUS FELIDAE','IPA',6.5,5.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/EGYI2303_2e741230-9a05-451c-81cd-dce98b12afa5_900x.jpg?v=1590079104'),
    (55,'OLD SCHOOL','IPA',7.0,4.99,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/NWEE0146_900x.jpg?v=1588871099'),
    (56,'PACHACAMAC','IPA',8.0,5.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/DADT9661_900x.jpg?v=1588865586'),
    (57,'WAÏNA','IPA',8.0,5.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/image0_8_900x.jpg?v=1608316568'),
    (58,'DOUBLE CATNIP','IPA',9.0,5.79,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/121019050_2071559212976839_1737958930221643042_n_900x.jpg?v=1602010365'),
    (59,'MOSAÏQUE','IPA',9.0,5.79,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/image0_3_900x.jpg?v=1615481521'),
    (60,'FELIS NIGRIPES','IPA',4.0,4.79,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/121016666_638925110319309_3201113328139346208_n_900x.jpg?v=1602010667'),
    (61,'LA NUIT...','Blanche',5.5,4.99,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/IMG_6500_900x.jpg?v=1614187344'),
    (62,'PATTE DE VELOURS','Pale Ale',5.5,4.99,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/IMG_6508_2_900x.jpg?v=1611855514'),
    (63,'HELIA','Blanche',5.0,4.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/NECD9250_900x.jpg?v=1588875698'),
    (64,'SURICAT FRAMBOISE','Rousse',4.5,5.79,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/XSLZ1892_900x.jpg?v=1588867471'),
    (65,'CALACA','IPA',3.5,4.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/DQIK7169_900x.jpg?v=1605734184'),
    (66,'HOPPY PEACH','IPA',6.5,5.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/image2_1_6f25c16e-69a2-4954-8fa1-a11938110118_900x.jpg?v=1593287808'),
    (67,'BRAVE MARGOT','IPA',6.5,5.49,473,5,'https://cdn.shopify.com/s/files/1/0263/1263/8500/products/IMG_6504_900x.jpg?v=1613749504'),
    (68,'Amaruq','Blonde',5.0,10.00,1000,6,'https://www.maturin.ca/image/thumbnail/17957/600/600'),
    (69,'Croquemitaine DC','Blonde',8.5,14.00,1000,6,'https://www.maturin.ca/image/thumbnail/17957/600/600'),
    (70,'Korrigane','Blonde',5.5,10.00,1000,6,'https://www.maturin.ca/image/thumbnail/17957/600/600'),
    (71,'Malgven','Blonde',9.0,14.00,1000,6,'https://www.maturin.ca/image/thumbnail/17957/600/600'),
    (72,'La Récolte','Blonde',5.5,12.00,1000,6,'https://www.maturin.ca/image/thumbnail/17957/600/600'),
    (73,'EXP 1070','Blonde',5.5,10.00,1000,6,'https://www.maturin.ca/image/thumbnail/17957/600/600'),
    (74,'Session black Kraken','Blonde',4.0,10.00,1000,6,'https://www.maturin.ca/image/thumbnail/17957/600/600'),
    (75,'Amphibie','IPA',6.0,4.50,473,7,'https://instagram.flwo4-2.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s640x640/128457298_136880064860618_1152552422181502450_n.jpg?tp=1&_nc_ht=instagram.flwo4-2.fna.fbcdn.net&_nc_cat=102&_nc_ohc=qY7I-BQ5JlYAX-vPcs4&ccb=7-4&oh=5823f1a7fe5e980cc3345e3514281346&oe=607F98AD&_nc_sid=d997c6'),
    (76,'Butineuse','Blanche',7.5,6.50,500,7,'https://untappd.akamaized.net/photos/2020_10_25/a718d61fdaf8b330c104f18566eda25e_640x640.jpg'),
    (77,'Flamboyante','Blanche',8.2,5.60,500,7,'https://untappd.akamaized.net/photos/2020_08_23/bc242e4b7b8bcd3f45e9bd32e47b3fdd_640x640.jpg'),
    (78,'Harfang','Noire',4.5,4.50,473,7,'https://instagram.flwo4-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.135.1080.1080a/s640x640/66408522_123276245624381_7841225862616118565_n.jpg?tp=1&_nc_ht=instagram.flwo4-1.fna.fbcdn.net&_nc_cat=105&_nc_ohc=AgXByfosSNkAX_tdcY0&ccb=7-4&oh=3ef25e3dbfeb0a19c4ac172d53fed3e1&oe=607D6581&_nc_sid=d997c6'),
    (79,'Jaseuse aux bleuets','Rousse',5.0,6.50,500,7,'https://instagram.flwo4-2.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.180.1440.1440a/s640x640/117327924_112220397130214_6389324500464705253_n.jpg?tp=1&_nc_ht=instagram.flwo4-2.fna.fbcdn.net&_nc_cat=102&_nc_ohc=-nKbrlzSDI8AX_n9vb5&ccb=7-4&oh=7d037a50ba558d8896178f5b0c4daa1f&oe=607F3A6A&_nc_sid=d997c6'),
    (80,'Lumineuse','Blonde',5.9,5.00,473,7,'https://instagram.fhrk5-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s640x640/120144808_2438257149801731_3725073722340102366_n.jpg?tp=1&_nc_ht=instagram.fhrk5-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=uUo5-B-nfQYAX-6SmjS&ccb=7-4&oh=c36329fd295b8b9f24cd2dd844ba05e7&oe=607FCA42&_nc_sid=d997c6'),
    (81,'Lynx','Blonde',5.0,4.50,473,7,'https://instagram.fhrk5-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.135.1080.1080a/s640x640/67425478_510949809653783_5238969305639272997_n.jpg?tp=1&_nc_ht=instagram.fhrk5-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=w6ogSwFqzewAX9oY_hx&ccb=7-4&oh=cd602b0e96aab4c83f3e7ef67b22f694&oe=607D853A&_nc_sid=d997c6'),
    (82,'Migratrice','Blanche',6.2,6.50,500,7,'https://www.nouvelleshebdo.com/wp-content/uploads/sites/41/2019/04/ACT-Micro-t3.jpg'),
    (83,'Ourse Noire','Noire',5.0,5.20,473,7,'https://instagram.flwo4-2.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c135.0.810.810a/s640x640/49527682_2196564487056840_8090757549407667708_n.jpg?tp=1&_nc_ht=instagram.flwo4-2.fna.fbcdn.net&_nc_cat=100&_nc_ohc=uHawX1M6wmcAX-3viAY&ccb=7-4&oh=6798c87b18b41bfe3c9da3a57c18ac16&oe=607CDBBE&_nc_sid=d997c6'),
    (84,'Rampante','Blanche',3.4,5.00,500,7,'https://untappd.akamaized.net/photos/2020_06_28/8ab2ce912c44d714db31759a1c030a13_640x640.jpg'),
    (85,'Renard','Rousse',5.0,4.50,473,7,'https://instagram.flwo4-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.162.1440.1440a/s640x640/129072991_406753080445569_1095820358725599699_n.jpg?tp=1&_nc_ht=instagram.flwo4-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=mFjJDmgJwT0AX-352YX&ccb=7-4&oh=da0310031c3d87bd91f71133360b14d2&oe=607CA1A2&_nc_sid=d997c6'),
    (86,'Blanche des Rivières','Blanche',5.0,4.40,473,8,'https://untappd.akamaized.net/photos/2021_01_16/e20a9f13620cbb0ead0c84795674a40c_640x640.jpg'),
    (87,'Torremondo','Noire',5.4,4.90,473,8,'https://untappd.akamaized.net/photos/2021_02_03/06f99a709c462085cffe83f9662be777_640x640.jpg'),
    (88,'Gros ours','Rousse',5.0,4.40,473,8,'https://untappd.akamaized.net/photos/2020_12_25/851094fedbcb9cb9f829074d8c473816_640x640.jpg'),
    (89,'Tomahawk','IPA',6.5,4.40,473,8,'https://untappd.akamaized.net/photos/2021_03_06/0ed5b52957e175730272459604014ef7_640x640.jpg'),
    (90,'Sépia','Brune',6.3,4.90,473,8,'https://untappd.akamaized.net/photos/2020_08_20/13259e7881be38bab312dc4e217f1825_640x640.jpg'),
    (91,'Pitmaster','IPA',5.5,4.90,473,8,'https://untappd.akamaized.net/photo/2020_12_25/54d3ddfdf1bf42bf6d9d3e33330dcb8f_c_979499605_640x640.jpg'),
    (92,'FPS 30','IPA',3.8,4.90,473,8,'https://untappd.akamaized.net/photos/2021_01_23/bffda0f7efc98403d4aa91a9292f8b31_640x640.jpg'),
    (93,'FPS 45','IPA',7.5,5.20,473,8,'https://untappd.akamaized.net/photos/2020_12_15/cf0b9373155998938a6160bdeef9f57d_640x640.jpg'),
    (94,'FPS 60','IPA',8.5,5.50,473,8,'https://untappd.akamaized.net/photos/2021_03_03/271584fc0f8e8ca1c207f8c1dd6013bf_640x640.jpeg'),
    (95,'Manche courte','IPA',5.0,5.20,473,8,'https://untappd.akamaized.net/photos/2021_02_08/749db191be0b42b5ddf536705fb7e279_640x640.jpeg'),
    (96,'Saison Trouble','Pale Ale',6.66,5.20,473,8,'https://untappd.akamaized.net/photos/2021_01_30/189063123582e4f30a7f35242e30c5ea_640x640.jpg'),
    (97,'Boite à lunch','Blonde',4.8,4.40,473,8,'https://untappd.akamaized.net/photos/2021_01_29/41c5f6043b1732a066ba529f1d12aa1d_640x640.jpg'),
    (98,'Mousqueton','IPA',6.5,4.90,473,8,'https://untappd.akamaized.net/photos/2021_02_28/8f640a244dd76010f02c001eb60982c3_640x640.JPG'),
    (99,'Highlander','Rousse',7.8,5.20,473,8,'https://untappd.akamaized.net/photos/2021_02_20/d9d8d6e564f1bf40b5ea1243a1f9df88_640x640.jpg'),
    (100,'Prêtre Orignal','Brune',4.5,4.40,473,8,'https://untappd.akamaized.net/photo/2021_01_03/0e4c76677477d46042d9d5e159b821de_c_983856318_640x640.jpg'),
    (101,'Boulzaille','Pale Ale',5.0,4.40,473,8,'https://untappd.akamaized.net/photos/2021_02_16/66fa70cac154e14461306410a58a4cbe_640x640.jpg'),
    (102,'Pale ale','Pale Ale',8.5,5.25,473,9,'https://amereaboire.com/wp-content/uploads/2021/01/IMG_9174-e1610647427404-132x300.jpg'),
    (103,'Montreal Hell','Blonde',5,5.25,473,9,'https://res.cloudinary.com/ratebeer/image/upload/w_250,c_limit/beer_34032.jpg'),
    (104,'Cerna','Blonde',5,5.25,473,9,'https://boutique.experience-biere.com/i/L-amere-a-boire-Cerna-4175.jpg'),
    (105,'Jarret Le prof','Rousse',5,5.25,473,9,'https://untappd.akamaized.net/photos/2020_12_06/9a4a6bf27ecbbd83ed5044522a79e4ba_640x640.jpg'),
    (106,'Kazbek','Pale Ale',5.5,5.25,473,9,'https://boutique.experience-biere.com/i/L-amere-a-boire-Kazbek-4173.jpg'),
    (107,'Drak','Rousse',6.2,5.25,473,9,'https://boutique.experience-biere.com/i/L-amere-a-boire-Drak-4170.jpg'),
    (108,'Stout Impérial','Noire',8.5,7.45,473,9,'https://untappd.akamaized.net/photos/2021_02_10/33a571fb963a6ba48553c4cba841aaa6_640x640.jpg'),
    (109,'Blanche neige','Blanche',8.3,6.54,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/BlancheNeige_verre_480.jpg'),
    (110,'APHRODISIAQUE','Noire',6.5,7.23,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/aphrodisiaque_verre_480.jpg'),
    (111,'Aphro Rhum','Noire',6.5,6.87,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/AphroRhum_web_verre_480.jpg'),
    (112,'Sentinelle','Rousse',5.1,7.23,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/Sentinelle_480.jpg'),
    (113,'Disco soleil','Blonde',6.5,6.90,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/DiscoSoleil_480.jpg'),
    (114,'Pêché mortel','Rousse',9.5,8,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/peche_mortel_480.jpg'),
    (115,'Moralité','IPA',6.9,7.56,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/moralite_480.jpg'),
    (116,'Saison du parc','Lien',4.2,7.34,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/SaisonParc_480.jpg'),
    (117,'Ultra mosaika','Pale Ale',5.4,7.34,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/UltraMosaika_480.jpg'),
    (118,'Solstice d''hiver','Rouge',10.2,8.43,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/SolsticeHiver_momentum_480.jpg'),
    (119,'Solstice d''été','Blonde',5.9,7.34,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/SolsticeEteFramboises_480.jpg'),
    (120,'Hérétique','IPA',7,7.34,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/HeretiqueBlonde-Web.jpg'),
    (121,'Brise-vent','Blanche',6.5,7.34,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/BriseVent_480.jpg'),
    (122,'Wild ultra','Pale Ale',6,7.65,341,10,'https://dieuduciel.com/wp-content/uploads/2020/03/WildUltra_480.jpg'),
    (123,'Petit détour','IPA',6.5,7.41,341,10,'https://dieuduciel.com/wp-content/uploads/2018/09/PetitDetourVinRouge_480.jpg'),
    (124,'Gros pin','Rousse',5,5.45,473,11,'https://foretdesaveurs.ca/assets/images/beers/gros-pin.png'),
    (125,'Jacki Dun','IPA',4,5.45,473,11,'https://foretdesaveurs.ca/assets/images/beers/jackie-dunn.png'),
    (126,'Limoilou Beach','Rousse',6.5,5.45,473,11,'https://foretdesaveurs.ca/assets/images/beers/limoilou-beach.png'),
    (127,'La canardière','IPA',7,5.45,473,11,'https://foretdesaveurs.ca/assets/images/beers/la-canardiere.png'),
    (128,'Limoiloise','Pale Ale',5,5.45,473,11,'https://foretdesaveurs.ca/assets/images/beers/limoiloise.png'),
    (129,'Franc Bois','Blanche',4.5,5.45,473,11,'https://foretdesaveurs.ca/assets/images/beers/franc-bois.png'),
    (130,'Saint-Charles','Brunne',3.5,5.45,473,11,'https://foretdesaveurs.ca/assets/images/beers/saint-charles.png'),
    (131,'Franc Bois d''hiver','Blanche',8.5,6.34,473,11,'https://foretdesaveurs.ca/assets/images/beers/franc-bois-hiver.png'),
    (132,'Tordeuse impérial','IPA',9,6.34,473,11,'https://foretdesaveurs.ca/assets/images/beers/tordeuse-imperiale.png'),
    (133,'Triple Limoiloise','IPA',11,6.34,473,11,'https://foretdesaveurs.ca/assets/images/beers/triple-limoiloise.png'),
    (134,'Avec pas de vanille','IPA',5.8,5.34,473,12,'https://www.labarberie.com/wp-content/uploads/2021/03/avec-pas-de-vanille-mockup.png'),
    (135,'Ogunquit','IPA',6.5,5.34,473,12,'https://www.labarberie.com/wp-content/uploads/2021/03/ogunquit3000-mockup.png'),
    (136,'Pourpre profond','Blanche',5,5.34,473,12,'https://www.labarberie.com/wp-content/uploads/2021/02/pourpre-profond-mockup.png'),
    (137,'Placebo','Blanche',0.5,5.34,473,12,'https://www.labarberie.com/wp-content/uploads/2021/02/placebo-mockup.png'),
    (138,'Sure au fambroise','Blanche',6,5.65,473,12,'https://www.labarberie.com/wp-content/uploads/2020/09/sure-aux-framboises-mockup.png'),
    (139,'Mégafruits Raptor','Blanche',5.2,5.34,473,12,'https://www.labarberie.com/wp-content/uploads/2020/09/megafruits-raptor-mockup.png'),
    (140,'Rousse anglaise','Rousse',4.5,5.34,473,12,'https://www.labarberie.com/wp-content/uploads/2020/09/rousse-anglaise-mockup.png'),
    (141,'Blanche aux mûres','Blanche',4.9,5.35,473,12,'https://www.labarberie.com/wp-content/uploads/2020/09/blanche-aux-mures-mockup.png'),
    (142,'Grande oasis','IPA',8,5.36,473,12,'https://www.labarberie.com/wp-content/uploads/2020/09/grande-oasis-mockup.png'),
    (143,'Pale ale lime framboise','Pale Ale',5,5.37,473,12,'https://www.labarberie.com/wp-content/uploads/2020/09/pale-ale-lime-framboises-mockup.png'),
    (144,'Blonde au chardonnay','Blonde',10,5.38,473,12,'https://www.labarberie.com/wp-content/uploads/2020/09/blonde-chardo-mockup.png'),
    (145,'Josée Galaxy','IPA',6,5.38,473,12,'https://www.labarberie.com/wp-content/uploads/2020/08/josee-galaxy-canette.png'),
    (146,'Blonde biologique','Blonde',4.5,5.38,473,12,'https://www.labarberie.com/wp-content/uploads/2020/09/blonde-bio-mockup.png'),
    (147,'Cuivrée au thé','Blanche',5,5.38,473,12,'https://www.labarberie.com/wp-content/uploads/2020/09/cuivre-au-the-mockup.png'),
    (148,'Chipie','Rousse',5.5,5.67,473,13,'https://d2x42bnn0tswa4.cloudfront.net/archibald-web-v2/uploads/beer/can_and_glass_image_fr/2/Chipie_canette_473ml_Verre.png'),
    (149,'Matante','Blonde',4.9,5.67,473,13,'https://d2x42bnn0tswa4.cloudfront.net/archibald-web-v2/uploads/beer/can_and_glass_image_fr/3/Matante_canette_473ml.png'),
    (150,'Joufflue','Blanche',4.2,5.87,473,13,'https://d2x42bnn0tswa4.cloudfront.net/archibald-web-v2/uploads/beer/can_and_glass_image_fr/4/Joufflue_canette_473ml-Verre.png'),
    (151,'Ciboire','Blonde',6,5.87,473,13,'https://d2x42bnn0tswa4.cloudfront.net/archibald-web-v2/uploads/beer/can_and_glass_image_fr/5/Ciboire_canette_473ml-Verre.png'),
    (152,'Brise du lac','Blonde',4.8,5.87,473,13,'https://d2x42bnn0tswa4.cloudfront.net/archibald-web-v2/uploads/beer/can_and_glass_image_fr/6/Brise_canette_473ml-Verre.png'),
    (153,'Valkyrie','Rousse',7,5.87,473,13,'https://d2x42bnn0tswa4.cloudfront.net/archibald-web-v2/uploads/beer/can_and_glass_image_fr/1/Valkyrie_canette_437-Verre.png'),
    (154,'Nuit blanche','IPA',6,5.87,473,13,'https://d2x42bnn0tswa4.cloudfront.net/archibald-web-v2/uploads/beer/can_and_glass_image_fr/10/Nuit_Blanche_canette_473ml_Verre.png'),
    (155,'Belle mer','IPA',7.1,5.87,473,13,'https://d2x42bnn0tswa4.cloudfront.net/archibald-web-v2/uploads/beer/can_and_glass_image_fr/11/BelleMer_canette_473ml-Verre.png'),
    (156,'La rousse','Rousse',5,5.65,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_rousse_bouteille.png'),
    (157,'La blonde','Blonde',4.5,5.66,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_blonde_bouteille.png'),
    (158,'La blanche','Blanche',4.2,5.67,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_blanche_bouteille.png'),
    (159,'La IPA','IPA',6.2,5.68,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_IPA_bouteille.png'),
    (160,'La dorée','Ale',4.8,5.69,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_doree_bouteille.png'),
    (161,'La cuivrée','Ambrée',6.9,5.70,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_cuivre_bouteille.png'),
    (162,'La noire','Noire',5.5,5.71,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_noir_bouteille.png'),
    (163,'Pilsner des mers','Blonde',5.3,6.34,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_pilsner_bouteille.png'),
    (164,'Isa des chutes','IPA',3.7,6.34,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_ISA_bouteille.png'),
    (165,'Double blanche du lac','Blanche',6.1,6.34,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_blanche-du-lac_bouteille.png'),
    (166,'Scotch ale du nord','Ale',7.5,6.34,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_scotch_bouteille.png'),
    (167,'Belge des champs','Ale',6.5,6.34,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_belge_bouteille.png'),
    (168,'Saison des plages','Ale',4.9,6.34,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_plages_bouteille.png'),
    (169,'Pale ale des bois','Pale Ale',5.1,6.34,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_pale-des-bois_bouteille.png'),
    (170,'Ipa des côtes','IPA',6.1,6.34,341,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/3DCan_IPAdesCotes_201119_171716.png'),
    (171,'Ipa du nord-est','IPA',6,6.56,473,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/Boreale_IPA-NE-cannette.png'),
    (172,'Tropical du nord','IPA',6.5,6.56,473,14,'https://s3.ca-central-1.amazonaws.com/medias.boreale.com/files/bieres/3DCan_TropiqueNord.png');

-- Aromas
INSERT INTO Aromas VALUES
    (0,'Houblon'),
    (1,'Cacao'),
    (1,'Chocolat'),
    (2,'Céréale'),
    (3,'Pamplemousse'),
    (4,'Orange'),
    (4,'Lime'),
    (5,'Blé'),
    (5,'Framboise'),
    (6,'Céréale'),
    (6,'Houblon'),
    (7,'Boisée'),
    (7,'Blé'),
    (8,'Hibiscus'),
    (9,'Pêche'),
    (10,'Agrume'),
    (10,'Fruits tropicaux'),
    (11,'Cerise'),
    (12,'Cerise'),
    (13,'Pomme'),
    (14,'Sure'),
    (15,'Sure'),
    (15,'Sauvage'),
    (16,'Citron'),
    (17,'Nectarine'),
    (17,'Pêche'),
    (18,'Pêche'),
    (18,'Mangue'),
    (19,'Riche'),
    (20,'Riche'),
    (21,'Houblon'),
    (22,'Pêche'),
    (23,'Fruits'),
    (24,'Houblon'),
    (24,'Avoine'),
    (25,'Gingembre'),
    (26,'Sucre'),
    (26,'Sel'),
    (27,'Houblon'),
    (27,'Abricot'),
    (28,'Amère'),
    (29,'Blé'),
    (30,'Houblon'),
    (31,'Parfumé'),
    (32,'Amer'),
    (32,'Houblon'),
    (33,'Coriandre'),
    (33,'Orange'),
    (34,'Café'),
    (34,'Chocolat noir'),
    (35,'Caramel'),
    (35,'Fruits noirs'),
    (36,'Fruits'),
    (37,'Fruits tropicaux'),
    (38,'Caramel'),
    (38,'Malt fumé'),
    (39,'Malt'),
    (40,'Fruits exotiques'),
    (40,'Résine de pin'),
    (41,'Agrume'),
    (41,'Fruits tropicaux'),
    (41,'Coriandre'),
    (42,'Fruits tropicaux'),
    (42,'Résine de pin'),
    (43,'Blé'),
    (44,'Malt'),
    (44,'Caramel'),
    (44,'Rhum'),
    (45,'Blé'),
    (46,'Floraux'),
    (46,'Amer'),
    (47,'Malt'),
    (47,'Céréale'),
    (48,'Houblon'),
    (49,'Agrume'),
    (49,'Pêche'),
    (49,'Fruits tropicaux'),
    (50,'Herbes'),
    (50,'Blé'),
    (51,'Houblon'),
    (51,'Fruits tropicaux'),
    (52,'Houblon'),
    (52,'Pêche'),
    (53,'Houblon'),
    (54,'Fruits'),
    (55,'Agrume'),
    (56,'Houblon'),
    (56,'Fruits'),
    (57,'Ekuanot'),
    (58,'Houblon'),
    (59,'Miel'),
    (60,'Fruits tropicaux'),
    (60,'Agrume'),
    (61,'Houblon'),
    (62,'Fruits'),
    (63,'Citron'),
    (63,'Épice'),
    (64,'Blé'),
    (64,'Framboise'),
    (65,'Citron'),
    (65,'Coriandre'),
    (66,'Houblon'),
    (66,'Pêche'),
    (67,'Houblon'),
    (67,'Vanille'),
    (68,'Blé'),
    (69,'Érable'),
    (69,'Boisé'),
    (70,'Caramel'),
    (70,'Agrume'),
    (71,'Malt'),
    (71,'Mélasse'),
    (72,'Herbes'),
    (73,'Houblon'),
    (74,'Houblon'),
    (75,'Agrume'),
    (75,'Citron'),
    (75,'Conifères'),
    (76,'Sucre'),
    (77,'Anana'),
    (77,'Épice'),
    (78,'Blé'),
    (78,'Coriandre'),
    (78,'Épice'),
    (79,'Fruits'),
    (79,'Blé'),
    (80,'Pamplemousse'),
    (80,'Anana'),
    (81,'Floraux'),
    (81,'Citron'),
    (82,'Épice'),
    (82,'Fruits'),
    (83,'Avoine'),
    (83,'Cacao'),
    (84,'Framboise'),
    (85,'Malt'),
    (85,'Caramel'),
    (85,'Noisette'),
    (86,'Blé'),
    (86,'Épice'),
    (86,'Coriandre'),
    (87,'Café'),
    (88,'Noisette'),
    (88,'Caramel'),
    (89,'Caramel'),
    (90,'Noisette'),
    (91,'Épice'),
    (92,'Agrume'),
    (93,'Fruits de la passion'),
    (94,'Fruits tropicaux'),
    (95,'Pamplemousse'),
    (95,'Anana'),
    (96,'Agrume'),
    (96,'Épice'),
    (97,'Agrume'),
    (97,'Floraux'),
    (98,'Fruits tropicaux'),
    (98,'Épice'),
    (99,'Caramel'),
    (99,'Prunaux'),
    (100,'Noisette'),
    (100,'Malt'),
    (101,'Houblon'),
    (102,'Fruits'),
    (103,'Malt'),
    (104,'Houblon'),
    (104,'Caramel'),
    (105,'Céréale'),
    (105,'Caramel'),
    (106,'Fruits tropicaux'),
    (107,'Miel'),
    (107,'Pain'),
    (108,'Café'),
    (108,'Chocolat'),
    (109,'Cannelle'),
    (110,'Cacao'),
    (110,'Chocolat noir'),
    (110,'Bourbon'),
    (111,'Chocolat noir'),
    (111,'Vanille'),
    (111,'Malt roti'),
    (112,'Fruits'),
    (112,'Houblon'),
    (113,'Agrume'),
    (113,'Fruits tropicaux'),
    (114,'Café'),
    (115,'Fruits tropicaux'),
    (116,'Céréale'),
    (116,'Agrume'),
    (117,'Anana'),
    (117,'Mangue'),
    (118,'Fruits'),
    (118,'Houblon'),
    (119,'Fruits'),
    (120,'Mangue'),
    (120,'Fruits de la passion'),
    (121,'Boisés'),
    (121,'Houblon'),
    (122,'Fruits'),
    (123,'Fruits tropicaux'),
    (123,'Houblon'),
    (124,'Caramel'),
    (124,'Céréale'),
    (125,'Houblon'),
    (125,'Agrume'),
    (126,'Fruits'),
    (127,'Pamplemousse'),
    (127,'Anana'),
    (128,'Fruits'),
    (129,'Agrume'),
    (129,'Malt'),
    (130,'Noisette'),
    (130,'Pain'),
    (131,'Framboise'),
    (131,'Blé'),
    (132,'Pain'),
    (132,'Chocolat'),
    (132,'Caramel'),
    (133,'Pêche'),
    (133,'Malt'),
    (134,'Avoine'),
    (134,'Houblon'),
    (135,'Fruits tropicaux'),
    (136,'Fruits noirs'),
    (137,'Framboise'),
    (138,'Framboise'),
    (139,'Fruits'),
    (139,'Avoine'),
    (140,'Houblon'),
    (140,'Noisette'),
    (141,'Mûre'),
    (142,'Houblon'),
    (143,'Framboise'),
    (144,'Fruits'),
    (144,'Boisés'),
    (145,'Agrume'),
    (146,'Blé'),
    (147,'Bergamote'),
    (148,'Caramel'),
    (148,'Anana'),
    (149,'Céréale'),
    (149,'Houblon'),
    (150,'Orange'),
    (151,'Caramel'),
    (152,'Malt'),
    (153,'Malt'),
    (153,'Pain'),
    (154,'Agrume'),
    (154,'Citron'),
    (155,'Fruits tropicaux'),
    (156,'Caramel'),
    (157,'Miel'),
    (157,'Malt'),
    (158,'Gingembre'),
    (158,'Orange'),
    (159,'Pamplemousse'),
    (159,'Floraux'),
    (160,'Miel'),
    (161,'Caramel'),
    (162,'Caramel'),
    (162,'Chocolat'),
    (163,'Floraux'),
    (163,'Pain'),
    (164,'Poivre rose'),
    (164,'Mandarine'),
    (165,'Coriandre'),
    (165,'Orange'),
    (166,'Malt fumé'),
    (166,'Caramel'),
    (167,'Sarrasin'),
    (167,'Miel'),
    (168,'Poivre'),
    (168,'Citron'),
    (169,'Pamplemousse'),
    (169,'Citron'),
    (170,'Pamplemousse'),
    (170,'Lime'),
    (170,'Citron'),
    (171,'Mangue'),
    (171,'Anana'),
    (171,'Pêche'),
    (172,'Orange'),
    (172,'Pêche'),
    (172,'Céréale');
