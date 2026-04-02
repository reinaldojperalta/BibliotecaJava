package sena.adso.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MySQLConexion implements IConexion {
    private Connection instance; // Removí el static para que cada motor gestione su ciclo

    // Estos datos idealmente irían en un archivo .properties
    private static final String URL = "jdbc:mysql://localhost:3307/bibliotecadb?serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "";

    @Override
    public Connection getConnection() throws SQLException {
        // Registrar el driver (opcional en versiones nuevas, pero buena práctica)
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL no encontrado", e);
        }

        if (instance == null || instance.isClosed()) {
            instance = DriverManager.getConnection(URL, USER, PASS);
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