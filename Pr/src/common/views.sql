DROP VIEW IF EXISTS disciplines_views;
DROP VIEW IF EXISTS players_views;
DROP VIEW IF EXISTS gold_medals;
DROP VIEW IF EXISTS silver_medals;
DROP VIEW IF EXISTS bronze_medals;
DROP VIEW IF EXISTS results cascade;
DROP VIEW IF EXISTS team_category cascade;
DROP VIEW IF EXISTS players_all cascade;
DROP VIEW IF EXISTS lol3 cascade;
DROP VIEW IF EXISTS lol2 cascade;
DROP VIEW IF EXISTS lol cascade;
DROP VIEW IF EXISTS teams_views CASCADE;
DROP VIEW IF EXISTS events_views CASCADE;
DROP VIEW IF EXISTS ranking CASCADE;

CREATE VIEW team_category AS SELECT
      nationalities.name as country,categories.name as category,teams.id as team
      from teams
            join nationalities on id_nationalities=nationalities.id
            join disciplines on id_discipline=disciplines.id
            join categories on id_categories=categories.id;


CREATE VIEW results AS SELECT
 country, category,id_final as final, finals.name, event_team_result.result as result
 from team_category
 join event_team_result on id_team=team
 join events on id_event=events.id
 join finals on id_final=finals.id;

CREATE VIEW teams_views as
 select teams.id ,sexes.name as sex,categories.name as category,nationalities.name as nationality
 from teams join sexes on teams.id_sex=sexes.id
 join disciplines on id_discipline=disciplines.id
 join categories on id_categories=categories.id
 join nationalities on nationalities.id=id_nationalities;

CREATE VIEW lol AS
 select
 final,category, max(result) as scoremax from results where final=1 group by category,final;

CREATE VIEW lol2 AS
 select
 final,category, min(result) as scoremax from results where final=1 group by category,final;

CREATE VIEW lol3 AS
 select
 final,category, max(result) as scoremax from results where final=2 group by category,final;

CREATE VIEW gold_medals AS SELECT country,lol.category
 from results join lol on results.final=lol.final and results.category=lol.category
        where results.result=lol.scoremax;

CREATE VIEW silver_medals AS SELECT country,lol2.category
 from results join lol2 on results.final=lol2.final and results.category=lol2.category
       where results.result=lol2.scoremax;

CREATE VIEW bronze_medals AS SELECT country,lol3.category
 from results join lol3 on results.final=lol3.final and results.category=lol3.category
       where results.result=lol3.scoremax;

CREATE VIEW disciplines_views AS SELECT d.id, sexes.name as sex_name, c.name as name_category from disciplines as d join sexes on sexes.id = d.id_sex join categories as c on c.id = d.id_categories;

CREATE VIEW players_views AS SELECT p.id, p.first_name, p.last_name, n.name, p.birth_date, s.name as sex_name from players as p 
	join nationalities as n on p.id_nationality = n.id
	join sexes as s on s.id = p.id_sex;

CREATE VIEW events_views AS SELECT e.id, p.name as place_name, e.date, d.sex_name, d.name_category, f.name as name_finals from events as e
	join places as p on e.id_place = p.id
	join disciplines_views as d on d.id = e.id_disciplines
	join finals as f on f.id = e.id_final;

CREATE VIEW ranking as select
      country,count(category) from gold_medals group by country order by 2,1;
