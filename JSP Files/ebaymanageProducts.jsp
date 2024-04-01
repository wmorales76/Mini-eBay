<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<% // Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Admin Manage Products</title>
	</head>
	<body>

		<%
			// Check the authentication process
			if ((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)){
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				response.sendRedirect("ebayloginHashing.html");
			} else {
				String currentPage="ebaymanageProducts.jsp";
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
					ResultSet res=appDBAuth.verifyUser(userName, currentPage, previousPage);

					// Verify if the user has been authenticated
					if (res.next()) {

						// Create the current page attribute
						session.setAttribute("currentPage", "ebaymanageProducts.jsp");

						// Create a session variable
						if (session.getAttribute("userName")==null ) {
							// Create the session variable
							session.setAttribute("userName", userName);
						} else {
							// Update the session variable
							session.setAttribute("userName", userName);
						}

						// Print the default elements
					ResultSet menuRes = appDBAuth.userElements(userName);
					String currentMenu="";
					while(menuRes.next()) {
					%>
						<a href="<%=menuRes.getString(1)%>"><%=menuRes.getString(3)%></a>
					<%
					} // Close the menu while loop
					menuRes.close();
					ResultSet resDept = appDBManager.getAllDepartments();
					%>
					<h1>Add Product</h1>
					<form action="ebayprocessProduct.jsp" method="post">
						<table>
							<tr>
								<td>Product Name:</td>
								<td><input type="text" name="productName" size="20" required></td>
							</tr>
							<tr>
								<td>Product Description:</td>
								<td><input type="text" name="productDescription" size="20" required></td>
							</tr>
							<tr>
								<td>Product Price:</td>
								<td><input type="number" name="productPrice" size="20" required></td>
							</tr>
							<tr>
								<td>Product Due Date:</td>
								<td><input type="text" name="productDate" size="20" required></td>
							</tr>
							<tr>
								<td>Upload Product Image:</td>
								<td><input type="file" name="productImage" size="20" required></td>
							</tr>
							<tr>
								<td>Product Department:</td>
								<td>
									<select name="productDepartment">
										<%
											// Print the department names

											while (resDept.next()) {
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
					</form>
					<%

                    resDept.close(); 
					// Get all the products, show the id, name, description, due date, and department
					ResultSet resProd = appDBManager.getAllProducts();
					// Dropdown list
					%>
					<h1> Modify Product </h1>
					<form action="ebaymodifyProduct.jsp" method="post">
						<select name="productId">
							<%
								while (resProd.next()) {
							%>
									<option value="<%=resProd.getString("productID")%>">
										<%=resProd.getString("productID")%> - <%=resProd.getString("productName")%> - <%=resProd.getString("Description")%> - <%=resProd.getString("DueDate")%> - <%=resProd.getString("DeptName")%>
									</option>
							<%
								}
							%>
						</select>

                        <%	resProd.close(); // Close ResultSet after reusing
                        ResultSet resDept2 = appDBManager.getAllDepartments(); 
                        %>
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
									<select name="deptName">
                                    <option value="None">None</option>
										<%
											// Print the department names
											while (resDept2.next()) {
										%>
												<option value="<%=resDept2.getString("deptName")%>"><%=resDept2.getString("deptName")%></option>
										<%
											}

										%>
									</select>
                                    <%
                                    resDept2.close();
                                    %>
								</td>
							</tr>
							<tr>
								<td><input type="submit" value="Modify Product"></td>
							</tr>
						</table>
					</form>
					<h1> Delete Product </h1>
					<p>Enter the ID of the product you want to remove</p>
					<form action="ebaydeleteProduct.jsp" method="post">
						<table>
							<tr>
								<td>Product ID:</td>
								<td><input type="number" name="productId" size="20" required></td>
							</tr>
							<tr>
								<td><input type="submit" value="Remove Product"></td>
							</tr>
						</table>
                    </form>
					<%

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
					}
					finally {
						System.out.println("Finally");
					}

			}%>		

	</body>
</html>
