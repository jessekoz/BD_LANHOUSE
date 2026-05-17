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
