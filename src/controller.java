

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

@WebServlet("/controller/*")
public class controller extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Connection connection = null;

	
	public static Connection getConnection() {
	        try {
	        	//Class.forName("com.mysql.jdbc.Driver");
				//connection = DriverManager.getConnection("jdbc:mysql://shenkar.info/nilt", "vandervidi", "nilttr");
			

	        	 //for online

	        	Context ctx = new InitialContext();
	        	DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/mydb");
	        	connection = ds.getConnection();
	        }
	        catch (Exception e) {
	            e.printStackTrace();
	        }
       
        return connection;
    }
	
	
    public controller() {
        super();
        connection = getConnection();	
    }
	
	
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String str = request.getPathInfo();
		int indicator=0;
		String[] parts; 
		if (str.equals("/nilt")){
			 try {
				if (connection!= null && connection.isClosed()){
				        
				        	//Class.forName("com.mysql.jdbc.Driver");
							//connection = DriverManager.getConnection("jdbc:mysql://shenkar.info/nilt", "vandervidi", "nilttr");
					Context ctx = new InitialContext();
		        	DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/mydb");
		        	connection = ds.getConnection();
				
				}
			} catch (SQLException | NamingException e4) {
				// TODO Auto-generated catch block
				e4.printStackTrace();
			}
			 	
			try {
				String createTable = "CREATE TABLE IF NOT EXISTS ytkeys ("
					    //+ "id INT(64) NOT NULL AUTO_INCREMENT,"
					    + " videokeys VARCHAR(11),"
					    + " publisherpic VARCHAR(100)"
					   // + " PRIMARY KEY(id)"
					    + ") ;";
				
				Statement statement = connection.createStatement();
				statement.executeUpdate(createTable);
				statement.close();
			} catch (SQLException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			
			
			//This part will isolate the youtube links and pass the links in a list oblject to index.jsp
		    String urlText = "http://facebook-rss.herokuapp.com/rss/534674899917897";
		    BufferedReader in = null;
		    List<String> youtubeLinks = new ArrayList<>();
		    List<String> publisherPic = new ArrayList<>();
		    try {
		      URL url = new URL(urlText);
		      in = new BufferedReader(new InputStreamReader(url.openStream()));

		      String inputLine;
		      while ((inputLine = in.readLine()) != null) {
		    	  //if the link is a SoundCloud link then ignore it.
		    	  if (inputLine.contains(" <title><![CDATA[http") && !inputLine.contains("soundcloud"))
		    	  {
		    		  youtubeLinks.add(inputLine);
		    		  indicator=1;
		    	  }
		    	  if (inputLine.contains("          ><img src=\"http://graph.facebook.com/") && (indicator==1))
		    	  {
		    		  parts = inputLine.split("\"");
		    		  publisherPic.add(parts[1]);
		    		  indicator=0;
		    	  }
		      }
		    } catch (Exception e) {
		      e.printStackTrace();
		    } finally {
		      if (in != null) {
		        try {
		          in.close();
		        } catch (IOException e) {
		          e.printStackTrace();
		        }
		      }
		    }
		    
//This loop removes all unwanted substrings and the result is an list of 
//strings that contain only YOUTUBE links.
		    for (int i=0 ; i<youtubeLinks.size() ; i++)
		    {
		    	String strTemp=youtubeLinks.get(i);
		    	if (strTemp.contains("<title><![CDATA[")){
					
					//removing special symbols from the URL, (=,&,#,?) and isolating uniqe video id.
					
					if(strTemp.contains("youtu.be/")){
						parts = strTemp.split("be/");
						strTemp = parts[1];
					}
					if(strTemp.contains("youtube")){
						parts = strTemp.split("v=");
						strTemp = parts[1];
					}
					if (strTemp.length()>11){
						strTemp = strTemp.substring(0,11);
					}
					youtubeLinks.set( i , strTemp);   	
		    	}
		    }  
/*   This part is adding new videos to the database
  
  Steps: 1. Create a temporary table that is a copy of the existing main table
		 2. Clear everything from the main table
		 3. Insert the new youtube keys to the original table
		 4. Insert values from the temporary table back to the main
		 5. Drop the temporary table
		 5. Create a new Temporary table
		 6. Copy the main table to the temporary table and remove duplicate rows
		 7. Drop the temporary table
*/
	
//Step 1
		    try {
		    	Statement statement = connection.createStatement();
				statement.executeUpdate(
						" CREATE TABLE IF NOT EXISTS `tempkeys` AS "  
						+" (SELECT `videokeys`,`publisherpic` FROM `ytkeys`);"
						);			
//Step 2
				statement.executeUpdate("TRUNCATE TABLE `ytkeys`; ");
				statement.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

//Step 3
			//Inserting into the empty 'index file' table all rows from the temporary table
			for(int i=0; i<youtubeLinks.size(); i++){
			                try {
								PreparedStatement prepstate = connection.prepareStatement
						                ("INSERT INTO `ytkeys` (`videokeys`,`publisherpic`) VALUES (?,?);");
						                prepstate.setString(1, youtubeLinks.get(i));
						                prepstate.setString(2, publisherPic.get(i));
						                prepstate.execute();
						                prepstate.close();
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}    
			}
//Step 4
			
				try {
					Statement statement = connection.createStatement();
					ResultSet rs = statement.executeQuery("SELECT `videokeys`,`publisherpic` FROM `tempkeys`; ");
					List <String> tmpValues = new ArrayList<String>();
					List <String> tmpPics = new ArrayList<String>();
					while(rs.next()){
						String tmpValue = rs.getString("videokeys");
						String tmpPic = rs.getString("publisherpic");
						tmpValues.add(tmpValue);
						tmpPics.add(tmpPic);
					}
					statement.close();
				
					for (int i=0; i<tmpValues.size() ; i++){
						PreparedStatement prepstate = connection.prepareStatement
				                ("INSERT INTO `ytkeys` (`videokeys` , `publisherpic`) VALUES (?,?);");
				                prepstate.setString(1, tmpValues.get(i));
				                prepstate.setString(2, tmpPics.get(i));
				                prepstate.execute();
				                prepstate.close();
					}
//Step 5				
				statement = connection.createStatement();
				statement.executeUpdate("DROP TABLE IF EXISTS `tempkeys`; ");
				statement.close();
				
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

//step6
			try {
				Statement statement = connection.createStatement();
			//Creating a temporary table that will store a table without duplicate rows.
			
				statement.executeUpdate(
						" CREATE TABLE IF NOT EXISTS `tempkeys` AS "  
						+" SELECT `videokeys`, `publisherpic` FROM `ytkeys` "
						+" GROUP BY `videokeys`,`publisherpic` ORDER BY NULL;"
						);
			//Clearing completely the 'index File' table	
			statement.executeUpdate("TRUNCATE TABLE `ytkeys`;");
			
			//Inserting into the empty 'index file' table all rows from the temporary table
			statement.executeUpdate(
						" INSERT INTO `ytkeys` (`videokeys`,`publisherpic`) "
						+" SELECT `videokeys`,`publisherpic` "
						+" FROM `tempkeys`;"
						);
			//Deleting the temporary table we used
				statement.executeUpdate("DROP TABLE IF EXISTS `tempkeys`;");
				statement.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

//step  7
			List <String> tmpValues = new ArrayList<String>();
			List <String> tmpPics = new ArrayList<String>();
			try {
				Statement statement = connection.createStatement();
				ResultSet rs = statement.executeQuery("SELECT * FROM `ytkeys`;");
				
				while(rs.next()){
					tmpValues.add(rs.getString("videokeys"));
					tmpPics.add(rs.getString("publisherpic"));
				}
			statement.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			try {
				connection.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
//This part will pass the list of strings and the next track number to the index.jsp		    
		    request.setAttribute("youtubeLinksList", tmpValues);
		    request.setAttribute("publisherPic", tmpPics);
			RequestDispatcher dispatcher = getServletContext()
					.getRequestDispatcher("/views/index.jsp");
			dispatcher.forward(request, response);	
	    }
		else{
            RequestDispatcher dispatcher = getServletContext()
            .getRequestDispatcher("/views/404.jsp");
            dispatcher.forward(request, response);        
		    }
		}
}
