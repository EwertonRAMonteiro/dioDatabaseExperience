-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ecommercedb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ecommercedb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecommercedb` DEFAULT CHARACTER SET utf8 ;
USE `ecommercedb` ;

-- -----------------------------------------------------
-- Table `ecommercedb`.`produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`produtos` (
  `idprodutos` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `valor` FLOAT NOT NULL,
  `relacaoprodutopedido` VARCHAR(45) NULL,
  PRIMARY KEY (`idprodutos`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`cliente` (
  `idcliente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(20) NOT NULL,
  `nomecomposto` VARCHAR(20) NULL,
  `sobrenome` VARCHAR(20) NOT NULL,
  `tipodocumento` ENUM('CPF', 'CNPJ') NOT NULL DEFAULT 'CPF',
  `identificacao` VARCHAR(18) NOT NULL,
  `endereco` VARCHAR(45) NOT NULL,
  `datanasc` DATE NOT NULL,
  PRIMARY KEY (`idcliente`),
  UNIQUE INDEX `identificacao_UNIQUE` (`identificacao` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`pedido` (
  `idpedido` INT NOT NULL AUTO_INCREMENT,
  `status` ENUM('Processando', 'transportadora') NOT NULL DEFAULT 'Processando',
  `descricao` VARCHAR(45) NULL,
  `frete` FLOAT NOT NULL,
  `cliente_idcliente` INT NOT NULL,
  PRIMARY KEY (`idpedido`, `cliente_idcliente`),
  INDEX `fk_pedido_cliente1_idx` (`cliente_idcliente` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_cliente1`
    FOREIGN KEY (`cliente_idcliente`)
    REFERENCES `ecommercedb`.`cliente` (`idcliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`fornecedor` (
  `idfornecedor` INT NOT NULL AUTO_INCREMENT,
  `razaSocial` VARCHAR(45) NOT NULL,
  `cnpj` VARCHAR(18) NOT NULL,
  PRIMARY KEY (`idfornecedor`),
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`estoque` (
  `idestoque` INT NOT NULL AUTO_INCREMENT,
  `local` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idestoque`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`disponibilizaUmProduto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`disponibilizaUmProduto` (
  `fornecedor_idfornecedor` INT NOT NULL,
  `produtos_idprodutos` INT NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`fornecedor_idfornecedor`, `produtos_idprodutos`),
  INDEX `fk_fornecedor_has_produtos_produtos1_idx` (`produtos_idprodutos` ASC) VISIBLE,
  INDEX `fk_fornecedor_has_produtos_fornecedor_idx` (`fornecedor_idfornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_fornecedor_has_produtos_fornecedor`
    FOREIGN KEY (`fornecedor_idfornecedor`)
    REFERENCES `ecommercedb`.`fornecedor` (`idfornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fornecedor_has_produtos_produtos1`
    FOREIGN KEY (`produtos_idprodutos`)
    REFERENCES `ecommercedb`.`produtos` (`idprodutos`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`disponibilidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`disponibilidade` (
  `produtos_idprodutos` INT NOT NULL,
  `estoque_idestoque` INT NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`produtos_idprodutos`, `estoque_idestoque`),
  INDEX `fk_produtos_has_estoque_estoque1_idx` (`estoque_idestoque` ASC) VISIBLE,
  INDEX `fk_produtos_has_estoque_produtos1_idx` (`produtos_idprodutos` ASC) VISIBLE,
  CONSTRAINT `fk_produtos_has_estoque_produtos1`
    FOREIGN KEY (`produtos_idprodutos`)
    REFERENCES `ecommercedb`.`produtos` (`idprodutos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produtos_has_estoque_estoque1`
    FOREIGN KEY (`estoque_idestoque`)
    REFERENCES `ecommercedb`.`estoque` (`idestoque`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`relacaoProdutoPedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`relacaoProdutoPedido` (
  `produtos_idprodutos` INT NOT NULL,
  `pedido_idpedido` INT NOT NULL,
  `quantidade` INT NOT NULL,
  `status` ENUM('disponivel', 'sem estoque') NULL DEFAULT 'disponivel',
  PRIMARY KEY (`produtos_idprodutos`, `pedido_idpedido`),
  INDEX `fk_produtos_has_pedido_pedido1_idx` (`pedido_idpedido` ASC) VISIBLE,
  INDEX `fk_produtos_has_pedido_produtos1_idx` (`produtos_idprodutos` ASC) VISIBLE,
  CONSTRAINT `fk_produtos_has_pedido_produtos1`
    FOREIGN KEY (`produtos_idprodutos`)
    REFERENCES `ecommercedb`.`produtos` (`idprodutos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produtos_has_pedido_pedido1`
    FOREIGN KEY (`pedido_idpedido`)
    REFERENCES `ecommercedb`.`pedido` (`idpedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`terceiroVendedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`terceiroVendedor` (
  `idterceiroVendedor` INT NOT NULL,
  `razaoSocial` VARCHAR(45) NOT NULL,
  `local` VARCHAR(45) NULL,
  `nomefantasia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idterceiroVendedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`produtoPorVendedorTerceiro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`produtoPorVendedorTerceiro` (
  `terceiroVendedor_idterceiroVendedor` INT NOT NULL,
  `produtos_idprodutos` INT NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`terceiroVendedor_idterceiroVendedor`, `produtos_idprodutos`),
  INDEX `fk_terceiroVendedor_has_produtos_produtos1_idx` (`produtos_idprodutos` ASC) VISIBLE,
  INDEX `fk_terceiroVendedor_has_produtos_terceiroVendedor1_idx` (`terceiroVendedor_idterceiroVendedor` ASC) VISIBLE,
  CONSTRAINT `fk_terceiroVendedor_has_produtos_terceiroVendedor1`
    FOREIGN KEY (`terceiroVendedor_idterceiroVendedor`)
    REFERENCES `ecommercedb`.`terceiroVendedor` (`idterceiroVendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_terceiroVendedor_has_produtos_produtos1`
    FOREIGN KEY (`produtos_idprodutos`)
    REFERENCES `ecommercedb`.`produtos` (`idprodutos`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`cartaoCredito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`cartaoCredito` (
  `idcartaoCredito` INT NOT NULL AUTO_INCREMENT,
  `numeroDoCartão` VARCHAR(45) NOT NULL,
  `validade` VARCHAR(45) NOT NULL,
  `nomeNoCartao` VARCHAR(45) NOT NULL,
  `bandeira` VARCHAR(45) NOT NULL,
  `cliente_idcliente` INT NOT NULL,
  PRIMARY KEY (`idcartaoCredito`, `cliente_idcliente`),
  UNIQUE INDEX `numeroDoCartão_UNIQUE` (`numeroDoCartão` ASC) VISIBLE,
  INDEX `fk_cartaoCredito_cliente1_idx` (`cliente_idcliente` ASC) VISIBLE,
  CONSTRAINT `fk_cartaoCredito_cliente1`
    FOREIGN KEY (`cliente_idcliente`)
    REFERENCES `ecommercedb`.`cliente` (`idcliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`pix`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`pix` (
  `idpix` INT NOT NULL AUTO_INCREMENT,
  `tipopix` ENUM('email', 'telefone', 'cpf', 'cnpj', 'chave aleatoria') NOT NULL DEFAULT 'email',
  `pix` VARCHAR(250) NOT NULL,
  `cliente_idcliente` INT NOT NULL,
  PRIMARY KEY (`idpix`, `cliente_idcliente`),
  INDEX `fk_boleto_cliente1_idx` (`cliente_idcliente` ASC) VISIBLE,
  CONSTRAINT `fk_boleto_cliente1`
    FOREIGN KEY (`cliente_idcliente`)
    REFERENCES `ecommercedb`.`cliente` (`idcliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`transportadora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`transportadora` (
  `idtransportadora` INT NOT NULL AUTO_INCREMENT,
  `razaosocial` VARCHAR(40) NOT NULL,
  `nomefantasia` VARCHAR(40) NOT NULL,
  `statusproduto` ENUM('recebido', 'enviado', 'entregue', 'a receber') NOT NULL DEFAULT 'a receber',
  `codrastreio` VARCHAR(45) NOT NULL,
  `pedido_idpedido` INT NOT NULL,
  PRIMARY KEY (`idtransportadora`, `pedido_idpedido`),
  INDEX `fk_transportadora_pedido1_idx` (`pedido_idpedido` ASC) VISIBLE,
  UNIQUE INDEX `codrastreio_UNIQUE` (`codrastreio` ASC) VISIBLE,
  CONSTRAINT `fk_transportadora_pedido1`
    FOREIGN KEY (`pedido_idpedido`)
    REFERENCES `ecommercedb`.`pedido` (`idpedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`pagamentocartao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`pagamentocartao` (
  `pedido_idpedido` INT NOT NULL,
  `cartaoCredito_idcartaoCredito` INT NOT NULL,
  `verificacaopagamento` ENUM('pago', 'não pago') NOT NULL DEFAULT 'não pago',
  PRIMARY KEY (`pedido_idpedido`, `cartaoCredito_idcartaoCredito`),
  INDEX `fk_pedido_has_cartaoCredito_cartaoCredito1_idx` (`cartaoCredito_idcartaoCredito` ASC) VISIBLE,
  INDEX `fk_pedido_has_cartaoCredito_pedido1_idx` (`pedido_idpedido` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_has_cartaoCredito_pedido1`
    FOREIGN KEY (`pedido_idpedido`)
    REFERENCES `ecommercedb`.`pedido` (`idpedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_has_cartaoCredito_cartaoCredito1`
    FOREIGN KEY (`cartaoCredito_idcartaoCredito`)
    REFERENCES `ecommercedb`.`cartaoCredito` (`idcartaoCredito`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommercedb`.`pagamentopix`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommercedb`.`pagamentopix` (
  `pix_idpix` INT NOT NULL,
  `pedido_idpedido` INT NOT NULL,
  `vrificacaopagamento` ENUM('pago', 'não pago') NOT NULL DEFAULT 'não pago',
  PRIMARY KEY (`pix_idpix`, `pedido_idpedido`),
  INDEX `fk_pix_has_pedido_pedido1_idx` (`pedido_idpedido` ASC) VISIBLE,
  INDEX `fk_pix_has_pedido_pix1_idx` (`pix_idpix` ASC) VISIBLE,
  CONSTRAINT `fk_pix_has_pedido_pix1`
    FOREIGN KEY (`pix_idpix`)
    REFERENCES `ecommercedb`.`pix` (`idpix`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pix_has_pedido_pedido1`
    FOREIGN KEY (`pedido_idpedido`)
    REFERENCES `ecommercedb`.`pedido` (`idpedido`)
    ON DELETE  CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
