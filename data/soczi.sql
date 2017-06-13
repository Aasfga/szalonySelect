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
INSERT INTO disciplines
  SELECT
    nextval('disciplines_id_seq'),
    sexes.id,
    categories.id
  FROM sexes
    CROSS JOIN categories;

COMMIT;
