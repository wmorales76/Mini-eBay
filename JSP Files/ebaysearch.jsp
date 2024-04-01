<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.CPEN410.*"%>
<%@ page import="java.sql.*"%>

<html>
    <head>
        <title>Ebay Search Result</title>
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
            try{
                applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
                applicationDBManager appDBManager = new applicationDBManager();
                System.out.println("Connecting to the database...");
                System.out.println(appDBAuth.toString()); // Debug print statement
                System.out.println(appDBManager.toString()); // Debug print statement
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

                        //draw the menu
                        ResultSet menuRes = appDBAuth.userElements(userName);
                        String currentMenu="";
                        while(menuRes.next()){
                            //print the page title and establish a hyperlink
                        %>
                            <a href="<%=menuRes.getString(1)%>"><%=menuRes.getString(3)%></a>
                        <%} //close the menu while loop
                        menuRes.close();
                    %> 
                        <a href="ebaysignout.jsp">Sign out</a> 
                    <% //show sign out ONLY if the user is logged in
                        ResultSet resDept = appDBManager.getAllDepartments();
                        String currentDept="";
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
                                        <option value="<%=resDept.getString("deptName")%>"><%=resDept.getString("deptName")%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </span>
                                <input type="submit" value="Submit">
                                </form>            
                        </div>
                    <%
                        resDept.close();
                        //search box
                        String searchProd = request.getParameter("search").toString();
                        String searchDept = request.getParameter("productDepartment").toString();
                        ResultSet searchRes = appDBManager.getSearchProducts(searchProd, searchDept);
                        String currentProduct="";
                        int productCount = 0; //
                    %> 
                        <h2>Products</h2> 
                        <div style="display: flex; justify-content: center; align-items: center;">
                    <%
                        while(searchRes.next()){
                    %>
                            <%
                                if(productCount==3){
                                    productCount = 0;
                            %>
                                    </div>
                                    <div style="display: flex; justify-content: left;">
                            <%
                                }
                                //Check to create a new product element
                                if (currentProduct.compareTo(searchRes.getString(3))!=0){ 
                                    //A new element
                                    productCount++;
                            %>
                                    <span style="display: inline-block; margin-right: 110px;">
                                        <h3>Product Name:
                            <% //print the product title and establish a hyperlink 
                                //1 productid, 2 username, 3 productname, 4 productdescription, 5 productprice, 6 duedate, 7 deptid
                                //8 image path name
                                String imagePath = "/cpen410/imagesjson/"+searchRes.getString(9);
                            %> 
                                <a href="ebayshowProduct.jsp?productId=<%=searchRes.getString(1)%>"><%=searchRes.getString(3)%></a>
                                        </h3>
                                        <img src=<%=imagePath%> alt="product image" width="100" height="100">
                                        <p>Product Price: <%=searchRes.getString(5)%></p>
                                        <p>Due Date: <%=searchRes.getString(6)%></p>
                                        <p>Department: <%=searchRes.getString(8)%></p>
                                    </span>
                            <%}
                            %>
                    <%
                        }
                    %>
                        </div>
                    <%
                    } else{
                        System.out.println("There was a problem verifying the user. Please, log in again.");
                        session.setAttribute("currentPage", null);
                        session.setAttribute("userName", null);
                        response.sendRedirect("ebayloginHashing.html");
                    }
                appDBAuth.close();
                appDBManager.close();
            } catch(Exception e){%>
                Nothing to show!
                <%
                e.printStackTrace();
                response.sendRedirect("ebayloginHashing.html");
            }finally{
                System.out.println("Finally");
            }
    }
        %>		
            
    </body>
</html>
