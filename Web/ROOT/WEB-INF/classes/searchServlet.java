
// Import required java libraries
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;
import org.json.*;
import ut.JAR.CPEN410.*;
import java.sql.*;

/***
 * This servlet generates a JSON object and sent it the a web browswer when
 * required
 */

// Extend HttpServlet class
public class searchServlet extends HttpServlet {


    // Servlet initialization
    public void init() throws ServletException {
        // Do required initialization
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        this.doPost(request, response);
    }

    /*
     * doGet Method
     * Generates a JSON object containg a JSON Array list
     */
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        if(search == null) search = "";
        String deptName = request.getParameter("deptName");
        if(deptName == null) deptName = "All";
        System.out.println("Search: " + search + " DeptName: " + deptName);
        // Create an JSONObject containing a JSONArray
        JSONObject jsonResult = createFinalJSON(search, deptName);
        // Actual logic goes here.
        PrintWriter out = response.getWriter();

        // Set response content type
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        // Send the response
        out.println(jsonResult.toString());
    }

    public void destroy() {
        // do nothing.
    }

    /**
     * Create a JSONObject containg a JSONArray
     **/
    public JSONObject createFinalJSON(String search, String deptName) {
        // Create the JSONObject
        JSONObject finalOutput = new JSONObject();
        try {
            // Create the JSONObject cointaing a JSONArray created using the createJSonArray
            // method
            // name the JSONObject as "contact"
            finalOutput.put("searchItems", createJSonArray(search, deptName));
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Return the JSONObject cointaing the array
            return finalOutput;
        }
    }

    /**
     * Create a JSONArray
     * 
     * @param count: number of elements in the array
     */

    public JSONArray createJSonArray(String search, String deptName) {

        
        // Create the JSONArray
        JSONArray jsonArray = new JSONArray();

        // Connect the the database
        applicationDBManager appDBMg = new applicationDBManager();
        int i = 0;

        try {
            // query the database
            ResultSet res = appDBMg.getSearchProducts(search, deptName);
            System.out.println("Sending all products...");

            while (res.next()) {
                jsonArray.put(i, createJSon(res));
                i++;
            }
            System.out.println(jsonArray.toString());
            if (i == 0) {
                // ResultSet is empty, handle accordingly
                // For example, you can add a default message to the JSONArray
                JSONObject defaultJson = new JSONObject();
                defaultJson.put("message", "No products found");
                jsonArray.put(defaultJson);
            }

            res.close();
            appDBMg.close();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Return the JSONArray
            return jsonArray;
        }
    }

    /*
     * This method creates a JSONObject
     * 
     */
    public JSONObject createJSon(ResultSet res) {
        applicationDBManager appDBMg = new applicationDBManager();
		Double maxBid = 0.0;
		try {
			ResultSet res2 = appDBMg.getMaxBid(Integer.parseInt(res.getString(1)));
			if (res2.next()) {
				maxBid = res2.getDouble(1);
			}
			res2.close();
			appDBMg.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        // Create the JSONObject
        JSONObject json = new JSONObject();
        try {
            // Add the appropriate data to the object
            json.put("product_id", res.getString(1));
            json.put("sellerUserName", res.getString(2));
            json.put("productName", res.getString(3));
            json.put("productDescription", res.getString(4));
            if(maxBid == 0.0 || maxBid == null){
                json.put("startingBid", res.getString(5));
            }else{
                json.put("startingBid", maxBid);
            }
            json.put("dueDate", res.getString(6));
            json.put("deptName", res.getString(7));
            json.put("imagePath", res.getString(8));

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // return the JSONObject
            return json;
        }
    }
}
