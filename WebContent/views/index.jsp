<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=windows-1255"
    pageEncoding="windows-1255"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<meta property="og:title" content="Now im listening to"> 
	<meta property="og:description" content="latest youtube video posts from 'Now im listening to...' facebook group."> 
	<meta property="og:type" content="music"> 
	<meta property="og:url" content="http://nilt.vandervidi.cloudbees.net/controller/nilt">
	<meta property="og:site_name" content="Now im listening to ..">
	<meta property="fb:admins" content="534674899917897">
  

    <title>Now Im Listening To.. Latest Posts</title>

    <!-- Bootstrap core CSS -->
    <link href="../views/css/bootstrap.min.css" rel="stylesheet">
	
    <!-- Custom styles for this template -->
    <link href="../views/css/cover.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy this line! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
	
<%
ArrayList<String> youtubeLinks=null;
try{
	youtubeLinks= (ArrayList<String>)request.getAttribute("youtubeLinksList"); 
   }
catch (NullPointerException e1)
{
	System.out.println("Null pointer exception");	
}
	%>
	<script type="text/javascript">
	var i=0;
	var playlistLimit = <%out.print(youtubeLinks.size()); %>;
	var track = new Array();
	var trackId = new Array();
	
	<% 
	try{
		for(int j=0; j<youtubeLinks.size(); j++){
		out.println("track["+j+"] = \"//www.youtube.com/embed/"+youtubeLinks.get(j)+"?rel=0&autoplay=1"+"\"");
		out.println("trackId["+j+"] =\""+youtubeLinks.get(j)+"\"");}
		}
	catch(NullPointerException e2)
	{
		System.out.println("Null pointer exception");
	}
	%>
	function loadNext(event) {
		if (i<playlistLimit-1){
		   document.getElementById('ytp').src = track[i+1];
		    i++;
		        //increment current playing track number
			    $(".currTrackPlaying").text(i+1);
			    document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackId[i]; 
			    event.preventDefault(); 
		}	                     
	}

	function loadPrev(event) {
		if (i>=1){
	   document.getElementById('ytp').src = track[i-1];
	    i--;
	        //decrement current playing track number
		    $(".currTrackPlaying").text(i+1);
		    document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackId[i]; 
		    event.preventDefault(); 
		}                  
	}
  
</script>
  </head>

  <body>
    <div class="site-wrapper">
      <div class="site-wrapper-inner">
        <div class="cover-container">
                <div class = "navbar navbar-inverse navbar-fixed-top">
                        <div class = "container">                             
                                <a href = "../controller/nilt" class = "navbar-brand">Now Im Listening to...</a>
                                <button class = "navbar-toggle" data-toggle = "collapse" data-target = ".navHeaderCollapse">
                                        <span class = "icon-bar"></span>
                                        <span class = "icon-bar"></span>
                                        <span class = "icon-bar"></span>
                                </button>
                               
                                <div class = "collapse navbar-collapse navHeaderCollapse">                               
                                        <ul class = "nav navbar-nav navbar-right">                                       
                                                <li class = "active"><a href="../controller/nilt"><span class="glyphicon glyphicon-refresh">  </span> Refresh playlist</a></li>
												<li><a href="../views/about.html"><span class="glyphicon glyphicon-info-sign"></span> About</a></li>
												<li><a href="../views/contact.html"><span class="glyphicon glyphicon-envelope"></span> Contact</a></li>
												                           
                                        </ul>                               
                                </div>                               
                        </div>
                </div>

		  <br><br><br>
          <div class="inner cover">
          <div class="alert alert-info" style="margin-bottom:2px;">
          THE LATEST: Now playing video <span class="currTrackPlaying"> 1 </span> / <%out.print(youtubeLinks.size()); %>
			</div>
	
	            <div class="video-container">	
				<iframe id="ytp" width="640" height="360" src="//www.youtube.com/embed/<% try{out.print(youtubeLinks.get(0));}catch(NullPointerException e3){System.out.println("null pointer exception");}%>?autoplay=1" frameborder="0" allowfullscreen></iframe>
				</div>
			<p>
			    <button type="button" class="btn btn-success btn-lg btn-block" onClick="loadNext()" id="nextTrack" style="margin-top:5px;">
	  			Next   <span class="glyphicon glyphicon-forward"></span> 
				</button>
				<button type="button" class="btn btn-danger btn-lg btn-block" onClick="loadPrev()" id="prevTrack">
	  			<span class="glyphicon glyphicon-backward"></span>  Previous
				</button>		
				<button type="button" class="btn btn-orange btn-lg btn-block">
	  			<a href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v=<%out.print(youtubeLinks.get(0));%>" id="downloadLink" style="text-decoration: none">Download (BETA - Chrome)</a>	
				<button type="button" class="btn btn-primary btn-lg btn-block">
	  			<a href="http://www.facebook.com/groups/now.im.listening.to/" style="text-decoration: none">Join us in Facebook!</a>
				</button>
			</p>

          </div>

            <div>
              <p>Copyright © 2014 Vidran Abdovich , NILT. All Rights Reserved.</p>
            </div>

        </div>

      </div>

    </div>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="../views/js/bootstrap.min.js"></script>
  </body>
</html>
