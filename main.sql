-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`clients` (
  `client_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(16) NOT NULL,
  `surnames` VARCHAR(33) NOT NULL,
  `address` VARCHAR(48) NOT NULL,
  `postal_code` SMALLINT UNSIGNED NOT NULL,
  `municipality` VARCHAR(15) NOT NULL,
  `province` VARCHAR(16) NOT NULL,
  `phone_number` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`client_id`),
  UNIQUE INDEX `address_UNIQUE` (`address` ASC) VISIBLE,
  INDEX `idx_name` (`name` ASC) INVISIBLE,
  INDEX `id_surnames` (`surnames` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`store` (
  `store_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `store_name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `municipaly` VARCHAR(15) NOT NULL,
  `province` VARCHAR(15) NOT NULL,
  `postal_code` SMALLINT NOT NULL,
  PRIMARY KEY (`store_id`),
  INDEX `idx_name` (`store_name` ASC) INVISIBLE,
  INDEX `idx_municipality` (`municipaly` ASC) VISIBLE,
  INDEX `idx_province` (`province` ASC) VISIBLE,
  INDEX `idx_postal_code` (`postal_code` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`riders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`riders` (
  `rider_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(16) NOT NULL,
  `nif` VARCHAR(15) NOT NULL,
  `surnames` VARCHAR(33) NOT NULL,
  `phone_number` VARCHAR(15) NOT NULL,
  `store_id` MEDIUMINT UNSIGNED NOT NULL,
  PRIMARY KEY (`rider_id`),
  INDEX `idx_name` (`name` ASC) INVISIBLE,
  INDEX `idx_surnames` (`surnames` ASC) VISIBLE,
  UNIQUE INDEX `nif_UNIQUE` (`nif` ASC) VISIBLE,
  UNIQUE INDEX `phone_number_UNIQUE` (`phone_number` ASC) VISIBLE,
  INDEX `idx_nif` (`nif` ASC) VISIBLE,
  INDEX `fk_store_rider_id_idx` (`store_id` ASC) VISIBLE,
  CONSTRAINT `fk_store_rider_id`
    FOREIGN KEY (`store_id`)
    REFERENCES `pizzeria`.`store` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`order` (
  `order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_id` MEDIUMINT UNSIGNED NOT NULL,
  `date_time` DATETIME NOT NULL DEFAULT (NOW()),
  `type` ENUM('take away', 'delivery') NOT NULL DEFAULT 'take away',
  `num_products` SMALLINT NOT NULL,
  `total` SMALLINT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `idx_date_time` (`date_time` ASC) INVISIBLE,
  INDEX `idx_num_products` (`num_products` ASC) VISIBLE,
  INDEX `idx_total` (`total` DESC) VISIBLE,
  INDEX `idx_client_id` (`client_id` ASC) VISIBLE,
  CONSTRAINT `fk_client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `pizzeria`.`clients` (`client_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`categories_pizza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`categories_pizza` (
  `category_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`products` (
  `store_id` MEDIUMINT UNSIGNED NOT NULL,
  `product_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_type` ENUM('pizza', 'burguer', 'drink') NOT NULL,
  `category_id` MEDIUMINT UNSIGNED NULL,
  `product_name` VARCHAR(30) NOT NULL,
  `product_description` TEXT NOT NULL,
  `image_URL` TEXT NOT NULL,
  `unit_price` SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `idx_product_type` (`product_type` ASC) INVISIBLE,
  INDEX `idx_product_name` (`product_name` ASC) VISIBLE,
  INDEX `idx_unit_price` (`unit_price` ASC) VISIBLE,
  INDEX `idx_category_id` (`category_id` ASC) INVISIBLE,
  INDEX `fk_store_product_id_idx` (`store_id` ASC) VISIBLE,
  INDEX `idx_store_id` (`store_id` ASC) VISIBLE,
  CONSTRAINT `fk_category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `pizzeria`.`categories_pizza` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_store_product_id`
    FOREIGN KEY (`store_id`)
    REFERENCES `pizzeria`.`store` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ck_pizza_category`
    CHECK ( `product_type` != 'pizza' OR `category_id` IS NOT NULL))
ENGINE = InnoDB
ROW_FORMAT = DYNAMIC;


-- -----------------------------------------------------
-- Table `pizzeria`.`order_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`order_detail` (
  `order_detail_id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL,
  `product_id` MEDIUMINT UNSIGNED NOT NULL,
  `quantity` SMALLINT UNSIGNED NOT NULL,
  `unit_price` SMALLINT UNSIGNED NOT NULL,
  `price` DECIMAL(8,2) GENERATED ALWAYS AS ((unit_price * quantity)) STORED,
  PRIMARY KEY (`order_detail_id`),
  INDEX `idx_order_id` (`order_id` ASC) INVISIBLE,
  INDEX `idx_product_id` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_orders_detail_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `pizzeria`.`order` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `pizzeria`.`products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`order_assigment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`order_assigment` (
  `order_assigment_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rider_id` MEDIUMINT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `store_id` MEDIUMINT UNSIGNED NOT NULL,
  PRIMARY KEY (`order_assigment_id`),
  INDEX `idx_order_id` (`order_id` ASC) VISIBLE,
  INDEX `idx_store_id` (`store_id` ASC) VISIBLE,
  INDEX `idx_rider_id` (`rider_id` ASC) INVISIBLE,
  UNIQUE INDEX `store_id_UNIQUE` (`store_id` ASC) VISIBLE,
  UNIQUE INDEX `order_id_UNIQUE` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `pizzeria`.`order` (`order_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rider_id`
    FOREIGN KEY (`rider_id`)
    REFERENCES `pizzeria`.`riders` (`rider_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_store_id`
    FOREIGN KEY (`store_id`)
    REFERENCES `pizzeria`.`store` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `pizzeria`;

DELIMITER $$
USE `pizzeria`$$
CREATE DEFINER = CURRENT_USER TRIGGER `pizzeria`.`order_detail_BEFORE_INSERT` BEFORE INSERT ON `order_detail` FOR EACH ROW
BEGIN

END
$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
