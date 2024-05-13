
//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
	This class manage a connection to the Department database and it should be accessed from the front End. Therefore,
	this class must contain all needed methods for manipulating data without showing how to access the database

*/
public class applicationDBManager{

	//myDBConn is an MySQLConnector object for accessing to the database
	private MySQLCompleteConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationDBManager(){
		//Create the MySQLConnector object
		myDBConn = new MySQLCompleteConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}
	
	
	/*******
		listAllDepartment method
			List all departments in the database
			@parameters:
			@returns:
				A ResultSet containing all departments in the database
	*/


	/**
	 * addProduct method
	 * Add a product to the database
	 * @params:
	 * @param userName The userName of the user.
	 * @param productName The name of the product.
	 * @param Description The description of the product.
	 * @param startingBid The starting bid of the product.
	 * @param dueDate The due date of the product.
	 * @param deptName The department name of the product.
	 * @returns:
	 * @return A boolean indicating whether the product was successfully added to the database.
	 */
	public boolean addProduct(String userName, String productName, String Description, float startingBid, String dueDate, String deptName){
		boolean res;
		String table, values;
		table="product";
		values="default"+","+"'"+userName+"', '" +productName+"', '"+ Description + "', " + startingBid + ", '" + dueDate + "', '"+deptName+"'";
		res=myDBConn.doInsert(table, values);
		System.out.println("Insertion result " + res);
		return res;
	}
	/**
	 * getMaxBid method
	 * Get the maximum bid for a product
	 * @params:
	 * @param productId The ID of the product.
	 * @returns:
	 * @return A ResultSet containing the maximum bid for the product.
	 */
	public ResultSet getMaxBid(int productId){
		String fields, tables, whereClause;
		fields="max(bidValue)";
		tables="bid";
		whereClause="productId="+productId;
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/**
	 * getProduct method
	 * Get a product by its ID
	 * @params:
	 * @param productID The ID of the product.
	 * @returns:
	 * @return A ResultSet containing the product with the given ID.
	 */
	public ResultSet getProduct(int productID) {
		String fields = "product.ProductId, product.UserName, product.ProductName, " +
				"product.Description, product.StartingBid, product.DueDate, " +
				"product.DeptName, image.path";
		String tables = "product, department, image";
		String whereClause = "product.DeptName = department.DeptName " +
				"and product.ProductId = " + productID + " " +
				"and product.productId = image.productId";
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/**
	 * getAllProducts method
	 * Get all products in the database
	 * @params:
	 * @returns:
	 * @return A ResultSet containing all products in the database.
	 */
	public ResultSet getAllProducts() {
		String fields = "product.ProductId, product.UserName, product.ProductName, product.Description, product.StartingBid, product.DueDate, product.DeptName, image.path";
		String tables = "product, department, image";
		String whereClause = "product.DeptName = department.DeptName and product.ProductId = image.ProductId";
		return myDBConn.doSelect(fields, tables, whereClause);
	}
	/**
	 * getSearchProducts method
	 * Get products that match the search criteria
	 * @params:
	 * @param productTitle The title of the product.
	 * @param deptName The department name of the product.
	 * @returns:
	 * @return A ResultSet containing the products that match the search criteria.
	 */
	public ResultSet getSearchProducts(String productTitle, String deptName) {
		String fields = "product.ProductId, product.UserName, product.ProductName, product.Description, product.StartingBid, product.DueDate, product.DeptName, image.path";
		String tables = "product, department, image";
		String whereClause = "product.DeptName = department.DeptName and product.ProductName like '%" + productTitle + "%' and product.ProductId = image.ProductId";
		if (!deptName.equals("All")) {
			whereClause += " and department.DeptName = '" + deptName + "'";
		}
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/**
	 * getLastProductId method
	 * Get the last product ID
	 * @params:
	 * @returns:
	 * @return A ResultSet containing the last product ID.
	 */
	public ResultSet getLastProductId() {
		String fields = "LAST_INSERT_ID()";
		String tables = "product";
		String whereClause = ""; // No additional conditions
		return myDBConn.doSelect(fields, tables);
	}

	/**
	 * getProductsByDepartment method
	 * Get products by department
	 * @params:
	 * @param department The department name.
	 * @returns:
	 * @return A ResultSet containing the products in the given department.
	 */
	public ResultSet getProductsByDepartment(String department) {
		String fields = "productID, productName, Description, startingBid, dueDate";
		String tables = "product, department";
		String whereClause = "product.deptName=department.deptName and department.DeptName="+"'"+department +"'";
		return myDBConn.doSelect(fields, tables, whereClause);
	}


	/**
	 * addDepartment method
	 * Add a department to the database
	 * @params:
	 * @param deptName The name of the department.
	 * @returns:
	 * @return A boolean indicating whether the department was successfully added to the database.
	 */
	public boolean addDepartment(String deptName) {
		boolean res;
		String table, values;
		table="department";
		values="'"+deptName+"'";
		res=myDBConn.doInsert(table, values);
		System.out.println("Insertion result " + res);
		return res;
	}
	
	/**
	 * getAllDepartments method
	 * Get all departments in the database
	 * @params:
	 * @returns:
	 * @return A ResultSet containing all departments in the database.
	 */
	public ResultSet getAllDepartments() {
		String fields = "*";
		String tables = "department";
		String whereClause = ""; // No additional conditions
		return myDBConn.doSelect(fields, tables);
	}


	/**
	 * addImage method
	 * Add an image to the database
	 * @params:
	 * @param imagePath The path of the image.
	 * @param productID The ID of the product.
	 * @returns:
	 * @return A boolean indicating whether the image was successfully added to the database.
	 */
	public boolean addImage(String imagePath, int productID){
		boolean res;
		String table, values;
		table="image";
		values="default"+","+"'"+imagePath+"', "+productID;
		res=myDBConn.doInsert(table, values);
		System.out.println("Insertion result " + res);
		return res;
	}

	/**
	 * addBid method
	 * Add a bid to the database
	 * @params:
	 * @param userName The userName of the user.
	 * @param bidValue The value of the bid.
	 * @param productId The ID of the product.
	 * @returns:
	 * @return A boolean indicating whether the bid was successfully added to the database.
	 */
	public boolean addBid(String userName, float bidValue, int productId){
		boolean res;
		String table, values;
		table="bid";
		values="default"+",'"+userName+"', "+bidValue+", "+productId+", default";
		res=myDBConn.doInsert(table, values);
		System.out.println("Insertion result " + res);
		return res;
	}

	/**
	 * updateDepartment method
	 * Update a department in the database
	 * @params:
	 * @param deptName The name of the department.
	 * @param newDeptName The new name of the department.
	 * @returns:
	 * @return A boolean indicating whether the department was successfully updated in the database.
	 */
	public boolean updateDepartment(String deptName, String newDeptName){
		boolean res;
		String table, setClause, whereClause;
		table="department";
		setClause="deptName='"+newDeptName+"'";
		whereClause="deptName='"+deptName+"'";
		res=myDBConn.doUpdate(table, setClause, whereClause);
		System.out.println("Update result " + res);
		return res;
	}
	
/**
 * updateProduct method
 * Update a product in the database
 * @params:
 * @param productId The ID of the product.
 * @param productName The name of the product.
 * @param Description The description of the product.
 * @param startingBid The starting bid of the product.
 * @param dueDate The due date of the product.
 * @param deptName The department name of the product.
 * @returns:
 * @return A boolean indicating whether the product was successfully updated in the database.
 */
public boolean updateProduct(int productId, String productName, String Description, Float startingBid, String dueDate, String deptName) {
    boolean res;
    String table = "product";
    String setClause = "";
    String whereClause = "productId=" + productId;

    // Append productName to the setClause if not null or empty
    if (productName != null && !productName.isEmpty()) {
        setClause += "ProductName='" + productName + "'";
    }

    // Append Description to the setClause if not null or empty
    if (Description != null && !Description.isEmpty()) {
        if (!setClause.isEmpty()) setClause += ", ";
        setClause += "Description='" + Description + "'";
    }

    // Append startingBid to the setClause if not null
    if (startingBid != null && startingBid >= 0) { // Assuming startingBid cannot be negative
        if (!setClause.isEmpty()) setClause += ", ";
        setClause += "StartingBid=" + startingBid;
    }

    // Append dueDate to the setClause if not null or empty
    if (dueDate != null && !dueDate.isEmpty()) {
        if (!setClause.isEmpty()) setClause += ", ";
        setClause += "DueDate='" + dueDate + "'";
    }

    // Append deptName to the setClause if not null or empty
    if (deptName != null && !deptName.isEmpty()) {
        if (!setClause.isEmpty()) setClause += ", ";
        setClause += "DeptName='" + deptName + "'";
    }

    // Execute the update
    res = myDBConn.doUpdate(table, setClause, whereClause);
    System.out.println("Update result: " + res);
    return res;
}

	/**
	 * updateUserRole method
	 * Update a user's role in the database
	 * @params:
	 * @param userName The userName of the user.
	 * @param roleId The ID of the role.
	 * @returns:
	 * @return A boolean indicating whether the user's role was successfully updated in the database.
	 */
	public boolean updateUserRole(String userName, int roleId){
		boolean res;
		String table, setClause, whereClause;
		table="roleuser";
		setClause="roleId="+roleId;
		whereClause="userName='"+userName+"'"; 
		res=myDBConn.doUpdate(table, setClause, whereClause);
		System.out.println("Update result " + res);
		return res;
	}

	/**
	 * deleteProduct method
	 * Delete a product from the database
	 * @params:
	 * @param productId The ID of the product.
	 * @returns:
	 * @return A boolean indicating whether the product was successfully deleted from the database.
	 */
	public boolean deleteProduct(int productId){
		boolean res;
		String table, whereClause;
		table="product";
		whereClause="productId="+productId;
		res=myDBConn.doDelete(table, whereClause);
		System.out.println("Deletion result " + res);
		return res;
	}

	/**
	 * deleteBid method
	 * Delete a bid from the database
	 * @params:
	 * @param bidId The ID of the bid.
	 * @returns:
	 * @return A boolean indicating whether the bid was successfully deleted from the database.
	 */
	public boolean deleteBid(int bidId){
		boolean res;
		String table, whereClause;
		table="bid";
		whereClause="bidId="+bidId;
		res=myDBConn.doDelete(table, whereClause);
		System.out.println("Deletion result " + res);
		return res;
	}

	/**
	 * deleteUser method
	 * Delete a user from the database
	 * @params:
	 * @param userName The userName of the user.
	 * @returns:
	 * @return A boolean indicating whether the user was successfully deleted from the database.
	 */
	public boolean deleteUser(String userName){
		boolean res;
		String table, whereClause;
		table="user";
		whereClause="userName='"+userName+"'";
		res=myDBConn.doDelete(table, whereClause);
		System.out.println("Deletion result " + res);
		return res;
	}

	/**
	 * deleteDepartment method
	 * Delete a department from the database
	 * @params:
	 * @param deptName The name of the department.
	 * @returns:
	 * @return A boolean indicating whether the department was successfully deleted from the database.
	 */
	public boolean deleteDepartment(String deptName){
		boolean res;
		String table, whereClause;
		table="department";
		whereClause="deptName='"+deptName+"'";
		res=myDBConn.doDelete(table, whereClause);
		System.out.println("Deletion result " + res);
		return res;
	}
	/**
	 * updateProductStartingBid method
	 * Update the starting bid of a product in the database
	 * @params:
	 * @param productId The ID of the product.
	 * @param startingBid The starting bid of the product.
	 * @returns:
	 * @return A boolean indicating whether the starting bid of the product was successfully updated in the database.
	 */
	public boolean updateProductStartingBid(int productId, double startingBid) {
		boolean res;
		String table = "product";
		String setClause = "StartingBid=" + startingBid;
		String whereClause = "productId=" + productId;
		res = myDBConn.doUpdate(table, setClause, whereClause);
		System.out.println("Update result: " + res);
		return res;
	}


	/*********
		close method
			Close the connection to the database.
			This method must be called at the end of each page/object that instatiates a applicationDBManager object
			@parameters:
			@returns:
	*/
	public void close()
	{
		//Close the connection
		myDBConn.closeConnection();
	}

}