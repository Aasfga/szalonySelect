package common;

import common.generators.Communication;
import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import static common.MainApp.statement;

public class Event {



//    public static String generateManually(Scanner scanner) {
//
//        System.out.println("Give sex ID:");
//        System.out.println("");
//        return null;
//    }


    public static Builder builder(Statement statement){
        return new Builder(statement);
    }

    public static class Builder {

        final private Randomise randomise;
        final private Preparer preparer;
        private Statement statement;

        private String id_place;
        private String start_time;
        private String end_time;
        private String id_discipline;
        private String id_final;
        private String id_judge;

        public  Builder(Statement statement){
            this.statement = statement;
            this.randomise = new Randomise(statement);
            this.preparer = new Preparer(statement);
        }

        public Builder withPlaceID(String id_place) {
            this.id_place = id_place;
            return this;
        }

        public Builder withStartTime(String start_time) {
            this.start_time = start_time;
            return this;
        }

        public Builder withEndTime(String end_time) {
            this.end_time = end_time;
            return this;
        }

        public Builder withDisciplineID(String id_discipline) {
            this.id_place = id_discipline;
            return this;
        }

        public Builder withFinalID(String id_final) {
            this.id_final = id_place;
            return this;
        }

        public Builder withJudgeID(String id_judge) {
            this.id_judge = id_judge;
            return this;
        }

        public void add() throws SQLException {
            id_place = ( id_place == null ) ? randomise.randomIdFromTable("places") : id_place;
            long time = randomise.randomFromBetween(1498000000000L,1500000000000L);
            start_time = ( start_time == null ) ? new Timestamp(time).toString() : start_time;
            end_time = ( end_time == null ) ?  new Timestamp(time + 10000000).toString()   : end_time;
            id_discipline = ( id_discipline == null ) ? randomise.randomIdFromTable("disciplines") : id_discipline;
            id_final = ( id_final == null ) ? randomise.randomIdFromTable("finals") : id_final;
            id_judge = (id_judge == null) ? randomise.randomIdFromTable("judges")   : id_judge; //check not null

            String sql = "INSERT INTO events VALUES(DEFAULT ," + id_place + ", \'" + start_time + "\', \'" + end_time + "\'," + id_discipline + "," + id_final + ");";
            statement.execute(sql);

            String eventID = preparer.lastUsedDefaultID("events");
            sql = "INSERT INTO judge_game VALUES(" + id_judge + "," + eventID + ");";
            statement.execute(sql);
        }

    }
    public static void manually()throws SQLException{
        String id_place= Communication.enter( "Place ID",true,"places"  );
        if(!new Preparer(statement).isTableContainsGivenId("places",id_place)) {
            Communication.error( new SQLException() );
            return;
        }
        String id_discipline=Communication.enter( "Discipline ID",true,"disciplines"  ) ;
        if(!new Preparer(statement).isTableContainsGivenId("disciplines",id_discipline)){
            Communication.error( new SQLException(  ) );
            return;
        }
        String id_final=Communication.enter( "Final ID",true,"finals"  );
        if(!new Preparer(statement).isTableContainsGivenId("finals",id_final)){
            Communication.error( new SQLException(  ) );
            return;
        }
        String id_judge=Communication.enter( "Judge ID",true,"judges"  );
        if(!new Preparer(statement).isTableContainsGivenId("judges",id_judge)){
            Communication.error( new SQLException(  ) );
            return;
        }
        builder( statement ).
                withPlaceID(id_place).
                withStartTime( Communication.enter( "Start Time",true  ) ).
                withEndTime( Communication.enter( "End Time",true  ) ).
                withJudgeID( id_judge ).
                withFinalID( id_final ).
                withDisciplineID( id_discipline).add();
    }
    public static void generate()throws SQLException{
        builder( statement ).add();
    }


}
