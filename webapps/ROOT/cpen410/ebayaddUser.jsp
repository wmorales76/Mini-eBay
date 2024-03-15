<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Mini Ebay Add User</title>
	</head>
	<body>

<%
	//Retrieve variables
	String userName = request.getParameter("userName");
	String userPass = request.getParameter("userPass");
	String completeName = request.getParameter("completeName");
	String telephone = request.getParameter("telephone");
	//if any of the variables are not provided, dont allow to register
	if(userName.isEmpty() || userPass.isEmpty()|| completeName.isEmpty() || telephone.isEmpty()){
        //Redirect to the login page
        response.sendRedirect("ebaysignUp.html");
    }
	
	//Try to connect the database using the applicationDBManager class
	try{
			//Create the appDBMnger object
			applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
			System.out.println("Connecting...");
			System.out.println(appDBAuth.toString());
			
			//Call the listAllDepartment method. This method returns a ResultSet containing all the tuples in the table Department
			boolean res=appDBAuth.addUser(userName, completeName, userPass, telephone);%>
		
			
			
			<%//Verify if the user has been authenticated
			if (res){%>
				<%
                //Create a session variable
				if (session.getAttribute("userName")==null ){
					//create the session variable
					session.setAttribute("userName", userName);
				} else{
					//Update the session variable
					session.setAttribute("userName", userName);
				}
                
                response.sendRedirect("ebayloginHashing.html");
                %>
                
			<%}else{
				//Close any session associated with the user
				session.setAttribute("userName", null);
				%>
				Cannot be added 
			<%}
				
				//Close the connection to the database
				appDBAuth.close();
			
			} catch(Exception e)
			{%>
				Nothing to show!
				<%e.printStackTrace();
			}finally{
				System.out.println("Finally");
			}
			%>		
		sessionName=<%=session.getAttribute("userName")%>
		
		
	</body>
</html>
