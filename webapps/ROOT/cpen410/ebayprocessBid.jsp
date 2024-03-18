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
	
		String currentPage="ebayprocessBid.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		//Try to connect the database using the applicationDBManager class
		try{
				//Create the appDBMnger object
				applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
				System.out.println("Connecting...");
				System.out.println(appDBAuth.toString());
				
                //verify the user
				ResultSet res=appDBAuth.verifyUser(userName, currentPage, previousPage);

				//if the addproduct method returns true, then the product was added successfully
				if (res.next()){
					
					//Create the current page attribute
					session.setAttribute("currentPage", "ebayprocessBid.jsp");
					
					//Create a session variable
					if (session.getAttribute("userName")==null ){
						//create the session variable
						session.setAttribute("userName", userName);
					} else{
						//Update the session variable
						session.setAttribute("userName", userName);
					}
					
                    //add the bid to the bids table after the user was verified
                    String bidder = session.getAttribute("bidder").toString();
                    String sproductId = session.getAttribute("productId").toString();
                    int productId = Integer.parseInt(sproductId);
                    String sbidAmount = request.getParameter("bidAmount").toString();
                    float bidAmount = Float.parseFloat(sbidAmount);
                    boolean bidres = appDBAuth.addBid(bidder, bidAmount, productId);
                    if (bidres){
                        //redirect to the success page
                        response.sendRedirect("ebayshowProduct.jsp?productId="+productId);
                    }
				
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
