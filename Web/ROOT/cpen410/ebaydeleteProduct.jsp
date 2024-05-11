<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%-- Import the java.sql package to handle database operations --%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Admin Remove Product</title>
</head>
<body>

<%
    // Authentication check to ensure the user is logged in
    if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
        // Invalidate the session to protect sensitive operations and redirect to login
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        response.sendRedirect("ebayloginHashing.html");
    } else {
        // Define the page context for session management
        String currentPage = "ebaydeleteProduct.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();
        
        // Attempt database connection
        try {
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            applicationDBManager appDBManager = new applicationDBManager();
            System.out.println("Connecting to the database...");
            System.out.println(appDBAuth.toString()); // Debug print statement
            System.out.println(appDBManager.toString()); // Debug print statement
            
            // Verify user's session for the current operation
            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);
            
            if (res.next()) {
                // Confirm session variables for operation continuity
                session.setAttribute("currentPage", "ebaydeleteProduct.jsp");
                session.setAttribute("userName", userName);
                
                // Process product deletion based on provided product ID
                String productIdString = request.getParameter("productId");
                int productId = 0;
                try {
                    productId = Integer.parseInt(productIdString);
                } catch (NumberFormatException e) {
                    System.err.println("Product ID parsing error.");
                }
                
                if (productId > 0) {
                    boolean result = appDBManager.deleteProduct(productId);
                    if (result) {
                        // Success message and navigation options
                        %>
                        <h1>Product Deleted Successfully</h1>
                        <%
                    } else {
                        // Failure message with a prompt to correct action
                        %>
                        <h1>Product Not Deleted</h1>
                        <p>Ensure the product ID is correct and try again.</p>
                        <%
                    }
                } else {
                    // Handling for invalid product ID input
                    %>
                    <h1>Invalid Product ID</h1>
                    <p>Please provide a valid product ID.</p>
                    <%
                }

                // Navigation links for after-operation actions
                %>
                <a href="ebaymanageProducts.jsp">Delete Another Product</a>
                <a href="ebayadminTools.jsp">Back to Admin Page</a>
                <a href="ebaywelcomeMenu.jsp">Welcome Page</a>
                <%

                res.close(); // Important to close ResultSet to free resources
                appDBManager.close(); // Closing database connection
                appDBAuth.close(); // Closing database connection
            } else {
                // Redirect to login if user verification fails
                session.setAttribute("userName", null);
                response.sendRedirect("ebayloginHashing.html");
            }
        } catch (Exception e) {
            // Exception handling with redirection to maintain user experience
            e.printStackTrace();
            response.sendRedirect("ebayloginHashing.html");
        } finally {
            System.out.println("Product deletion process completed.");
        }
    }
%>

</body>
</html>
