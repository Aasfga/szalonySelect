package common;

import common.generators.Preparer;
import common.generators.Randomise;
import common.generators.SchemaProvider;

import java.sql.*;
import java.util.LinkedHashSet;
import java.util.Scanner;
import java.util.Set;

import static common.generators.Preparer.displayResultSet;

public class MainApp {

    public static Scanner scanner = new Scanner(System.in);
    public static Connection connection;
    public static Statement statement = null;
    public static Preparer preparer;
    public static Randomise randomise;

    public static final Set <String> displaySet = getDisplayableTables();
    public static final Set <String> addSet = getAddableTables();

    public static void main(String args[]) {

        connectWithDataBase();


        try {
            SchemaProvider schemaProvider = new SchemaProvider(connection, statement);

            schemaProvider.clear();
            schemaProvider.create();
            schemaProvider.addData();
            schemaProvider.views();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        startApplication();

        closeConnection();
    }

    private static void connectWithDataBase() {
        System.out.println("Hello!\nWelcome to \"Olympic Games database programme!\" \n \n");
        while (statement == null) {

            try {
                System.out.println("Enter your database name:");
                String databaseName = scanner.next();

                System.out.println("Enter user:");
                String login = scanner.next();

                System.out.println("Enter password:");
                String password = scanner.next();

                connection = DriverManager
                        .getConnection("jdbc:postgresql://localhost:5432/" + databaseName, login, password);

                connection.setAutoCommit(false); //TODO IS THIS IMPORTANT?

                statement = connection.createStatement();

                preparer = new Preparer(statement);
                randomise = new Randomise(statement);

            } catch (Exception e) {
//                System.err.println( e.getClass().getName()+": "+ e.getMessage() );
                System.out.println("Try again...");
            }

        }
        System.out.println("Opened database successfully");
    }

    private static void closeConnection() {
        System.out.println("Closing...");
        try {
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            connection.commit();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void startApplication() {

        System.out.println("In this application you have several options. \n You will be asked to enter number of selected function or 'EXIT' to back");

        String choice = "";
        while (!"EXIT".equals(choice)) {

            System.out.println("Select function:\n");
            System.out.println("1 - Display database");
            System.out.println("2 - Add data");
            System.out.println("or EXIT for exit");

            choice = scanner.next();
            try {
                switch (choice) {
                    case "1":
                        displayFunction();
                        break;
                    case "2":
                        addFunction();
                        break;
                    default:
                        break;
                }
            } catch (SQLException e) {
                failureCommunicate();
            }
        }

    }

    private static void displayFunction() throws SQLException {
        String choice;
        while( true ) {
            System.out.println("Choose table you want to display? ( or enter BACK for back to menu )");
            System.out.println(displaySet);
            choice = scanner.next();

            if( displaySet.contains(choice) ){
                displayTable(choice);
                return;
            }

            if ("BACK".equals(choice)) {
                return;
            }

            failureCommunicate();
        }
    }



    private static void addFunction() throws SQLException {

        System.out.println("Where you want to add something? (BACK for back)");
        System.out.println("1 - Player");
        System.out.println("2 - Judge");
        System.out.println("3 - Team");
        System.out.println("4 - Event");
        System.out.println("5 - Result");
        System.out.println("6 - Category");

        String table = scanner.next();
        while (true) {

            if ("BACK".equals(table)) {
                return;
            }

            if ("1".equals(table) || "2".equals(table) || "3".equals(table) || "4".equals(table) || "5".equals(table)) {
                break;
            }
            if ("1".equals(table)){
                Category.manually();
                return;
            }

            if ( "6".equals(table)){
                Category.manually();
                return;
            }

            System.out.println("Please, try again.");
            table = scanner.next();
        }


        System.out.println("Choose 1 for generate automatically, or 2 for do it manually. (BACK for back)");

        String choice = scanner.next();
        while( true ) {

            if ("BACK".equals(choice)) {
                return;
            }

            if ("1".equals(choice) || "2".equals(choice)) {
                break;
            }
            System.out.println("Please, try again.");
            choice = scanner.next();
        }

        if( "1".equals(choice)){
            switch (table){
                case "1":
                    Player.generate();
                    break;
                case "2":
                    Judge.generate();
                    break;
                case "3":
                    Team.generate();
                    break;
                case "4":
                    Event.builder(statement).add();
                    Event.generate();
                    break;
                case "5":
                    Event.generate();
                    break;
            }
        } else {
            switch (table){
                case "1":
                    Player.manually();
                    break;
                case "2":
                    Judge.manually();
                    break;
                case "3":
                    Team.manually();
                    break;
                case "4":
                    Event.manually();
                    break;
                case "5":
                    Results.manually();
            }
        }

    }

    private static Set<String> getDisplayableTables() {
        LinkedHashSet <String> set = new LinkedHashSet<>();
        set.add("nationalities");
        set.add("disciplines");
        set.add("players");
        set.add("teams");
        set.add("judges");
        set.add("events");
        set.add("places");
        set.add("results");
        set.add("gold_medals");
        set.add("silver_medals");
        set.add("bronze_medals");
        return set;
    }

    private static Set<String> getAddableTables() {
        LinkedHashSet <String> set = new LinkedHashSet<>();
        set.add("categories");
        set.add("players");
        set.add("teams");
        set.add("judges");
        set.add("events");
        return set;
    }


    @Deprecated
    private static void addNationality() {
        System.out.printf("Enter nationality name:");
        String name = scanner.next();

        try {
            String sql = "INSERT INTO nationalities VALUES( DEFAULT, '" + name + "');";
            statement.execute(sql);
        } catch (SQLException e) {
            System.out.println("Something went wrong...Sorry. Try different name.");
            e.printStackTrace();
            return;
        }
        System.out.println("Success! " + name + " added.\n");
    }

    private static void failureCommunicate() {
        System.out.println("Something went wrong :( Try with different parameters.");
    }

    public static void displayTable(String table) throws SQLException {
        String sql = "SELECT * FROM " + table + ";";
        ResultSet rs = statement.executeQuery(sql);
        displayResultSet(rs);
    }
}
