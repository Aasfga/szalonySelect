package common;

import common.generators.Communication;
import common.generators.Manually;
import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.SQLException;
import java.sql.Statement;
import java.util.Objects;
import java.util.Scanner;

public class Category {
    public static Builder builder(Statement statement) {
        return new Builder( statement );
    }
    private static Scanner scanner = new Scanner(System.in);
    public static class Builder {
        final private Preparer preparer;
        private Statement statement;
        public Builder(Statement statement) {
            this.statement = statement;

            this.preparer = new Preparer( statement );
        }

        public void manually() {
            Communication.hello( "category" );
            String name = Communication.enter( "name" );
            String sex = Communication.enter( "sex", "1-male, 2-female, 3-both" );

            try {
                String sql = "INSERT INTO categories VALUES(DEFAULT ,\'" +
                        name + "\', "
                        + Communication.enter( "min_team_game" ) + ", "
                        + Communication.enter( "max_team_game" ) + ","
                        + Communication.enter( "min_players_team" ) + ","
                        + Communication.enter( "max_players_team" ) + ","
                        + Communication.enter( "id_result_type", "1-score, 2-time, 3-points" ) + ");";
                statement.execute( sql );

                String categoryID = preparer.lastUsedDefaultID( "categories" );
                if (Objects.equals( sex, "3" )) {
                    sql = "INSERT INTO disciplines VALUES(DEFAULT ," + "1" + "," + categoryID + ");";
                    statement.execute( sql );
                    sql = "INSERT INTO disciplines VALUES(DEFAULT ," + "2" + "," + categoryID + ");";
                    statement.execute( sql );
                } else if (Objects.equals( sex, "2" )||Objects.equals( sex, "1" )) {
                    sql = "INSERT INTO disciplines VALUES(DEFAULT ," + sex + "," + categoryID + ");";
                    statement.execute( sql );
                }
                else{
                    Communication.error( new SQLException(  ) );
                    return;
                }
            } catch (SQLException e) {
                Communication.error( e );
            }
            System.out.println( "Success! " + name + " added.\n" );
        }
    }
    public static void manually(){
        builder( MainApp.statement ).manually();
    }
}
