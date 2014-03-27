

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class controller
 */
@WebServlet("/controller/*")
public class controller extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public controller() {
        // TODO Auto-generated constructor stub
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String str = request.getPathInfo();
		int trackNumber=0;
		String[] parts; 
		if (str.equals("/nilt")){
//This part will isolate the youtube links and pass the links in a list oblject to index.jsp
		    String urlText = "http://facebook-rss.herokuapp.com/rss/534674899917897";
		    BufferedReader in = null;
		    List<String> youtubeLinks = new ArrayList<>();
		    try {
		      URL url = new URL(urlText);
		      in = new BufferedReader(new InputStreamReader(url.openStream()));

		      String inputLine;
		      while ((inputLine = in.readLine()) != null) {
		    	  //if the link is a SoundCloud link then ignore it.
		    	  if (inputLine.contains(" <title><![CDATA[http") && !inputLine.contains("soundcloud"))
		    	  {
		    		  youtubeLinks.add(inputLine);
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
		    	String strTemp=youtubeLinks.get(i).replaceAll("]]></title>", "");
		    	youtubeLinks.set( i , strTemp);
		    	strTemp=youtubeLinks.get(i).replace("    <title><![CDATA[", "");
		    	//<--start--This part removes any additional parameters like &hd and so...
		    	parts = strTemp.split("&");
				strTemp=parts[0];
				parts = strTemp.split("#");
				strTemp=parts[0];
				strTemp=strTemp.trim();
				//end-->
		    	youtubeLinks.set( i , strTemp);
		    	//if the link is HTTP link and the string contains the substring "&list=" - remove it (its part of a playlist)
		    	if (youtubeLinks.get(i).contains("&list=") && youtubeLinks.get(i).contains("http://www.youtube.com/watch?v="))
		    	{
		    		
		    		strTemp=youtubeLinks.get(i).replace("http://www.youtube.com/watch?v=", "");
		    		parts = strTemp.split("&");
		    		strTemp=parts[0];
		    		strTemp=strTemp.trim();
			    	youtubeLinks.set( i , strTemp);
		    	}
		    	//if the link is HTTPS link and the string contains the substring "&list=" - remove it (its part of a playlist)
		    	else if (youtubeLinks.get(i).contains("&list=") && youtubeLinks.get(i).contains("https://www.youtube.com/watch?v="))
		    	{

		    		strTemp=youtubeLinks.get(i).replace("https://www.youtube.com/watch?v=", "");
		    		parts = strTemp.split("&");
		    		strTemp=parts[0];
		    		strTemp=strTemp.trim();
		    		System.out.println(strTemp);
			    	youtubeLinks.set( i , strTemp);
			    	
		    	}
		    	//if the string contains the substring "HTTPS://www.youtube.com/watch?v=" - remove it. (secured connection)
		    	else if (youtubeLinks.get(i).contains("https://www.youtube.com/watch?v="))
		    	{
		    		strTemp=youtubeLinks.get(i).replace("https://www.youtube.com/watch?v=", "");
			    	youtubeLinks.set( i , strTemp);
		    	}
		    	//if the string contains the substring "HTTP://www.youtube.com/watch?v=" - remove it
		    	else if (youtubeLinks.get(i).contains("http://www.youtube.com/watch?v="))
		    	{
		    		strTemp=youtubeLinks.get(i).replace("http://www.youtube.com/watch?v=", "");
			    	youtubeLinks.set( i , strTemp);
		    	}
		    	//if the string contains the substring "HTTP://youtu.be/" - remove it. 
		    	else if (youtubeLinks.get(i).contains("http://youtu.be/"))
		    	{
		    		strTemp=youtubeLinks.get(i).replace("http://youtu.be/", "");
			    	youtubeLinks.set( i , strTemp);
		    	}
		    	//if the string contains the substring "HTTPS://youtu.be/" - remove it. (secured connection)
		    	else if (youtubeLinks.get(i).contains("https://youtu.be/"))
		    	{
		    		strTemp=youtubeLinks.get(i).replace("https://youtu.be/", "");
			    	youtubeLinks.set( i , strTemp);
		    	}
  	
		    }
		    
//This part will pass the list of strings and the next track number to the index.jsp
		    request.setAttribute("youtubeLinksList", youtubeLinks);
		    request.setAttribute("trackNum", trackNumber);
			RequestDispatcher dispatcher = getServletContext()
					.getRequestDispatcher("/views/nextVersionIndex.jsp");
			dispatcher.forward(request, response);	
	    }

		else{
            RequestDispatcher dispatcher = getServletContext()
            .getRequestDispatcher("/views/404.jsp");
            dispatcher.forward(request, response);        
		    }
		}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
