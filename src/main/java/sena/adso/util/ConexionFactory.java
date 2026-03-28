package sena.adso.util;

public class ConexionFactory {
    public static IConexion getConexion(String motorDB){
        return switch (motorDB.toLowerCase()){
            case  "mysql" -> new MySQLConexion();
            case  "sqlite" -> new SQLiteConexion();
            case  "postgres" -> new PostgresConexion();
            default -> throw new IllegalArgumentException("Motor no soportado");
        };
    }
}
