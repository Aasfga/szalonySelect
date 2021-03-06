CREATE TABLE  IF NOT EXISTS result_types
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR(30) NOT NULL
);
CREATE TABLE IF NOT EXISTS categories
(
  id                SERIAL PRIMARY KEY,
  name              VARCHAR(30) NOT NULL,
  min_team_game     INTEGER DEFAULT 0,
  max_team_game     INTEGER DEFAULT 2147483647,
  min_players_team  INTEGER DEFAULT 0,
  max_players_team  INTEGER DEFAULT 2147483647,
  id_result_type    INTEGER REFERENCES result_types
);

CREATE TABLE IF NOT EXISTS sexes
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  UNIQUE (name)
);

CREATE TABLE  IF NOT EXISTS  places
(
  id    SERIAL PRIMARY KEY,
  name  VARCHAR(30) NOT NULL,
  place INTEGER REFERENCES places
);


CREATE TABLE IF NOT EXISTS finals
(
  id SERIAL PRIMARY KEY,
  name VARCHAR(30) UNIQUE
);

CREATE TABLE IF NOT EXISTS disciplines
(
  id            SERIAL PRIMARY KEY,
  id_sex        INTEGER REFERENCES sexes      NOT NULL,
  id_categories INTEGER REFERENCES categories NOT NULL
);


CREATE TABLE IF NOT EXISTS nationalities
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS  judges
(
  id   SERIAL PRIMARY KEY,
  first_name     VARCHAR(30)                          NOT NULL,
  last_name      VARCHAR(30)                          NOT NULL
);



CREATE TABLE IF NOT EXISTS  events
(
  id         SERIAL PRIMARY KEY,
  id_place   INTEGER REFERENCES places,
  date DATE NOT NULL ,
  id_disciplines INTEGER REFERENCES disciplines,
  id_final INTEGER REFERENCES finals
);

CREATE TABLE IF NOT EXISTS  teams
(
  id               SERIAL PRIMARY KEY,
  id_sex           INTEGER REFERENCES sexes,
  id_discipline    INTEGER REFERENCES disciplines   NOT NULL,
  id_nationalities INTEGER REFERENCES nationalities NOT NULL
);

CREATE TABLE IF NOT EXISTS  players
(
  id             SERIAL PRIMARY KEY,
  first_name     VARCHAR(30)                          NOT NULL,
  last_name      VARCHAR(30)                          NOT NULL,
  id_nationality INTEGER REFERENCES nationalities NOT NULL,
  birth_date     DATE                        NOT NULL,
  id_sex         INTEGER REFERENCES sexes         NOT NULL
);

CREATE TABLE IF NOT EXISTS  weights
(
  id_player INTEGER REFERENCES players,
  weight    NUMERIC(10, 2) NOT NULL,
  date      DATE      NOT NULL
);


CREATE TABLE IF NOT EXISTS  player_team
(
  id_player INTEGER REFERENCES players,
  id_team   INTEGER REFERENCES teams,

  PRIMARY KEY (id_player, id_team)
);

CREATE TABLE IF NOT EXISTS  places
(
  id    SERIAL PRIMARY KEY,
  name  VARCHAR(30) NOT NULL,
  place INTEGER REFERENCES places
);


CREATE TABLE IF NOT EXISTS  judge_game
(
  id_judge INTEGER REFERENCES judges,
  id_event INTEGER REFERENCES events,

  PRIMARY KEY (id_judge, id_event)
);


CREATE TABLE IF NOT EXISTS  event_team_result
(
  id_event INTEGER REFERENCES events,
  id_team  INTEGER REFERENCES teams,
  result   INTEGER NOT NULL,

  PRIMARY KEY (id_event, id_team)
);

CREATE VIEW disciplinemale AS SELECT id from disciplines where id_sex = 1;
CREATE VIEW disciplinefemale AS SELECT id from disciplines where id_sex = 2;


