<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Ebay Welcome Menu</title>
	</head>
	<body>

<%

	try{
		applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
		System.out.println("Connecting...");
		System.out.println(appDBAuth.toString());

		if ((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)){
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
         %><a href="ebayloginHashing.html">Sign in</a><% 
         //show sign in ONLY if the user is not logged in
		}
		else{
		String currentPage="ebayshowProduct.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		ResultSet res=appDBAuth.verifyUser(userName, currentPage, previousPage);
        if(res.next()){
            System.out.println("User is logged in");
            session.setAttribute("currentPage", currentPage);
            if (session.getAttribute("userName")==null ){
                //create the session variable
                session.setAttribute("userName", userName);
            } else{
                //Update the session variable
                session.setAttribute("userName", userName);
            }
        %> <a href="ebaysignout.jsp">Sign out</a> 
		<% //show sign out ONLY if the user is logged in
		}else{
            System.out.println("There was a problem verifying the user. Please, log in again.");
            session.setAttribute("currentPage", null);
            session.setAttribute("userName", null);
            response.sendRedirect("ebayloginHashing.html");
        }
        }
        %>
        Welcome!
        <%
        //draw the menu
        ResultSet menuRes = appDBAuth.defaultElements();
        String currentMenu="";
        while(menuRes.next()){
                //print the page title and establish a hyperlink
            %>
            <a href="<%=menuRes.getString(1)%>"><%=menuRes.getString(3)%></a>
        <%} //close the menu while loop
        //get all the products
        //1 productid, 2 username, 3 productname, 4 productdescription, 5 productprice, 6 duedate, 7 deptid
        String sproductId = (String) request.getParameter("productId");//get the product id from the ?= from get method
        int productId = Integer.parseInt(sproductId); //change from string to int
        ResultSet productres = appDBAuth.getProduct(productId); //pass the int to the method to get the product
        String currentProduct=""; //
        while(productres.next()){
            //Check to create a new product element
            if (currentProduct.compareTo(productres.getString(3))!=0){ 
                //A new element
                %>
                <div class="product">
                <h3>Product Name:
                <% //print the product title and establish a hyperlink 
                %> 
                <a href="ebayshowProduct.jsp?productId=<%=productres.getString(1)%>"><%=productres.getString(3)%></a>
                </h3>
                <p>Product Description: <%=productres.getString(4)%></p>
                <p>Product Price: <%=productres.getString(5)%></p>
                <p>Due Date: <%=productres.getString(6)%></p>
                <p>Department: <%=productres.getString(8)%></p>
                </div>
                <%
            %> 
            <%}
            
            %>
        <%
        } //close the product while loop
		} catch(Exception e){%>
			Nothing to show!
			<%e.printStackTrace();
			response.sendRedirect("ebayloginHashing.html");
		}finally{
			System.out.println("Finally");
		}
%>		
			
	</body>
</html>
