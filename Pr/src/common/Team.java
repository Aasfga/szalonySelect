package common;

import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedHashSet;
import java.util.Random;

import static common.MainApp.displayResultSet;

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
            int counter = 0;
            String randomdiscipline;
            sexID = ( sexID == null ) ? randomise.randomIdFromTable("sexes") : sexID;

            String sql = "SELECT count(*) from disciplines where id_sex = " + sexID + ";";
            ResultSet rs = statement.executeQuery(sql);
            rs.next();
            int randomnumber = random.nextInt(rs.getInt(1));
            sql = "SELECT id from disciplines  where id_sex = " + sexID + ";";
            rs = statement.executeQuery(sql);
            while(true){
                rs.next();
                if ( counter == randomnumber) {
                    randomdiscipline = rs.getString(1);
                    break;
                }
                counter++;
            }


            disciplineID = ( disciplineID == null ) ?  randomdiscipline  : disciplineID;
            nationalityID = ( nationalityID == null ) ? randomise.randomIdFromTable("nationalities") : nationalityID;

            sql = "INSERT INTO teams VALUES(DEFAULT ," + sexID + " , " + disciplineID + " , " + nationalityID + ");";
            statement.execute(sql);
            System.out.println(sql);


            sql = "SELECT c.min_players_team, c.max_players_team from disciplines as d join categories as c on c.id = d.id_categories where id_sex = " + sexID + " and d.id = " + disciplineID + ";";
            rs = statement.executeQuery(sql);
            rs.next();
            int min_players_team = rs.getInt(1);
            int max_players_team = rs.getInt(2);

            sql = "SELECT * from disciplines as d join categories as c on c.id = d.id_categories where id_sex = " + sexID + " and d.id = " + disciplineID + ";";
            rs = statement.executeQuery(sql);
            displayResultSet(rs);

            int randomnumber_players = random.nextInt(max_players_team + 1 - min_players_team) + min_players_team;

            sql = " SELECT * from players where id_sex = " + sexID + " and id_nationality = " + nationalityID+ ";";
            rs = statement.executeQuery(sql);
            counter = 0;
            while (rs.next() ) counter++;


            while( counter < randomnumber_players) {
                Player.builder(statement).withID(sexID).withNationalityID(nationalityID).add();
                counter++;
            }


            LinkedHashSet list_random_int = new LinkedHashSet();
            do{
                int number = random.nextInt(counter);
                list_random_int.add(number);
            } while ( list_random_int.size() < randomnumber_players);


            counter = 0;
            String teamID = preparer.lastUsedDefaultID("teams");

            sql = " SELECT * from players where id_sex = " + sexID + " and id_nationality = " + nationalityID+ ";";
            rs = statement.executeQuery(sql);


            try {
                   while( rs.next()) {
                       if ( list_random_int.contains(counter)) {
                           sql = "INSERT INTO player_team values ( " + rs.getString(1) + " , " + teamID + " );";
                           statement.execute(sql);
                           System.out.println(sql);
                       }
                       counter++;
                   }
               } catch (SQLException e) {
//            TODO
                  e.printStackTrace();
               }

        }

    }


}
