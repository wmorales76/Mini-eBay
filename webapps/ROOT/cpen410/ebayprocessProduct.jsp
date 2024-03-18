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

    String productName = request.getParameter("productName");
    String productDescription = request.getParameter("productDescription");
    String sproductPrice = request.getParameter("productPrice");
	float productPrice = Float.parseFloat(sproductPrice);
    String productDate = request.getParameter("productDate");
	String productImage = request.getParameter("productImage");
	String productDepartment = request.getParameter("productDepartment");
	//Check the authentication process
	int lastprodId=-1;
	if ((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)){
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
		response.sendRedirect("ebayloginHashing.html");
	}
	else{
	
		String currentPage="ebayprocessProduct.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		//Try to connect the database using the applicationDBManager class
		try{
				//Create the appDBMnger object
				applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
				System.out.println("Connecting...");
				System.out.println(appDBAuth.toString());
				
				//Call the listAllDepartment method. This method returns a ResultSet containing all the tuples in the table Department
				boolean res=appDBAuth.addProduct(userName, productName, productDescription, productPrice, productDate, productDepartment);
				if (res){
					//Get the last product id
					ResultSet resprodId=appDBAuth.getLastProductId();
					if(resprodId.next()){
						//Create the product image
						lastprodId= resprodId.getInt(1);
						boolean imageres=appDBAuth.addImage(productImage, lastprodId);
					}

				}

				//if the addproduct method returns true, then the product was added successfully
				if (res){
					
					//Create the current page attribute
					session.setAttribute("currentPage", "ebayprocessProduct.jsp");
					
					//Create a session variable
					if (session.getAttribute("userName")==null ){
						//create the session variable
						session.setAttribute("userName", userName);
					} else{
						//Update the session variable
						session.setAttribute("userName", userName);
					}
					
				%>
				<h1>Product Added</h1>
				<%
				response.sendRedirect("ebayshowProduct.jsp?productId="+ lastprodId);
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
