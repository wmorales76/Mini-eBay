<%@ page import="java.lang.*" %>
<%@ page import="ut.JAR.CPEN410.*" %>
<%@ page import="java.sql.*" %>
<html>
    <head>
        <title>Admin Update Product</title>
    </head>
    <body>
        <%
            // Check the authentication process
            if ((session.getAttribute("userName") == null) || (session.getAttribute("currentPage") == null)) {
                session.setAttribute("currentPage", null);
                session.setAttribute("userName", null);
                response.sendRedirect("ebayloginHashing.html");
            } else {
                String currentPage = "ebaymodifyProduct.jsp";
                String userName = session.getAttribute("userName").toString();
                String previousPage = session.getAttribute("currentPage").toString();

                // Try to connect to the database using the applicationDBManager class
                try {
                    applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
                    applicationDBManager appDBManager = new applicationDBManager();
                    System.out.println("Connecting to the database...");
                    System.out.println(appDBAuth.toString()); // Debug print statement
                    System.out.println(appDBManager.toString()); // Debug print statement


                    ResultSet res = appDBAuth.verifyUser(userName, currentPage, previousPage);

                    // Verify if the user has been authenticated
                    if (res.next()) {
                        session.setAttribute("currentPage", "ebaymodifyProduct.jsp");
                        session.setAttribute("userName", userName);


                         // Product information retrieval and null checks
                    String productIdStr = request.getParameter("productId");
                    int productId = 0;
                    if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                        productId = Integer.parseInt(productIdStr.trim());
                    }

                    String productName = request.getParameter("productName");
                    productName = (productName != null && !productName.trim().isEmpty()) ? productName.trim() : null;

                    String productDescription = request.getParameter("productDescription");
                    productDescription = (productDescription != null && !productDescription.trim().isEmpty()) ? productDescription.trim() : null;

                    String startingBidStr = request.getParameter("startingBid");
                    Float startingBid = null;
                    if (startingBidStr != null && !startingBidStr.trim().isEmpty()) {
                        startingBid = Float.parseFloat(startingBidStr.trim());
                    }

                    String dueDate = request.getParameter("dueDate");
                    dueDate = (dueDate != null && !dueDate.trim().isEmpty()) ? dueDate.trim() : null;

                    String deptName = request.getParameter("deptName");
                    deptName = (deptName != null && !deptName.trim().isEmpty()) ? deptName.trim() : null;
                    boolean result = false;
                    // Update the product if the productId is valid and at least one other parameter is provided
                    if(productId > 0 && (productName != null || productDescription != null || startingBid != null || dueDate != null || deptName != null)){
                        result = appDBManager.updateProduct(productId, productName, productDescription, startingBid, dueDate, deptName);
                    }

                    if (result) {
                        %>
                        <h1>Product Updated Successfully</h1>
                        <%
                    } else {
                        %>
                        <h1>Product Not Updated</h1>
                        <p>Make sure the product ID is valid and the product exists.</p>

                        <%
                    }


                    } else {
                        session.setAttribute("userName", null);
                        response.sendRedirect("ebayloginHashing.html");
                    }
%>
                        <a href="ebaymanageProducts.jsp">Try Again</a>
                        <a href="ebayadminTools.jsp">Back to Admin Page</a>
                        <a href="ebaywelcomeMenu.jsp">Welcome Page</a>
<%
                    res.close();
                   
                    appDBAuth.close();
                } catch (Exception e) {
                    %>
                    Nothing to show!
                    <%
                    e.printStackTrace();
                    response.sendRedirect("ebayloginHashing.html");
                } finally {
                    System.out.println("Finally");
                }
            }
        %>
    </body>
</html>
