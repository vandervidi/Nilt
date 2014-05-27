

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

@WebServlet("/controller/*")
public class controller extends HttpServlet {
	private static final long serialVersionUID = 1L;
    public controller() {}
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String str = request.getPathInfo();
		int indicator=0;
		String[] parts; 
		if (str.equals("/nilt")){
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
//This part will pass the list of strings and the next track number to the index.jsp		    
		    request.setAttribute("youtubeLinksList", youtubeLinks);
		    request.setAttribute("publisherPic", publisherPic);
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
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
