package common.generators;

import java.sql.SQLException;

import static common.MainApp.scanner;

public class Communication {

    public static void hello(String arg) {
        System.out.printf("Adding new " + arg + ":\n");
    }

    public static String enter(String word) {
        System.out.printf("Enter " + word + ":");
        return scanner.next();
    }

    public static String enter(String word, String extraInfo) {
        System.out.printf("Enter " + word + ":");
        System.out.printf("(" + extraInfo + ")");
        return scanner.next();
    }

    public static void error(SQLException e) {
        System.out.println("Something went wrong...Sorry. Try different parameters.");
        e.printStackTrace();
    }
}