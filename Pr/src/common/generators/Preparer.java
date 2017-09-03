package common.generators;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Preparer {

    private final Statement statement;

    public Preparer(Statement statement){
        this.statement = statement;
    }

    public ArrayList<String> arrayFromResultSetColumn(ResultSet rs, int whichColumn) throws SQLException {
        ArrayList<String> arrayList = new ArrayList<>();

        while (rs.next()) {
            arrayList.add(rs.getString(whichColumn));
        }

        return arrayList;
    }

    public String lastUsedDefaultID(String tablename) throws SQLException {
        String sql = "SELECT last_value FROM " + tablename + "_id_seq";

        ResultSet resultSet = statement.executeQuery(sql);
        resultSet.next();
        return resultSet.getString(1);
    }

    public boolean isAlpha(String s){
        String pattern= "^[a-zA-Z]*$";
        return s.matches(pattern);
    }

    public boolean isTableContainsGivenId(String tableName, String id) throws SQLException {
        String sql = "SELECT * FROM " + tableName + ";";
        ResultSet rs =  statement.executeQuery(sql);

        ArrayList<String> arrayList = arrayFromResultSetColumn(rs, 1);

        return arrayList.contains(id);
    }

    public static void displayResultSet(ResultSet rs) {
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

}
