package common;

import common.generators.Communication;
import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Random;

import static common.generators.Preparer.displayResultSet;


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

        public void manually() throws SQLException {
            Communication.hello( "team" );
            String sex=Communication.enter( "sex","1-male, 2-female" );

                Communication.hello( "Select discipline");
                String sql = "SELECT d.id, c.name FROM disciplines as d left join categories as c on d.id_categories = c.id where id_sex = " + sex + ";";
                ResultSet rs = statement.executeQuery(sql);
                displayResultSet(rs);
                String discipline =Communication.enter("Select ID" );

                Communication.hello( "Select nationality");
                sql = "SELECT * FROM nationalities;";
                rs = statement.executeQuery(sql);
                displayResultSet(rs);
                String nationalities =Communication.enter("Select ID" );

                sql = "INSERT INTO teams VALUES(DEFAULT ," + sex + "," + discipline + "," + nationalities+ ");";
                statement.execute(sql);
                String teamID = preparer.lastUsedDefaultID("teams");


                sql = "select * from categories where id = " + discipline +";";
                rs = statement.executeQuery(sql);
                rs.next();
                int minplayer = rs.getInt(5);
                int maxplayer = rs.getInt(6);
                String numberplayers =Communication.enter("Select number of players in team (" + minplayer + "," + maxplayer + ")" );

                sql = "SELECT * FROM players where id_sex = " + sex + " and id_nationality = " + nationalities + ";";
                rs = statement.executeQuery(sql);

                int counter = 0;
                while( rs.next( )) counter++;
                if ( counter < Integer.parseInt(numberplayers) ) {
                    Communication.hello( "Not enough players, first add new players");
                    return;
                }

                Communication.hello( "Select players");
                displayResultSet(rs);

                for ( int i = 0; i <  Integer.parseInt(numberplayers); i++ ) {
                    String id_players =Communication.enter("Select ID" );
                    sql = "INSERT INTO player_team VALUES("+ id_players + "," + teamID + ");";
                    statement.execute(sql);
                }
                System.out.println("Success!\n");

        }

    }

    public static void manually()throws SQLException{
        builder( MainApp.statement ).manually();
    }
    public static void generate()throws SQLException{
        builder( MainApp.statement ).add();
    }


}

