package common;

import java.sql.SQLException;

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

    public static final Set<String> displaySet = getDisplayableTables();
    public static final Set<String> addSet = getAddableTables();

    public static void main(String args[]) {

        connectWithDataBase();
        randomise = new Randomise(statement);

        try {
            SchemaProvider schemaProvider = new SchemaProvider(connection, statement);

            schemaProvider.clear();
            schemaProvider.create();
            schemaProvider.addData();
            schemaProvider.views();
            for (int i=0;i<1000;i++){
                Player.generate();
                Judge.generate();
                Team.generate();
            }
            for (int i=0;i<200;i++){
                Event.generate();
            }
            for (int i=0;i<1500;i++){
                Results.generate();
            }

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

                connection.setAutoCommit(false);

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
                        try {
                            addFunction();
                        } catch (SQLException e) {
                            System.out.println("Wrong Data");
                        }
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
        while (true) {
            System.out.println("Choose table you want to display? ( or enter BACK for back to menu )");
            int counter = 1;
            for ( Object a : displaySet ) {
                System.out.println(counter + " - " + a);
                counter++;
            }

            choice = scanner.next();
            switch (choice) {
                case "1":
                    displayTable("nationalities");
                    break;
                case "2":
                    displayTable("disciplines_views");
                    break;
                case "3":
                    displayTable("players_views");
                    break;
                case "4":
                    displayTable("teams_views");
                    break;
                case "5":
                    displayTable("judges");
                    break;
                case "6":
                    displayTable("events_views");
                    break;
                case "7":
                    displayTable("places");
                    break;
                case "8":
                    displayTable("results");
                    break;
                case "9":
                    displayTable("gold_medals");
                    break;
                case "10":
                    displayTable("silver_medals");
                    break;
                case "11":
                    displayTable("bronze_medals");
                    break;
                case "12":
                    displayTable("ranking");
                    break;
            }

            if ("BACK".equals(choice)) {
                return;
            }

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
            if ("6".equals(table)) {
                Category.manually();
                return;
            }

            System.out.println("Please, try again.");
            table = scanner.next();
        }


        System.out.println("Choose 1 for generate automatically, or 2 for do it manually. (BACK for back)");

        String choice = scanner.next();
        while (true) {

            if ("BACK".equals(choice)) {
                return;
            }

            if ("1".equals(choice) || "2".equals(choice)) {
                break;
            }
            System.out.println("Please, try again.");
            choice = scanner.next();
        }

        if ("1".equals(choice)) {
            switch (table) {
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
                    Event.generate();
                    break;
                case "5":
                    Results.generate();
            }
        } else {
            switch (table) {
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

    @Deprecated
    private static Set<String> getDisplayableTables() {
        LinkedHashSet<String> set = new LinkedHashSet<>();
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
        set.add("ranking");
        return set;
    }

    @Deprecated
    private static Set<String> getAddableTables() {
        LinkedHashSet<String> set = new LinkedHashSet<>();
        set.add("categories");
        set.add("players");
        set.add("teams");
        set.add("judges");
        set.add("events");
        return set;
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