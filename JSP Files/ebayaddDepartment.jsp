<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%-- Import the java.sql package to use classes such as ResultSet --%>
<%@ page import="java.sql.*"%>
<html>
    <head>
        <title>Admin Remove User</title>
    </head>
    <body>

<%
    // Check if the user is authenticated by verifying session attributes
    if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
        // Invalidate the current session if authentication fails
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        // Redirect to the login page
        response.sendRedirect("ebayloginHashing.html");
    } else {
        // Variables for page navigation and user management
        String currentPage = "ebayaddDepartment.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();
        
        // Attempt to connect to the database
        try {
            // Initialize database connection object
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            applicationDBManager appDBManager = new applicationDBManager();
            
            System.out.println("Connecting to database...");
            System.out.println(appDBAuth.toString());
            System.out.println(appDBManager.toString());
            
            // Verify the user and get departments list
            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);
            
            // Check if the user is verified
            if (res.next()) {
                // Set current page in session
                session.setAttribute("currentPage", currentPage);
                
                // Ensure userName is stored in session
                if (session.getAttribute("userName") == null) {
                    session.setAttribute("userName", userName);
                } else {
                    // Update session userName
                    session.setAttribute("userName", userName);
                }

                // Attempt to add a new department
                String deptName = request.getParameter("departmentName").toString();
                if (deptName != null && !deptName.trim().isEmpty()) {
                    boolean result = appDBManager.addDepartment(deptName);
                    if (result) {
                        // Display success message and options
                        %>
                        <h1>Department Added Successfully</h1>
                        <%
                    } else {
                        // Display failure message and options
                        %>
                        <h1>Department Not Added</h1>
                        <p>Ensure the department does not already exist or the name is valid</p>
                        <%
                    }
                } else {
                    // Display message for invalid or empty department name
                    %>
                    <h1>Department Not Added</h1>
                    <p>The name is invalid or you left the box empty</p>
                    <%
                }

                %>
                    <a href="ebaymanageDepartments.jsp">Add Another Department</a>
                    <a href="ebayadminTools.jsp">Back to Admin Page</a>
                    <a href="ebaywelcomeMenu.jsp">Welcome Page</a>
                <%
                // Clean up resources and close connections
                res.close();
                appDBManager.close();
                appDBAuth.close();
            } else {
                // Invalidate session for failed verification and redirect
                session.setAttribute("userName", null);
                response.sendRedirect("ebayloginHashing.html");
            }
        } catch (Exception e) {
            // Handle exceptions and redirect to the login page
            %>
            Nothing to show!
            <% e.printStackTrace();
            response.sendRedirect("ebayloginHashing.html");
        } finally {
            // Optional cleanup or logging
            System.out.println("Operation completed");
        }
    }
%>
    </body>
</html>
