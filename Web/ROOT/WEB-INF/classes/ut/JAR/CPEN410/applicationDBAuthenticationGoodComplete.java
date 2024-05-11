
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
			@param userName The userName of the user.
			@param userPass The password of the user.
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
			@param userName The userName of the user.
			@returns:
			@return A ResultSet containing the userName and all roles assigned to her.
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



    /**
	 * userElements method
     * Retrieves user elements based on their roles.
     * @params:
     * 	@param userName The userName of the user.
     * @retuens:
	 * 	@return A ResultSet containing user elements for a specific role.
     */
	public ResultSet userElements(String userName){
		String fields, tables, whereClause, orderBy;
		tables="roleuser, rolewebpage, menuElement, webpage";
		fields="rolewebpage.pageURL, menuElement.title, webpage.pageTitle";
		whereClause="roleuser.userName='"+userName+"' and roleuser.roleID=rolewebpage.roleID and rolewebpage.pageURL=webpage.pageURL and menuElement.menuID=webpage.menuID and menuElement.menuId=1";
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/**
	 * Retrieves admin elements based on their roles.
	 * @params:
	 * 	@param userName The userName of the user.
	 * @retuens:
	 * 	@return A ResultSet containing admin elements for a specific role.
	 */
	public ResultSet adminElements(String userName){
		String fields, tables, whereClause, orderBy;
		tables="roleuser, rolewebpage, menuElement, webpage";
		fields="rolewebpage.pageURL, menuElement.title, webpage.pageTitle";
		whereClause="roleuser.userName='"+userName+"' and roleuser.roleID=rolewebpage.roleID and rolewebpage.pageURL=webpage.pageURL and menuElement.menuID=webpage.menuID and menuElement.menuId=3";
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/**
	 * verifyUser method
     * Verifies user's access to a specific page based on their roles and the page's URL.
     * @parameters:
     * 	@param userName The userName of the user.
     * 	@param currentPage The URL of the current page.
     * 	@param previousPage The URL of the previous page.
     * @returns
	 * 	@return A ResultSet containing the userName and all roles assigned to her.
     */
	public ResultSet verifyUser(String userName, String currentPage, String previousPage)
	{
		
		//Declare function variables
		String fields, tables, whereClause, hashingVal;
		
		//Define the table where the selection is performed
		tables="roleuser, role, rolewebpage, webpage, user, webpageprevious";
		//Define the list fields list to retrieve assigned roles to the user
		fields ="user.userName, roleuser.roleId, user.Name ";
		whereClause=" user.userName = roleuser.userName and user.userName='" +userName+"' and role.roleId=roleuser.roleId and ";
		whereClause+=" rolewebpage.roleId=role.roleId and rolewebpage.pageURL=webpage.pageURL and webpage.pageURL='" +currentPage+"' and ";
		whereClause+=" webpageprevious.previousPageURL='"+previousPage+"' and webpageprevious.currentPageURL=webpage.pageURL";
		System.out.println("listing...");
		
		//Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause);
		
		
	}

	/**
	 * setRole method
	 * Assigns a role to a user.
	 * @params:
	 * 	@param userName The userName of the user.
	 * 	@param roleId The ID of the role to be assigned.
	 * @returns:
	 * 	@return A boolean value indicating the success of the operation.
	 */
	public boolean setRole(String userName, int roleId){
		boolean res;
		String table, values;
		table="roleuser";
		values="default"+",'"+userName+"', "+roleId+",default";
		res=myDBConn.doInsert(table, values);
		System.out.println("Insertion result " + res);
		return res;
	}
	

	/**
	 * getAllUsers method
	 * Retrieves all users from the database.
	 * @params:
	 * @returns:
	 * 	@return A ResultSet containing all users in the database.
	 */
	public ResultSet getAllUsers() {
		String fields = "*";
		String tables = "user";
		String whereClause = ""; // No additional conditions
		return myDBConn.doSelect(fields, tables);
	}

	/**
	 * addUser method
	 * Adds a new user to the database.
	 * @params:
	 * 	@param userName The userName of the user.
	 * 	@param completeName The complete name of the user.
	 * 	@param userPass The password of the user.
	 * 	@param userTelephone The telephone number of the user.
	 * @returns:
	 * 	@return A boolean value indicating the success of the operation.
	 */
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

	/**
	 * updateUser method
	 * Updates a user's information in the database.
	 * @params:
	 * 	@param userName The userName of the user.
	 * 	@param newUserName The new userName of the user.
	 * 	@param userPass The new password of the user.
	 * 	@param completeName The new complete name of the user.
	 * 	@param userTelephone The new telephone number of the user.
	 * @returns:
	 * 	@return A boolean value indicating the success of the operation.
	 */
	public boolean updateUser(String userName, String newUserName, String userPass, String completeName, String userTelephone) {
    boolean res;
    String table = "user";
    String setClause = "";
    String whereClause = "userName='" + userName + "'";
    String hashingValue;

    // Ensure newUserName and userPass are provided together
    if (newUserName != null && !newUserName.isEmpty() && userPass != null && !userPass.isEmpty()) {
        hashingValue = hashingSha256(newUserName + userPass);
        // Assuming you're updating userName to newUserName as part of the requirements
        setClause += "userName='" + newUserName + "', hashing='" + hashingValue + "'";
    }

    // Append completeName and userTelephone to the setClause if they're not null or empty
    if (completeName != null && !completeName.isEmpty()) {
        if (!setClause.isEmpty()) setClause += ", ";
        setClause += "Name='" + completeName + "'";
    }
    if (userTelephone != null && !userTelephone.isEmpty()) {
        if (!setClause.isEmpty()) setClause += ", ";
        setClause += "Telephone='" + userTelephone + "'";
    }

    // Execute the update
    res = myDBConn.doUpdate(table, setClause, whereClause);
    System.out.println("Update result: " + res);
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