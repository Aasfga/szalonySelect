package common.generators;

import common.Judge;
import common.Results;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Objects;
import java.util.Scanner;


public class Manually {
    public static Builder builder(Statement statement) {
        return new Builder( statement );
    }
    private static Scanner scanner = new Scanner(System.in);




    public static class Builder{
        private Statement statement;
        final private Preparer preparer;
        Builder(Statement statement) {
            this.statement = statement;
            this.preparer = new Preparer(statement);
        }

        public void team(){
            Communication.hello( "team" );
            String sex=Communication.enter( "sex","1-male, 2-female" );

            try {
                Communication.hello( "Select discipline");
                String sql = "SELECT d.id, c.name FROM disciplines as d left join categories as c on d.id_categories = c.id where id_sex = " + sex + ";";
                ResultSet rs = statement.executeQuery(sql);
//                displayResultSet(rs);
                String discipline =Communication.enter("Select ID" );

                Communication.hello( "Select nationality");
                sql = "SELECT * FROM nationalities;";
                rs = statement.executeQuery(sql);
//                displayResultSet(rs);
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
//                    displayResultSet(rs);
                    return;
                }

                Communication.hello( "Select players");
//                displayResultSet(rs);

                for ( int i = 0; i <  Integer.parseInt(numberplayers); i++ ) {
                    String id_players =Communication.enter("Select ID" );
                    sql = "INSERT INTO player_team VALUES("+ id_players + "," + teamID + ");";
                    statement.execute(sql);
                }

            } catch (SQLException e) {
                Communication.error( e );
            }
            System.out.println("Success!\n");
        }
    }

}
