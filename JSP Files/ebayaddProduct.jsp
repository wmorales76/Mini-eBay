<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Ebay Add Product</title>
</head>
<body>
<%
// Initialize authentication and navigation flow
if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
    // Invalidate session if authentication fails
    session.setAttribute("currentPage", null);
    session.setAttribute("userName", null);
    // Redirect to login page
    response.sendRedirect("ebayloginHashing.html");
} else {
    // Set the current and previous page for session tracking
    String currentPage = "ebayaddProduct.jsp";
    String userName = session.getAttribute("userName").toString();
    String previousPage = session.getAttribute("currentPage").toString();

    // Establish database connection
    try {
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        applicationDBManager appDBManager = new applicationDBManager();
        System.out.println("Connecting to the database...");
        System.out.println(appDBAuth.toString()); // Debug print statement
        System.out.println(appDBManager.toString()); // Debug print statement

        // Validate user and get navigation menu options
        ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);
        if (res.next()) {
            session.setAttribute("currentPage", "ebayaddProduct.jsp");

            // Ensure userName is set in session
            session.setAttribute("userName", userName);

            // Generate user-specific navigation menu
            ResultSet menuRes = appDBAuth.userElements(userName);
            while (menuRes.next()) {
                %>
                <a href="<%=menuRes.getString(1)%>"><%=menuRes.getString(3)%></a>
                <%
            } 
            menuRes.close(); // Always close ResultSet objects to free up database resources

            // Fetch and display all departments for product categorization
            ResultSet resDept = appDBManager.getAllDepartments(); 
            %>
            <a href="ebaysignout.jsp">Sign out</a>
            <div>
                            <span>
                                <form action="ebaysearch.jsp" method="get">
                                    <label for="search">Search:</label>
                                    <input type="text" id="search" name="search" placeholder="Search for products">

                            </span>
                            <span>
                                <select name="productDepartment">
                                    <option value="All">All</option>
                                    <%          
                                        //Print the department names
                                        while (resDept.next()) {
                                    %>
                                        <option value="<%=resDept.getString("deptName")%>"><%=resDept.getString("deptName")%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </span>
                                <input type="submit" value="Submit">
                                </form>            
                        </div>
            <h1>Please, add your product information</h1>
            <form action="ebayprocessProduct.jsp" method="post">
                <table>
                    <tr>
                        <td>Product Name:</td>
                        <td><input type="text" name="productName" size="20" required></td>
                    </tr>
                    <tr>
                        <td>Product Description:</td>
                        <td><input type="text" name="productDescription" size="20" required></td>
                    </tr>
                    <tr>
                        <td>Product Price:</td>
                        <td><input type="number" name="productPrice" size="20" required></td>
                    </tr>
                    <tr>
                        <td>Product Due Date:</td>
                        <td><input type="text" name="productDate" size="20" required></td>
                    </tr>
                    <tr>
                        <td>Upload Product Image:</td>
                        <td><input type="file" name="productImage" size="20" required></td>
                    </tr>
                    <tr>
                        <td>Product Department:</td>
                        <td>
                            <select name="productDepartment">
                                <%
                                    resDept = appDBManager.getAllDepartments(); // Ensure ResultSet is refreshed
                                    while (resDept.next()) {
                                        %>
                                        <option value="<%=resDept.getString("deptName")%>"><%=resDept.getString("deptName")%></option>
                                        <%
                                    }
                                    resDept.close(); // Close ResultSet to release database resources
                                %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="submit" value="Add Product"></td>
                    </tr>
                </table>
            </form>
                <%
                res.close(); // Close main ResultSet

                // Close database connection
                appDBManager.close();
                appDBAuth.close();
        } else {
            // Handle unauthorized access by clearing session and redirecting to login page
            session.setAttribute("userName", null);
            response.sendRedirect("ebayloginHashing.html");
        }
    } catch (Exception e) {
        // Handle exceptions and redirect to login page for recovery
        e.printStackTrace();
        response.sendRedirect("ebayloginHashing.html");
    } finally {
        // Log completion of database operations
        System.out.println("Database operations completed.");
    }
}%>
</body>
</html>
