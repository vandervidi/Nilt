<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=windows-1255" pageEncoding="windows-1255"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta property="og:title" content="Now im listening to"/> 
	<meta property="og:description" content="latest youtube music video posts from 'Now im listening to...' facebook group."/> 
	<meta property="og:type" content="website"/> 
	<meta property="og:url" content="http://nilt.vandervidi.cloudbees.net/controller/nilt"/>
	<meta property="og:site_name" content="Now im listening to .."/>
	<meta property="og:image" content="http://i.imgur.com/6HhvwDw.png"/>
	<meta property=article:publisher content='https://www.facebook.com/groups/now.im.listening.to/'/> 
    
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
  <body>
    <script>
	var i=0;
	var playlistLimit = <%out.print(youtubeLinks.size()); %>;
	var track = new Array();
	var trackId = new Array();
    //creating TrackId elemnts
    <% 
	try{
		for(int j=0; j<youtubeLinks.size(); j++){
		out.println("trackId["+j+"] =\""+youtubeLinks.get(j)+"\"");}
		}
	catch(NullPointerException e2)
	{
		System.out.println("Null pointer exception");
	}
	%>
      // 2. This code loads the IFrame Player API code asynchronously.
      var tag = document.createElement('script');

      tag.src = "https://www.youtube.com/iframe_api";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      // 3. This function creates an <iframe> (and YouTube player)
      //    after the API code downloads.
      var player;
      function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
          height: '360',
          width: '640',
          videoId: trackId[i],
          playerVars: {
              'iv_load_policy': 3,'enablejsapi ':1,'autohide':1},
          events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
          }
        });
      }

      // 4. The API will call this function when the video player is ready.
      function onPlayerReady(event) {
        event.target.playVideo();
        var imageUrl="http://i1.ytimg.com/vi/"+trackId[i]+"/hqdefault.jpg";
        document.body.style.backgroundImage="url("+imageUrl+")";
       
      }

      function loadNextVideo() {
    	  if(i<playlistLimit-1){
	    	  i++;
	    	  //setting the video thumbnail as a bckground
	    	  var imageUrl="http://i1.ytimg.com/vi/"+trackId[i]+"/hqdefault.jpg";
	          document.body.style.backgroundImage="url("+imageUrl+")";
	    	  $(".currTrackPlaying").text(i+1);
	    	  var videoId=trackId[i];
	    	  //setting the video thumbnail as a background
			  document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackId[i]; 
			  if(player) { player.loadVideoById(videoId); }
		}
    	  else{
    		  i=0;
        	  //setting the video thumbnail as a background
        	  var imageUrl="http://i1.ytimg.com/vi/"+trackId[i]+"/hqdefault.jpg";
              document.body.style.backgroundImage="url("+imageUrl+")";
        	  $(".currTrackPlaying").text(i+1);
        	  var videoId=trackId[i];
        	  //updating the download button with the current playing youtube video
    		  document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackId[i]; 
    		  if(player) { player.loadVideoById(videoId); }
    		}
       
    	  
      }
      
      function loadPrevVideo() {
    	  if(i>0){
	    	  i--;
	    	  //setting the video thumbnail as a background
	    	  var imageUrl="http://i1.ytimg.com/vi/"+trackId[i]+"/hqdefault.jpg";
	          document.body.style.backgroundImage="url("+imageUrl+")";
	    	  $(".currTrackPlaying").text(i+1);
	    	  var videoId=trackId[i];
	    	  //updating the download button with the current playing youtube video
			  document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackId[i]; 
			  if(player) { player.loadVideoById(videoId); }
    	  }
    	  else{
    		  i=playlistLimit-1;
    		  //setting the video thumbnail as a background
	    	  var imageUrl="http://i1.ytimg.com/vi/"+trackId[i]+"/hqdefault.jpg";
	          document.body.style.backgroundImage="url("+imageUrl+")";
	    	  $(".currTrackPlaying").text(i+1);
	    	  var videoId=trackId[i];
	    	  //updating the download button with the current playing youtube video
			  document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackId[i]; 
			  if(player) { player.loadVideoById(videoId); }
    	  }
    	  
		}
      
      function onPlayerStateChange(event) {
        if (event.data == YT.PlayerState.ENDED ) {
        	loadNextVideo();
        }
      }
      function stopVideo() {
        player.stopVideo();
      }
      
      //Google analytics code
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-48510324-1']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();

    </script>
    <!-- AddThis Pro BEGIN -->
	<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-53230e4114f8a5ea"></script>
	<!-- AddThis Pro END -->
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
                                        	<li class="activefb"><a href="http://www.facebook.com/groups/now.im.listening.to/" target="_blank" id="underlinedLink1"><img src="../views/images/facebook_icon3.png" width=18 style="margin-bottom: 6px;"> Add your songs!</a></li>         
                                                <li><a href="../controller/nilt" id="underlinedLink2"><span class="glyphicon glyphicon-refresh">  </span> Refresh playlist</a></li>
												<li><a href="#" id="underlinedLink3" data-toggle="modal" data-target="#myModal"><span class="glyphicon glyphicon-info-sign"></span> About</a></li>
												<li><a href="#" id="underlinedLink4" data-toggle="modal" data-target="#myModal2"><span class="glyphicon glyphicon-envelope"></span> Contact</a></li>											                           
                                        </ul>                               
                                </div>                               
                        </div>    
                </div>
		  <br><br><br> <br>
          <div class="inner cover">
          
          <!-- Live Streaming block
          <a href="../views/liveStream.html" style="text-decoration: none;">
          <button type="button" class="btn btn-orange btn-lg btn-block" style="margin-bottom:5px;text-align:center;">LIVE:Future Music Festival Asia</button></a>
          -->
          <div class="alert alert-info" style="margin-bottom:2px;">
          THE LATEST: Now playing video <span class="currTrackPlaying"> 1 </span> / <%out.print(youtubeLinks.size()); %>
			</div>
	
		    <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
		      <div class="video-container">
		      	<video id="player">
		      	</video>
		     </div>
			<p>
			    <button type="button" class="btn btn-success btn-lg btn-block" onClick="loadNextVideo()" id="nextTrack" style="margin-top:1px;">
	  			Next   <span class="glyphicon glyphicon-forward"></span> 
				</button>
				
				<button type="button" class="btn btn-danger btn-lg btn-block" onClick="loadPrevVideo()" id="prevTrack" style="margin-top:1px;">
	  			<span class="glyphicon glyphicon-backward"></span>  Previous
				</button>		
				
	  			<a href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v=<%out.print(youtubeLinks.get(0));%>" id="downloadLink" style="text-decoration: none" target="_blank">
	  			<button type="button" class="btn btn-orange btn-lg btn-block" style="margin-top:1px;">Download this song</button></a>
	  			
				<a href="http://www.facebook.com/groups/now.im.listening.to/" style="text-decoration: none" target="_blank">
				<button type="button" class="btn btn-primary btn-lg btn-block" style="margin-top:1px;">Join us in Facebook!
				</button></a>
			</p>

          </div>
            <div>
              <p>Copyright © 2014 Vidran Abdovich , NILT. All Rights Reserved.</p>
            </div>

        </div>

      </div>

    </div>

<!-- About Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">About</h4>
      </div>
      <div class="modal-body">
        <div style="background-color:#202020;text-align:left; padding-left:5px;padding-right:5px;">
        		<span style="color:#BEF781;"><strong>So what is this about?</strong></span>
				<br>This website was built to play ,in a playlist, the recent Youtube videos that were posted by the
				users of the <a href="https://www.facebook.com/groups/now.im.listening.to/">"Now i'm listening to...."</a> Facebook group.
				<br><br><span style="color:#BEF781;"><strong>Important: </strong></span>
				<br>Please read the terms of service from YoutubeInMp3.com (<a href="http://youtubeinmp3.com/tos/">HERE</a>)before Downloading content from this website.
				
				<br><br><span style="color:#BEF781;"><strong>F.A.Q</strong></span>
				<ul>
				<li><span style="color:#BEF781;"><strong>How can i add music videos to the playlist?</strong></span>
				<br>Just Enter the facebook group and "Like" it, then post a youtube link of the song you wish to add.
				<li><span style="color:#BEF781;"><strong>What to do when the 'Download' button doesnt work? </strong></span>
				<br>Unfortunatelly, sometimes that happens. Im using an external service and sometimes it is off (It is rare..). Just try again in a few minutes.
				<li><span style="color:#BEF781;"><strong>When loading the site on my Android smartphone browser, the video shows a black screen and doesnt play. Why is that?? </strong></span>
				<br> It works on some devices. Im still working on it and hope to sort that out soon. You could try downloading other browsers like chrome, opera, and etc.. It might sort the problem.
				</ul>
				<br><br>
				<div class="hidden-xs">
				<span style="color:#BEF781;"><strong>This is my visitors map:</strong></span>
				  <div style="text-align: center; ">
				     <iframe  marginwidth="0"   frameborder="0"  marginheight="0" width="550" height="350" src="http://www.embeddedanalytics.com/reports/displayreport?reportcode=rtUh2LQvas&chckcode=gaKdkG4BY5kwfk13PlOICJ" type="text/html"  scrolling="no"></iframe>
				     <br><br>
				  </div>
				</div>
				<span style="color:#BEF781;"><strong>Release notes:</strong></span>
				<span style="color:white;"><ul>
				<li>15/3/2014 - The background image changes to a thumbnail of the playing video.
				<li>15/3/2014 - When the playlist reaches the end, it restarts automatically.
				<li>12/3/2014 - Now when a video ends , the next one is loaded automatically.
				<li>12/3/2014 - When pressing "Next" and "Previous" buttons ,the track starts automatically.
				<li>12/3/2014 - Fixed the issue where the "Next" and "Previous" buttons that lead to out of playlist boundries.
			 	</ul>
			  </span>
			  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
        
      </div>
    </div>
  </div>
</div>
<!-- Modal end -->

<!-- Contact Modal -->
<div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Ways to contact me</h4>
      </div>
      <div class="modal-body">
      
			  <div style="background-color:#202020;text-align:center; padding-left:5px;padding-right:5px;">
			  <span style="color:#BEF781;">Via Facebook:</span>
				<!-- Facebook Badge START --><span style="font-family: &quot;lucida grande&quot;,tahoma,verdana,arial,sans-serif; font-size: 11px; line-height: 16px; font-variant: normal; font-style: normal; font-weight: normal; color: #555555; text-decoration: none;"></span><br/><a href="https://www.facebook.com/Vidran" target="_TOP" title="Vidran Abdovich"><img src="https://badge.facebook.com/badge/1119083452.1337.1958078608.png" style="border: 0px;" /></a><!-- Facebook Badge END -->
				<br>
				<span style="color:#BEF781;">Via Google+:</span><br>
				<!-- Place this tag in your head or just before your close body tag. -->
				<script type="text/javascript" src="https://apis.google.com/js/platform.js"></script>

			<!-- Place this tag where you want the widget to render. -->
			<div class="g-person" data-width="320" data-href="//plus.google.com/u/0/100699221861245624678" data-layout="landscape" data-rel="author"></div>
			</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<!-- Modal end -->
    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="../views/js/bootstrap.min.js"></script>
  </body>
</html>

