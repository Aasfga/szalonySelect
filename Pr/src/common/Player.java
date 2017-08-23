package common;

import common.generators.Preparer;
import common.generators.Randomise;

import java.sql.SQLException;
import java.sql.Statement;

public class Player {
    final private Statement statement;
    final private Randomise randomise;
    final private Preparer preparer;

    public Player(Statement statement) {
        this.statement = statement;
        randomise = new Randomise(statement);
        preparer = new Preparer(statement);
    }

//    public static String generateManually(Scanner scanner) {
//
//        System.out.println("Give sex ID:");
//        System.out.println("");
//        return null;
//    }

    public String generateAuto() throws SQLException {
        //1 - male, 2 - female
        String sex = randomise.randomIdFromTable("sexes");
        String firstName = (sex.equals(1)) ? randomise.generateMaleName() : randomise.generateFemaleName();
        String lastName = randomise.generateLastName();
        String nationality = randomise.randomIdFromTable("nationalities");
        String birthDate = randomise.generateBirthTime();

        String weightDate = randomise.generateOlympicTime();
        String bodyMassKg = String.valueOf(randomise.randomFromBetween(50,80));
        String bodyMassAfterDot = String.valueOf(randomise.randomFromBetween(0,9));

        String sql = "INSERT INTO players VALUES(DEFAULT, \'" + firstName + "\', \'" + lastName + "\'," + nationality + ",\'" + birthDate + "\'," + sex + ");";
        System.out.println(sql);
        statement.execute(sql);

        String playerID = preparer.lastUsedDefaultID("players");
        sql = "INSERT INTO weights VALUES(" + playerID + ", " + bodyMassKg + "." + bodyMassAfterDot + ",\'" + weightDate + "\');";
        System.out.println(sql);
        statement.execute(sql);

        return playerID;
    }

}
