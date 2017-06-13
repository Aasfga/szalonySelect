CREATE OR REPLACE FUNCTION one_judge_in_game()
  RETURNS TRIGGER AS
$one_judge_in_game$
DECLARE
   start_date DATE := (SELECT start_time
                          FROM event
                          WHERE id_judge = NEW.id_judge);

   end_date DATE := (SELECT end_time
                          FROM event
                          WHERE id_judge = NEW.id_judge);
BEGIN

  IF ( select * from event as e where e.id_judge = NEW.id_judge 
				and (start_data,end_data) OVERLAPS ( e.start_time, e.end_time)
				 ) is not null
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

id_disciplines int := (SELECT d.id
                          FROM event_team as et
			    join teams as t on t.id = et.id_team
			    join disciplines as d on d.id = t.id_disciplines
                          WHERE et.id_event = NEW.id
		          group by d.id
);

BEGIN

  IF ( select * from event as e 
				 join event_team as et on et.id_event = e.id
				 join teams as t on t.id = et.id_team
			    	 join disciplines as d on d.id = t.id_disciplines
					where e.final_id < NEW.final_id and d.id = id_disciplines and e.end_time < NEW.start_time				 			) is not null
  THEN
    RAISE 'Wrong finals orders';
  END IF;

  IF ( select * from event as e  
				 join event_team as et on et.id_event = e.id
				 join teams as t on t.id = et.id_team
			    	 join disciplines as d on d.id = t.id_disciplines
				where e.final_id < NEW.final_id and  d.id = id_disciplines and e.start_time > NEW.end_time				 			) is not null
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

