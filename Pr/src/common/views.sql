DROP VIEW IF EXISTS gold_medals;
DROP VIEW IF EXISTS silver_medals;
DROP VIEW IF EXISTS bronze_medals;
DROP VIEW IF EXISTS results cascade;
DROP VIEW IF EXISTS team_category cascade;
DROP VIEW IF EXISTS players_all cascade;
DROP VIEW IF EXISTS lol3 cascade;
DROP VIEW IF EXISTS lol2 cascade;
DROP VIEW IF EXISTS lol cascade;


CREATE VIEW team_category AS SELECT
      nationalities.name as country,categories.name as category,teams.id as team
      from teams
            join nationalities on id_nationalities=nationalities.id
            join disciplines on id_discipline=disciplines.id
            join categories on id_categories=categories.id;

CREATE VIEW results AS SELECT
 country, category,id_final as final, finals.name, event_team_result.result as points
 from team_category
 join event_team_result on id_team=team
 join events on id_event=events.id
 join finals on id_final=finals.id;

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
