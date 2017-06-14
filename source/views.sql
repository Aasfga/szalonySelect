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
