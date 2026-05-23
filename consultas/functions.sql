/* FUNCTION 01 - VALOR DA SESSÃO */

DELIMITER //

CREATE FUNCTION fn_valor_sessao(
    p_id_sessao INT
)

RETURNS DECIMAL(8,2)

READS SQL DATA

BEGIN

DECLARE v_valor DECIMAL(8,2);

SELECT VALOR_TOTAL
INTO v_valor
FROM SESSOES
WHERE IDSESSOES = p_id_sessao;

RETURN v_valor;

END //

DELIMITER ;


/*Testando a FUNCTION 01 - VALOR DA SESSÃO */

SELECT fn_valor_sessao(1);

+--------------------+
| fn_valor_sessao(1) |
+--------------------+
|            3368.20 |
+--------------------+


/* FUNCTION 02 - CATEGORIA CLIENTE */

DELIMITER //

CREATE FUNCTION fn_categoria_cliente(
    p_id_cliente INT
)

RETURNS VARCHAR(20)

READS SQL DATA

BEGIN

DECLARE v_total DECIMAL(8,2);

SELECT COALESCE(SUM(VALOR_TOTAL),0)
INTO v_total
FROM SESSOES
WHERE ID_CLIENTE = p_id_cliente;

IF v_total >= 100 THEN
    RETURN 'OURO';

ELSEIF v_total >= 40 THEN
    RETURN 'PRATA';

ELSE
    RETURN 'BRONZE';

END IF;

END //

DELIMITER ;


/* Testando a FUNCTION 02 - CATEGORIA CLIENTE */

SELECT
NOME,
fn_categoria_cliente(IDCLIENTE) AS CATEGORIA
FROM CLIENTES;

+----------------------+-----------+
| NOME                 | CATEGORIA |
+----------------------+-----------+
| PEDRO                | OURO      |
| JOAO                 | PRATA     |
| THIAGO               | BRONZE    |
| MATEUS               | BRONZE    |
| JUNINHO PERNAMBUCANO | BRONZE    |
| CARLINHOS BALA       | BRONZE    |
+----------------------+-----------+
