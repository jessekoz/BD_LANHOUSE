/* Procedure 01 - ABRIR SESSÃO */

DELIMITER //

CREATE PROCEDURE sp_abrir_sessao(
    IN p_id_cliente INT,
    IN p_id_computador INT,
    OUT p_id_sessao INT
)

BEGIN

DECLARE v_status VARCHAR(20);
DECLARE v_erro BOOLEAN DEFAULT FALSE;

DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
SET v_erro = TRUE;

SELECT STATUS
INTO v_status
FROM COMPUTADORES
WHERE IDCOMPUTADOR = p_id_computador;

IF v_status != 'LIVRE' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'COMPUTADOR INDISPONIVEL';
END IF;

START TRANSACTION;

INSERT INTO SESSOES
(
HORARIO_INICIO,
ID_CLIENTE,
ID_COMPUTADOR,
STATUS_SESSAO
)

VALUES
(
NOW(),
p_id_cliente,
p_id_computador,
'ABERTA'
);

SET p_id_sessao = LAST_INSERT_ID();

UPDATE COMPUTADORES
SET STATUS = 'OCUPADO'
WHERE IDCOMPUTADOR = p_id_computador;

IF v_erro THEN
    ROLLBACK;
ELSE
    COMMIT;
END IF;

END //

DELIMITER ;



/* TESTANDO A PROCEDURE */

SET @nova_sessao = 0;

CALL sp_abrir_sessao(1, 1, @nova_sessao);

SELECT @nova_sessao;

+--------------+
| @nova_sessao |
+--------------+
|            9 |
+--------------+


/* Adicionando Procedure 02 - FECHAR SESSÃO */

DELIMITER //

CREATE PROCEDURE sp_fechar_sessao(
    IN p_id_sessao INT
)

BEGIN

DECLARE v_erro BOOLEAN DEFAULT FALSE;
DECLARE v_id_comp INT;
DECLARE v_inicio DATETIME;
DECLARE v_horas DECIMAL(8,2);
DECLARE v_valor DECIMAL(8,2);

DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
SET v_erro = TRUE;

SELECT ID_COMPUTADOR,
HORARIO_INICIO
INTO v_id_comp, v_inicio
FROM SESSOES
WHERE IDSESSOES = p_id_sessao;

SET v_horas =
TIMESTAMPDIFF(MINUTE, v_inicio, NOW()) / 60;

SET v_valor = v_horas * 10;

START TRANSACTION;

UPDATE SESSOES
SET HORARIO_FIM = NOW(),
VALOR_TOTAL = v_valor,
STATUS_SESSAO = 'FECHADA'
WHERE IDSESSOES = p_id_sessao;

UPDATE COMPUTADORES
SET STATUS = 'LIVRE'
WHERE IDCOMPUTADOR = v_id_comp;

IF v_erro THEN
    ROLLBACK;
ELSE
    COMMIT;
END IF;

END //

DELIMITER ;


/*Testando a Procedure 02*/

CALL sp_fechar_sessao(1);

SELECT * FROM SESSOES 
WHERE IDSESSOES = 1;

+-----------+---------------------+---------------------+------------+---------------+-------------+---------------+
| IDSESSOES | HORARIO_INICIO      | HORARIO_FIM         | ID_CLIENTE | ID_COMPUTADOR | VALOR_TOTAL | STATUS_SESSAO |
+-----------+---------------------+---------------------+------------+---------------+-------------+---------------+
|         1 | 2026-05-09 14:00:00 | 2026-05-23 14:49:53 |          1 |             1 |     3368.20 | FECHADA       |
+-----------+---------------------+---------------------+------------+---------------+-------------+---------------+
