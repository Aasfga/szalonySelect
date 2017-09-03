package common.generators;

import common.MainApp;

import java.io.*;
import java.net.URL;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class SchemaProvider {

    private final Statement statement;
    private final Connection connection;

    public SchemaProvider(Connection connection, Statement statement){
        this.statement = statement;
        this.connection = connection;
    }

    public void create() throws SQLException {
        executeFile("tables.sql");
    }
    public void addData() throws SQLException {
        executeFile("data.sql");
    }
    public void addViews() throws SQLException {
        executeFile("views.sql");
    }

    public void clear() throws SQLException {
        executeFile("clear.sql");
    }



        private void executeFile(String fileName ) throws SQLException {

        String s;
        StringBuffer sb = new StringBuffer();

        try {
            URL fileURL= MainApp.class.getResource(fileName);
            FileReader fr = new FileReader(fileURL.getFile());
            // be sure to not have line starting with "--" or "/*" or any other non aplhabetical character

            BufferedReader br = new BufferedReader(fr);
            while ((s = br.readLine()) != null) {
                sb.append(s);
            }
            br.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        statement.execute(sb.toString());
    }



}
