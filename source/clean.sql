
drop table if exists finals cascade;
drop table if exists nationalities cascade;
drop table if exists sexes cascade;
drop table if exists categories cascade;
drop table if exists disciplines cascade;
drop table if exists players cascade;
drop table if exists weights cascade;
drop table if exists teams cascade;
drop table if exists player_team cascade;
drop table if exists places cascade;
drop table if exists judges cascade;
drop table if exists event cascade;
drop table if exists judge_game cascade;
drop table if exists event_team cascade;
drop table if exists results_score cascade;
drop table if exists results_time cascade;
drop table if exists results_notes cascade;



-- drop trigger if exists team_insert on player_team cascade;
-- drop trigger if exists sex_change_team on teams CASCADE;


DROP FUNCTION IF EXISTS event_time();
DROP FUNCTION IF EXISTS dont_overloading_team();
DROP FUNCTION IF EXISTS insert_event();
DROP FUNCTION IF EXISTS one_nationality_in_team();
DROP FUNCTION IF EXISTS one_judge_in_game();
DROP FUNCTION IF EXISTS sex_change_team();
DROP FUNCTION IF EXISTS team_insert();
DROP FUNCTION IF EXISTS team_number();




