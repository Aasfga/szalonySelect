CREATE OR REPLACE FUNCTION one_judge_in_game()
  RETURNS TRIGGER AS
$one_judge_in_game$
DECLARE
  start_date DATE := (SELECT
                        start_time
                      FROM event
                      WHERE id_judge = NEW.id_judge);

  end_date   DATE := (SELECT
                        end_time
                      FROM event
                      WHERE id_judge = NEW.id_judge);
BEGIN

  IF (SELECT
        *
      FROM event AS e
      WHERE e.id_judge = NEW.id_judge
            AND (start_data, end_data) OVERLAPS (e.start_time, e.end_time)
     ) IS NOT NULL
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

CREATE OR REPLACE FUNCTION insert_event()
  RETURNS TRIGGER AS
$insert_event$
DECLARE

  id_disciplines INT := (SELECT
                           d.id
                         FROM event_team AS et
                           JOIN teams AS t
                             ON t.id = et.id_team
                           JOIN disciplines AS d
                             ON d.id = t.id_discipline
                         WHERE et.id_event = NEW.id
                         GROUP BY d.id
  );

BEGIN

  IF (SELECT
        *
      FROM event AS e
        JOIN event_team AS et
          ON et.id_event = e.id
        JOIN teams AS t
          ON t.id = et.id_team
        JOIN disciplines AS d
          ON d.id = t.id_discipline
      WHERE e.id_final < NEW.id_final AND d.id = id_disciplines AND e.end_time < NEW.start_time) IS NOT NULL
  THEN
    RAISE 'Wrong finals orders';
  END IF;

  IF (SELECT
        *
      FROM event AS e
        JOIN event_team AS et
          ON et.id_event = e.id
        JOIN teams AS t
          ON t.id = et.id_team
        JOIN disciplines AS d
          ON d.id = t.id_discipline
      WHERE e.id_final < NEW.id_final AND d.id = id_disciplines AND e.start_time > NEW.end_time) IS NOT NULL
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

