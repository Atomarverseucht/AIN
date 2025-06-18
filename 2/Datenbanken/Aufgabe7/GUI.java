import javax.swing.*;
import java.awt.*;
import java.util.LinkedList;
import java.util.List;
import java.sql.*;
import java.io.*;

public class GUI extends JFrame {
    private class fwp extends JPanel{
        public final JLabel title;
        public final double bewertung;

        public fwp(String title, double bewertung){
            this.title = new JLabel(title);
            this.bewertung = bewertung;
        }
    }

    final JComboBox<String> cLand;
    JTextField start = new JTextField();
    JTextField ende = new JTextField();
    final JComboBox<String> cAusstattung;
    List<fwp> fewopa = new LinkedList<>();

    public static void main(String[] args) {
        GUI window = new GUI();
    }

    public GUI(){
        this.setTitle("Calculator");
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setPreferredSize(new Dimension(100, 100));
        test();
    }

    public static void test(){
        String name = null;
        String passwd = null;
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        Connection conn = null;
        Statement stmt = null;
        ResultSet rset = null;

        try {
            System.out.println("Benutzername: ");
            name = in.readLine();
            System.out.println("Passwort:");
            passwd = in.readLine();
        } catch (IOException e) {
            System.out.println("Fehler beim Lesen der Eingabe: " + e);
            System.exit(-1);
        }

        System.out.println("");

        try {
            DriverManager.registerDriver(new oracle.jdbc.OracleDriver()); 				// Treiber laden
            String url = "jdbc:oracle:thin:@oracle19c.in.htwg-konstanz.de:1521:ora19c"; // String für DB-Connection
            conn = DriverManager.getConnection(url, name, passwd); 						// Verbindung erstellen

            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); 			// Transaction Isolations-Level setzen
            conn.setAutoCommit(false);													// Kein automatisches Commit

            stmt = conn.createStatement(); 												// Statement-Objekt erzeugen

            String myUpdateQuery = "INSERT INTO pers(pnr, name, jahrg, eindat, gehalt, anr) " +
                    "VALUES('124', 'Huber', 1980, sysdate, 80000, 'K51')";				// Mitarbeiter hinzufügen
            stmt.executeUpdate(myUpdateQuery);

            String mySelectQuery = "SELECT pnr, name, jahrg, TO_CHAR(eindat, 'YYYY') " +
                    "AS eindat, gehalt, beruf, anr, vnr FROM pers";
            rset = stmt.executeQuery(mySelectQuery);									// Query ausführen

            while(rset.next())
                System.out.println(rset.getInt("pnr") + " "
                        + rset.getString("name") + " "
                        + rset.getInt("jahrg") + " "
                        + rset.getString("eindat") + " "
                        + rset.getInt("gehalt") + " "
                        + rset.getString("beruf") + " "
                        + rset.getString("anr") + " "
                        + rset.getInt("vnr"));

            myUpdateQuery = "DELETE FROM pers WHERE pnr = '124'";
            stmt.executeUpdate(myUpdateQuery);											// Mitarbeiter wieder löschen

            stmt.close();																// Verbindung trennen
            conn.commit();
            conn.close();
        } catch (SQLException se) {														// SQL-Fehler abfangen
            System.out.println();
            System.out
                    .println("SQL Exception occurred while establishing connection to DBS: "
                            + se.getMessage());
            System.out.println("- SQL state  : " + se.getSQLState());
            System.out.println("- Message    : " + se.getMessage());
            System.out.println("- Vendor code: " + se.getErrorCode());
            System.out.println();
            System.out.println("EXITING WITH FAILURE ... !!!");
            System.out.println();
            try {
                conn.rollback();														// Rollback durchführen
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.exit(-1);
        }
    }
}
