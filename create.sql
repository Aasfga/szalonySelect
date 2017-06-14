
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
  id_player INTEGER REFERENCES players,
  id_team   INTEGER REFERENCES teams,

  PRIMARY KEY (id_player, id_team)
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
  id_place   INTEGER REFERENCES places,
  start_time TIMESTAMP NOT NULL ,
  end_time   TIMESTAMP,
  discipline INTEGER NOT NULL,
  id_final INTEGER REFERENCES finals,
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
  id_event_team INTEGER REFERENCES event_team,
  time          NUMERIC(11, 4)
);

CREATE TABLE results_notes (
  id_event_team INTEGER REFERENCES event_team,
  note          NUMERIC(11, 4)
);


--Podstawowe dane

INSERT INTO sexes VALUES (DEFAULT , 'male'), (DEFAULT , 'female');

INSERT INTO finals VALUES (1, 'final');
INSERT INTO finals VALUES (2, 'semi-final');
INSERT INTO finals VALUES (3, 'eliminations');


--Dodawanie do drużyny


CREATE OR REPLACE FUNCTION team_insert()
  RETURNS TRIGGER AS
$team_insert$
DECLARE
  max_players INTEGER := (SELECT
                            categories.max_players_team
                          FROM teams
                            JOIN disciplines
                              ON teams.id_discipline = disciplines.id
                            JOIN categories
                              ON disciplines.id_categories = categories.id
                          WHERE teams.id = new.id_team);

  crr_players INTEGER := (SELECT
                            count(id_player)
                          FROM player_team
                          WHERE id_team = new.id_team);

  team_sex    INTEGER := (SELECT
                            id_sex
                          FROM teams
                          WHERE id = new.id_team);

  player_sex  INTEGER := (SELECT
                            id_sex
                          FROM players
                          WHERE id = new.id_player);

BEGIN

  IF team_sex NOTNULL AND team_sex != player_sex
  THEN
    RAISE 'Wrong sex';
  END IF;

  IF crr_players = max_players
  THEN
    RAISE 'Team is full';
  END IF;

  RETURN new;
END;
$team_insert$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS team_insert
ON player_team;
CREATE TRIGGER team_insert
BEFORE INSERT ON player_team
FOR EACH ROW
EXECUTE PROCEDURE team_insert();

----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sex_change_team()
  RETURNS TRIGGER AS
$sex_change_team$
DECLARE
  team_sex INTEGER := (SELECT
                         id_sex
                       FROM teams
                       WHERE id = new.id);
  r        RECORD;
BEGIN

  IF team_sex ISNULL
  THEN
    RETURN new;
  END IF;

  FOR r IN SELECT
             players.id_sex
           FROM teams
             JOIN player_team
               ON teams.id = player_team.id_team
             JOIN players
               ON player_team.id_player = players.id
           WHERE teams.id = new.id
  LOOP
    IF r.id_sex != team_sex
    THEN
      RAISE 'Other sex is in team';
    END IF;
  END LOOP;

  RETURN new;
END;
$sex_change_team$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sex_change_team
ON teams;
CREATE TRIGGER sex_change_team
BEFORE UPDATE ON teams
FOR EACH ROW
EXECUTE PROCEDURE sex_change_team();

---------------------------------------------------------------


CREATE OR REPLACE FUNCTION event_time()
  RETURNS TRIGGER AS $checks$
BEGIN
  IF new.start_time > new.end_time
  THEN
    RAISE 'Start time after end time';
    RETURN NULL;
  END IF;
  RETURN new;
END;
$checks$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS result_after_finish
ON event;
CREATE TRIGGER result_after_finish
BEFORE INSERT OR UPDATE ON event
FOR EACH ROW EXECUTE PROCEDURE event_time();


---------------------------------------------------------------

CREATE OR REPLACE FUNCTION team_number()
  RETURNS TRIGGER AS $checks$
BEGIN
  IF (SELECT
        count(teams.id)
      FROM teams
      WHERE id_discipline = new.id_discipline
      GROUP BY id_discipline) >=
     (SELECT
        max_team_olympiad
      FROM disciplines
        JOIN categories
          ON disciplines.id_categories = categories.id
      WHERE disciplines.id = new.id_discipline)
  THEN
    RAISE 'Too many teams';
    RETURN NULL;
  END IF;
  RETURN new;
END;
$checks$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS number_of_teams
ON teams;
CREATE TRIGGER number_of_teams
BEFORE INSERT OR UPDATE ON teams
FOR EACH ROW EXECUTE PROCEDURE team_number();

---------------------------------------------------------------

CREATE OR REPLACE FUNCTION one_judge_in_game()
  RETURNS TRIGGER AS
$one_judge_in_game$
DECLARE
   start_date DATE = (SELECT start_time
                          FROM event
                          WHERE id = NEW.id_event);

   end_date DATE = (SELECT end_time
                          FROM event
                          WHERE id = NEW.id_event);
BEGIN

  IF ( select count(*) from event as e where e.id = NEW.id_event
				and (start_date , end_date) OVERLAPS ( e.start_time, e.end_time)
				 ) > 0
  THEN
    RAISE 'The referee judges more than one match';
  END IF;

  RETURN new;
END;
$one_judge_in_game$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS one_judge_in_game
ON judge_game;
CREATE TRIGGER one_judge_in_game
BEFORE INSERT ON judge_game
FOR EACH ROW
EXECUTE PROCEDURE one_judge_in_game();

---------------------------------------------------------------

CREATE OR REPLACE FUNCTION insert_event()
  RETURNS TRIGGER AS
$insert_event$
DECLARE

id_disciplines int := (SELECT d.id
                          FROM event_team as et
			    join teams as t on t.id = et.id_team
			    join disciplines as d on d.id = t.id_discipline
                          WHERE et.id_event = NEW.id
		          group by d.id
);

BEGIN

  IF ( select count(*) from event as e
				 join event_team as et on et.id_event = e.id
				 join teams as t on t.id = et.id_team
			    	 join disciplines as d on d.id = t.id_discipline
					where e.id_final < NEW.id_final and d.id = id_disciplines and e.end_time < NEW.start_time				 			) > 0
  THEN
    RAISE 'Wrong finals orders';
  END IF;

  IF ( select count(*) from event as e
				 join event_team as et on et.id_event = e.id
				 join teams as t on t.id = et.id_team
			    	 join disciplines as d on d.id = t.id_discipline
				where e.id_final < NEW.id_final and  d.id = id_disciplines and e.start_time > NEW.end_time				 			) > 0
  THEN
    RAISE 'Wrong finals orders';
  END IF;

  RETURN new;
END;
$insert_event$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS insert_event
ON event;
CREATE TRIGGER insert_event
BEFORE INSERT ON event
FOR EACH ROW
EXECUTE PROCEDURE insert_event();

---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION one_nationality_in_team() RETURNS trigger AS $nation$
DECLARE
  player INTEGER := (SELECT id_nationality FROM players WHERE NEW.id_player = players.id);
  team INTEGER := (SELECT id_nationalities FROM teams WHERE NEW.id_team = teams.id);
BEGIN

  IF player <> team THEN
    RAISE EXCEPTION 'Cant join player with other nationality';
  END IF;

  RETURN NEW;
END;
$nation$ LANGUAGE plpgsql;

CREATE TRIGGER one_nationality BEFORE INSERT ON player_team
  FOR EACH ROW EXECUTE PROCEDURE one_nationality_in_team();



------------------------------------------------------------------------------
-- CREATE VIEW team_capacity AS SELECT
 --     teams.id as id_team, categories.*
 --     from teams
 --          join disciplines on teams.id_discipline = disciplines.id
 --           join categories on disciplines.id_categories = categories.id;
--
--CREATE OR REPLACE FUNCTION dont_overloading_team() RETURNS trigger AS $player$
--DECLARE
--  playersinteam NUMERIC := (SELECT COUNT(*) FROM player_team WHERE NEW.id_team = player_team.id_team);
--BEGIN

--  IF playersinteam + 1 > (SELECT max_players_team FROM team_capacity WHERE NEW.id_team = team_capacity.id) THEN
--    RAISE EXCEPTION 'Cant overload team';
--  END IF;

--  RETURN NEW;
--END;
--$player$ LANGUAGE plpgsql;

--CREATE TRIGGER no_overloading BEFORE INSERT ON player_team
--  FOR EACH ROW EXECUTE PROCEDURE dont_overloading_team();

DROP VIEW IF EXISTS golden_medals;
DROP VIEW IF EXISTS silver_medals;
DROP VIEW IF EXISTS bronze_medals;
DROP VIEW IF EXISTS results;
DROP VIEW IF EXISTS team_category;




CREATE VIEW team_category AS SELECT
      nationalities.name as country,categories.name as category,teams.id as team
      from teams
            join nationalities on id_nationalities=nationalities.id
            join disciplines on id_discipline=disciplines.id
            join categories on id_categories=categories.id;

CREATE VIEW results AS SELECT
      country,category,finals.id as final,sum(score) as score
      from results_score
            join event_team on id_event_team =event_team.id
            join team_category on event_team.id_team=team_category.team
            join event on event_team.id_event=event.id
            join finals on id_final=finals.id group by team_category.category,team_category.country,finals.id;

CREATE VIEW golden_medals AS SELECT country,category from
      (select country, category, max(score) as scoremax from results where final=1 group by country,category)s where s.scoremax=1;

CREATE VIEW silver_medals AS SELECT country,category from
      (select country, category, min(score) as scoremin from results where final=1 group by country,category)s where s.scoremin=0;

CREATE VIEW bronze_medals AS SELECT country,category from
      (select country, category, max(score) as scoremax from results where final=2 group by country,category)s where s.scoremax=1;

BEGIN;
INSERT INTO categories VALUES (DEFAULT, 'Biathlon', DEFAULT, 60, 3, 60, 1, 1);
INSERT INTO categories VALUES (DEFAULT, 'Alpine skiing', DEFAULT, 60, 3, 60, 1, 1);
INSERT INTO categories VALUES (DEFAULT, 'Bobsleight', DEFAULT, 40, 3, 40, 2, 2);
INSERT INTO categories VALUES (DEFAULT, 'Curling', DEFAULT, 50,2, 2, 5, 5);
INSERT INTO categories VALUES (DEFAULT, 'Ice hockey', DEFAULT, 16, 2, 2, 6, 6);
INSERT INTO categories VALUES (DEFAULT, 'Figure skating', DEFAULT, 40, 2, 2, 1, 2);
INSERT INTO categories VALUES (DEFAULT, 'Skeleton', DEFAULT, 30, 3, 20, 1, 1);
INSERT INTO categories VALUES (DEFAULT, 'Competetive progrmming', DEFAULT, 40, 5, 40, 3, 3);
INSERT INTO categories VALUES (DEFAULT, 'Ski jumping', DEFAULT, 50, 10, 50, 1, 1);
INSERT INTO categories VALUES (DEFAULT, 'League of legends', DEFAULT, 16, 2, 2, 5, 5);
INSERT INTO categories VALUES (DEFAULT, 'CS-GO', DEFAULT, 16, 2, 2, 5, 5);
INSERT INTO categories VALUES (DEFAULT, 'Snowboarding', DEFAULT, 40, 3, 40, 5, 5);
INSERT INTO categories VALUES (DEFAULT, 'Speed skating', DEFAULT, 30, 3, 30, 1, 1);
INSERT INTO categories VALUES (DEFAULT, 'Cross-country skiing', DEFAULT, 40, 3, 40, 5, 5);
INSERT INTO categories VALUES (DEFAULT, 'Freestyle skiing', DEFAULT, 40, 3, 40, 1, 1);
COMMIT;

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

INSERT INTO nationalities VALUES (1, 'Ascension Island');
INSERT INTO nationalities VALUES (2, 'Andorra');
INSERT INTO nationalities VALUES (3, 'United Arab Emirates');
INSERT INTO nationalities VALUES (4, 'Afghanistan');
INSERT INTO nationalities VALUES (5, 'Antigua and Barbuda');
INSERT INTO nationalities VALUES (6, 'Anguilla');
INSERT INTO nationalities VALUES (7, 'Albania');
INSERT INTO nationalities VALUES (8, 'Armenia');
INSERT INTO nationalities VALUES (9, 'Netherlands Antilles');
INSERT INTO nationalities VALUES (10, 'Angola');
INSERT INTO nationalities VALUES (11, 'Antartica');
INSERT INTO nationalities VALUES (12, 'Argentina');
INSERT INTO nationalities VALUES (13, 'American Samoa');
INSERT INTO nationalities VALUES (14, 'Australia');
INSERT INTO nationalities VALUES (15, 'Aruba');
INSERT INTO nationalities VALUES (16, 'Azerbaijan');
INSERT INTO nationalities VALUES (17, 'Bosnia and Herzegovina');
INSERT INTO nationalities VALUES (18, 'Barbados');
INSERT INTO nationalities VALUES (19, 'Bangladesh');
INSERT INTO nationalities VALUES (20, 'Belgium');
INSERT INTO nationalities VALUES (21, 'Burkina Faso');
INSERT INTO nationalities VALUES (22, 'Bulgaria');
INSERT INTO nationalities VALUES (23, 'Bahrain');
INSERT INTO nationalities VALUES (24, 'Burundi');
INSERT INTO nationalities VALUES (25, 'Benin');
INSERT INTO nationalities VALUES (26, 'Bermuda');
INSERT INTO nationalities VALUES (27, 'Brunei Darussalam');
INSERT INTO nationalities VALUES (28, 'Bolivia');
INSERT INTO nationalities VALUES (29, 'Brazil');
INSERT INTO nationalities VALUES (30, 'Bahamas');
INSERT INTO nationalities VALUES (31, 'Bhutan');
INSERT INTO nationalities VALUES (32, 'Bouvet Island');
INSERT INTO nationalities VALUES (33, 'Botswana');
INSERT INTO nationalities VALUES (34, 'Belarus');
INSERT INTO nationalities VALUES (35, 'Belize');
INSERT INTO nationalities VALUES (36, 'Canada');
INSERT INTO nationalities VALUES (37, 'Cocos (Keeling) Islands');
INSERT INTO nationalities VALUES (38, 'Republic Of Kongo');
INSERT INTO nationalities VALUES (39, 'Central African Republic');
INSERT INTO nationalities VALUES (40, 'Prawilna Grupa z Chuty');
INSERT INTO nationalities VALUES (41, 'Switzerland');
INSERT INTO nationalities VALUES (42, 'Cote d''Ivoire');
INSERT INTO nationalities VALUES (43, 'Cook Islands');
INSERT INTO nationalities VALUES (44, 'Chile');
INSERT INTO nationalities VALUES (45, 'Cameroon');
INSERT INTO nationalities VALUES (46, 'China');
INSERT INTO nationalities VALUES (47, 'Colombia');
INSERT INTO nationalities VALUES (48, 'Costa Rica');
INSERT INTO nationalities VALUES (49, 'Cuba');
INSERT INTO nationalities VALUES (50, 'Cap Verde');
INSERT INTO nationalities VALUES (51, 'Christmas Island');
INSERT INTO nationalities VALUES (52, 'Cyprus');
INSERT INTO nationalities VALUES (53, 'Czeck Republic');
INSERT INTO nationalities VALUES (54, 'Germany');
INSERT INTO nationalities VALUES (55, 'Djibouti');
INSERT INTO nationalities VALUES (56, 'Denmark');
INSERT INTO nationalities VALUES (57, 'Dominica');
INSERT INTO nationalities VALUES (58, 'Dominican Republic');
INSERT INTO nationalities VALUES (59, 'Algeria');
INSERT INTO nationalities VALUES (60, 'Ecuador');
INSERT INTO nationalities VALUES (61, 'Estonia');
INSERT INTO nationalities VALUES (62, 'Egypt');
INSERT INTO nationalities VALUES (63, 'Western Sahara');
INSERT INTO nationalities VALUES (64, 'Eritrea');
INSERT INTO nationalities VALUES (65, 'Spain');
INSERT INTO nationalities VALUES (66, 'Ethiopia');
INSERT INTO nationalities VALUES (67, 'Finland');
INSERT INTO nationalities VALUES (68, 'Fiji');
INSERT INTO nationalities VALUES (69, 'Falkland Islands (Malvina)');
INSERT INTO nationalities VALUES (70, 'Federal State of ABCD');
INSERT INTO nationalities VALUES (71, 'Faroe Islands');
INSERT INTO nationalities VALUES (72, 'France');
INSERT INTO nationalities VALUES (73, 'Gabon');
INSERT INTO nationalities VALUES (74, 'Grenada');
INSERT INTO nationalities VALUES (75, 'Georgia');
INSERT INTO nationalities VALUES (76, 'French Guiana');
INSERT INTO nationalities VALUES (77, 'Guernsey');
INSERT INTO nationalities VALUES (78, 'Ghana');
INSERT INTO nationalities VALUES (79, 'Gibraltar');
INSERT INTO nationalities VALUES (80, 'Greenland');
INSERT INTO nationalities VALUES (81, 'Gambia');
INSERT INTO nationalities VALUES (82, 'Guinea');
INSERT INTO nationalities VALUES (83, 'Guadeloupe');
INSERT INTO nationalities VALUES (84, 'Equatorial Guinea');
INSERT INTO nationalities VALUES (85, 'Greece');
INSERT INTO nationalities VALUES (86, 'South Georgia and the South Sandwich Islands');
INSERT INTO nationalities VALUES (87, 'Guatemala');
INSERT INTO nationalities VALUES (88, 'Guam');
INSERT INTO nationalities VALUES (89, 'Guinea-Bissau');
INSERT INTO nationalities VALUES (90, 'Guyana');
INSERT INTO nationalities VALUES (91, 'Hong Kong');
INSERT INTO nationalities VALUES (92, 'Heard and McDonald Islands');
INSERT INTO nationalities VALUES (93, 'Honduras');
INSERT INTO nationalities VALUES (94, 'Croatia/Hrvatska');
INSERT INTO nationalities VALUES (95, 'Haiti');
INSERT INTO nationalities VALUES (96, 'Hungary');
INSERT INTO nationalities VALUES (97, 'Indonesia');
INSERT INTO nationalities VALUES (98, 'Ireland');
INSERT INTO nationalities VALUES (99, 'Israel');
INSERT INTO nationalities VALUES (100, 'Isle of Man');
INSERT INTO nationalities VALUES (101, 'India');
INSERT INTO nationalities VALUES (102, 'British Indian Ocean Territory');
INSERT INTO nationalities VALUES (103, 'Iraq');
INSERT INTO nationalities VALUES (104, 'Iran (Islamic Republic of)');
INSERT INTO nationalities VALUES (105, 'Iceland');
INSERT INTO nationalities VALUES (106, 'Italy');
INSERT INTO nationalities VALUES (107, 'Jersey');
INSERT INTO nationalities VALUES (108, 'Jamaica');
INSERT INTO nationalities VALUES (109, 'Jordan');
INSERT INTO nationalities VALUES (110, 'Japan');
INSERT INTO nationalities VALUES (111, 'Kenya');
INSERT INTO nationalities VALUES (112, 'Kyrgyzstan');
INSERT INTO nationalities VALUES (113, 'Cambodia');
INSERT INTO nationalities VALUES (114, 'Kiribati');
INSERT INTO nationalities VALUES (115, 'Comoros');
INSERT INTO nationalities VALUES (116, 'Saint Kitts and Nevis');
INSERT INTO nationalities VALUES (117,  'Democratic Peoples Republic');
INSERT INTO nationalities VALUES (118, 'ABCD');
INSERT INTO nationalities VALUES (119, 'Kuwait');
INSERT INTO nationalities VALUES (120, 'Cayman Islands');
INSERT INTO nationalities VALUES (121, 'Kazakhstan');
INSERT INTO nationalities VALUES (122, 's Democratic Republic');
INSERT INTO nationalities VALUES (123, 'Lebanon');
INSERT INTO nationalities VALUES (124, 'Saint Lucia');
INSERT INTO nationalities VALUES (125, 'Liechtenstein');
INSERT INTO nationalities VALUES (126, 'Sri Lanka');
INSERT INTO nationalities VALUES (127, 'Liberia');
INSERT INTO nationalities VALUES (128, 'Lesotho');
INSERT INTO nationalities VALUES (129, 'Lithuania');
INSERT INTO nationalities VALUES (130, 'Luxembourg');
INSERT INTO nationalities VALUES (131, 'Latvia');
INSERT INTO nationalities VALUES (132, 'Libyan Arab Jamahiriya');
INSERT INTO nationalities VALUES (133, 'Morocco');
INSERT INTO nationalities VALUES (134, 'Monaco');
INSERT INTO nationalities VALUES (135, 'Republic of');
INSERT INTO nationalities VALUES (136, 'Madagascar');
INSERT INTO nationalities VALUES (137, 'Marshall Islands');
INSERT INTO nationalities VALUES (138, 'Former Yugoslav Republic');
INSERT INTO nationalities VALUES (139, 'Mali');
INSERT INTO nationalities VALUES (140, 'Myanmar');
INSERT INTO nationalities VALUES (141, 'Mongolia');
INSERT INTO nationalities VALUES (142, 'Macau');
INSERT INTO nationalities VALUES (143, 'Northern Mariana Islands');
INSERT INTO nationalities VALUES (144, 'Martinique');
INSERT INTO nationalities VALUES (145, 'Mauritania');
INSERT INTO nationalities VALUES (146, 'Montserrat');
INSERT INTO nationalities VALUES (147, 'Malta');
INSERT INTO nationalities VALUES (148, 'Mauritius');
INSERT INTO nationalities VALUES (149, 'Maldives');
INSERT INTO nationalities VALUES (150, 'Malawi');
INSERT INTO nationalities VALUES (151, 'Mexico');
INSERT INTO nationalities VALUES (152, 'Malaysia');
INSERT INTO nationalities VALUES (153, 'Mozambique');
INSERT INTO nationalities VALUES (154, 'Namibia');
INSERT INTO nationalities VALUES (155, 'New Caledonia');
INSERT INTO nationalities VALUES (156, 'Niger');
INSERT INTO nationalities VALUES (157, 'Norfolk Island');
INSERT INTO nationalities VALUES (158, 'Nigeria');
INSERT INTO nationalities VALUES (159, 'Nicaragua');
INSERT INTO nationalities VALUES (160, 'Netherlands');
INSERT INTO nationalities VALUES (161, 'Norway');
INSERT INTO nationalities VALUES (162, 'Nepal');
INSERT INTO nationalities VALUES (163, 'Nauru');
INSERT INTO nationalities VALUES (164, 'Niue');
INSERT INTO nationalities VALUES (165, 'New Zealand');
INSERT INTO nationalities VALUES (166, 'Oman');
INSERT INTO nationalities VALUES (167, 'Panama');
INSERT INTO nationalities VALUES (168, 'Peru');
INSERT INTO nationalities VALUES (169, 'French Polynesia');
INSERT INTO nationalities VALUES (170, 'Papua New Guinea');
INSERT INTO nationalities VALUES (171, 'Philippines');
INSERT INTO nationalities VALUES (172, 'Pakistan');
INSERT INTO nationalities VALUES (173, 'Poland');
INSERT INTO nationalities VALUES (174, 'St. Pierre and Miquelon');
INSERT INTO nationalities VALUES (175, 'Pitcairn Island');
INSERT INTO nationalities VALUES (176, 'Puerto Rico');
INSERT INTO nationalities VALUES (177, 'Portugal');
INSERT INTO nationalities VALUES (178, 'Palau');
INSERT INTO nationalities VALUES (179, 'Paraguay');
INSERT INTO nationalities VALUES (180, 'Qatar');
INSERT INTO nationalities VALUES (181, 'Reunion Island');
INSERT INTO nationalities VALUES (182, 'Romania');
INSERT INTO nationalities VALUES (183, 'Russian Federation');
INSERT INTO nationalities VALUES (184, 'Rwanda');
INSERT INTO nationalities VALUES (185, 'Saudi Arabia');
INSERT INTO nationalities VALUES (186, 'Solomon Islands');
INSERT INTO nationalities VALUES (187, 'Seychelles');
INSERT INTO nationalities VALUES (188, 'Sudan');
INSERT INTO nationalities VALUES (189, 'Sweden');
INSERT INTO nationalities VALUES (190, 'Singapore');
INSERT INTO nationalities VALUES (191, 'St. Helena');
INSERT INTO nationalities VALUES (192, 'Slovenia');
INSERT INTO nationalities VALUES (193, 'Svalbard and Jan Mayen Islands');
INSERT INTO nationalities VALUES (194, 'Slovak Republic');
INSERT INTO nationalities VALUES (195, 'Sierra Leone');
INSERT INTO nationalities VALUES (196, 'San Marino');
INSERT INTO nationalities VALUES (197, 'Senegal');
INSERT INTO nationalities VALUES (198, 'Somalia');
INSERT INTO nationalities VALUES (199, 'Suriname');
INSERT INTO nationalities VALUES (200, 'Sao Tome and Principe');
INSERT INTO nationalities VALUES (201, 'El Salvador');
INSERT INTO nationalities VALUES (202, 'Syrian Arab Republic');
INSERT INTO nationalities VALUES (203, 'Swaziland');
INSERT INTO nationalities VALUES (204, 'Turks and Ciacos Islands');
INSERT INTO nationalities VALUES (205, 'Chad');
INSERT INTO nationalities VALUES (206, 'French Southern Territories');
INSERT INTO nationalities VALUES (207, 'Togo');
INSERT INTO nationalities VALUES (208, 'Thailand');
INSERT INTO nationalities VALUES (209, 'Tajikistan');
INSERT INTO nationalities VALUES (210, 'Tokelau');
INSERT INTO nationalities VALUES (211, 'Turkmenistan');
INSERT INTO nationalities VALUES (212, 'Tunisia');
INSERT INTO nationalities VALUES (213, 'Tonga');
INSERT INTO nationalities VALUES (214, 'East Timor');
INSERT INTO nationalities VALUES (215, 'Turkey');
INSERT INTO nationalities VALUES (216, 'Trinidad and Tobago');
INSERT INTO nationalities VALUES (217, 'Tuvalu');
INSERT INTO nationalities VALUES (218, 'Taiwan');
INSERT INTO nationalities VALUES (219, 'Tanzania');
INSERT INTO nationalities VALUES (220, 'Ukraine');
INSERT INTO nationalities VALUES (221, 'Uganda');
INSERT INTO nationalities VALUES (222, 'United Kingdom');
INSERT INTO nationalities VALUES (223, 'United Kingdom');
INSERT INTO nationalities VALUES (224, 'US Minor Outlying Islands');
INSERT INTO nationalities VALUES (225, 'United States');
INSERT INTO nationalities VALUES (226, 'Uruguay');
INSERT INTO nationalities VALUES (227, 'Uzbekistan');
INSERT INTO nationalities VALUES (228, 'Holy See (City Vatican State)');
INSERT INTO nationalities VALUES (229, 'Saint Vincent and the Grenadines');
INSERT INTO nationalities VALUES (230, 'Venezuela');
INSERT INTO nationalities VALUES (231, 'Virgin Islands (British)');
INSERT INTO nationalities VALUES (232, 'Virgin Islands (USA)');
INSERT INTO nationalities VALUES (233, 'Vietnam');
INSERT INTO nationalities VALUES (234, 'Vanuatu');
INSERT INTO nationalities VALUES (235, 'Wallis and Futuna Islands');
INSERT INTO nationalities VALUES (236, 'Western Samoa');
INSERT INTO nationalities VALUES (237, 'Yemen');
INSERT INTO nationalities VALUES (238, 'Mayotte');
INSERT INTO nationalities VALUES (239, 'Yugoslavia');
INSERT INTO nationalities VALUES (240, 'South Africa');
INSERT INTO nationalities VALUES (241, 'Zambia');
INSERT INTO nationalities VALUES (242, 'Zaire');
INSERT INTO nationalities VALUES (243, 'Zimbabwe');
INSERT INTO nationalities VALUES (244, 'Austria');

BEGIN;

INSERT INTO judges VALUES
  (DEFAULT, 'Adam Adamski'),
  (DEFAULT, 'Seba Prawilny'),
  (DEFAULT, 'Mati Itam'),
  (DEFAULT, 'Dominik Kinimod'),
  (DEFAULT, 'Łukasz Zsakuł'),
  (DEFAULT, 'Michał Łahcim'),
  (DEFAULT, 'Marcin Nicram'),
  (DEFAULT, 'Sedzia Kalosz');
COMMIT;



--Meski team nr 1 ice hockey
BEGIN;
INSERT INTO teams VALUES(1, 1, 5, 191);
INSERT INTO players VALUES(0, 'London', 'Webster', 191, '1995-4-5', 1);
Insert Into player_team VALUES (0, 1);
Insert Into weights VALUES (0, 60, '2017-1-1');
INSERT INTO players VALUES(1, 'Levi', 'Newton', 191, '1997-1-17', 1);
Insert Into player_team VALUES (1, 1);
Insert Into weights VALUES (1, 78, '2017-1-1');
INSERT INTO players VALUES(2, 'Max', 'Cox', 191, '1991-4-12', 1);
Insert Into player_team VALUES (2, 1);
Insert Into weights VALUES (2, 64, '2017-1-1');
INSERT INTO players VALUES(3, 'Gunner', 'Woods', 191, '2001-10-18', 1);
Insert Into player_team VALUES (3, 1);
Insert Into weights VALUES (3, 64, '2017-1-1');
INSERT INTO players VALUES(4, 'Juan', 'Clarke', 191, '1998-11-8', 1);
Insert Into player_team VALUES (4, 1);
Insert Into weights VALUES (4, 75, '2017-1-1');
INSERT INTO players VALUES(5, 'Damion', 'Pearce', 191, '1999-6-12', 1);
Insert Into player_team VALUES (5, 1);
Insert Into weights VALUES (5, 73, '2017-1-1');
----

--Meski team nr 2 ice hockey
INSERT INTO teams VALUES(2, 1, 5, 48);
INSERT INTO players VALUES(6, 'Bobby', 'Payne', 48, '1992-3-12', 1);
Insert Into player_team VALUES (6, 2);
Insert Into weights VALUES (6, 51, '2017-1-1');
INSERT INTO players VALUES(7, 'Darren', 'Bates', 48, '1997-7-5', 1);
Insert Into player_team VALUES (7, 2);
Insert Into weights VALUES (7, 62, '2017-1-1');
INSERT INTO players VALUES(8, 'Harrison', 'Wilkinson', 48, '1993-3-3', 1);
Insert Into player_team VALUES (8, 2);
Insert Into weights VALUES (8, 51, '2017-1-1');
INSERT INTO players VALUES(9, 'Arturo', 'Spencer', 48, '2000-4-16', 1);
Insert Into player_team VALUES (9, 2);
Insert Into weights VALUES (9, 75, '2017-1-1');
INSERT INTO players VALUES(10, 'Donte', 'Robson', 48, '1995-10-7', 1);
Insert Into player_team VALUES (10, 2);
Insert Into weights VALUES (10, 77, '2017-1-1');
INSERT INTO players VALUES(11, 'Chris', 'Burton', 48, '1993-6-9', 1);
Insert Into player_team VALUES (11, 2);
Insert Into weights VALUES (11, 65, '2017-1-1');
----

--Meski team nr 3 ice hockey
INSERT INTO teams VALUES(3, 1, 5, 127);
INSERT INTO players VALUES(12, 'Chace', 'Wright', 127, '1999-5-3', 1);
Insert Into player_team VALUES (12, 3);
Insert Into weights VALUES (12, 58, '2017-1-1');
INSERT INTO players VALUES(13, 'Daniel', 'Holland', 127, '1994-2-8', 1);
Insert Into player_team VALUES (13, 3);
Insert Into weights VALUES (13, 53, '2017-1-1');
INSERT INTO players VALUES(14, 'Edwin', 'Bates', 127, '1994-3-18', 1);
Insert Into player_team VALUES (14, 3);
Insert Into weights VALUES (14, 52, '2017-1-1');
INSERT INTO players VALUES(15, 'Keenan', 'Stone', 127, '1998-2-1', 1);
Insert Into player_team VALUES (15, 3);
Insert Into weights VALUES (15, 56, '2017-1-1');
INSERT INTO players VALUES(16, 'Daniel', 'Riley', 127, '1999-6-1', 1);
Insert Into player_team VALUES (16, 3);
Insert Into weights VALUES (16, 61, '2017-1-1');
INSERT INTO players VALUES(17, 'Harrison', 'Baker', 127, '2003-2-2', 1);
Insert Into player_team VALUES (17, 3);
Insert Into weights VALUES (17, 68, '2017-1-1');
----

--Meski team nr 4 ice hockey
INSERT INTO teams VALUES(4, 1, 5, 87);
INSERT INTO players VALUES(18, 'Fletcher', 'Mitchell', 87, '1995-10-8', 1);
Insert Into player_team VALUES (18, 4);
Insert Into weights VALUES (18, 75, '2017-1-1');
INSERT INTO players VALUES(19, 'Clark', 'Harvey', 87, '2003-11-11', 1);
Insert Into player_team VALUES (19, 4);
Insert Into weights VALUES (19, 77, '2017-1-1');
INSERT INTO players VALUES(20, 'Joseph', 'Lane', 87, '2000-2-1', 1);
Insert Into player_team VALUES (20, 4);
Insert Into weights VALUES (20, 78, '2017-1-1');
INSERT INTO players VALUES(21, 'Conrad', 'Burgess', 87, '1992-8-15', 1);
Insert Into player_team VALUES (21, 4);
Insert Into weights VALUES (21, 65, '2017-1-1');
INSERT INTO players VALUES(22, 'Bobby', 'Day', 87, '1993-8-3', 1);
Insert Into player_team VALUES (22, 4);
Insert Into weights VALUES (22, 63, '2017-1-1');
INSERT INTO players VALUES(23, 'Raul', 'Dixon', 87, '2004-2-12', 1);
Insert Into player_team VALUES (23, 4);
Insert Into weights VALUES (23, 59, '2017-1-1');
----

--Meski team nr 5 ice hockey
INSERT INTO teams VALUES(5, 1, 5, 154);
INSERT INTO players VALUES(24, 'Jamar', 'Perry', 154, '1998-5-4', 1);
Insert Into player_team VALUES (24, 5);
Insert Into weights VALUES (24, 54, '2017-1-1');
INSERT INTO players VALUES(25, 'Valentin', 'Newman', 154, '1996-6-9', 1);
Insert Into player_team VALUES (25, 5);
Insert Into weights VALUES (25, 75, '2017-1-1');
INSERT INTO players VALUES(26, 'Felix', 'Cooke', 154, '1993-10-8', 1);
Insert Into player_team VALUES (26, 5);
Insert Into weights VALUES (26, 61, '2017-1-1');
INSERT INTO players VALUES(27, 'Frankie', 'Stevens', 154, '2001-8-18', 1);
Insert Into player_team VALUES (27, 5);
Insert Into weights VALUES (27, 52, '2017-1-1');
INSERT INTO players VALUES(28, 'Thaddeus', 'Hill', 154, '1992-5-14', 1);
Insert Into player_team VALUES (28, 5);
Insert Into weights VALUES (28, 55, '2017-1-1');
INSERT INTO players VALUES(29, 'Mateo', 'Mills', 154, '2000-11-5', 1);
Insert Into player_team VALUES (29, 5);
Insert Into weights VALUES (29, 58, '2017-1-1');
----

--Meski Team nr 6 ice hockey
INSERT INTO teams VALUES(6, 1, 5, 110);
INSERT INTO players VALUES(30, 'Kai', 'Armstrong', 110, '2001-5-3', 1);
Insert Into player_team VALUES (30, 6);
Insert Into weights VALUES (30, 73, '2017-1-1');
INSERT INTO players VALUES(31, 'Baron', 'Armstrong', 110, '1999-11-20', 1);
Insert Into player_team VALUES (31, 6);
Insert Into weights VALUES (31, 50, '2017-1-1');
INSERT INTO players VALUES(32, 'Andres', 'Oliver', 110, '1997-11-20', 1);
Insert Into player_team VALUES (32, 6);
Insert Into weights VALUES (32, 53, '2017-1-1');
INSERT INTO players VALUES(33, 'Colt', 'Chapman', 110, '2000-9-2', 1);
Insert Into player_team VALUES (33, 6);
Insert Into weights VALUES (33, 67, '2017-1-1');
INSERT INTO players VALUES(34, 'Kyle', 'Dawson', 110, '2003-7-10', 1);
Insert Into player_team VALUES (34, 6);
Insert Into weights VALUES (34, 50, '2017-1-1');
INSERT INTO players VALUES(35, 'Silas', 'Wilkinson', 110, '1997-5-11', 1);
Insert Into player_team VALUES (35, 6);
Insert Into weights VALUES (35, 62, '2017-1-1');
----


--Meski team nr 7 ice hockey
INSERT INTO teams VALUES(7, 1, 5, 183);
INSERT INTO players VALUES(36, 'Marcel', 'Jackson', 183, '1995-4-2', 1);
Insert Into player_team VALUES (36, 7);
Insert Into weights VALUES (36, 72, '2017-1-1');
INSERT INTO players VALUES(37, 'Jayce', 'Bailey', 183, '2001-4-11', 1);
Insert Into player_team VALUES (37, 7);
Insert Into weights VALUES (37, 65, '2017-1-1');
INSERT INTO players VALUES(38, 'Drew', 'Jackson', 183, '1998-11-14', 1);
Insert Into player_team VALUES (38, 7);
Insert Into weights VALUES (38, 61, '2017-1-1');
INSERT INTO players VALUES(39, 'Tanner', 'Stevens', 183, '1991-8-18', 1);
Insert Into player_team VALUES (39, 7);
Insert Into weights VALUES (39, 51, '2017-1-1');
INSERT INTO players VALUES(40, 'Conor', 'Lawrence', 183, '1998-1-9', 1);
Insert Into player_team VALUES (40, 7);
Insert Into weights VALUES (40, 68, '2017-1-1');
INSERT INTO players VALUES(41, 'Jayce', 'Marsh', 183, '2003-11-19', 1);
Insert Into player_team VALUES (41, 7);
Insert Into weights VALUES (41, 59, '2017-1-1');
----


--Meski team nr 8 ice hockey
INSERT INTO teams VALUES(8, 1, 5, 23);
INSERT INTO players VALUES(42, 'Brennan', 'Cook', 23, '1996-6-20', 1);
Insert Into player_team VALUES (42, 8);
Insert Into weights VALUES (42, 71, '2017-1-1');
INSERT INTO players VALUES(43, 'Andres', 'Armstrong', 23, '1991-5-4', 1);
Insert Into player_team VALUES (43, 8);
Insert Into weights VALUES (43, 75, '2017-1-1');
INSERT INTO players VALUES(44, 'Bobby', 'Elliott', 23, '1995-7-7', 1);
Insert Into player_team VALUES (44, 8);
Insert Into weights VALUES (44, 60, '2017-1-1');
INSERT INTO players VALUES(45, 'Ramiro', 'Stevens', 23, '2004-3-20', 1);
Insert Into player_team VALUES (45, 8);
Insert Into weights VALUES (45, 77, '2017-1-1');
INSERT INTO players VALUES(46, 'Edwin', 'Foster', 23, '1999-4-15', 1);
Insert Into player_team VALUES (46, 8);
Insert Into weights VALUES (46, 57, '2017-1-1');
INSERT INTO players VALUES(47, 'Mekhi', 'Lowe', 23, '2004-10-6', 1);
Insert Into player_team VALUES (47, 8);
Insert Into weights VALUES (47, 57, '2017-1-1');
----


--Żeńska drużyna nr 9 ice hockey
INSERT INTO teams VALUES(9, 2, 20, 229);
INSERT INTO players VALUES(48, 'Arely', 'Perry', 229, '2000-8-1', 2);
Insert Into player_team VALUES (48, 9);
Insert Into weights VALUES (48, 62, '2017-1-1');
INSERT INTO players VALUES(49, 'Paris', 'Chambers', 229, '1993-4-1', 2);
Insert Into player_team VALUES (49, 9);
Insert Into weights VALUES (49, 55, '2017-1-1');
INSERT INTO players VALUES(50, 'Rosemary', 'Richardson', 229, '2002-7-15', 2);
Insert Into player_team VALUES (50, 9);
Insert Into weights VALUES (50, 72, '2017-1-1');
INSERT INTO players VALUES(51, 'Clara', 'Jackson', 229, '1997-7-19', 2);
Insert Into player_team VALUES (51, 9);
Insert Into weights VALUES (51, 53, '2017-1-1');
INSERT INTO players VALUES(52, 'Tanya', 'Parsons', 229, '1998-8-14', 2);
Insert Into player_team VALUES (52, 9);
Insert Into weights VALUES (52, 79, '2017-1-1');
INSERT INTO players VALUES(53, 'Annie', 'Taylor', 229, '2001-6-6', 2);
Insert Into player_team VALUES (53, 9);
Insert Into weights VALUES (53, 58, '2017-1-1');
----

--Żeńska drużyna nr 10 ice hockey
INSERT INTO teams VALUES(10, 2, 20, 92);
INSERT INTO players VALUES(54, 'Marina', 'Reed', 92, '1995-8-9', 2);
Insert Into player_team VALUES (54, 10);
Insert Into weights VALUES (54, 56, '2017-1-1');
INSERT INTO players VALUES(55, 'Rosemary', 'Hart', 92, '2003-9-10', 2);
Insert Into player_team VALUES (55, 10);
Insert Into weights VALUES (55, 54, '2017-1-1');
INSERT INTO players VALUES(56, 'Lorena', 'Davis', 92, '1992-2-15', 2);
Insert Into player_team VALUES (56, 10);
Insert Into weights VALUES (56, 65, '2017-1-1');
INSERT INTO players VALUES(57, 'Maya', 'Chapman', 92, '1991-3-8', 2);
Insert Into player_team VALUES (57, 10);
Insert Into weights VALUES (57, 61, '2017-1-1');
INSERT INTO players VALUES(58, 'Tanya', 'Walsh', 92, '1998-5-17', 2);
Insert Into player_team VALUES (58, 10);
Insert Into weights VALUES (58, 68, '2017-1-1');
INSERT INTO players VALUES(59, 'Payton', 'Gregory', 92, '2004-10-13', 2);
Insert Into player_team VALUES (59, 10);
Insert Into weights VALUES (59, 57, '2017-1-1');
----


--Żeńska drużyna nr 11 ice hockey
INSERT INTO teams VALUES(11, 2, 20, 183);
INSERT INTO players VALUES(60, 'Gracie', 'Stevenson', 183, '2001-8-2', 2);
Insert Into player_team VALUES (60, 11);
Insert Into weights VALUES (60, 75, '2017-1-1');
INSERT INTO players VALUES(61, 'Alejandra', 'Cooper', 183, '1997-10-11', 2);
Insert Into player_team VALUES (61, 11);
Insert Into weights VALUES (61, 62, '2017-1-1');
INSERT INTO players VALUES(62, 'Felicity', 'Butler', 183, '1991-3-9', 2);
Insert Into player_team VALUES (62, 11);
Insert Into weights VALUES (62, 57, '2017-1-1');
INSERT INTO players VALUES(63, 'Rosa', 'King', 183, '1996-5-15', 2);
Insert Into player_team VALUES (63, 11);
Insert Into weights VALUES (63, 67, '2017-1-1');
INSERT INTO players VALUES(64, 'Clara', 'Howard', 183, '2001-8-5', 2);
Insert Into player_team VALUES (64, 11);
Insert Into weights VALUES (64, 70, '2017-1-1');
INSERT INTO players VALUES(65, 'Ashlyn', 'Payne', 183, '1998-8-12', 2);
Insert Into player_team VALUES (65, 11);
Insert Into weights VALUES (65, 55, '2017-1-1');
----

--Żeńska drużyna nr 12 ice hockey
INSERT INTO teams VALUES(12, 2, 20, 213);
INSERT INTO players VALUES(66, 'Felicity', 'Newman', 213, '2000-6-12', 2);
Insert Into player_team VALUES (66, 12);
Insert Into weights VALUES (66, 59, '2017-1-1');
INSERT INTO players VALUES(67, 'Tessa', 'Ball', 213, '1994-8-6', 2);
Insert Into player_team VALUES (67, 12);
Insert Into weights VALUES (67, 62, '2017-1-1');
INSERT INTO players VALUES(68, 'Juliette', 'Martin', 213, '1998-5-17', 2);
Insert Into player_team VALUES (68, 12);
Insert Into weights VALUES (68, 62, '2017-1-1');
INSERT INTO players VALUES(69, 'Alyssa', 'Robson', 213, '1996-11-10', 2);
Insert Into player_team VALUES (69, 12);
Insert Into weights VALUES (69, 70, '2017-1-1');
INSERT INTO players VALUES(70, 'Caylee', 'Yates', 213, '1994-11-10', 2);
Insert Into player_team VALUES (70, 12);
Insert Into weights VALUES (70, 76, '2017-1-1');
INSERT INTO players VALUES(71, 'Noelle', 'Nicholson', 213, '2004-3-8', 2);
Insert Into player_team VALUES (71, 12);
Insert Into weights VALUES (71, 59, '2017-1-1');
----


--Żeńska drużyna nr 13 ice hockey
INSERT INTO teams VALUES(13, 2, 20, 231);
INSERT INTO players VALUES(72, 'Keira', 'Baker', 231, '2000-11-16', 2);
Insert Into player_team VALUES (72, 13);
Insert Into weights VALUES (72, 63, '2017-1-1');
INSERT INTO players VALUES(73, 'Jaylee', 'Williamson', 231, '2000-10-16', 2);
Insert Into player_team VALUES (73, 13);
Insert Into weights VALUES (73, 74, '2017-1-1');
INSERT INTO players VALUES(74, 'Jakayla', 'Stone', 231, '1996-9-11', 2);
Insert Into player_team VALUES (74, 13);
Insert Into weights VALUES (74, 77, '2017-1-1');
INSERT INTO players VALUES(75, 'Amaris', 'Hart', 231, '1996-10-11', 2);
Insert Into player_team VALUES (75, 13);
Insert Into weights VALUES (75, 53, '2017-1-1');
INSERT INTO players VALUES(76, 'Selina', 'Wright', 231, '1998-4-10', 2);
Insert Into player_team VALUES (76, 13);
Insert Into weights VALUES (76, 68, '2017-1-1');
INSERT INTO players VALUES(77, 'Juliette', 'Holland', 231, '2002-2-13', 2);
Insert Into player_team VALUES (77, 13);
Insert Into weights VALUES (77, 54, '2017-1-1');
----

--Żeńska drużyna nr 14 ice hockey
INSERT INTO teams VALUES(14, 2, 20, 48);
INSERT INTO players VALUES(78, 'Camille', 'Brown', 48, '2001-3-18', 2);
Insert Into player_team VALUES (78, 14);
Insert Into weights VALUES (78, 53, '2017-1-1');
INSERT INTO players VALUES(79, 'Donna', 'Taylor', 48, '2003-9-19', 2);
Insert Into player_team VALUES (79, 14);
Insert Into weights VALUES (79, 56, '2017-1-1');
INSERT INTO players VALUES(80, 'Shania', 'Reynolds', 48, '1994-5-1', 2);
Insert Into player_team VALUES (80, 14);
Insert Into weights VALUES (80, 76, '2017-1-1');
INSERT INTO players VALUES(81, 'Diana', 'Riley', 48, '1991-7-18', 2);
Insert Into player_team VALUES (81, 14);
Insert Into weights VALUES (81, 75, '2017-1-1');
INSERT INTO players VALUES(82, 'Holly', 'Reynolds', 48, '1995-2-13', 2);
Insert Into player_team VALUES (82, 14);
Insert Into weights VALUES (82, 60, '2017-1-1');
INSERT INTO players VALUES(83, 'Shaylee', 'Reed', 48, '1999-3-18', 2);
Insert Into player_team VALUES (83, 14);
Insert Into weights VALUES (83, 75, '2017-1-1');
----


--Żeńska drużyna nr 15 ice hockey
INSERT INTO teams VALUES(15, 2, 20, 108);
INSERT INTO players VALUES(84, 'Aurora', 'Dunn', 108, '1997-8-3', 2);
Insert Into player_team VALUES (84, 15);
Insert Into weights VALUES (84, 51, '2017-1-1');
INSERT INTO players VALUES(85, 'Diana', 'Page', 108, '2001-5-13', 2);
Insert Into player_team VALUES (85, 15);
Insert Into weights VALUES (85, 53, '2017-1-1');
INSERT INTO players VALUES(86, 'Jessie', 'Bishop', 108, '1999-4-3', 2);
Insert Into player_team VALUES (86, 15);
Insert Into weights VALUES (86, 68, '2017-1-1');
INSERT INTO players VALUES(87, 'Savanna', 'Saunders', 108, '1993-5-16', 2);
Insert Into player_team VALUES (87, 15);
Insert Into weights VALUES (87, 72, '2017-1-1');
INSERT INTO players VALUES(88, 'Tanya', 'Chambers', 108, '1991-6-11', 2);
Insert Into player_team VALUES (88, 15);
Insert Into weights VALUES (88, 72, '2017-1-1');
INSERT INTO players VALUES(89, 'Reyna', 'Andrews', 108, '1998-11-7', 2);
Insert Into player_team VALUES (89, 15);
Insert Into weights VALUES (89, 51, '2017-1-1');
----

--Żeńska drużyna nr 16 ice hockey
INSERT INTO teams VALUES(16, 2, 20, 214);
INSERT INTO players VALUES(90, 'Juliette', 'Sharp', 214, '1990-7-1', 2);
Insert Into player_team VALUES (90, 16);
Insert Into weights VALUES (90, 71, '2017-1-1');
INSERT INTO players VALUES(91, 'Marina', 'Nicholls', 214, '1996-4-6', 2);
Insert Into player_team VALUES (91, 16);
Insert Into weights VALUES (91, 53, '2017-1-1');
INSERT INTO players VALUES(92, 'Jaylee', 'Warren', 214, '1999-10-2', 2);
Insert Into player_team VALUES (92, 16);
Insert Into weights VALUES (92, 50, '2017-1-1');
INSERT INTO players VALUES(93, 'Liana', 'Lane', 214, '1999-8-9', 2);
Insert Into player_team VALUES (93, 16);
Insert Into weights VALUES (93, 68, '2017-1-1');
INSERT INTO players VALUES(94, 'Annie', 'Hunt', 214, '2003-1-20', 2);
Insert Into player_team VALUES (94, 16);
Insert Into weights VALUES (94, 50, '2017-1-1');
INSERT INTO players VALUES(95, 'Samara', 'Bennett', 214, '2001-11-5', 2);
Insert Into player_team VALUES (95, 16);
Insert Into weights VALUES (95, 64, '2017-1-1');
----


--eventy
INSERT INTO event VALUES (1, 2, '2017-01-10 12:00:00', '2017-01-10 12:30:00', 5, 3);
INSERT INTO event VALUES (2, 2, '2017-01-10 12:30:00', '2017-01-10 13:00:00', 5, 3);
INSERT INTO event VALUES (3, 2, '2017-01-10 13:00:00', '2017-01-10 13:30:00', 5, 3);
INSERT INTO event VALUES (4, 2, '2017-01-10 13:30:00', '2017-01-10 14:00:00', 5, 3);
INSERT INTO event VALUES (5, 2, '2017-01-10 14:00:00', '2017-01-10 14:30:00', 5, 2);
INSERT INTO event VALUES (6, 2, '2017-01-10 14:30:00', '2017-01-10 15:00:00', 5, 2);
INSERT INTO event VALUES (7, 2, '2017-01-10 15:00:00', '2017-01-10 15:30:00', 5, 1);
----

--eventy
INSERT INTO event VALUES (8, 2, '2017-01-10 15:30:00', '2017-01-10 16:00:00', 20, 3);
INSERT INTO event VALUES (9, 2, '2017-01-10 16:00:00', '2017-01-10 16:30:00', 20, 3);
INSERT INTO event VALUES (10, 2, '2017-01-10 16:30:00', '2017-01-10 17:00:00', 20, 3);
INSERT INTO event VALUES (11, 2, '2017-01-10 17:00:00', '2017-01-10 17:30:00', 20, 3);
INSERT INTO event VALUES (12, 2, '2017-01-10 17:30:00', '2017-01-10 18:00:00', 20, 3);
INSERT INTO event VALUES (13, 2, '2017-01-10 18:00:00', '2017-01-10 18:30:00', 20, 2);
INSERT INTO event VALUES (14, 2, '2017-01-10 18:30:00', '2017-01-10 19:00:00', 20, 2);
INSERT INTO event VALUES (15, 2, '2017-01-10 19:00:00', '2017-01-10 19:30:00', 20, 1);

----


--event_team
INSERT INTO event_team VALUES (1, 1, 1);
INSERT INTO event_team VALUES (2, 1, 2);
INSERT INTO event_team VALUES (3, 2, 3);
INSERT INTO event_team VALUES (4, 2, 4);
INSERT INTO event_team VALUES (5, 3, 5);
INSERT INTO event_team VALUES (6, 3, 6);
INSERT INTO event_team VALUES (7, 4, 7);
INSERT INTO event_team VALUES (8, 4, 8);
INSERT INTO event_team VALUES (9, 5, 1);
INSERT INTO event_team VALUES (10, 5, 3);
INSERT INTO event_team VALUES (11, 6, 5);
INSERT INTO event_team VALUES (12, 6, 7);
INSERT INTO event_team VALUES (13, 7, 1);
INSERT INTO event_team VALUES (14, 7, 5);
----

--event_team
INSERT INTO event_team VALUES (15, 8, 9);
INSERT INTO event_team VALUES (16, 8, 10);
INSERT INTO event_team VALUES (17, 9, 11);
INSERT INTO event_team VALUES (18, 9, 12);
INSERT INTO event_team VALUES (19, 10, 13);
INSERT INTO event_team VALUES (20, 10, 14);
INSERT INTO event_team VALUES (21, 11, 15);
INSERT INTO event_team VALUES (22, 11, 16);
INSERT INTO event_team VALUES (23, 12, 9);
INSERT INTO event_team VALUES (24, 12, 11);
INSERT INTO event_team VALUES (25, 13, 13);
INSERT INTO event_team VALUES (26, 13, 15);
INSERT INTO event_team VALUES (27, 14, 9);
INSERT INTO event_team VALUES (28, 14, 13);
--event_team

--results
INSERT INTO results_score VALUES (1, 1);
INSERT INTO results_score VALUES (2, 0);
INSERT INTO results_score VALUES (3, 1);
INSERT INTO results_score VALUES (4, 0);
INSERT INTO results_score VALUES (5, 1);
INSERT INTO results_score VALUES (6, 0);
INSERT INTO results_score VALUES (7, 1);
INSERT INTO results_score VALUES (8, 0);
INSERT INTO results_score VALUES (9, 1);
INSERT INTO results_score VALUES (10, 0);
INSERT INTO results_score VALUES (11, 1);
INSERT INTO results_score VALUES (12, 0);
INSERT INTO results_score VALUES (13, 1);
INSERT INTO results_score VALUES (14, 0);
----

--results
INSERT INTO results_score VALUES (15, 1);
INSERT INTO results_score VALUES (16, 0);
INSERT INTO results_score VALUES (17, 1);
INSERT INTO results_score VALUES (18, 0);
INSERT INTO results_score VALUES (19, 1);
INSERT INTO results_score VALUES (20, 0);
INSERT INTO results_score VALUES (21, 1);
INSERT INTO results_score VALUES (22, 0);
INSERT INTO results_score VALUES (23, 1);
INSERT INTO results_score VALUES (24, 0);
INSERT INTO results_score VALUES (25, 1);
INSERT INTO results_score VALUES (26, 0);
INSERT INTO results_score VALUES (27, 1);
INSERT INTO results_score VALUES (28, 0);
-----


--judges
INSERT INTO judge_game VALUES (1, 1);
INSERT INTO judge_game VALUES (1, 2);
INSERT INTO judge_game VALUES (1, 3);
INSERT INTO judge_game VALUES (1, 4);
INSERT INTO judge_game VALUES (1, 5);
INSERT INTO judge_game VALUES (1, 6);
INSERT INTO judge_game VALUES (1, 7);
----


--judges
INSERT INTO judge_game VALUES (1, 8);
INSERT INTO judge_game VALUES (1, 9);
INSERT INTO judge_game VALUES (1, 10);
INSERT INTO judge_game VALUES (1, 11);
INSERT INTO judge_game VALUES (1, 12);
INSERT INTO judge_game VALUES (1, 13);
INSERT INTO judge_game VALUES (1, 14);
----

COMMIT;
