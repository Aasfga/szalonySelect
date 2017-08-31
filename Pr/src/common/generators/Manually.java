package common.generators;

import common.Judge;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Objects;
import java.util.Scanner;


public class Manually {
    public static Manually.Builder builder(Statement statement) {
        return new Manually.Builder( statement );
    }
    private static Scanner scanner = new Scanner(System.in);

    static class Communication{
        static void hello(String arg){
            System.out.printf("Adding new "+arg+":\n");
        }
        static String enter(String word){
            System.out.printf("Enter "+word+":");
            return scanner.next();
        }
        static String enter(String word,String extrainfo){
            System.out.printf("Enter "+word+":");
            System.out.printf( "("+extrainfo+")" );
            return scanner.next();
        }
        static void error(SQLException e){
            System.out.println("Something went wrong...Sorry. Try different parameters.");
            e.printStackTrace();
        }
    }


    public static class Builder{
        private Statement statement;
        final private Preparer preparer;
        Builder(Statement statement) {
            this.statement = statement;
            this.preparer = new Preparer(statement);
        }

        public void judge(){
            Communication.hello( "judge" );
            String first_name=Communication.enter( "first name" );
            String last_name=Communication.enter( "last name" );;
            try {
                Judge.builder(statement).withFirstName(first_name).withLastName( last_name ).add();
            } catch (SQLException e) {
                Communication.error( e );
                return;
            }
            System.out.println("Success! " + first_name+ " " + last_name + " added.\n");
        }

        public void category(){
            Communication.hello( "category" );
            String name= Communication.enter( "name" );
            String sex=Communication.enter( "sex","1-male, 2-female, 3-both" );

            try {
                String sql = "INSERT INTO categories VALUES(DEFAULT ,\'" +
                        name + "\', "
                        + Communication.enter( "min_team_game" ) + ", "
                        + Communication.enter( "max_team_game" ) + ","
                        + Communication.enter( "min_players_team" ) + ","
                        + Communication.enter( "max_players_team" ) + ","
                        + Communication.enter( "id_result_type","1-score, 2-time, 3-points" ) + ");";
                statement.execute( sql );

                String categoryID = preparer.lastUsedDefaultID("categories");
                if(!Objects.equals( sex, "3" )){
                    sql = "INSERT INTO disciplines VALUES(DEFAULT ," + sex + "," + categoryID + ");";
                    statement.execute(sql);
                }
                else{
                    sql = "INSERT INTO disciplines VALUES(DEFAULT ," + "1" + "," + categoryID + ");";
                    statement.execute(sql);
                    sql = "INSERT INTO disciplines VALUES(DEFAULT ," + "2" + "," + categoryID + ");";
                    statement.execute(sql);
                }
            } catch (SQLException e) {
               Communication.error( e );
            }
            System.out.println("Success! " + name+  "added.\n");
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
