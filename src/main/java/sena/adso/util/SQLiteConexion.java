package sena.adso.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SQLiteConexion implements IConexion {
    private static Connection instance;

    private static final String URL = "jdbc:sqlite:C:/Users/reinaldo jose/adso/java/bibliotecaBien/bibliotecadb.db";

    @Override
    public Connection getConnection() throws SQLException {
        try {

            Class.forName("org.sqlite.JDBC");

            if (instance == null || instance.isClosed()) {

                instance = DriverManager.getConnection(URL);

                try (var st = instance.createStatement()) {
                    st.execute("PRAGMA foreign_keys = ON");
                }
            }
        } catch (ClassNotFoundException e) {
            System.err.println("[SQLiteConexion] Error Grave: No se encontró el Driver de SQLite.");
            throw new SQLException("Driver org.sqlite.JDBC no encontrado", e);
        }
        return instance;
    }

    @Override
    public void closeConnection() {
        try {
            if (instance != null && !instance.isClosed()) {
                instance.close();
            }
        } catch (SQLException e) {
            System.err.println("[SQLiteConexion] Error al cerrar conexión: " + e.getMessage());
        }
    }
}