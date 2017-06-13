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
                          WHERE teams.id = new.team_id);

  crr_players INTEGER := (SELECT
                            count(player_id)
                          FROM player_team
                          WHERE team_id = new.team_id);

  team_sex    INTEGER := (SELECT
                            id_sex
                          FROM teams
                          WHERE id = new.team_id);

  player_sex  INTEGER := (SELECT
                            id_sex
                          FROM players
                          WHERE id = new.player_id);

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
               ON teams.id = player_team.team_id
             JOIN players
               ON player_team.player_id = players.id
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


CREATE OR REPLACE FUNCTION event_time() RETURNS trigger AS $checks$
BEGIN
IF new.start_time>new.end_time  THEN
      RAISE 'Start time after end time';
      RETURN NULL;
END IF;
RETURN new;
END;
$checks$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS result_after_finish
ON event;
CREATE TRIGGER result_after_finish BEFORE INSERT OR UPDATE ON event
FOR EACH ROW EXECUTE PROCEDURE event_time();

CREATE OR REPLACE FUNCTION team_number() RETURNS trigger AS $checks$
BEGIN
IF (select count(teams.id) from teams where id_discipline=new.id_discipline group by id_discipline)>=
   (select max_team_olympiad from disciplines join categories on disciplines.id_categories=categories.id where disciplines.id=new.id_discipline)
THEN
      RAISE 'Too many teams';
      RETURN NULL;
END IF;
RETURN new;
END;
$checks$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS number_of_teams
ON teams;
CREATE TRIGGER number_of_teams BEFORE INSERT OR UPDATE ON teams
FOR EACH ROW EXECUTE PROCEDURE team_number();
