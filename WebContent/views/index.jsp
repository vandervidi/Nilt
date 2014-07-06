<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=windows-1255" pageEncoding="windows-1255"%>
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://ogp.me/ns/fb#">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta property="og:title" content="Now i'm listening to"/> 
	<link rel="shortcut icon" href="../views/images/favicon.ico" />
	<meta property="og:description" content="Now i'm listening to is based on its group on facebook. It's all about sharing and listening to music that other people listen to. Join us ,share your music and enjoy listening to music that other people shared."/> 
	<meta property="og:type" content="website"/> 
	<meta property="og:url" content="http://www.nowimlisteningto.com/controller/nilt"/>
	<meta property="og:site_name" content="Now i'm listening to"/>
	<meta property="og:image" content="http://i.imgur.com/ihTGpaJ.jpg"/>
    <meta name="google-site-verification" content="Q0zzoW5qfuknFK7qodXxS1sKX1GOawnwFoZb3Ya4mmw" />
    <meta name="author" content="Vidran Abdovich">
    <title>Now i'm listening to - Share your music</title>

    <!-- Bootstrap core CSS -->
    <link href="../views/css/bootstrap.min.css" rel="stylesheet">
	
    <!-- Custom styles for this template -->
    <link href="../views/css/cover.css" rel="stylesheet">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>    
    
   
<%
ArrayList<String> youtubeLinks=null;
ArrayList<String> publisherPicLink=null;
try{
	youtubeLinks= (ArrayList<String>)request.getAttribute("youtubeLinksList"); 
	publisherPicLink= (ArrayList<String>)request.getAttribute("publisherPic"); 
   }
catch (NullPointerException e1)
{
	System.out.println("Null pointer exception");	
}
%>

<script type="text/javascript">

$(window).load(function() {
	$(".loader").fadeOut("slow");
	if(localStorage.getItem("update")==null){
	 $('#myModal3').modal('show');
	 localStorage['update'] = "seen";
	}
})

var i=0;
var title=null;
var playlistLimit = <%out.print(youtubeLinks.size()); %>;
var trackInfo = [];
var trackId = []; 
var publisherPic = []; 
//creating TrackId elements
<% 
try{
		for(int j=0; j<youtubeLinks.size(); j++){	
		out.print("trackId["+j+"] =\""+youtubeLinks.get(j)+"\""+";");
		out.print("publisherPic["+j+"] =\""+publisherPicLink.get(j)+"\""+";");
		}
	}
catch(NullPointerException e2)
{
	System.out.println("Null pointer exception");
}
%>
//making a new array of objects that will represent a track. Its ID and its publishers FB pic link.
//Reason for creating this array is to prevent unsynchronization btween track id and publisher's picture when shuffeling.
for(var j = 0 ; j<trackId.length ; j++){
	trackInfo.push({id:trackId[j] , publisher: publisherPic[j]});
}

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
    height: '720',
    width: '1280',
    videoId: trackInfo[i].id,
    playerVars: {
        'iv_load_policy': 3,'autohide':1, 'controls':0, 'showinfo':0},
    events: {
      'onReady': onPlayerReady,
      'onStateChange': onPlayerStateChange
    }
  });
}

 // 3. The API will call this function when the video player is ready.
 function onPlayerReady(event) {
	//auto play
   //event.target.playVideo();
   loadInfo(trackInfo[i].id);
   player.setVolume(100);
   player.setPlaybackQuality('hd720');
   changePublishersPic();
 }

 function loadNextVideo() {
  if(i<playlistLimit-1){
	  i++;
	  changePublishersPic();
	  loadInfo(trackInfo[i].id);
	  $(".currTrackPlaying").text(i+1);
	  var videoId=trackInfo[i].id;
	  //setting the video thumbnail as a background
	  document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackInfo[i].id; 
	  if(player) { player.loadVideoById(videoId); }
}
 else{
  i=0;
 	 changePublishersPic();
 	 loadInfo(trackInfo[i].id);
  	 $(".currTrackPlaying").text(i+1);
  	 var videoId=trackInfo[i].id;
     //updating the download button with the current playing youtube video
     document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackInfo[i].id; 
 	 if(player) { player.loadVideoById(videoId); }
	}
}
      
function loadPrevVideo() {
  if(i>0){
	  i--;
	  changePublishersPic();
	  loadInfo(trackInfo[i].id);
	  $(".currTrackPlaying").text(i+1);
	  var videoId=trackInfo[i].id;
	  //updating the download button with the current playing youtube video
	 document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackInfo[i].id; 
	 if(player) { player.loadVideoById(videoId); }
  }
 else{
  i=playlistLimit-1;
  changePublishersPic();
  loadInfo(trackInfo[i].id);
  $(".currTrackPlaying").text(i+1);
  var videoId=trackInfo[i].id;
 //updating the download button with the current playing youtube video
 document.getElementById("downloadLink").href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v="+trackInfo[i].id; 
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
   
 //getting youtube video title from youtube gdata
var loadInfo = function (videoId) {
var gdata = document.createElement("script");
gdata.src = "http://gdata.youtube.com/feeds/api/videos/" + videoId + "?v=2&alt=jsonc&callback=storeInfo";
var body = document.getElementsByTagName("body")[0];
body.appendChild(gdata);
  };

var storeInfo = function (info) {
title=info.data.title;
document.getElementById("currTrackTitle").innerHTML = (i+1)+"/"+(playlistLimit)+" : "+title;
   console.log(title);
};

//function that changes th song publisher logo
function changePublishersPic(){
	 document.getElementById("publishersPic").src = trackInfo[i].publisher;
}

//Twitter share poppup
function twitter_click(width, height) {
var leftPosition, topPosition;
//Allow for borders.
leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
//Allow for title and status bars.
topPosition = (window.screen.height / 2) - ((height / 2) + 50);
var windowFeatures = "status=no,height=" + height + ",width=" + width + ",resizable=yes,left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ",toolbar=no,menubar=no,scrollbars=no,location=no,directories=no";
u=location.href;
t=document.title;
window.open('https://twitter.com/intent/tweet?u='+encodeURIComponent(u)+'&t='+encodeURIComponent(t),'sharer', windowFeatures);
return false;
}

//function that pops a window for a Facebook share
function fbs_click(width, height) {
var leftPosition, topPosition;
//Allow for borders.
leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
//Allow for title and status bars.
topPosition = (window.screen.height / 2) - ((height / 2) + 50);
var windowFeatures = "status=no,height=" + height + ",width=" + width + ",resizable=yes,left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ",toolbar=no,menubar=no,scrollbars=no,location=no,directories=no";
u=location.href;
t=document.title;
window.open('http://www.facebook.com/sharer.php?u='+encodeURIComponent(u)+'&t='+encodeURIComponent(t),'sharer', windowFeatures);
return false;
}

$(function() {
$("#shareOnFacebook").bind("mouseover",hoverEffectFacebook);
$("#shareOnFacebook").bind("mouseleave",normalFacebook);
$("#shareOnGooglePlus").bind("mouseover",hoverEffectGooglePlus);
$("#shareOnGooglePlus").bind("mouseleave",normalGooglePlus);
$("#shareOnTwitter").bind("mouseover",hoverEffectTwitter);
$("#shareOnTwitter").bind("mouseleave",normalTwitter);
});

function hoverEffectFacebook(event)
{
$("#shareOnFacebook").animate({
width: "130%",
}, 100 );
}

function hoverEffectGooglePlus(event)
{
$("#shareOnGooglePlus").animate({
width: "130%",
}, 100 );
}

function hoverEffectTwitter(event)
{
$("#shareOnTwitter").animate({
width: "130%",
}, 100 );
}

function normalFacebook(event)
{
$("#shareOnFacebook").animate({
width: "100%",
}, 200 );
}

function normalGooglePlus(event)
{
$("#shareOnGooglePlus").animate({
width: "100%",
}, 200 );
}

function normalTwitter(event)
{
$("#shareOnTwitter").animate({
width: "100%",
}, 200 );
}


//A Fisher-Yates shuffle algorithm - used to shuffle the playlist.
function shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
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

<body>  
<div class="loader">
	<div id="loadingContainer">
		<span id="loaderHeader">Now I'm Listening To</span><Br><Br><Br>
		<img src="../views/images/loading-spinner.gif">
		<br><br><h3>Creating Playlist...</h3>
	</div>
</div>
 
<div class="video-container">
	<div id="player"></div>
</div>
  
<div class = "navbar navbar-inverse">
   <div class = "container">
	 <a href = "../controller/nilt" class = "navbar-brand">Now i'm listening to ..</a>
     <button class = "navbar-toggle" data-toggle = "collapse" data-target = ".navHeaderCollapse">
             <span class = "icon-bar"></span>
             <span class = "icon-bar"></span>
             <span class = "icon-bar"></span>
     </button> 
                     
    	 <div class = "collapse navbar-collapse navHeaderCollapse">                               
             <ul class = "nav navbar-nav navbar-right"> 
             <!--   LIVE STREAM
             	<li class="activesc"><a href="../views/liveStream.html" id="underlinedLink2liveStream"><span class="glyphicon glyphicon-facetime-video"></span>
				event name</a></li>
				-->
             	<li class="activefb"><a href="http://www.facebook.com/groups/now.im.listening.to/" target="_blank" id="underlinedLink1"><img src="../views/images/facebook_icon3.png" width=18 style="margin-bottom: 6px;" alt="facebook icon"> Add your songs!</a></li>         
                <li><a href="../controller/nilt" id="underlinedLink2"><span class="glyphicon glyphicon-refresh">  </span> Refresh playlist</a></li>
				<li><a href="#" id="underlinedLink3" data-toggle="modal" data-target="#myModal"><span class="glyphicon glyphicon-info-sign"></span> About</a></li>
				<li><a href="#" id="underlinedLink4" data-toggle="modal" data-target="#myModal2"><span class="glyphicon glyphicon-envelope"></span> Contact</a></li>											                           
             </ul>                               
         </div>                               
  </div>    
</div>
            
<div class = "navbar navbar-inverse navbar-fixed-bottom" style="padding-top:5px;">  
	<div id="bottomNavConatainer">
	   <div id="titleContainer">
	   		<div id="publishersPicContainer" height="50" width="50" style="float: left;" ><img src="" id="publishersPic" alt="" style="padding-right:10px;"></div>
	   		<div id="currTrackTitle"></div>
	   </div>  
		   <div id="playerButtons">
		  		 <div>
				   	<button type="button" class="btn btn-danger" onClick="loadPrevVideo()" id="prevTrack" style="margin-top:1px;">
					<span class="glyphicon glyphicon-backward"></span></button> 
					<a href="http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v=<%try{out.print(youtubeLinks.get(0));} catch(Exception e2){System.out.println("error creating download link");}%>" id="downloadLink" style="text-decoration: none" target="_blank">
			    	<button type="button" class="btn btn-orange" style="margin-top:1px;">Download</button></a>
					<button type="button" class="btn btn-success" onClick="loadNextVideo()" id="nextTrack" style="margin-top:1px;">
					<span class="glyphicon glyphicon-forward"></span></button> 
					<button type="button" class="btn btn-success" onClick="trackInfo = shuffleArray(trackInfo);loadNextVideo()" id="shuffle" style="margin-top:1px;">
					<span class="glyphicon glyphicon-random"></span></button> 
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
					Vandervidi@gmail.com
			 </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<!-- Modal end -->

<!-- New feature popup -->
<div class="modal fade" id="myModal3" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">A new feature is now available!</h4>
      </div>
      <div class="modal-body">
      
			  <div style="background-color:#202020;text-align:left; padding-left:5px;padding-right:5px;">
			  Since the playlist is stored in a database, it constantly grows so i thought that a shuffle button would come in handy.
			  A shuffle button is now available in the playlist control buttons. It looks like this: 
			  <button type="button" class="btn btn-success" style="margin-top:1px;">
			  <span class="glyphicon glyphicon-random"></span></button> 
			  <br><br> What is a shuffle button?
			  <p>Shuffle randomly selects songs from the playlist to play in no particular order. 
			  It's a great way to be surprised by the next song!</p>
			  
			  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal end -->
<div id="sharePluginWrapper">
			<div id="sharePluginTitle">Share</div>
			
			<a href="http://www.facebook.com/share.php?u=http://www.nowimlisteningto.com" onClick="return fbs_click(400, 300)" target="_blank">
			<div id="shareOnFacebook"><img src="../views/images/facebook-48.png"></div></a>
			
			<a href="https://plus.google.com/share?url=http://www.nowimlisteningto.com"	onclick="javascript:window.open('https://plus.google.com/share?url=http://www.nowimlisteningto.com','','menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600'); return false;">
			<div id="shareOnGooglePlus"><img src="../views/images/googleplus-48.png"></div></a>
			
			<a href="https://twitter.com/intent/tweet?text=Now+Im+Listening+To+-+Share+your+music&url=http%3A%2F%2Fwww.nowimlisteningto.com%2Fcontroller%2Fnilt%23"  onclick="javascript:window.open('https://twitter.com/intent/tweet?text=Now+Im+Listening+To+-+Share+your+music&url=http%3A%2F%2Fwww.nowimlisteningto.com%2Fcontroller%2Fnilt%23','','menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600'); return false;">
			<div id="shareOnTwitter"><img src="../views/images/twitter-48.png"></div></a>
		</div>
		
    <!-- Bootstrap core JavaScript-->
    <script src="../views/js/bootstrap.min.js"></script>
  </body>
</html>

