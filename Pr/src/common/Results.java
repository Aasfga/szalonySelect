package common;

import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
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

        public Results.Builder withTeamID(String id_team) {
            this.id_team = id_team;
            return this;
        }
        public Results.Builder withEventID(String id_event) {
            this.id_event = id_event;
            return this;
        }
        public Results.Builder withResult(String result) {
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
                    break;
                }

            }
            else{
                //TODO
            }
            String[] tab= {"1","2","3","0","4"};
            int x=randomise.randomFromBetween(0,4);
            result = ( result == null ) ? tab[x] : result;
            String sql = "INSERT INTO event_team_result VALUES(" + id_event + "," + id_team + "," + result + ");";

            statement.execute(sql);


        }

    }
}
