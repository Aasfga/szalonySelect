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


