/*Relatório 01 - Ranking De Clientes Por Faturamento*/

SELECT C.NOME, C.EMAIL, 
COUNT(S.IDSESSOES) AS TOTAL_SESSOES
FROM CLIENTES C 
JOIN SESSOES S 
ON C.IDCLIENTE = S.ID_CLIENTE
GROUP BY C.IDCLIENTE, C.NOME, C.EMAIL
HAVING COUNT(S.IDSESSOES) > 1 
ORDER BY TOTAL_SESSOES DESC 
LIMIT 5;

+--------+---------------------+---------------+
| NOME   | EMAIL               | TOTAL_SESSOES |
+--------+---------------------+---------------+
| PEDRO  | PEDRO123@GMAIL.COM  |             2 |
| JOAO   | JOAO123@GMAIL.COM   |             2 |
| THIAGO | THIAGO123@GMAIL.COM |             2 |
+--------+---------------------+---------------+



/*Relatório 02 - Clientes Cadastrados sem Sessão */

SELECT c.NOME,
       c.EMAIL,
       c.DATA_CADASTRO
FROM CLIENTES c
LEFT JOIN SESSOES s
    ON c.IDCLIENTE = s.ID_CLIENTE
WHERE s.IDSESSOES IS NULL;

+----------------------+------------------------+---------------+
| NOME                 | EMAIL                  | DATA_CADASTRO |
+----------------------+------------------------+---------------+
| JUNINHO PERNAMBUCANO | JUNINHO123@GMAIL.COM   | 2026-05-16    |
| CARLINHOS BALA       | CARLINHOS123@GMAIL.COM | 2026-05-17    |
+----------------------+------------------------+---------------+


/* Relatório 03 - Monitoramento de Sessões ativas na LanHouse */

SELECT
C.NOME,
S.HORARIO_INICIO,
fn_valor_sessao(S.IDSESSOES) AS VALOR_ATUAL
FROM SESSOES S
JOIN CLIENTES C
ON C.IDCLIENTE = S.ID_CLIENTE
WHERE STATUS_SESSAO = 'ABERTA';

+--------+---------------------+-------------+
| NOME   | HORARIO_INICIO      | VALOR_ATUAL |
+--------+---------------------+-------------+
| PEDRO  | 2026-05-17 17:00:00 |       10.00 |
| PEDRO  | 2026-05-23 14:43:33 |        NULL |
| JOAO   | 2026-05-09 11:00:00 |       20.00 |
| JOAO   | 2026-06-02 09:00:00 |       20.00 |
| THIAGO | 2026-05-09 15:00:00 |       10.00 |
| THIAGO | 2026-05-17 11:00:00 |       10.00 |
| MATEUS | 2026-05-17 13:00:00 |       18.00 |
+--------+---------------------+-------------+
