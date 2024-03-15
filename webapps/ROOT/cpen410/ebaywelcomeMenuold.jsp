<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Ebay Welcome Menu</title>
		<link> rel="stylesheet" type="text/css" href="css/ebaywelcomeMenu.css">
	</head>
	<body>

	<a href="ebaysignout.jsp">Sign out</a>
<%
	//Check the authentication process
	if ((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)){
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
		response.sendRedirect("ebayloginHashing.html");
	}
	else{
	
		String currentPage="ebaywelcomeMenu.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		//Try to connect the database using the applicationDBManager class
		try{
				//Create the appDBMnger object
				applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
				System.out.println("Connecting...");
				System.out.println(appDBAuth.toString());
				
				//Call the listAllDepartment method. This method returns a ResultSet containing all the tuples in the table Department
				ResultSet res=appDBAuth.verifyUser(userName, currentPage, previousPage);
			
				
				
				//Verify if the user has been authenticated
				if (res.next()){
					String userActualName=res.getString(3);
					
					//Create the current page attribute
					session.setAttribute("currentPage", "ebaywelcomeMenu.jsp");
					
					//Create a session variable
					if (session.getAttribute("userName")==null ){
						//create the session variable
						session.setAttribute("userName", userName);
					} else{
						//Update the session variable
						session.setAttribute("userName", userName);
					}
					
					%>
					Welcome! <%=userActualName%>
					<table border=1>
					<%
					//draw the menu
					ResultSet menuRes = appDBAuth.menuElements(userName);
					String currentMenu="";
					while(menuRes.next()){
						//Check to create a new menu element
						if (currentMenu.compareTo(menuRes.getString(2))!=0){ 
							//A new element
						    currentMenu = menuRes.getString(2);
						%> <tr><td><%=currentMenu%> <td></tr>
						<%}
							//print the page title and establish a hyperlink
						%>
						<tr><td>-</td><td><a href="<%=menuRes.getString(1)%>"><%=menuRes.getString(3)%></a>
						
					<%} //Close the table 
                    %>
					</table>
					<%
					
				}else{
					//Close any session associated with the user
					session.setAttribute("userName", null);
					
					//return to the login page
					response.sendRedirect("ebayloginHashing.html");
					}
					res.close();
					//Close the connection to the database
					appDBAuth.close();
				
				} catch(Exception e)
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
