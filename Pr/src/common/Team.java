package common;

import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Random;


public class Team {


    public static Builder builder(Statement statement){
        return new Builder(statement);
    }

    public static class Builder {

        final private Randomise randomise;
        final private Preparer preparer;
        private Statement statement;
        private String sexID;
        private String disciplineID;
        private String nationalityID;

        public  Builder(Statement statement){
            this.statement = statement;
            this.randomise = new Randomise(statement);
            this.preparer = new Preparer(statement);
        }

        public Builder withsexID(String sexID) {
            this.sexID = sexID;
            return this;
        }

        public Builder withdisciplineID(String disciplineID) {
            this.disciplineID = disciplineID;
            return this;
        }

        public Builder withNationalityID(String nationalityID) {
            this.nationalityID = nationalityID;
            return this;
        }


        public void add() throws SQLException {
            Random random = new Random();
            Preparer preparer = new Preparer(statement);

            sexID = ( sexID == null ) ? randomise.randomIdFromTable("sexes") : sexID;
            disciplineID = (  disciplineID == null ) ? ( (sexID.equals("1")) ? randomise.randomIdFromTable("disciplinemale") : randomise.randomIdFromTable("disciplinefemale") ) : disciplineID;
            nationalityID = ( nationalityID == null ) ? randomise.randomIdFromTable("nationalities") : nationalityID;

            String sql = "INSERT INTO teams VALUES(DEFAULT ," + sexID + " , " + disciplineID + " , " + nationalityID + ");";
            statement.execute(sql);

            sql = "SELECT * from disciplines as d join categories as c on c.id = d.id_categories where id_sex = " + sexID + " and d.id = " + disciplineID + ";";
            ResultSet rs = statement.executeQuery(sql);
            rs.next();
            int min_players_team = rs.getInt(8);
            int max_players_team = rs.getInt(9);

            int randomnumber_players = random.nextInt(max_players_team + 1 - min_players_team) + min_players_team;
            sql = " SELECT id from players where id_sex = " + sexID + " and id_nationality = " + nationalityID+ ";";
            rs = statement.executeQuery(sql);
            ArrayList players = preparer.arrayFromResultSetColumn(rs,1);

            while( players.size() < randomnumber_players) {
                Player.builder().withSexId(sexID).withNationalityID(nationalityID).add();
                players.add(preparer.lastUsedDefaultID("players"));
            }

            String teamID = preparer.lastUsedDefaultID("teams");

            while( randomnumber_players-- > 0  ) {
                sql = "INSERT INTO player_team values ( " + players.get(randomnumber_players) + " , " + teamID + " );";
                    statement.execute(sql);
                }

            System.out.println( "Success! New teams has been added!" );
        }

    }


}

