package sena.adso.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SQLiteConexion implements IConexion {
    private static Connection instance;
    private static final String URL = "jdbc:sqlite:biblioteca.db";

    @Override
    public Connection getConnection() throws SQLException {
        if (instance == null || instance.isClosed()) {
            instance = DriverManager.getConnection(URL);
            try (var st = instance.createStatement()) {
                st.execute("PRAGMA foreign_keys = ON");
            }
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
            e.printStackTrace();
        }
    }
}