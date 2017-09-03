package common;


import common.generators.Communication;
import common.generators.Manually;
import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;

public class Judge {
    public static Builder builder(Statement statement) {
        return new Builder( statement );
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

        public Builder withFirstName(String firstName) {
            this.firstName = firstName;
            return this;
        }

        public Builder withLastName(String lastName) {
            this.lastName = lastName;
            return this;
        }


        public void generate() throws SQLException {
            Random random = new Random();
            firstName = (firstName == null) ? ((random.nextInt()%2==0) ? randomise.generateMaleName() : randomise.generateFemaleName()) : firstName;
            lastName = (lastName == null) ? randomise.generateLastName() : lastName;

            String sql = "INSERT INTO Judges VALUES(DEFAULT, \'" + firstName + "\',\' " + lastName + "\')";
            statement.execute( sql );
        }
        public void manually(){
            Communication.hello( "judge" );
            String first_name= Communication.enter( "first name",true );
            String last_name= Communication.enter( "last name",true );;
            try {
                Judge.builder(statement).withFirstName(first_name).withLastName( last_name ).generate();
            } catch (SQLException e) {
                Communication.error( e );
                return;
            }
            System.out.println("Success! " + first_name+ " " + last_name + " added.\n");
        }
    }
}
