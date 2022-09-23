
use ecommerce;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema ecommerce
-- -----------------------------------------------------
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`produtos` (
  `idprodutos` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `valor` FLOAT NOT NULL,
  PRIMARY KEY (`idprodutos`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cpf`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cpf` (
  `idcpf` INT NOT NULL AUTO_INCREMENT,
  `cpf` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`idcpf`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cnpj`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cnpj` (
  `idcnpj` INT NOT NULL AUTO_INCREMENT,
  `cnpj` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idcnpj`),
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cliente` (
  `idcliente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `endereco` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `cpf_idcpf` INT NOT NULL,
  `cnpj_idcnpj` INT NOT NULL,
  PRIMARY KEY (`idcliente`, `cpf_idcpf`, `cnpj_idcnpj`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_cliente_cpf1_idx` (`cpf_idcpf` ASC) VISIBLE,
  INDEX `fk_cliente_cnpj1_idx` (`cnpj_idcnpj` ASC) VISIBLE,
  CONSTRAINT `fk_cliente_cpf1`
    FOREIGN KEY (`cpf_idcpf`)
    REFERENCES `mydb`.`cpf` (`idcpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cliente_cnpj1`
    FOREIGN KEY (`cnpj_idcnpj`)
    REFERENCES `mydb`.`cnpj` (`idcnpj`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pedido` (
  `idpedido` INT NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `frete` INT NOT NULL,
  `cliente_idcliente` INT NOT NULL,
  PRIMARY KEY (`idpedido`, `cliente_idcliente`),
  INDEX `fk_pedido_cliente1_idx` (`cliente_idcliente` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_cliente1`
    FOREIGN KEY (`cliente_idcliente`)
    REFERENCES `mydb`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`fornecedor` (
  `idfornecedor` INT NOT NULL AUTO_INCREMENT,
  `razaSocial` VARCHAR(45) NOT NULL,
  `cnpj` INT NOT NULL,
  PRIMARY KEY (`idfornecedor`),
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`estoque` (
  `idestoque` INT NOT NULL,
  `local` VARCHAR(45) NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`idestoque`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`disponibilizaUmProduto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`disponibilizaUmProduto` (
  `fornecedor_idfornecedor` INT NOT NULL,
  `produtos_idprodutos` INT NOT NULL,
  PRIMARY KEY (`fornecedor_idfornecedor`, `produtos_idprodutos`),
  INDEX `fk_fornecedor_has_produtos_produtos1_idx` (`produtos_idprodutos` ASC) VISIBLE,
  INDEX `fk_fornecedor_has_produtos_fornecedor_idx` (`fornecedor_idfornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_fornecedor_has_produtos_fornecedor`
    FOREIGN KEY (`fornecedor_idfornecedor`)
    REFERENCES `mydb`.`fornecedor` (`idfornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fornecedor_has_produtos_produtos1`
    FOREIGN KEY (`produtos_idprodutos`)
    REFERENCES `mydb`.`produtos` (`idprodutos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`disponibilidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`disponibilidade` (
  `produtos_idprodutos` INT NOT NULL,
  `estoque_idestoque` INT NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`produtos_idprodutos`, `estoque_idestoque`),
  INDEX `fk_produtos_has_estoque_estoque1_idx` (`estoque_idestoque` ASC) VISIBLE,
  INDEX `fk_produtos_has_estoque_produtos1_idx` (`produtos_idprodutos` ASC) VISIBLE,
  CONSTRAINT `fk_produtos_has_estoque_produtos1`
    FOREIGN KEY (`produtos_idprodutos`)
    REFERENCES `mydb`.`produtos` (`idprodutos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produtos_has_estoque_estoque1`
    FOREIGN KEY (`estoque_idestoque`)
    REFERENCES `mydb`.`estoque` (`idestoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`relacaoProdutoPedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`relacaoProdutoPedido` (
  `produtos_idprodutos` INT NOT NULL,
  `pedido_idpedido` INT NOT NULL,
  `quantidade` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`produtos_idprodutos`, `pedido_idpedido`),
  INDEX `fk_produtos_has_pedido_pedido1_idx` (`pedido_idpedido` ASC) VISIBLE,
  INDEX `fk_produtos_has_pedido_produtos1_idx` (`produtos_idprodutos` ASC) VISIBLE,
  CONSTRAINT `fk_produtos_has_pedido_produtos1`
    FOREIGN KEY (`produtos_idprodutos`)
    REFERENCES `mydb`.`produtos` (`idprodutos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produtos_has_pedido_pedido1`
    FOREIGN KEY (`pedido_idpedido`)
    REFERENCES `mydb`.`pedido` (`idpedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`terceiroVendedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`terceiroVendedor` (
  `idterceiroVendedor` INT NOT NULL,
  `razaoSocial` VARCHAR(45) NOT NULL,
  `local` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idterceiroVendedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`produtoPorVendedorTerceiro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`produtoPorVendedorTerceiro` (
  `terceiroVendedor_idterceiroVendedor` INT NOT NULL,
  `produtos_idprodutos` INT NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`terceiroVendedor_idterceiroVendedor`, `produtos_idprodutos`),
  INDEX `fk_terceiroVendedor_has_produtos_produtos1_idx` (`produtos_idprodutos` ASC) VISIBLE,
  INDEX `fk_terceiroVendedor_has_produtos_terceiroVendedor1_idx` (`terceiroVendedor_idterceiroVendedor` ASC) VISIBLE,
  CONSTRAINT `fk_terceiroVendedor_has_produtos_terceiroVendedor1`
    FOREIGN KEY (`terceiroVendedor_idterceiroVendedor`)
    REFERENCES `mydb`.`terceiroVendedor` (`idterceiroVendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_terceiroVendedor_has_produtos_produtos1`
    FOREIGN KEY (`produtos_idprodutos`)
    REFERENCES `mydb`.`produtos` (`idprodutos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cartaoCredito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cartaoCredito` (
  `idcartaoCredito` INT NOT NULL AUTO_INCREMENT,
  `numeroDoCartão` VARCHAR(45) NOT NULL,
  `validade` VARCHAR(45) NOT NULL,
  `nomeNoCartao` VARCHAR(45) NOT NULL,
  `bandeira` VARCHAR(45) NOT NULL,
  `cliente_idcliente` INT NOT NULL,
  `cliente_cpf_idcpf` INT NOT NULL,
  `cliente_cnpj_idcnpj` INT NOT NULL,
  PRIMARY KEY (`idcartaoCredito`, `cliente_idcliente`, `cliente_cpf_idcpf`, `cliente_cnpj_idcnpj`),
  UNIQUE INDEX `numeroDoCartão_UNIQUE` (`numeroDoCartão` ASC) VISIBLE,
  INDEX `fk_cartaoCredito_cliente1_idx` (`cliente_idcliente` ASC, `cliente_cpf_idcpf` ASC, `cliente_cnpj_idcnpj` ASC) VISIBLE,
  CONSTRAINT `fk_cartaoCredito_cliente1`
    FOREIGN KEY (`cliente_idcliente` , `cliente_cpf_idcpf` , `cliente_cnpj_idcnpj`)
    REFERENCES `mydb`.`cliente` (`idcliente` , `cpf_idcpf` , `cnpj_idcnpj`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`boleto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`boleto` (
  `idboleto` INT NOT NULL AUTO_INCREMENT,
  `codigoDeBarra` BIGINT(100) NULL,
  `cliente_idcliente` INT NOT NULL,
  `cliente_cpf_idcpf` INT NOT NULL,
  `cliente_cnpj_idcnpj` INT NOT NULL,
  PRIMARY KEY (`idboleto`, `cliente_idcliente`, `cliente_cpf_idcpf`, `cliente_cnpj_idcnpj`),
  INDEX `fk_boleto_cliente1_idx` (`cliente_idcliente` ASC, `cliente_cpf_idcpf` ASC, `cliente_cnpj_idcnpj` ASC) VISIBLE,
  CONSTRAINT `fk_boleto_cliente1`
    FOREIGN KEY (`cliente_idcliente` , `cliente_cpf_idcpf` , `cliente_cnpj_idcnpj`)
    REFERENCES `mydb`.`cliente` (`idcliente` , `cpf_idcpf` , `cnpj_idcnpj`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pagamento` (
  `idpagamento` INT NOT NULL AUTO_INCREMENT,
  `cartaoCredito_idcartaoCredito` INT NOT NULL,
  `boleto_idboleto` INT NOT NULL,
  `cliente_idcliente` INT NOT NULL,
  `cliente_cpf_idcpf` INT NOT NULL,
  `cliente_cnpj_idcnpj` INT NOT NULL,
  PRIMARY KEY (`idpagamento`, `cartaoCredito_idcartaoCredito`, `boleto_idboleto`, `cliente_idcliente`, `cliente_cpf_idcpf`, `cliente_cnpj_idcnpj`),
  INDEX `fk_pagamento_cartaoCredito1_idx` (`cartaoCredito_idcartaoCredito` ASC) VISIBLE,
  INDEX `fk_pagamento_boleto1_idx` (`boleto_idboleto` ASC) VISIBLE,
  INDEX `fk_pagamento_cliente1_idx` (`cliente_idcliente` ASC, `cliente_cpf_idcpf` ASC, `cliente_cnpj_idcnpj` ASC) VISIBLE,
  CONSTRAINT `fk_pagamento_cartaoCredito1`
    FOREIGN KEY (`cartaoCredito_idcartaoCredito`)
    REFERENCES `mydb`.`cartaoCredito` (`idcartaoCredito`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagamento_boleto1`
    FOREIGN KEY (`boleto_idboleto`)
    REFERENCES `mydb`.`boleto` (`idboleto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagamento_cliente1`
    FOREIGN KEY (`cliente_idcliente` , `cliente_cpf_idcpf` , `cliente_cnpj_idcnpj`)
    REFERENCES `mydb`.`cliente` (`idcliente` , `cpf_idcpf` , `cnpj_idcnpj`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`analise`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`analise` (
  `idanalise` INT NOT NULL AUTO_INCREMENT,
  `pedido_idpedido` INT NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idanalise`, `pedido_idpedido`),
  INDEX `fk_analise_pedido1_idx` (`pedido_idpedido` ASC) VISIBLE,
  CONSTRAINT `fk_analise_pedido1`
    FOREIGN KEY (`pedido_idpedido`)
    REFERENCES `mydb`.`pedido` (`idpedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`transportadora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`transportadora` (
  `idtransportadora` INT NOT NULL AUTO_INCREMENT,
  `emTransito` TINYINT NOT NULL,
  `entregue` TINYINT NOT NULL,
  PRIMARY KEY (`idtransportadora`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`verificacaoDeEstadoDoProduto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`verificacaoDeEstadoDoProduto` (
  `analise_idanalise` INT NOT NULL,
  `transportadora_idtransportadora` INT NOT NULL,
  `codigoRatreamento` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`analise_idanalise`, `transportadora_idtransportadora`),
  INDEX `fk_analise_has_transportadora_transportadora1_idx` (`transportadora_idtransportadora` ASC) VISIBLE,
  INDEX `fk_analise_has_transportadora_analise1_idx` (`analise_idanalise` ASC) VISIBLE,
  CONSTRAINT `fk_analise_has_transportadora_analise1`
    FOREIGN KEY (`analise_idanalise`)
    REFERENCES `mydb`.`analise` (`idanalise`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_analise_has_transportadora_transportadora1`
    FOREIGN KEY (`transportadora_idtransportadora`)
    REFERENCES `mydb`.`transportadora` (`idtransportadora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`verificacaoDePagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`verificacaoDePagamento` (
  `analise_idanalise` INT NOT NULL,
  `pagamento_idpagamento` INT NOT NULL,
  `pago` TINYINT NOT NULL,
  PRIMARY KEY (`analise_idanalise`, `pagamento_idpagamento`),
  INDEX `fk_pagamento_has_analise_analise1_idx` (`analise_idanalise` ASC) VISIBLE,
  INDEX `fk_pagamento_has_analise_pagamento1_idx` (`pagamento_idpagamento` ASC) VISIBLE,
  CONSTRAINT `fk_pagamento_has_analise_pagamento1`
    FOREIGN KEY (`pagamento_idpagamento`)
    REFERENCES `mydb`.`pagamento` (`idpagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagamento_has_analise_analise1`
    FOREIGN KEY (`analise_idanalise`)
    REFERENCES `mydb`.`analise` (`idanalise`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
