
CREATE TABLE finals
(
  id SERIAL PRIMARY KEY ,
  name VARCHAR UNIQUE
);

CREATE TABLE nationalities
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL
);

CREATE TABLE sexes
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  UNIQUE (name)
);

CREATE TABLE categories
(
  id                SERIAL PRIMARY KEY,
  name              VARCHAR NOT NULL,
  min_team_olymiad  INTEGER DEFAULT 0,
  max_team_olympiad INTEGER DEFAULT 2147483647,
  min_team_game     INTEGER DEFAULT 0,
  max_team_game     INTEGER DEFAULT 2147483647,
  min_players_team  INTEGER DEFAULT 0,
  max_players_team  INTEGER DEFAULT 2147483647
);

CREATE TABLE disciplines
(
  id            SERIAL PRIMARY KEY,
  id_sex        INTEGER REFERENCES sexes      NOT NULL,
  id_categories INTEGER REFERENCES categories NOT NULL
);

CREATE TABLE players
(
  id             INTEGER PRIMARY KEY,
  first_name     VARCHAR                          NOT NULL,
  last_name      VARCHAR                          NOT NULL,
  id_nationality INTEGER REFERENCES nationalities NOT NULL,
  birth_date     TIMESTAMP                        NOT NULL,
  id_sex         INTEGER REFERENCES sexes         NOT NULL
);

CREATE TABLE weights
(
  id_player INTEGER REFERENCES players,
  weight    NUMERIC(10, 2) NOT NULL,
  date      TIMESTAMP      NOT NULL
);

CREATE TABLE teams
(
  id               INTEGER PRIMARY KEY,
  id_sex           INTEGER REFERENCES sexes,
  id_discipline    INTEGER REFERENCES disciplines   NOT NULL,
  id_nationalities INTEGER REFERENCES nationalities NOT NULL
);

CREATE TABLE player_team
(
  player_id INTEGER REFERENCES players,
  team_id   INTEGER REFERENCES teams,

  PRIMARY KEY (player_id, team_id)
);

CREATE TABLE places
(
  id    SERIAL PRIMARY KEY,
  name  VARCHAR NOT NULL,
  place INTEGER REFERENCES places
);


CREATE TABLE judges
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL
);


CREATE TABLE event
(
  id         INTEGER PRIMARY KEY,
  place_id   INTEGER REFERENCES places,
  start_time TIMESTAMP NOT NULL ,
  end_time   TIMESTAMP,
  discipline INTEGER NOT NULL,
  final_id INTEGER REFERENCES finals,
  CHECK (start_time < event.end_time)
);

CREATE TABLE judge_game
(
  id_judge INTEGER REFERENCES judges,
  id_event INTEGER REFERENCES event,

  PRIMARY KEY (id_judge, id_event)
);


CREATE TABLE event_team
(
  id       INTEGER PRIMARY KEY,
  id_event INTEGER REFERENCES event,
  id_team  INTEGER REFERENCES teams,

  UNIQUE (id_event, id_team)
);


CREATE TABLE results_score (
  id_event_team INTEGER REFERENCES event_team,
  score         INTEGER
);

CREATE TABLE results_time (
  event_team_id INTEGER REFERENCES event_team,
  time          NUMERIC(11, 4)
);

CREATE TABLE reesults_notes (
  id_event_team INTEGER REFERENCES event_team,
  note          NUMERIC(11, 4)
);


--Podstawowe dane

INSERT INTO sexes VALUES (DEFAULT , 'male'), (DEFAULT , 'female');