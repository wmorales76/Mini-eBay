<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<% // Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Admin Remove User</title>
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
		String currentPage="ebaymanageDepartments.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		// Try to connect the database using the applicationDBManager class
		try{
			// Create the appDBMnger object
			applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
			applicationDBManager appDBManager = new applicationDBManager();
			System.out.println("Connecting to the database...");
			System.out.println(appDBAuth.toString()); // Debug print statement
			System.out.println(appDBManager.toString()); // Debug print statement
			
			// Call the listAllDepartment method. This method returns a ResultSet containing all the tuples in the table Department
			ResultSet res=appDBAuth.verifyUser(userName, currentPage, previousPage);
			
			// Verify if the user has been authenticated
			if (res.next()){
				// Create the current page attribute
				session.setAttribute("currentPage", "ebaymanageDepartments.jsp");
				
				// Create a session variable
				if (session.getAttribute("userName")==null ){
					// Create the session variable
					session.setAttribute("userName", userName);
				} else{
					// Update the session variable
					session.setAttribute("userName", userName);
				}
				
				// Print the default elements
				ResultSet menuRes = appDBAuth.userElements(userName);
        		String currentMenu="";
        		while(menuRes.next()){
%>				<a href="<%=menuRes.getString(1)%>"><%=menuRes.getString(3)%></a>
<%
        		} // Close the menu while loop
        		menuRes.close();

				ResultSet resDept = appDBManager.getAllDepartments();
%>				
 
				<h1>Manage Departments</h1>
				<h2>Add Department</h2>
				<form action="ebayaddDepartment.jsp" method="post">
					Department Name: <input type="text" name="departmentName" /><br />
					<input type="submit" value="Add Department" />
				</form>

				<h2>Modify Department</h2>
				<form action="ebaymodifyDepartment.jsp" method="post">
					<select name="deptName">
<%          
            			// Print the department names
            			while (resDept.next()){
%>
                		<option value="<%=resDept.getString("deptName")%>"><%=resDept.getString("deptName")%></option>
<%
            			}
%>
        			</select><br />
					<% resDept.beforeFirst(); %>
					New Department Name: <input type="text" name="newDeptName" /><br />
					<input type="submit" value="Modify Department" />
				</form>

				<h2>Remove Department</h2>
				<form action="ebaydeleteDepartment.jsp" method="post">
					<select name="deptName">
<%          
            			// Print the department names
            			while (resDept.next()){
%>
                		<option value="<%=resDept.getString("deptName")%>"><%=resDept.getString("deptName")%></option>
<%
            			}
%>
        			</select><br />
					<input type="submit" value="Remove Department" />
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
			appDBManager.close();
		}catch(Exception e){
%>
			Nothing to show!
			<%
				e.printStackTrace();
				response.sendRedirect("ebayloginHashing.html");
		}finally{
			System.out.println("Finally");
		}
				
	}%>		
	</body>
</html>
