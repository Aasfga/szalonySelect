package common.generators;

import common.Judge;

import java.sql.SQLException;
import java.sql.Statement;
import java.util.Objects;
import java.util.Scanner;

public class Manually {
    public static Manually.Builder builder(Statement statement) {
        return new Manually.Builder( statement );
    }
    private static Scanner scanner = new Scanner(System.in);

    public static class Communication{
        public static void hello(String arg){
            System.out.printf("Adding new "+arg+":");
        }
        public static String enter(String word){
            System.out.printf("Enter "+word+":");
            return scanner.next();
        }
        public static String enter(String word,String extrainfo){
            System.out.printf("Enter "+word+":");
            System.out.printf( "("+extrainfo+")" );
            return scanner.next();
        }
        public static void error(SQLException e){
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
            String name=Communication.enter( "name" );
            String min_team_game=Communication.enter( "min_team_game" );
            String max_team_game=Communication.enter( "max_team_game" );
            String min_players_team=Communication.enter( "min_players_team" );
            String max_players_team=Communication.enter( "max_players_team" );
            String id_result_type=Communication.enter( "id_result_type","1-score, 2-time, 3-points" );
            String sex=Communication.enter( "sex","1-male, 2-female, 3-both" );

            try {
                String sql = "INSERT INTO categories VALUES(DEFAULT ,\'" + name + "\', " + min_team_game + ", " + max_team_game + "," + min_players_team + "," + max_players_team + "," + id_result_type + ");";
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
    }

}
