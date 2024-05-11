<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%-- Import the java.sql package to use the ResultSet class --%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Admin Add User</title>
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
        String currentPage = "ebaycreateUser.jsp";
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
                session.setAttribute("currentPage", "ebaycreateUser.jsp");
                session.setAttribute("userName", userName);

                res.close(); // Close ResultSet after verification

                //get all the parameters needed for registration
                String accUserName = request.getParameter("userName").toString();
                String userPass = request.getParameter("userPass").toString();
                String completeName = request.getParameter("completeName").toString();
                String telephone = request.getParameter("telephone").toString();
                String roleString = request.getParameter("role").toString();
                int role = Integer.parseInt(roleString);

                if (accUserName != null && !accUserName.trim().isEmpty() &&
                    userPass != null && !userPass.trim().isEmpty() &&
                    completeName != null && !completeName.trim().isEmpty() &&
                    telephone != null && !telephone.trim().isEmpty() &&
                    (role == 2 || role == 3)) {

                    // Attempt to add the user
                    boolean result = appDBAuth.addUser(accUserName, userPass, completeName, telephone);
                    boolean result2 = appDBAuth.setRole(accUserName, role);
                    if (result && result2) {
                        %>
                        <h1>User Added Successfully</h1>
                        <%
                    } else {
                        %>
                        <h1>User not added</h1>
                        <p>Ensure the user doesnt exists already and the role is correct.</p>
                        <%
                    }
                } else {
                    %>
                    <h1>Invalid Input</h1>
                    <p>Please provide valid informaton.</p>
                    <%
                }

                // Links for navigation
                %>
                <a href="ebaymanageUsers.jsp">Add Another User</a>
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
            System.out.println("Finally."); // Final log statement
        }
    }
%>

</body>
</html>
