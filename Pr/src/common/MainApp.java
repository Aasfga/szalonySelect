package common;

import common.generators.Manually;
import common.generators.Preparer;
import common.generators.Randomise;
import common.generators.SchemaProvider;

import java.sql.*;
import java.util.LinkedHashSet;
import java.util.Scanner;
import java.util.Set;

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

//            new Player.Builder(statement).add();
//            Player.builder(statement).add();
//            Player.builder(statement).withFirstName("Filip").add();
//
//            Judge.builder(statement).add();
//            Judge.builder(statement).withFirstName("Marcin").add();
//
//            Event.builder(statement).add();
//
//            Manually.builder(statement).judge();
//            Manually.builder(statement).category();

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
            System.out.println("3 - Delete data\n");
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
                    case "3":
                        updateFunction();
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

    private static void displayTable(String table) throws SQLException {
        String sql = "SELECT * FROM " + table + ";";
        ResultSet rs = statement.executeQuery(sql);
        displayResultSet(rs);
    }


    private static void addFunction() {

        String table;
        while(true) {
            System.out.println("Choose table to add something.");
            System.out.println(addSet);
            table = scanner.next();

            if (addSet.contains(table)) {
                break;
            }

            if ("BACK".equals(table)) {
                return;
            }
            failureCommunicate();
        }

        while (true) {
            String choice;
            while(true) {
                System.out.println("Enter 'GENERATE' for generating automatically,\n 'MANUALLY' for adding fields by yourself\n or 'BACK' for back");
                choice = scanner.next();

                if ("GENERATE".equals(choice) ) {
                    //TODO
                    return;
                }

                if ("MANUALLY".equals(choice)) {
                    //TODO
                    return;
                }

                if ("BACK".equals(table)) {
                    return;
                }

                failureCommunicate();
            }
        }

//            switch (choice) {
//                case "1":
//                    addNationality();
//                    break;
//                case "2":
//                    Manually.builder(statement).category();
//                    break;
//                case "3":
//                    //TODO
//                    break;
//                case "4":
//                    //TODO
//                    break;
//                case "5":
//                    Manually.builder(statement).judge();
//                    break;
//                case "6":
//                    //TODO
//                    break;
//                case "7":
//                    //TODO
//                    break;
//                default:
//                    break;
//            }
    }

    private static void updateFunction() {


        System.out.println("From where you want to update something?");
//        displayNumberFunction();

        String wybor = scanner.next();

        switch (wybor) {
            case "1":
                //TODO
                break;
            case "2":
                //TODO
                break;
            case "3":
                //TODO
                break;
            case "4":
                //TODO
                break;
            case "5":
                //TODO
                break;
            case "6":
                //TODO
                break;
            case "7":
                //TODO
                break;
            default:
                break;
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
        set.add("medals");
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

    private static void displayResultSet(ResultSet rs) {
        try {
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnsNumber = rsmd.getColumnCount();

            for (int i = 1; i <= columnsNumber; i++) {

                int ile = 15 - rsmd.getColumnName(i).length();
                String spaces = String.format("%" + ile + "s", "");
                System.out.print(rsmd.getColumnName(i) + spaces);
            }
            System.out.println();

            while (rs.next()) {

                for (int i = 1; i <= columnsNumber; i++) {

                    int ile = 15 - rs.getString(i).length();
                    String spaces = String.format("%" + ile + "s", "");
                    System.out.print(rs.getString(i) + spaces);
                }
                System.out.println();
            }
        } catch (SQLException e) {
//            TODO
//            e.printStackTrace();
        }
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
}
