<%/******
 This page create a connection to the Department database, and count all departments in the table department using the 
//ut.JAR.CPEN410.MySQLConnector class.**/
%>
<%//Import the ut.JAR.CPEN410 package for accessing the database %>
<%@ page import="ut.JAR.CPEN410.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>

<html>
	<head>
		<title>Your first web form!</title>
	</head>
	<body>
	<%
	
	System.out.println("Testing");
		
		//Define the fields to be projected, the tables to be selected and the where clause
		String fields, tables, whereClause;
		fields ="dept_name, building";
		tables="department";
		whereClause="budget>1000";		
		
		//Try to connect the database using the MySQLConnector class	
		try{
			//Create a MySQLConnector object
			MySQLConnector conn = new MySQLConnector();
			System.out.println("Connecting...");
			//Open the connection
			conn.doConnection();
			//Perform the query
			ResultSet res=conn.doSelect(fields, tables, whereClause);
		
		
			//Iterate over the ResulSet containing all departments in the database, and count how many tuples were retrieved
			int count=0;%>
			
				
				<table border=1> //crea una tabla 
				<%while (res.next())
				{%>
				<tr> //table row
					<td> //table data cell
					<%=res.getString(1)%><br> //br es un enter en html
					</td>
				</tr>
				<%
					count++;
					
				}%>
				</table>

			Count:  <%=count%>;
			
			<%res.close();
			conn.closeConnection();
			
		} catch(Exception e)
		{
			e.printStackTrace();
		}%>		
		
	</body>
</html>