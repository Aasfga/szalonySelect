BEGIN;
INSERT INTO places VALUES (DEFAULT, 'Stadion Olimpijski "Fiszt"', NULL);
INSERT INTO places VALUES (DEFAULT, 'Pałac lodowy "Bolszoj"');
INSERT INTO places VALUES (DEFAULT, 'Pałac sportów zimowych "Ajsbierg"');
INSERT INTO places VALUES (DEFAULT, 'Adler-Arena');
INSERT INTO places VALUES (DEFAULT, 'Arena lodowa "Szajba"');
INSERT INTO places VALUES (DEFAULT, 'Centrum curlingowe "Ledianoj kub"');
INSERT INTO places VALUES (DEFAULT, 'Plac "Miedał Płaza');
COMMIT;


BEGIN;
INSERT INTO categories VALUES (DEFAULT, 'Biathlon', DEFAULT, DEFAULT, DEFAULT, DEFAULT, 1, 1);
INSERT INTO categories VALUES (DEFAULT, 'Biegi narciarskie', DEFAULT, DEFAULT, DEFAULT, DEFAULT, 1, 1);
INSERT INTO categories VALUES (DEFAULT, 'Bobsleje', DEFAULT, DEFAULT, DEFAULT, DEFAULT, 2, 2);
INSERT INTO categories VALUES (DEFAULT, 'Curling', DEFAULT, DEFAULT, DEFAULT, DEFAULT, 5, 5);
COMMIT;

BEGIN;
INSERT INTO disciplines
  SELECT
    nextval('disciplines_id_seq'),
    sexes.id,
    categories.id
  FROM sexes
    CROSS JOIN categories;

COMMIT;
