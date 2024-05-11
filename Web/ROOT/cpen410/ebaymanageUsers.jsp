<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<% // Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Admin Manage Users</title>
	</head>
	<body>

	<%
		// Check the authentication process
		if ((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)){
			session.setAttribute("currentPage", null);
			session.setAttribute("userName", null);
			response.sendRedirect("ebayloginHashing.html");
		}
		else{
			String currentPage="ebaymanageUsers.jsp";
			String userName = session.getAttribute("userName").toString();
			String previousPage = session.getAttribute("currentPage").toString();
			
			// Try to connect the database using the applicationDBManager class
			try{
					// Create the appDBMnger object
					applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
					System.out.println("Connecting...");
					System.out.println(appDBAuth.toString());
					
					// Call the listAllDepartment method. This method returns a ResultSet containing all the tuples in the table Department
					ResultSet res=appDBAuth.verifyUser(userName, currentPage, previousPage);
				
					// Verify if the user has been authenticated
					if (res.next()){
						
						// Create the current page attribute
						session.setAttribute("currentPage", "ebaymanageUsers.jsp");
						
						// Create a session variable
						if (session.getAttribute("userName")==null ){
							// create the session variable
							session.setAttribute("userName", userName);
						} else{
							// Update the session variable
							session.setAttribute("userName", userName);
						}

						// print the default elements
					ResultSet menuRes = appDBAuth.userElements(userName);
					String currentMenu="";
					while(menuRes.next()){
	%>				<a href="<%=menuRes.getString(1)%>"><%=menuRes.getString(3)%></a>
	<%
					} // close the menu while loop
					menuRes.close();

					ResultSet resUsers = appDBAuth.getAllUsers();
	%>				

					<h1>Manage Users</h1>
					<h2>Add User</h2>
					<form action="ebaycreateUser.jsp" method="post">
						Username: <input type="text" name="userName" /><br />
						Password: <input type="password" name="userPass" /><br />
						Complete Name: <input type="text" name="completeName" /><br />
						Telephone Number: <input type="text" name="telephone" /><br />
						User Type: 
						<select name="role">
							<option value="2">User</option>
							<option value="3">Admin</option>
						</select><br />
						<input type="submit" value="Add User" />
					</form>

					<h2>Modify User</h2>
					<form action="ebaymodifyUser.jsp" method="post">
						<select name="userName">
						<%          
							// Print the usernames, names, and telephone numbers
							while (resUsers.next()){
								String username = resUsers.getString("UserName");
								String name = resUsers.getString("Name");
								String telephone = resUsers.getString("telephone");
						%>
								<option value="<%=username%>"><%=username%> - <%=name%> - <%=telephone%></option>
						<%
							}
						%>
						</select><br />
						<% resUsers.beforeFirst(); %>

						New Username: <input type="text" name="newUsername" /><br />
						New Password: <input type="password" name="newPassword" /><br />
						<small>Note: Providing a new username also requires a new password.</small> <br />
						New Complete Name: <input type="text" name="newCompleteName" /><br />
						New Telephone Number: <input type="text" name="newTelephone" /><br />
						<select name="role">
							<option value="">None</option>
							<option value="2">User</option>
							<option value="3">Admin</option>
						</select><br />
						<input type="submit" value="Modify User" />
					</form>

					<h2>Remove User</h2>
					<form action="ebaydeleteUser.jsp" method="post">
						<select name="userName">
						<%          
							// Print the usernames, names, and telephone numbers
							while (resUsers.next()){
								String username = resUsers.getString("UserName");
								String name = resUsers.getString("Name");
								String telephone = resUsers.getString("telephone");
						%>
								<option value="<%=username%>"><%=username%> - <%=name%> - <%=telephone%></option>
						<%
							}
						%>
						</select><br />
						<input type="submit" value="Remove User" />
					</form>
					<%


					}else{
						// Close any session associated with the user
						session.setAttribute("userName", null);
						
						// Return to the login page
						response.sendRedirect("ebayloginHashing.html");
						}

					res.close();
					
					
					// Close the connection to the database
					appDBAuth.close();
					
					}catch(Exception e)
					{%>
						Nothing to show!
						<%e.printStackTrace();
						response.sendRedirect("ebayloginHashing.html");
					}finally{
						System.out.println("Finally");
					}
					
		}%>		
				
			
	</body>
</html>
