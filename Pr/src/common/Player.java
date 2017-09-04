package common;

import common.generators.Communication;

import java.sql.SQLException;

import static common.MainApp.preparer;
import static common.MainApp.randomise;
import static common.MainApp.statement;

public class Player {

    public static Builder builder(){
        return new Builder();
    }

    public static class Builder {
        private String sexID;
        private String firstName;
        private String lastName;
        private String nationalityID;
        private String birthDate;
        private String weightDate;
        private String weight;

        public  Builder(){
        }

        public Builder withSexId(String sexID) {
            this.sexID = sexID;
            return this;
        }

        public Builder withFirstName(String firstName) {
            this.firstName = firstName;
            return this;
        }

        public Builder withLastName(String lastName) {
            this.lastName = lastName;
            return this;
        }

        public Builder withNationalityID(String nationalityID) {
            this.nationalityID = nationalityID;
            return this;
        }

        public Builder withBirthDate(String birthDate) {
            this.birthDate = birthDate;
            return this;
        }

        public Builder withWeightDate(String weightDate) {
            this.weightDate = weightDate;
            return this;
        }

        public Builder withWeight(String weight) {
            this.weight = weight;
            return this;
        }

        public void add() throws SQLException {
            sexID = ( sexID == null ) ? randomise.randomIdFromTable("sexes") : sexID;
            firstName = ( firstName == null ) ? ( (sexID.equals("1")) ? randomise.generateMaleName() : randomise.generateFemaleName() ) : firstName;
            lastName = ( lastName == null ) ? randomise.generateLastName() : lastName;
            nationalityID = ( nationalityID == null ) ? randomise.randomIdFromTable("nationalities") : nationalityID;
            birthDate = ( birthDate == null ) ? Date.generateBirthDay() : birthDate;

            weightDate = ( weightDate == null ) ?  Date.generateOlympic() : weightDate;

            String bodyMassKg = String.valueOf(randomise.randomFromBetween(50,80));
            String bodyMassAfterDot = String.valueOf(randomise.randomFromBetween(0,9));
            weight = (weight == null) ? bodyMassKg + "." + bodyMassAfterDot : weight;

            String sql = "INSERT INTO players VALUES(DEFAULT, \'" + firstName + "\', \'" + lastName + "\'," + nationalityID + ",\'" + birthDate + "\'," + sexID + ");";
            statement.execute(sql);

            String playerID = preparer.lastUsedDefaultID("players");
            sql = "INSERT INTO weights VALUES(" + playerID + ", " + bodyMassKg + "." + bodyMassAfterDot + ",\'" + weightDate + "\');";

            statement.execute(sql);

            System.out.println( "Success! New player has been added!" );
        }
    }


    public static void generate() throws SQLException {
        Player.builder().add();
    }

    public static void manually() throws SQLException {
        System.out.println("'RANDOM' for random field");
        Communication.hello("Player");
        String sexId = Communication.enter("id of sex","1-male, 2-female, 3-both");
        String firstName = Communication.enter("first name");
        String lastName = Communication.enter("first name");
        String nationalityId = Communication.enter("nationality");
        String birthDate = Date.manually();
        String weight = Communication.enter("weight");
        String weightDate = Date.manually();


        Builder builder = Player.builder();

        if( !"RANDOM".equals(sexId)){
            builder.withSexId(sexId);
        }

        if( !"RANDOM".equals(firstName)){
            builder.withFirstName(firstName);
        }

        if( !"RANDOM".equals(lastName)){
            builder.withLastName(lastName);
        }

        if( !"RANDOM".equals(nationalityId)){
            builder.withNationalityID(nationalityId);
        }

        if( !"RANDOM".equals(birthDate)){
            builder.withBirthDate(birthDate);
        }

        if( !"RANDOM".equals(weight)){
            builder.withWeight(weight);
        }

        if( !"RANDOM".equals(weightDate)){
            builder.withWeightDate(weightDate);
        }

        builder.add();
    }

}
