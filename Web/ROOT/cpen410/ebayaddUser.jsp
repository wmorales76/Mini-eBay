<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%-- Import the java.sql package to use the ResultSet class --%>
<%@ page import="java.sql.*"%>
<html>
<head>
    <title>Mini Ebay Add User</title>
</head>
<body>

<%
    // Initialize user variables from request parameters
    String userName = request.getParameter("userName").toString();
    String userPass = request.getParameter("userPass").toString();
    String completeName = request.getParameter("completeName").toString();
    String telephone = request.getParameter("telephone").toString();

    // Check if any user information is missing and redirect if true
    if(userName.isEmpty() || userPass.isEmpty() || completeName.isEmpty() || telephone.isEmpty()){
        response.sendRedirect("ebaysignUp.html");
    } else {
        // Proceed with database operations if all user information is provided
        try {
          applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            System.out.println("Connecting to the database...");
            System.out.println(appDBAuth.toString()); // Debug print statement
            boolean res = appDBAuth.addUser(userName, completeName, userPass, telephone);
            boolean roleRes = appDBAuth.setRole(userName, 2);
            if (res && roleRes) {
                // Set userName in session if user registration is successful                
                // Assign user role
                session.setAttribute("userName", userName);
                session.setAttribute("currentPage", "ebayaddUser.jsp");
                // Redirect to login page upon successful role assignment
                response.sendRedirect("ebaywelcomeMenu.jsp");
            } else {
                    session.setAttribute("userName", null);
                    session.setAttribute("currentPage", null);
                %>
                Registration failed. Please try again.
                <%
            }
            appDBAuth.close();
        } catch (Exception e) {
            e.printStackTrace();
            %>
            An error occurred. Please try again later.
            <%
        } finally {
            System.out.println("Finally");
        }
    }
%>

</body>
</html>
