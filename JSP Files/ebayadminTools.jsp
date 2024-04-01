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
    // Authenticate user session
    if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        // Redirect to login if authentication fails
        response.sendRedirect("ebayloginHashing.html");
    } else {
        // Establish current user and page for session tracking
        String currentPage = "ebayadminTools.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        // Database connection attempt
        try {
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        applicationDBManager appDBManager = new applicationDBManager();
        System.out.println("Connecting to the database...");
        System.out.println(appDBAuth.toString()); // Debug print statement
        System.out.println(appDBManager.toString()); // Debug print statement

            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);
            
            // Check user authentication status
            if (res.next()) {
                // Update session with current page
                session.setAttribute("currentPage", "ebayadminTools.jsp");
                session.setAttribute("userName", userName);

                res.close(); // Important: Close ResultSet to free resources

                // Fetch and display user-specific navigation elements
                ResultSet menuRes = appDBAuth.userElements(userName);
                while (menuRes.next()) {
                    %>
                    <a href="<%=menuRes.getString(1)%>"><%=menuRes.getString(3)%></a>
                    <%
                }
                menuRes.close(); // Close ResultSet after use

                // Fetch and display admin-specific tools
                ResultSet menuRes2 = appDBAuth.adminElements(userName);
                while (menuRes2.next()) {
                    %>
                    <div>
                        <a href="<%=menuRes2.getString(1)%>"><%=menuRes2.getString(3)%></a>
                    </div>
                    <%
                }
                menuRes2.close(); // Ensure resources are freed
                appDBManager.close(); // Close database connection
                appDBAuth.close(); // Close database connection
            } else {
                // Invalidate session and redirect to login on authentication failure
                session.setAttribute("userName", null);
                response.sendRedirect("ebayloginHashing.html");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log exception details
            response.sendRedirect("ebayloginHashing.html"); // Redirect on error
        } finally {
            System.out.println("Database operations completed."); // Log completion
        }
    }
%>

</body>
</html>
