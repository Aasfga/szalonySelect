package common.generators;

import java.sql.ResultSet;
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
}
