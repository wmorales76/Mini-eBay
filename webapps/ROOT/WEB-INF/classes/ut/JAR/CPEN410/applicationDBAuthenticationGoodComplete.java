
//This class belongs to the ut.JAR.CPEN410 package
package ut.JAR.CPEN410;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

//Import hashing functions
import org.apache.commons.codec.*;

/******
	This class authenticate users using userName and passwords

*/
public class applicationDBAuthenticationGoodComplete{

	//myDBConn is an MySQLConnector object for accessing to the database
	private MySQLCompleteConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationDBAuthenticationGoodComplete(){
		//Create the MySQLConnector object
		myDBConn = new MySQLCompleteConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}
	
	
	/*******
		authenticate method
			Authentication method
			@parameters:
			@returns:
				A ResultSet containing the userName and all roles assigned to her.
	*/
	public ResultSet authenticate(String userName, String userPass)
	{
		
		//Declare function variables
		String fields, tables, whereClause, hashingVal;
		
		//Define the table where the selection is performed
		tables="user, roleuser";
		//Define the list fields list to retrieve assigned roles to the user
		fields ="user.userName, roleuser.roleId, user.Name";
		hashingVal = hashingSha256(userName + userPass);
		whereClause="user.userName = roleuser.userName and user.userName='" +userName +"' and hashing='" + hashingVal + "'";
		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause);
	}


	/*******
		menuElements method
			Authentication method
			@parameters:
			@returns:
				A ResultSet containing the userName and all roles assigned to her.
	*/
	public ResultSet menuElements(String userName)
	{
		
		//Declare function variables
		String fields, tables, whereClause, orderBy;
		
		//Define the table where the selection is performed
		tables="roleuser, role, rolewebpage, menuElement,webpage ";
		//Define the list fields list to retrieve assigned roles to the user
		fields ="rolewebpage.pageURL, menuElement.title, webpage.pageTitle";
		whereClause=" roleuser.roleID=role.roleID and role.roleID=rolewebpage.roleId and menuElement.menuID = webpage.menuID";
		whereClause+=" and rolewebpage.pageURL=webpage.pageURL";
		whereClause+=" and userName='"+ userName+"' order by menuElement.title, webpage.pageTitle;";
		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause);
	}
	//return the default elements that roleId 3 has access to
	public ResultSet defaultElements(){
		String fields, tables, whereClause, orderBy;
		tables="rolewebpage, menuElement, webpage";
		fields="rolewebpage.pageURL, menuElement.title, webpage.pageTitle";
		whereClause="rolewebpage.roleID=3 and rolewebpage.pageURL=webpage.pageURL and menuElement.menuID=webpage.menuID";
		whereClause+=" order by menuElement.title, webpage.pageTitle;";
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	//get userelements
	public ResultSet userElements(String userName){
		String fields, tables, whereClause, orderBy;
		tables="roleuser, rolewebpage, menuElement, webpage";
		fields="rolewebpage.pageURL, menuElement.title, webpage.pageTitle";
		whereClause="roleuser.userName='"+userName+"' and roleuser.roleID=rolewebpage.roleID and rolewebpage.pageURL=webpage.pageURL and menuElement.menuID=webpage.menuID";
		whereClause+=" order by menuElement.title, webpage.pageTitle;";
		return myDBConn.doSelect(fields, tables, whereClause);
	}



	/*******
		verifyUser method
			Authentication method
			@parameters:
			@returns:
				A ResultSet containing the userName and all roles assigned to her.
	*/

	
	public ResultSet verifyUser(String userName, String currentPage, String previousPage)
	{
		
		//Declare function variables
		String fields, tables, whereClause, hashingVal;
		
		//Define the table where the selection is performed
		tables="roleuser, role, rolewebpage, webpage, user, webpageprevious";
		//Define the list fields list to retrieve assigned roles to the user
		fields ="user.userName, roleuser.roleId, user.Name ";
		whereClause=" user.userName = roleuser.userName and user.userName='" +userName +"' and role.roleId=roleuser.roleId and ";
		whereClause+=" rolewebpage.roleId=role.roleId and rolewebpage.pageURL=webpage.pageURL and webpage.pageURL='" +currentPage+"' and ";
		whereClause+=" webpageprevious.previousPageURL='"+previousPage+"' and webpageprevious.currentPageURL=webpage.pageURL";
		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause);
		
		
	}
	//get one specific product 
	public ResultSet getProduct(int productID) {
		String fields = "product.ProductId, product.UserName, product.ProductName, product.Description, product.StartingBid, product.DueDate, product.DeptId, department.DeptName";
		String tables = "product, department";
		String whereClause = "product.DeptId = department.DeptId and product.ProductId = " + productID;
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	//retorna todos los productor en el database
	//SELECT product.UserName, product.ProductName, product.Description, product.StartingBid, product.DueDate, product.DeptId, department.DeptName FROM product, department WHERE product.DeptId = department.DeptId;

	public ResultSet getAllProducts() {
		String fields = "product.ProductId, product.UserName, product.ProductName, product.Description, product.StartingBid, product.DueDate, product.DeptId, department.DeptName";
		String tables = "product, department";
		String whereClause = "product.DeptId = department.DeptId";
		return myDBConn.doSelect(fields, tables, whereClause);
	}
	//get all departments
	public ResultSet getAllDepartments() {
		String fields = "*";
		String tables = "department";
		String whereClause = ""; // No additional conditions
		return myDBConn.doSelect(fields, tables);
	}

	//get all products by department
	//select productID, productName, Description, startingBid, dueDate from product, department where product.deptId=department.deptId and department.DeptName="Computers";
	public ResultSet getProductsByDepartment(String department) {
		String fields = "productID, productName, productDescription, startingBid, dueDate";
		String tables = "product, department";
		String whereClause = "product.deptId=department.deptId and department.DeptName="+"'"+department +"'";
		return myDBConn.doSelect(fields, tables, whereClause);
	}
	//get the image path associated with the product


	public boolean addUser(String userName, String completeName, String userPass, String userTelephone)
	{
		boolean res;
		String table, values, hashingValue;
		hashingValue=hashingSha256(userName + userPass);
		table="user";
		values="'"+userName+"', '" +hashingValue+"', '"+ completeName + "', '" + userTelephone + "'";
		res=myDBConn.doInsert(table, values);
		System.out.println("Insertion result " + res);
		return res;
	}


	// INSERT INTO product VALUES (default, 'userName', 'productName', 'productDescription', startingBid, 'dueDate')
	public boolean addProduct(String userName, String productName, String productDescription, String startingBid, String dueDate){
		boolean res;
		String table, values;
		table="product";
		values="default"+","+"'"+userName+"', '" +productName+"', '"+ productDescription + "', " + startingBid + ", '" + dueDate + "',"+"default";
		res=myDBConn.doInsert(table, values);
		System.out.println("Insertion result " + res);
		return res;
	}
	
	
	/*********
		hashingSha256 method
			Generates a hash value using the sha256 algorithm.
			@parameters: Plain text
			@returns: the hash string based on the plainText
	*/
	private String hashingSha256(String plainText)
	{
			String sha256hex = org.apache.commons.codec.digest.DigestUtils.sha256Hex(plainText); 
			return sha256hex;
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