<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%-- Import the java.sql package to use the ResultSet class for database operations --%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Admin Remove User</title>
</head>
<body>

<%
    // Authentication check: ensure the user is logged in before allowing access to admin functionalities
    if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
        // If not authenticated, clear session variables for security and redirect to login page
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        response.sendRedirect("ebayloginHashing.html");
    } else {
        // Variables for current user session management
        String currentPage = "ebaydeleteUser.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();
        
        // Attempt to connect to the database
        try {
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            applicationDBManager appDBManager = new applicationDBManager();
            System.out.println("Connecting to the database...");
            System.out.println(appDBAuth.toString()); // Debug print statement
            System.out.println(appDBManager.toString()); // Debug print statement
            
            // Verify user session validity
            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);
            
            if (res.next()) {
                // If user is authenticated, update session with current page
                session.setAttribute("currentPage", currentPage);
                session.setAttribute("userName", userName);

                res.close(); // It's important to close ResultSet to free up database resources
                
                // Process user deletion based on provided username
                String usernameToDelete = request.getParameter("userName");
                if (usernameToDelete != null && !usernameToDelete.trim().isEmpty()) {
                    // Attempt to delete the user
                    boolean result = appDBManager.deleteUser(usernameToDelete);
                    if (result) {
                        %>
                        <h1>User Deleted Successfully</h1>
                        <%
                    } else {
                        %>
                        <h1>User Not Deleted</h1>
                        <p>Ensure the user exists and the username is correct.</p>
                        <%
                    }
                } else {
                    %>
                    <h1>Invalid Username</h1>
                    <p>Username field cannot be empty.</p>
                    <%
                }

                // Navigation links for post-operation actions
                %>
                <a href="ebaymanageUsers.jsp">Delete Another User</a>
                <a href="ebayadminTools.jsp">Back to Admin Page</a>
                <a href="ebaywelcomeMenu.jsp">Welcome Page</a>
                <%

            } else {
                // Redirect to login if user session cannot be verified
                session.setAttribute("userName", null);
                response.sendRedirect("ebayloginHashing.html");
            }

            appDBAuth.close(); // Closing database connection after operation
            appDBManager.close(); // Closing database connection after operation
        } catch (Exception e) {
            // Handle exceptions and redirect to maintain user experience
            e.printStackTrace();
            response.sendRedirect("ebayloginHashing.html");
        } finally {
            System.out.println("Finally"); // Final log statement for debugging
        }
    }
%>

</body>
</html>
