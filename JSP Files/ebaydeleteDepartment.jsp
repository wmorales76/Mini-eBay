<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%-- Import the java.sql package to use the ResultSet class --%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Admin Remove User</title>
</head>
<body>

<%
    // Authentication check
    if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
        // Invalidate session and redirect if authentication fails
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        response.sendRedirect("ebayloginHashing.html");
    } else {
        // Session variables for current and previous page tracking
        String currentPage = "ebaydeleteDepartment.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();
        
        // Database connection
        try {
            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            applicationDBManager appDBManager = new applicationDBManager();
            System.out.println("Connecting to the database...");
            System.out.println(appDBAuth.toString()); // Debug print statement
            System.out.println(appDBManager.toString()); // Debug print statement

            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);
            
            // User authentication check
            if (res.next()) {
                // Set current page in session
                session.setAttribute("currentPage", "ebaydeleteDepartment.jsp");
                session.setAttribute("userName", userName);

                res.close(); // Close ResultSet after verification

                // Handling department deletion
                String deptName = request.getParameter("deptName");
                if (deptName != null && !deptName.trim().isEmpty()) {
                    // Attempt to delete the department
                    boolean result = appDBManager.deleteDepartment(deptName);
                    if (result) {
                        %>
                        <h1>Department Deleted Successfully</h1>
                        <%
                    } else {
                        %>
                        <h1>Department Not Deleted</h1>
                        <p>Ensure the department exists and the name is spelled correctly.</p>
                        <%
                    }
                } else {
                    %>
                    <h1>Invalid Department Name</h1>
                    <p>Please provide a valid department name.</p>
                    <%
                }

                // Links for navigation
                %>
                <a href="ebaymanageDepartments.jsp">Delete Another Department</a>
                <a href="ebayadminTools.jsp">Back to Admin Page</a>
                <a href="ebaywelcomeMenu.jsp">Welcome Page</a>
                <%
                appDBManager.close(); // Close database connection
                appDBAuth.close(); // Close database connection
            } else {
                // Invalidate session and redirect to login if user is not authenticated
                session.setAttribute("userName", null);
                response.sendRedirect("ebayloginHashing.html");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log exception
            response.sendRedirect("ebayloginHashing.html"); // Redirect on error
        } finally {
            System.out.println("Database operations concluded."); // Final log statement
        }
    }
%>

</body>
</html>
