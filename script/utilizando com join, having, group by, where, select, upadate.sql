use ecommercedb;
-- simples SELECT
select * from cartaocredito;
select * from cliente;
select * from pedido;
select * from pix;
select * from cartaocredito;
select * from pagamentopix;

-- where e select
UPDATE pagamentopix 
SET pix_idpix = 13, vrificacaopagamento = 'não pago'
WHERE pedido_idpedido = 9;

select concat(nome,' ',sobrenome) as cliente, concat(tipodocumento,' ',identificacao) as Documento
from cliente where idcliente; 

-- order by + expressoes

SELECT * FROM cliente
ORDER BY nome,tipodocumento;

select concat(c.nome,' ',c.sobrenome) as Cliente,
	   concat(p.tipopix,' ',p.pix) as Pix
       from cliente as c, pix p
       where(c.idcliente=p.cliente_idcliente)
       order by c.nome,p.tipopix;
       
-- having + group

select idcliente, nome, sobrenome,count(*)
from cliente,pedido
where idcliente = cliente_idcliente
group by idcliente,nome,sobrenome
having count(*)=2;

-- join
SELECT c.nome, c.sobrenome, c.tipodocumento, p.descricao, p.status
FROM cliente c
INNER JOIN pedido p ON c.idcliente = p.cliente_idcliente;

SELECT c.nome, p.descricao
FROM cliente c
right outer JOIN pedido p ON c.idcliente = p.cliente_idcliente;

--
