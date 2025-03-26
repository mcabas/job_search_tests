CREATE TABLE table_A (
    id_test int 
);

CREATE TABLE table_B (
    id_test int 
);

--table a (1,1)
INSERT INTO public.table_a(
	id_test)
	VALUES (1);

--table a (1,1,1,1,null)
INSERT INTO public.table_b(
	id_test)
	VALUES (null);

	select * from table_a;
	select * from table_b;


--INNER JOIN: 8 rows (each of A’s 2 1s matches all 4 1s in B, NULL is excluded).
SELECT * FROM table_A A
INNER JOIN table_B B ON A.id_test = B.id_test;

--LEFT JOIN: 8 rows (same as INNER—no unmatched rows in A since all 1s match B’s 1s).
SELECT * FROM table_A A
LEFT JOIN table_B B ON A.id_test = B.id_test;

--RIGHT JOIN: 9 rows (8 matches + 1 row from B’s NULL, padded with NULLs for B's columns).
SELECT * FROM table_A A
RIGHT JOIN table_B B ON A.id_test = B.id_test;

--FULL JOIN: 9 rows (8 matches + 1 unmatched NULL from B; no unmatched rows from A).
SELECT * FROM table_A A
FULL JOIN table_B B ON A.id_test = B.id_test;

--CROSS JOIN: 10 rows (2 rows × 5 rows, pairing everything, including NULL).
SELECT * FROM table_A A
CROSS JOIN table_B B;

--UNION: 2 rows (only distinct values: 1 and NULL).
SELECT * FROM table_A
UNION
SELECT * FROM table_B;

--UNION ALL: 7 rows (2 from A + 5 from B, keeping all duplicates and NULL).
SELECT * FROM table_A
UNION ALL
SELECT * FROM table_B;
