import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;

import java.io.*;
import java.net.*; // For HTTP connections with remote and local servers

// Servlet activated when user access: http://localhost:8080/servlet-web-2/transfer
@WebServlet("/transfer")
public class DataSyncServlet extends HttpServlet {

  // URL of source and target webservices (PHP and Django)
  private static final String SOURCE_URL = "https://youraltervista.altervista.org/api/data.php";
  private static final String TARGET_URL = "http://localhost:8000/api/import/";

  // Executes when the user opens the webpage from the browser
  // Generates HTML interface to begin the data migration
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse res)
      throws ServletException, IOException {

    res.setContentType("text/html");
    PrintWriter writer = res.getWriter();

    writer.println("<!DOCTYPE html>");
    writer.println("<html><head><title>Sync Panel</title></head><body>");
    writer.println("<h2>Data Synchronization</h2>");
    // The botton sends a POST request to the own servlet -> trigger migration
    writer.println("<form action=\"/servlet-web-2/transfer\" method=\"post\">");
    writer.println("<input type=\"submit\" value=\"Execute Transfer\"/>");
    writer.println("</form>");
    writer.println("</body></html>");
  }

  // Executes when the user presses "Execute Transfer" button
  // In charge of data transfer between remote and local webservers
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse res)
      throws ServletException, IOException {

    res.setContentType("text/html");
    PrintWriter writer = res.getWriter();

    // Where the JSON content received from the PHP server will be stored
    String responsePayload = "";

    try {
      // Establish a connection with the PHP server (source), and set petition as GET,
      // as it won't send anything, only receive
      URL source = new URL(SOURCE_URL);
      HttpURLConnection getRequest = (HttpURLConnection) source.openConnection();
      getRequest.setRequestMethod("GET");

      // Read response of the server line by line (BufferedReader)
      try (BufferedReader input = new BufferedReader(new InputStreamReader(getRequest.getInputStream()))) {
        String line;
        StringBuilder jsonBuffer = new StringBuilder(); // https://www.geeksforgeeks.org/stringbuilder-class-in-java-with-examples/

        while ((line = input.readLine()) != null) {
          jsonBuffer.append(line);
        }
        responsePayload = jsonBuffer.toString();
      }
    } catch (Exception err) {
      writer.println(
          "<html><body><h3>Failed to retrieve source data:</h3><pre>" + err.getMessage() + "</pre></body></html>");
      return;
    }

    try {
      // Creates a connection with the Django server (target)
      // The request is POST, as it will send data to the local server
      URL target = new URL(TARGET_URL);
      HttpURLConnection postRequest = (HttpURLConnection) target.openConnection();
      postRequest.setRequestMethod("POST");
      postRequest.setDoOutput(true); // Enable to insert data in the body of POST
      postRequest.setRequestProperty("Content-Type", "application/json");

      try (OutputStream out = postRequest.getOutputStream()) {
        out.write(responsePayload.getBytes("utf-8"));
      }

      int status = postRequest.getResponseCode();
      writer.println("<html><body><h3>Transfer completed successfully</h3>");
      writer.println("<p>Server returned HTTP code: " + status + "</p></body></html>");

    } catch (Exception err) {
      writer.println("<html><body><h3>Failed to send data to target server:</h3><pre>" + err.getMessage()
          + "</pre></body></html>");
    }
  }
}
