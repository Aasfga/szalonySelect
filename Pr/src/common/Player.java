package common;

import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.SQLException;
import java.sql.Statement;

public class Player {

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
        private String sexID;
        private String firstName;
        private String lastName;
        private String nationalityID;
        private String birthDate;
        private String weightDate;
        private String weight;

        public  Builder(Statement statement){
            this.statement = statement;
            this.randomise = new Randomise(statement);
            this.preparer = new Preparer(statement);
        }

        public Builder withID(String sexID) {
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
            birthDate = ( birthDate == null ) ? randomise.generateBirthTime() : birthDate;

            weightDate = ( weightDate == null ) ?  randomise.generateOlympicTime() : weightDate;

            String bodyMassKg = String.valueOf(randomise.randomFromBetween(50,80));
            String bodyMassAfterDot = String.valueOf(randomise.randomFromBetween(0,9));
            weight = (weight == null) ? bodyMassKg + "." + bodyMassAfterDot : weight;

            String sql = "INSERT INTO players VALUES(DEFAULT, \'" + firstName + "\', \'" + lastName + "\'," + nationalityID + ",\'" + birthDate + "\'," + sexID + ");";
            statement.execute(sql);

            String playerID = preparer.lastUsedDefaultID("players");
            sql = "INSERT INTO weights VALUES(" + playerID + ", " + bodyMassKg + "." + bodyMassAfterDot + ",\'" + weightDate + "\');";

            statement.execute(sql);
        }

    }

}
