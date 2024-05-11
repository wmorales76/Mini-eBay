<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>
<html>
    <head>
        <title>Admin Remove User</title>
    </head>
    <body>
        <%
            // Check the authentication process
            if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
                session.setAttribute("currentPage", null);
                session.setAttribute("userName", null);
                response.sendRedirect("ebayloginHashing.html");
            } else {
                String currentPage = "ebaymodifyUser.jsp";
                String userName = session.getAttribute("userName").toString();
                String previousPage = session.getAttribute("currentPage").toString();

                // Try to connect to the database using the applicationDBManager class
                try {
                    // Create the appDBMnger object
                    applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
                    applicationDBManager appDBManager = new applicationDBManager();
                    System.out.println("Connecting to the database...");
                    System.out.println(appDBAuth.toString()); // Debug print statement
                    System.out.println(appDBManager.toString()); // Debug print statement

                    // Call the listAllDepartment method. This method returns a ResultSet containing all the tuples in the table Department
                    ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

                    // Verify if the user has been authenticated
                    if (res.next()) {
                        // Create the current page attribute
                        session.setAttribute("currentPage", "ebaymodifyUser.jsp");

                        // Create or update a session variable
                        session.setAttribute("userName", userName);


                        // Variables declaration and null-check
                        // avoid null pointer exception when the parameter is not received
                        // because some of the parameters are optional
                        String username = request.getParameter("userName");
                        if (username != null && !username.trim().isEmpty()) {
                            username = username.trim();
                        } else {
                            username = "";
                        }

                        String newUsername = request.getParameter("newUsername");
                        if (newUsername != null && !newUsername.trim().isEmpty()) {
                            newUsername = newUsername.trim();
                        } else {
                            newUsername = "";
                        }

                        String newPassword = request.getParameter("newPassword");
                        if (newPassword != null && !newPassword.trim().isEmpty()) {
                            newPassword = newPassword.trim();
                        } else {
                            newPassword = "";
                        }

                        String newCompleteName = request.getParameter("newCompleteName");
                        if (newCompleteName != null && !newCompleteName.trim().isEmpty()) {
                            newCompleteName = newCompleteName.trim();
                        } else {
                            newCompleteName = "";
                        }

                        String newTelephone = request.getParameter("newTelephone");
                        if (newTelephone != null && !newTelephone.trim().isEmpty()) {
                            newTelephone = newTelephone.trim();
                        } else {
                            newTelephone = "";
                        }
                        int intRole = 0;
                        String userRole = request.getParameter("role");
                        if (userRole != null && !userRole.trim().isEmpty()) {
                            userRole = userRole.trim();
                            intRole = Integer.parseInt(userRole);
                        } else {
                            userRole = "";
                        }


                        // if username and another parameter is not empty, then update the user
                        boolean result = true;
                        if (!username.isEmpty() && (!newUsername.isEmpty() || !newPassword.isEmpty() || !newCompleteName.isEmpty() || !newTelephone.isEmpty())) {
                            result = appDBAuth.updateUser(username, newUsername, newPassword, newCompleteName, newTelephone);
                        }
                        // if role is not empty, then update the role
                        if (intRole == 2 || intRole == 3) {
                            boolean roleresult = appDBManager.updateUserRole(username, intRole);
                        }
                        if (result) {
                    %>
                            <h1>User Updated Successfully</h1>
                    <%
                        } else {
                    %>
                            <h1>User Not Updated</h1>
                            <p>Make sure the user exists and the username is valid</p>
                    <%
                        }


                    } else {
                        // Close any session associated with the user
                        session.setAttribute("userName", null);
                        // return to the login page
                        response.sendRedirect("ebayloginHashing.html");
                    }
                    %>
                    <a href="ebaymanageUsers.jsp">Update Another User</a>
                    <a href="ebayadminTools.jsp">Back to Admin Page</a>
                    <a href="ebaywelcomeMenu.jsp">Welcome Page</a>
                    <%
                    res.close();
                    appDBManager.close();
                    appDBAuth.close();
                } catch (Exception e) {
                    %>
                    Nothing to show!
                    <%
                    e.printStackTrace();
                    response.sendRedirect("ebayloginHashing.html");
                } finally {
                    System.out.println("Finally");
                }
            }
        %>
    </body>
</html>
