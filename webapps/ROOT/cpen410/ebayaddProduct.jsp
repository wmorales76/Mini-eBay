<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Ebay Add Product</title>
	</head>
	<body>

<%
	//Check the authentication process
	if ((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)){
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
		response.sendRedirect("ebayloginHashing.html");
	}
	else{
	
		String currentPage="ebayaddProduct.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		//Try to connect the database using the applicationDBManager class
		try{
				//Create the appDBMnger object
				applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
				System.out.println("Connecting...");
				System.out.println(appDBAuth.toString());
				
				//Call the listAllDepartment method. This method returns a ResultSet containing all the tuples in the table Department
				ResultSet resDept=appDBAuth.getAllDepartments();

				//if the addproduct method returns true, then the product was added successfully
				if (resDept.next()){
					
					//Create the current page attribute
					session.setAttribute("currentPage", "ebayaddProduct.jsp");
					
					//Create a session variable
					if (session.getAttribute("userName")==null ){
						//create the session variable
						session.setAttribute("userName", userName);
					} else{
						//Update the session variable
						session.setAttribute("userName", userName);
					}
					
				%>
				<h1>Please, add your product information</h1>
				<form action="ebayprocessProduct.jsp" method="post">
					<table>
						<tr>
							<td>Product Name:</td>
							<td><input type="text" name="productName" size="20"></td>
						</tr>
						<tr>
							<td>Product Description:</td>
							<td><input type="text" name="productDescription" size="20"></td>
						</tr>
						<tr>
							<td>Product Price:</td>
							<td><input type="number" name="productPrice" size="20"></td>
						</tr>
						<tr>
							<td>Product Due Date:</td>
							<td><input type="text" name="productDate" size="20"></td>
						</tr>
						<tr>
						<td>Upload Product Image:</td>
						<td><input type="file" name="productImage" size="20"></td>
						</tr>
						<tr>
							<td>Product Department:</td>
							<td>
								<select name="productDepartment">
									<%
										//Print the department names
										while (resDept.next()){
											%>
											<option value="<%=resDept.getString("deptName")%>"><%=resDept.getString("deptName")%></option>
											<%
										}
									%>
								</select>
							</td>
						</tr>
						<tr>
							<td><input type="submit" value="Add Product"></td>
						</tr>
					</table>
				<%
				}else{
					//Close any session associated with the user
					session.setAttribute("userName", null);
					
					//return to the login page
					response.sendRedirect("ebayloginHashing.html");
					}
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
