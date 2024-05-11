<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Ebay Show Product</title>
</head>
<body>

<%
    if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        response.sendRedirect("ebayloginHashing.html");
    } else {

        String currentPage = "ebaywelcomeMenu.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();
        try {

            applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
            applicationDBManager appDBManager = new applicationDBManager();
            System.out.println("Connecting to the database...");
            System.out.println(appDBAuth.toString()); // Debug print statement
            System.out.println(appDBManager.toString()); // Debug print statement

            currentPage = "ebayshowProduct.jsp";
            userName = session.getAttribute("userName").toString();
            previousPage = session.getAttribute("currentPage").toString();
            ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);
            if (res.next()) {
                System.out.println("User is logged in");
                session.setAttribute("currentPage", currentPage);
                if (session.getAttribute("userName") == null) {
                    //create the session variable
                    session.setAttribute("userName", userName);
                }
                ResultSet menuRes = appDBAuth.userElements(userName);
                String currentMenu = "";
                while (menuRes.next()) {
%>
                    <a href="<%= menuRes.getString(1) %>"><%= menuRes.getString(3) %></a>
<%
                } //close the menu while loop
                menuRes.close();
%>
                <a href="ebaysignout.jsp">Sign out</a>

<%
                ResultSet resDept = appDBManager.getAllDepartments();
%>
                <div>
                    <span>
                        <form action="ebaysearch.jsp" method="get">
                            <label for="search">Search:</label>
                            <input type="text" id="search" name="search" placeholder="Search for products">
                    </span>
                    <span>
                        <select name="productDepartment">
                            <option value="All">All</option>
<%
                            //Print the department names
                            while (resDept.next()) {
%>
                                <option value="<%= resDept.getString("deptName") %>"><%= resDept.getString("deptName") %></option>
<%
                            }
%>
                        </select>
                    </span>
                    <input type="submit" value="Submit">
                    </form>            
                </div>
<%
                //get a specific product
                //1 productid, 2 username, 3 productname, 4 productdescription, 5 productprice, 6 duedate, 7 deptid
                String sproductId = (String) request.getParameter("productId"); //get the product id from the ?= from get method
                int productId = Integer.parseInt(sproductId); //change from string to int
                ResultSet bidred = appDBManager.getMaxBid(productId); //get the bid for the product
                double maxBid = 0.0;
                while (bidred.next()) {
                    maxBid = bidred.getDouble(1);
                }
                bidred.close();
                //get the product information
                ResultSet productres = appDBManager.getProduct(productId); //pass the int to the method to get the product
                String productOwner = "", currentProduct = "";
                double currentBid = 0.0;
                while (productres.next()) {
                    //Check to create a new product element
                    if (currentProduct.compareTo(productres.getString(3)) != 0) {
                        currentBid= productres.getDouble(5);
%>
                        <div class="product">
                            <h3>Product Name:
<% 
                                //print the product title and establish a hyperlink 
                                String imagePath = "/cpen410/imagesjson/" + productres.getString(9);
%> 
                            <a><%= productres.getString(3) %></a>
                            </h3>
                            <img src="<%= imagePath %>" alt="product image" width="auto" height="250">
                            <p>Product Description: <%= productres.getString(4) %></p>
                            <p>Product Price: <%
                                //if there is no bid, print the product price
                                if (maxBid == 0.0 || maxBid < productres.getDouble(5)) {
                                  maxBid = productres.getDouble(5);
                                  %>
                                    <%= maxBid%></p>
<%
                                } else {
%>
                                    <%= maxBid %></p>
<%
                                }
%>
                            <p>Due Date: <%= productres.getString(6) %></p>
                            <p>Department: <%= productres.getString(8) %></p>
                        </div>
<%
                    }
                    currentProduct = productres.getString(3);
                    productOwner = productres.getString(2);
                } 
                //close the product while loop and close the resultset resource
                productres.close();
                boolean updateBid;
                if(maxBid > currentBid){
                    updateBid = appDBManager.updateProductStartingBid(productId, maxBid);
                }
                //check if the user is the owner of the product
                if (session.getAttribute("userName") != null) {
                    if (session.getAttribute("userName").toString().compareTo(productOwner) == 0) {
%>
                        You are the owner of this product. You cannot bid on your own product.
<%
                    } else {
                        session.setAttribute("productId", productId);
                        session.setAttribute("bidder", session.getAttribute("userName").toString());
%>
                        <form action="ebayprocessBid.jsp" method="post">
                            <input type="number" name="bidAmount" min=<%=maxBid%> placeholder="Enter your bid amount" required>
                            <input type="submit" value="Submit">
                        </form>
<%
                    }
                } else {
%>
                    Please, log in to make a bid.
                    <a href="ebayloginHashing.html">Sign in</a>
<%
                }

            } else {
                System.out.println("There was a problem verifying the user. Please, log in again.");
                session.setAttribute("currentPage", null);
                session.setAttribute("userName", null);
                response.sendRedirect("ebayloginHashing.html");
            }
            res.close();

            appDBAuth.close();
            appDBManager.close();
        } catch (Exception e) {
%> 
            Nothing to show!
<% 
            e.printStackTrace();
            response.sendRedirect("ebayloginHashing.html");
        } finally {
            //close the connection
            System.out.println("Finally");
        }
    }
%>      

</body>
</html>
