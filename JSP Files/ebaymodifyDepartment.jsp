<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<% // Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*" %>
<html>
	<head>
		<title>Admin Modify Department</title>
	</head>
	<body>

<%
	// Check the authentication process
	if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
		response.sendRedirect("ebayloginHashing.html");
	} else {
	
		String currentPage = "ebaymodifyDepartment.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		// Try to connect the database using the applicationDBManager class
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
				session.setAttribute("currentPage", "ebaymodifyDepartment.jsp");
				
				// Create a session variable
				if (session.getAttribute("userName") == null ) {
					// Create the session variable
					session.setAttribute("userName", userName);
				} else {
					// Update the session variable
					session.setAttribute("userName", userName);
				}

				String deptName = request.getParameter("deptName").toString();
				String newDeptName = request.getParameter("newDeptName").toString();
				if (deptName != null && !deptName.trim().isEmpty() && newDeptName != null && !newDeptName.trim().isEmpty()) {
					boolean result = appDBManager.updateDepartment(deptName, newDeptName);
					if (result) {
%>
						<h1>Department Updated Successfully</h1>
						<a href="ebaymanageDepartments.jsp">Update Another Department</a>
						<a href="ebayadminTools.jsp">Back to Admin Page</a>
						<a href="ebaywelcomeMenu.jsp">Welcome Page</a>
<%
					} else {
%>
						<h1>Department Not Updated</h1>
						<p>Make sure the department exists and the name is valid</p>
						<a href="ebaymanageDepartments.jsp">Try Again</a>
						<a href="ebayadminTools.jsp">Back to Admin Page</a>
						<a href="ebaywelcomeMenu.jsp">Welcome Page</a>
<%
					}
				} else {
%>
					<h1>Department Not Updated</h1>
					<p>The name is invalid or you left the box empty</p>
					<a href="ebaymanageDepartments.jsp">Try Again</a>
					<a href="ebayadminTools.jsp">Back to Admin Page</a>
					<a href="ebaywelcomeMenu.jsp">Welcome Page</a>
<%
				}
			} else {
				// Close any session associated with the user
				session.setAttribute("userName", null);
				
				// Return to the login page
				response.sendRedirect("ebayloginHashing.html");
			}

			res.close();
			// Close the connection to the database
			appDBAuth.close();
			appDBManager.close();
		} catch(Exception e) {
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
