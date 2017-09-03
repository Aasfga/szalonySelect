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
        addTrigger();
    }

    private void addTrigger() throws SQLException {
        String sql =  "CREATE OR REPLACE FUNCTION event_team_result_insert()\n" +
                "  RETURNS TRIGGER AS\n" +
                "$event_team_result_insert$\n" +
                "DECLARE\n" +
                "\n" +
                "  discipline_id_fromevent INTEGER := (SELECT id_disciplines FROM events WHERE id = new.id_event);\n" +
                "\n" +
                "  discipline_id_fromteams INTEGER := (SELECT id_discipline FROM teams WHERE id = new.id_team);\n" +
                "\n" +
                "BEGIN\n" +
                "\n" +
                "  IF discipline_id_fromevent != discipline_id_fromteams\n" +
                "  THEN\n" +
                "    RAISE 'Wrong id_disciplines';\n" +
                "  END IF;\n" +
                "\n" +
                "  RETURN new;\n" +
                "END;\n" +
                "$event_team_result_insert$\n" +
                "LANGUAGE plpgsql;\n" +
                "\n" +
                "DROP TRIGGER IF EXISTS event_team_result_insert\n" +
                "ON event_team_result;\n" +
                "CREATE TRIGGER event_team_result_insert\n" +
                "BEFORE INSERT ON event_team_result\n" +
                "FOR EACH ROW\n" +
                "EXECUTE PROCEDURE event_team_result_insert();\n";
        statement.execute(sql);
    }

    public void addData() throws SQLException {
        executeFile("data.sql");
    }
    public void views() throws SQLException {
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
