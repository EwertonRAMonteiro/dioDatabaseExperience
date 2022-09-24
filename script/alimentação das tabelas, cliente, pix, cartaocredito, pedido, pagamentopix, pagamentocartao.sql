-- alimentação do banco de dados



insert into cliente(nome,sobrenome,tipodocumento,identificacao,endereco,datanasc)
values("morgana","grilhoes","cpf","222.222.222-22","rua tapajó","2022-02-02"),
	   ("kayle","justifica","cpf","333.333.333-33","rua camoes","2022-03-03"),
       ("akali","kunai","cnpj","44.444.444/0001-44","rua cabelo","2022-04-04"),
       ("sivir","chalicar","cnpj","66.666.666/0001-66","rua perneta","2022-06-06"),
       ("aatrox","darkin","cpf","777.777.777-77","rua. virgula","2022-07-07"),
       ("lissandra","blair","cpf","888.888.888-88","rua harry potter","2022-08-08")
;

INSERT INTO pix(tipopix,pix,cliente_idcliente)
values("cpf","222.222.222-22",2),
	  ("email","kayle@gmail.com",3),
	  ("cnpj","66.666.666/0001-66",5),
	  ("chave aleatoria","asdk-as15sd3a-asdsad452",4),
	  ("cpf","777.777.777-77",6),
	  ("telefone","81000000",7)
;

insert INTO cartaocredito(numeroDoCartão,validade,nomeNoCartao,bandeira,cliente_idcliente)
values("7898456512321232","03/30","morgana g  grilhoes","visa",2),
	  ("1232456578984586","03/22","kayle j justifica","mastercard",3),
      ("1472258996363654","05/11","lissandra b blair","elo",7)
      
;

insert into pedido(status,descricao,frete,cliente_idcliente)
values("transportadora","cabo tipo c",19.99,2),
	  ("processando","toca maluca",7.99,2),
      ("transportadora","descascador de batata",12.45,3),
      ("processando","barraca camping",10.50,3),
      ("processando","camisa bob sponja",35.44,7),
      ("transportadora","sapto gales",40.99,7),
      ("transportadora","lapis",1,4),
      ("processando","caneta",2,5),
      ("transportadora","lace",79.88,6)
      ;

insert into pagamentopix(pix_idpix,pedido_idpedido,vrificacaopagamento)
values(13,2,"pago"),
      (17,8,"não pago"),
      (18,5,"pago"),
      (14,4,"pago"),
      (15,7,"não pago"),
      (16,6,"não pago")
;

insert into pagamentocartao(pedido_idpedido,cartaoCredito_idcartaoCredito,verificacaopagamento)
values(10,1,"pago"),
      (12,2,"não pago"),
      (13,3,"pago")
      ;



