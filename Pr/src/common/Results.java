package common;

import common.generators.Communication;
import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Random;

public class Results {
    public static Builder builder(Statement statement){
        return new Builder(statement);
    }

    public static class Builder {

        final private Randomise randomise;
        final private Preparer preparer;
        private Statement statement;

        private String id_event;
        private String id_team;
        private String id_discipline;
        private String result;

        public  Builder(Statement statement){
            this.statement = statement;
            this.randomise = new Randomise(statement);
            this.preparer = new Preparer(statement);
        }

        public Builder withTeamID(String id_team) {
            this.id_team = id_team;
            return this;
        }
        public Builder withEventID(String id_event) {
            this.id_event = id_event;
            return this;
        }
        public Builder withResult(String result) {
            this.result = result;
            return this;
        }
        public void add() throws SQLException {
            if( id_event == null&&id_team==null ){
                while(true){
                    id_event = randomise.randomIdFromTable("events");
                    String sql = "SELECT id_disciplines FROM  events where id=" +id_event +";";
                    ResultSet resultSet = statement.executeQuery(sql);
                    resultSet.next();
                    id_discipline= resultSet.getString(1);
                    sql = "SELECT * FROM teams where id_discipline=" +id_discipline + ";";
                    ResultSet rs = statement.executeQuery(sql);
                    ArrayList<String> ids = preparer.arrayFromResultSetColumn(rs,1);
                    if(ids.size()==1||ids.size()==0){
                        continue;
                    }
                    Random random = new Random();
                    int rand = Math.abs(random.nextInt()%(ids.size()-1));
                    id_team=ids.get(rand);
                    sql = "SELECT * FROM event_team_result where id_event=" +id_event +" and id_team="+id_team+ ";";
                    rs = statement.executeQuery(sql);
                    ids = preparer.arrayFromResultSetColumn(rs,1);
                    if(ids.size()==1)
                        continue;
                    break;
                }

            }
            String[] tab= {"1","0","2","3","4","5","6","7","8","9"};
            int x=randomise.randomFromBetween(0,9);
            result = ( result == null ) ? tab[x] : result;
            String sql = "INSERT INTO event_team_result VALUES(" + id_event + "," + id_team + "," + result + ");";

            statement.execute(sql);


        }

        public void manually() throws SQLException {
            Communication.hello("result");
            String sql = "SELECT * FROM events;";
            ResultSet rs = statement.executeQuery(sql);
            Preparer.displayResultSet(rs);
            String ev = Communication.enter("event", "id");
            if (!new Preparer(statement).isTableContainsGivenId("events", ev)) {
                Communication.error(new SQLException());
            }
            sql = "SELECT id_disciplines FROM  events where id=" + ev + ";";
            ResultSet resultSet = statement.executeQuery(sql);
            resultSet.next();
            String id_discipline = resultSet.getString(1);
            sql = "SELECT * FROM teams where id_discipline=" + id_discipline + ";";
            rs = statement.executeQuery(sql);
            Preparer.displayResultSet(rs);
            String t = Communication.enter("team", "id");
            if (!new Preparer(statement).isTableContainsGivenId("teams", t)) {
                Communication.error(new SQLException());
            }
            String r = Communication.enter("result", true);
            Results.builder(statement).
                    withEventID(ev).withResult(t).withTeamID(r).
                    add();
            System.out.println("Success! new result added.\n");
        }

    }
    public static void manually()throws SQLException{
        builder( MainApp.statement ).manually();
    }
    public static void generate()throws SQLException{
        builder( MainApp.statement ).add();
    }
}
