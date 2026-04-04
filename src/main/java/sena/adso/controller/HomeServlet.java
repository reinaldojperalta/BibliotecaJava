package sena.adso.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("") // Mapeado a la raíz del proyecto
public class HomeServlet extends HttpServlet {

    private String folder;

    @Override
    public void init() {
        // Aprovechamos el mismo vistasPath que ya tienes configurado
        this.folder = getServletContext().getInitParameter("vistasPath");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // Obtenemos el path desde el context-param del web.xml
        String folder = getServletContext().getInitParameter("vistasPath");
        req.getRequestDispatcher(folder + "home.jsp").forward(req, res);
    }
}