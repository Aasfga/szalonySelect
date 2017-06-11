CREATE TABLE nationalities
(
  id      INTEGER PRIMARY KEY,
  name    VARCHAR(100)
);

CREATE TABLE sexes
(
  id      INTEGER PRIMARY KEY,
  name    VARCHAR(100)
);

CREATE TABLE categories
(
  id                              INTEGER PRIMARY KEY,
  name                            VARCHAR(100),
  number_of_teams_on_the_olympiad INTEGER,
  number_of_teams_in_one_game     INTEGER,
  number_of_players_in_team       INTEGER
);

CREATE TABLE disciplines
(
  id            INTEGER PRIMARY KEY,
  id_sex        INTEGER REFERENCES sexes,
  id_categories INTEGER REFERENCES categories
);

CREATE TABLE players
(
  id                INTEGER PRIMARY KEY,
  first_name        VARCHAR(100),
  last_name         VARCHAR(100),
  id_nationality    INTEGER REFERENCES nationalities,
  birth_date        TIMESTAMP,
  id_sex            INTEGER REFERENCES sexes
);

CREATE TABLE weights
(
  id_player     INTEGER REFERENCES players,
  weight        NUMERIC(10, 2),
  date          TIMESTAMP
);

CREATE TABLE teams
(
  id                  INTEGER PRIMARY KEY,
  id_sex              INTEGER REFERENCES sexes,
  id_discipline       INTEGER REFERENCES disciplines,
  id_nationalities    INTEGER REFERENCES nationalities

);

CREATE TABLE player_team
(
  id_zawodnika    INTEGER REFERENCES players,
  id_druzyna      INTEGER REFERENCES teams
);

CREATE TABLE sport_venues
(
  id              INTEGER PRIMARY KEY,
  nazwa           VARCHAR(100),
  id_main_venue   INTEGER REFERENCES sport_venues
);


CREATE TABLE judges
(
  id              INTEGER PRIMARY KEY ,
  name            VARCHAR(100)
);


CREATE TABLE event
(
  id                INTEGER PRIMARY KEY,
  id_sport_venue    INTEGER REFERENCES sport_venues,
  start_time        TIMESTAMP,
  end_time          TIMESTAMP,
  id_judge          INTEGER REFERENCES judges
);

CREATE TABLE judge_game
(
  id_judge          INTEGER REFERENCES judges,
  id_event          INTEGER REFERENCES event
);


CREATE TABLE event_team
(
  id_event          INTEGER REFERENCES event,
  id_team           INTEGER REFERENCES teams
);



CREATE TABLE scores(
  id_event INTEGER REFERENCES event,
  first
)