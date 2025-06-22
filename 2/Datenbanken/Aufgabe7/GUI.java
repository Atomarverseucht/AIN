import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.LinkedList;
import java.util.List;
import java.sql.*;
import java.io.*;

public class GUI extends JFrame implements ActionListener {
    @Override
    public void actionPerformed(ActionEvent e) {
        switch(e.getActionCommand()){
            case "Suchen": suchen(); break;
        }
    }

    private class fwp extends JPanel{
        public final JLabel title;
        public final JLabel bewertung;

        public fwp(String title, double bewertung){
            this.title = new JLabel(title);
            this.bewertung = new JLabel(Double.toString(bewertung));
            this.add(this.title);
            this.add(this.bewertung);
        }
    }

    JComboBox<String> cLand = new JComboBox<>();
    JTextField start = new JTextField(LocalDate.now().format(DateTimeFormatter.ofPattern("dd.MM.yyyy")));
    JTextField ende = new JTextField(LocalDate.now().format(DateTimeFormatter.ofPattern("dd.MM.yyyy")));
    JComboBox<String> cAusstattung = new JComboBox<>();
    List<fwp> fewopa = new LinkedList<>();
    JPanel gui = new JPanel();
    JButton suchen = new JButton("Suchen");
    JPanel out = new JPanel();

    // SQL - Zeug
    String name = null;
    String passwd = null;
    BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
    Connection conn = null;
    Statement stmt = null;
    ResultSet rset = null;

    public static void main(String[] args) {
        GUI window = new GUI();

    }

    public GUI(){
        String input = "SELECT name_ FROM dbsys08.Ferienwohnung";

        this.setTitle("Calculator");
        this.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                try{
                    sql_close();
                    System.exit(0);
                } catch (Exception ex){
                    System.out.println("problem");
                }
            }
        });
        gui.setPreferredSize(new Dimension(100, 100));

        // SQL Initialization
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

            // SQL-Abfrage für Länder-Combobox
            String selectCountries = "SELECT * FROM dbsys08.Land";
            rset = stmt.executeQuery(selectCountries);
            while(rset.next()){
                cLand.addItem(rset.getString("name_"));
            }

                rset = stmt.executeQuery(input);
                while (rset.next()){
                    System.out.println(rset.getString("name_"));
                }
            String selectAccess = "SELECT * FROM dbsys08.Ausstattung";
            rset = stmt.executeQuery(selectAccess);
            cAusstattung.addItem("keine");
            while(rset.next()){
                cAusstattung.addItem(rset.getString("name_"));
            }


            JLabel z1 = new JLabel(" Von:");
            JLabel z2 = new JLabel(" Bis: ");
            JPanel in = new JPanel();
            gui.setLayout(new BoxLayout(gui, BoxLayout.Y_AXIS));
            in.setLayout(new FlowLayout());
            in.add(cLand);
            in.add(cAusstattung);
            in.add(z1);
            in.add(start);
            in.add(z2);
            in.add(ende);
            in.add(suchen);
            gui.add(in);
            this.add(gui);
            this.pack();
            this.setVisible(true);

            suchen.addActionListener(this);

            // SQL - Errors
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
    public void suchen() {
        try {

            String SQLsuche = "SELECT fw.name_, AVG(b.BEWERTSTERNE) AS Durchschnitt  " +
                    "FROM dbsys08.Ferienwohnung fw " +
                    (cAusstattung.getSelectedIndex() != 0 ? "INNER JOIN dbsys08.WOHNUNGSAUSSTATTUNG wa ON fw.FEWONR = wa.FEWONR ":" ") +
                    "INNER JOIN dbsys08.ADRESSE ad ON fw.adressNr = ad.ADRESSNR " +
                    "LEFT OUTER JOIN dbsys08.BUCHUNG b ON b.FEWONR = fw.FEWONR " +
                    "WHERE ad.LANDNAME = '" + cLand.getSelectedItem().toString() +
                    ((cAusstattung.getSelectedIndex() != 0) ? "' AND wa.AUSSTNAME = '" + cAusstattung.getSelectedItem().toString() +"'": "'") + " AND fw.FEWONR NOT IN ( " +
                    "SELECT b1.fewoNR FROM dbsys08.Buchung b1 " +
                    "WHERE NOT(endtag < TO_DATE('" + start.getText() + "', 'DD.MM.YYYY') OR b1.STARTTAG > (TO_DATE('" + ende.getText() + "', 'DD.MM.YYYY')))) " +
                    "GROUP BY fw.name_ ORDER BY NVL(Durchschnitt, 0) DESC";
            rset = stmt.executeQuery(SQLsuche);
            fewopa.clear();
            gui.remove(out);

            out.removeAll();
            while (rset.next()){
                fwp f = new fwp(rset.getString("name_"), rset.getDouble("Durchschnitt"));
                fewopa.add(f);
                out.add(f);
            }
            out.setVisible(false);
            gui.add(out);
            out.setVisible(true);
        } catch(SQLException sqlEx){
            System.err.println("SQL Fehler: suchen");
            System.out.println(sqlEx.getMessage());
        }
    }
        public void sql_close() throws SQLException{
            stmt.close();                                                                // Verbindung trennen
            conn.commit();
            conn.close();
        }
}
