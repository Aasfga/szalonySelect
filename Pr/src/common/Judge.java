package common;


import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;

public class Judge {
    public static Judge.Builder builder(Statement statement) {
        return new Judge.Builder( statement );
    }

    public static class Builder {

        final private Randomise randomise;
        private Statement statement;
        private String firstName;
        private String lastName;

        public Builder(Statement statement) {
            this.statement = statement;
            this.randomise = new Randomise( statement );
        }

        public Judge.Builder withFirstName(String firstName) {
            this.firstName = firstName;
            return this;
        }

        public Judge.Builder withLastName(String lastName) {
            this.lastName = lastName;
            return this;
        }


        public void add() throws SQLException {
            Random random = new Random();
            firstName = (firstName == null) ? ((random.nextInt()%2==0) ? randomise.generateMaleName() : randomise.generateFemaleName()) : firstName;
            lastName = (lastName == null) ? randomise.generateLastName() : lastName;

            String sql = "INSERT INTO Judges VALUES(DEFAULT, \'" + firstName + " " + lastName + "\')";
            statement.execute( sql );
        }

    }
}
