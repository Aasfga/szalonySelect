CREATE TABLE panstwa
(
  id    INTEGER PRIMARY KEY,
  nazwa VARCHAR(100)
);

CREATE TABLE plec
(
  id INTEGER PRIMARY KEY,
  nazwa VARCHAR(100)
);

CREATE TABLE kategorie
(
  id                          INTEGER PRIMARY KEY,
  nazwa                       VARCHAR(100),
  ilosc_druzyn_na_olimpiadzie INTEGER,
  ilosc_druzyn_w_rozgrywce    INTEGER,
  ilosc_zawodnikow_w_druzynie INTEGER
);

CREATE TABLE dyscypliny
(
  id INTEGER PRIMARY KEY,
  id_plci INTEGER REFERENCES plec,
  id_kategorii INTEGER REFERENCES kategorie
);

CREATE TABLE zawodnicy
(
  id             INTEGER PRIMARY KEY,
  imie           VARCHAR(100),
  nazwisko       VARCHAR(100),
  narodowosc     INTEGER REFERENCES panstwa,
  data_urodzenia TIMESTAMP,
  plec INTEGER REFERENCES plec
);

CREATE TABLE wagi
(
  id_zawodnika INTEGER REFERENCES zawodnicy,
  waga         NUMERIC(10, 2),
  data         TIMESTAMP
);

CREATE TABLE druzyny
(
  id         INTEGER PRIMARY KEY,
  plec_zawodnikow INTEGER REFERENCES plec,
  dyscyplina INTEGER REFERENCES dyscypliny,
  narodowosc INTEGER REFERENCES panstwa

);

CREATE TABLE kto_gdzie
(
  id_zawodnika INTEGER REFERENCES zawodnicy,
  id_druzyna   INTEGER REFERENCES druzyny
);

CREATE TABLE obiekty_sportowe
(
  id INTEGER PRIMARY KEY,
  nazwa VARCHAR(100),
  id_nadbudynku INTEGER REFERENCES obiekty_sportowe
);

CREATE TABLE rozgrywka
(
  id INTEGER PRIMARY KEY,
  id_obiektu INTEGER REFERENCES obiekty_sportowe,
  data_rozpoczecia TIMESTAMP,
  data_zakonczenia TIMESTAMP
);

CREATE TABLE kto_z_kim
(
  id_rozgrywki INTEGER REFERENCES rozgrywka,
  id_druzyny INTEGER REFERENCES druzyny,
  wyniki VARCHAR(100)
)

