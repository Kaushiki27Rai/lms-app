package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/House") // Annotation declaration
public class House extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public House() {
		super();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher requestDispatcher;

		String action = request.getParameter("action");
		if (action == null) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action parameter is missing.");
			return;
		}

		switch (action) {
		case "register":
			requestDispatcher = request.getRequestDispatcher("registration.jsp");
			requestDispatcher.forward(request, response);
			break;
		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND,
					"The requested action '" + action + "' is not available.");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
