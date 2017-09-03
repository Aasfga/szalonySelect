package common.generators;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Objects;

import static common.MainApp.scanner;

public class Communication{
    public static void hello(String arg){
        System.out.printf("Adding new "+arg+":\n");
    }
    public static String enter(String word,Boolean rand){
        System.out.printf("Enter "+word+":(RAND to random)");
        String s=scanner.next();
        if (Objects.equals( s, "RAND" ))
            return null;
        else
            return s;
    }
    public static String enter(String word){
        System.out.printf("Enter "+word+":");
        return scanner.next();
    }
    public static String enter(String word,String extrainfo){
        System.out.printf("Enter "+word+":");
        System.out.printf( "("+extrainfo+")" );
        return scanner.next();
    }
    public static void error(SQLException e){
        System.out.println("Something went wrong...Sorry. Try different parameters.");
    }
    
}
