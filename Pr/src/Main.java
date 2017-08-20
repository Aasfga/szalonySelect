import java.sql.*;
import java.util.Scanner;

public class Main {

    private static Scanner scanner = new Scanner(System.in);
    private static Connection connection;
    private static Statement statement = null;

    public static void main( String args[] ) {

        connectWithDataBase();

        startApplication();

        closeConnection();
    }


    private static void connectWithDataBase(){
        System.out.println("Hello!\nWelcome to \"Olympic Games database programme!\" \n \n");
        while( statement == null){

            try{
                System.out.println("Enter your database name:");
                String databaseName = scanner.next();

                System.out.println("Enter user:");
                String login = scanner.next();

                System.out.println("Enter password:");
                String password = scanner.next();

                connection = DriverManager
                        .getConnection("jdbc:postgresql://localhost:5432/" + databaseName, login, password);

                connection.setAutoCommit(false);//TODO IS THIS IMPORTANT?

                statement = connection.createStatement();

            } catch(Exception e) {
                System.err.println( e.getClass().getName()+": "+ e.getMessage() );
                System.out.println("Try again...");
            }

        }
        System.out.println("Opened database successfully");
    }

    private static void closeConnection(){
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

    private static void startApplication(){

        System.out.println("In this application you have several options. \n You will be asked to enter number of selected function or 'EXIT' to back");

        String wybor = "";
        while (!wybor.equals("EXIT")) {

            System.out.println("Select function:\n");
            System.out.println("1 - Display database");
            System.out.println("2 - Add data");
            System.out.println("3 - Delete data\n");
            System.out.println("or EXIT for exit");

            wybor = scanner.next();
            try {
                switch (wybor) {
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
//                e.printStackTrace();
            }
        }

    }

    private static void displayFunction() throws SQLException {

        System.out.println("What you want to display?");
        displayNumberFunction();

        System.out.println("8 - medals");

        String wybor = scanner.next();

        switch (wybor){
            case "1":
                displayNationalities();
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
            default :
                break;
        }
    }

    private static void displayNationalities() throws SQLException {
        String sql = "SELECT * FROM nationalities;";
        ResultSet rs = statement.executeQuery(sql);
        displayResultSet(rs);
    }

    private static void addFunction(){

        displayNumberFunction();
        System.out.println("Where you want to add something?");
        String wybor = scanner.next();

        switch (wybor){
            case "1":
                addNationality();
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
            default :
                break;
        }
    }

    private static void updateFunction(){


        System.out.println("From where you want to update something?");
        displayNumberFunction();

        String wybor = scanner.next();

        switch (wybor){
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
            default :
                break;
        }
    }

    private static void displayNumberFunction(){
        System.out.println("1 - nationalities");
        System.out.println("2 - categories");
        System.out.println("3 - players");
        System.out.println("4 - teams");
        System.out.println("5 - judges");
        System.out.println("6 - events");
        System.out.println("7 - places\n");
        System.out.println("Anything else mean back");
    }

    private static void displayResultSet(ResultSet rs){
        try {
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnsNumber = rsmd.getColumnCount();

            for (int i = 1; i <= columnsNumber; i++) {

                int ile = 15-rsmd.getColumnName(i).length();
                String spaces = String.format("%"+ile+"s", "");
                System.out.print(rsmd.getColumnName(i) + spaces);
            }
            System.out.println();

            while (rs.next()) {

                for (int i = 1; i <= columnsNumber; i++) {

                    int ile = 15-rs.getString(i).length();
                    String spaces = String.format("%"+ile+"s", "");
                    System.out.print(rs.getString(i) + spaces);
                }
                System.out.println();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    private static void addNationality() {
        System.out.printf("Enter nationality name:");
        String name = scanner.next();

        try {
            String sql = "INSERT INTO nationalities VALUES( DEFAULT, '" + name + "');";
            statement.execute(sql);
        } catch (SQLException e) {
            System.out.println("Something went wrong...Sorry. Try diffrent name.");
            e.printStackTrace();
            return;
        }
        System.out.println("Success! " + name + " added.\n");
    }

    private static void failureCommunicate() {
        System.out.println("Something went wrong :( Try with diffrent parameters.");
    }

}
