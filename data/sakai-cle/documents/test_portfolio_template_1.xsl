<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
		<!ENTITY nbsp "&#160;">
		<!ENTITY apos "&#39;">
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:output method="html" />
 <xsl:output encoding="UTF-8" indent="no"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    omit-xml-declaration="no" />
 
   <xsl:param name="id" />
   <xsl:param name="sakai.tool.placement.id" />
   <xsl:param name="pid" />
   <xsl:param name="criterion1" select="'Child Development and Learning'" />
   <xsl:param name="criterion2" select="'Family / Community Relationships'" />
   <xsl:param name="criterion3" select="'Observation and Assessment'" />
   <xsl:param name="criterion4" select="'Teaching and Learning'" />
   <xsl:param name="criterion5" select="'Connecting with Children and Families'" />
   <xsl:param name="criterion6" select="'Developmentally Effective Approaches'" />
   <xsl:param name="criterion7" select="'Understanding Content Knowledge'" />
   <xsl:param name="criterion8" select="'Building Curriculum'" />
   <xsl:param name="criterion9" select="'Professionalism'" />
   
   <xsl:param name="glossary_criterion1" select="'Sed ut perspiciatis unde omnis iste natus error sit voluptatem
accusantium doloremque laudantium, totam rem aperiam, eaque ipsa ab
illo inventore veritatis et quasi architecto beatae vitae dicta sunt
explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut
odit aut fugit, sed quia consequuntur magni dolores eos qui ratione
voluptatem sequi nesciunt.  Neque porro quisquam est qui do lorem
ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia
nonnumquam eiusmodi tempora incidunt ut labore et dolore magnam
aliquam quaerat voluptatem.
'" />
   <xsl:param name="glossary_criterion2" select="'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut
odit aut fugit, sed quia consequuntur magni dolores eos qui ratione
voluptatem sequi nesciunt.  Neque porro quisquam est qui do lorem
ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia
nonnumquam eiusmodi tempora incidunt ut labore et dolore magnam
aliquam quaerat voluptatem'" />
   <xsl:param name="glossary_criterion3" select="'Observation and Assessment'" />
   <xsl:param name="glossary_criterion4" select="'Teaching and Learning'" />
   <xsl:param name="glossary_criterion5" select="'Connecting with Children and Families'" />
   <xsl:param name="glossary_criterion6" select="'Developmentally Effective Approaches'" />
   <xsl:param name="glossary_criterion7" select="'Understanding Content Knowledge'" />
   <xsl:param name="glossary_criterion8" select="'Building Curriculum'" />
   <xsl:param name="glossary_criterion9" select="'Professionalism'" />    
  
   <xsl:param name="level1" select="'Program Evidence'" />
   <xsl:param name="level2" select="'Individual Evidence'" />
   <xsl:param name="level3" select="'Reflection'" />
 
   <xsl:param name="glossary_level1" select="'Program Evidence'" />
   <xsl:param name="glossary_level2" select="'Individual Evidence'" />
   <xsl:param name="glossary_level3" select="'Reflection'" />
   
 <!-- <xsl:param name="assignmentId" select="'b9f5f2a0-ae32-4fd9-000a-2d9b0e814709'" />
   <xsl:param name="assignment" select="'assignment1'" />
    <xsl:param name="criterion" select="'Communicate effectively through speaking and writing'" />
   <xsl:param name="level" select="'Entry 1'" />
   <xsl:param name="assignmentTitle" select="'Assignment 001'" />-->
   
    <xsl:param name="assignmentId" select="'3333'" />
   <xsl:param name="assignment" select="'4444'" />
   
  <xsl:param name="criterion" select="'0000'" />
   <xsl:param name="level" select="'1111'" />
	<xsl:param name="assignmentTitle" select="'9999'" />
   
   
   <xsl:param name="datesubmit" select="'5555'" />
   <xsl:param name="datereturn" select="'7777'" />
   
   
 
   
  
   
   
    <xsl:param name="reflection" select="'notdisplay'" />
    
   
   

  <xsl:key name="criterionkey"  match="//scaffoldingCell"  use="rootCriterion/description" />
  <xsl:key name="levelkey"  match="//scaffoldingCell"  use="level/description" />
   
   
   
<xsl:template name="test" match="ospiPresentation">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Owens CC Portfolio</title>

<meta http-equiv="expires" content="0"></meta>
<meta http-equiv="Pragma" content="no-cache"></meta>
<meta http-equiv="Cache-Control" content="no-cache"></meta>







<script type="text/javascript">
<![CDATA[


var mousex = 0;
var mousey = 0;

function init()
{
  document.onmousemove = update; // update(event) implied on NS, update(null) implied on IE
  update();
}

function getMouseXY(e) // works on IE6,FF,Moz,Opera7
{ 
  if (!e) e = window.event; // works on IE, but not NS (we rely on NS passing us the event)

  if (e)
  { 
    if (e.pageX || e.pageY)
    { // this doesn't work on IE6!! (works on FF,Moz,Opera7)
      mousex = e.pageX;
      mousey = e.pageY;
          }
    else if (e.clientX || e.clientY)
    { // works on IE6,FF,Moz,Opera7
      mousex = e.clientX + document.body.scrollLeft;
      mousey = e.clientY + document.body.scrollTop;
    }  
  }
}

function update(e){
  getMouseXY(e); // NS is passing (event), while IE is passing (null)
   }


function show(object) {
  if (document.getElementById) {
    document.getElementById(object).style.visibility = 'visible';
    document.getElementById(object).style.top = mousey;
    document.getElementById(object).style.left = mousex;

  }
  else if (document.layers && document.layers[object]) {
    document.layers[object].visibility = 'visible';
  }
  else if (document.all) {
    document.all[object].style.visibility = 'visible';
  }
}




function hide(object) {
  if (document.getElementById) {
    document.getElementById(object).style.visibility = 'hidden';
  }
  else if (document.layers && document.layers[object]) {
    document.layers[object].visibility = 'hidden';
  }
  else if (document.all) {
    document.all[object].style.visibility = 'hidden';
  }
}


]]>
</script>



<style type="text/css">

body{

}

.absolute  {
	position: absolute;
	visibility: hidden;
	border: 2px solid Purple;
	background-color: #D8BFD8;
	padding: 15px;
	margin: 15px;
}




h2 {
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	font-size: 0.9em;
	font-weight: bold;
	color: #666666;
}



h3 {
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	font-size: 0.7em;
	font-weight: bold;
	color: #666666;
}

hr {
	color: #666666;
} 

div.contents {
        display: none;
 }
 
 div.selectedcontents {
        display: block;
 }
 
.contentsTable {
	width: 100%;
	border:1px solid #AAAAAA;
}

.contentsTable2 {
	width: 100%;
	border:1px solid #AAAAAA;
}


.MainContent {
	width: 100%;
	border:2px solid #AAAAAA;
}

.contentsTable3 {
	width: 50%;
}

.navTable {
	width: 100%;
	height: 45px;
	text-align: center;
	font-weight: bold;
}

.logoTable {
	background: #A50800;
	width: 100%;
	height: 45px;
	text-align: center;
	font-weight: bold;
}


.notTD {
	background: #AAAAAA;
	width: 100%;
	height: 45px;
	text-align: center;
	font-weight: bold;
}

.navTD {
	border: 1px solid White;
	background: #FFFFFF;
	color: Black;
	font-size: 1.4em;
}

.navTD a:link, .navTD a:visited, .navTD a:hover{
	color: White;
	text-decoration: underline;
	font-size: 1.0em;
}

.headerTD {
	background: #021a92;
	color: #FFFFFF;
}

.headerTD a:link {
	color: #FF9999;
	font-size: 1.0em;
	background: #336666;
}

.headerTD a:visited {
	color: #FF9999;
	font-size: 1.0em;
	background: #336666;
}


.expectationTD {
	background: #336699;
	color: #FFFFFF;
}

.expectationTD a:link {
	color: #FF9999;
	font-size: 1.0em;
	background: #336699;
}

.expectationTD a:visited {
	color: #FF9999;
	font-size: 1.0em;
	background: #336699;
}




.evidenceTD {
	background: #339999;
	color: #FFFFFF;
}

.evidenceTD a:link {
	color: #FF5555;
	font-size: 1.0em;
	background: #339999;
}

.evidenceTD a:visited {
	color: #FF5555;
	font-size: 1.0em;
	background: #339999;
}



.connectTD {
	background: #669999;
	color: #FFFFFF;
}

.connectTD a:link {
	color: #FF5555;
	font-size: 1.0em;
	background: #669999;
	background-color: transparent;
}

.connectTD a:visited {
	color: #FF5555;
	font-size: 1.0em;
	background: #669999;
	background-color: transparent;
}

.cpaDescTD1 {
	background: #DDDDDD;
	color: #777777;
	width: 30%;
	font-size: .7em;
}

.allTD {
	background: #669999;
	color: #FFFFFF;
	width: 30%;
}

.allTD a:link {
	color: #FF5555;
	font-size: 1.0em;
	background: #669999;
	background-color: transparent;
}

.allTD a:visited {
	color: #FF5555;
	font-size: 1.0em;
	background: #669999;
	background-color: transparent;
}


.cpaDescTD2 {
	background: #DDDDDD;
	color: #777777;
	width: 70%;
	font-size: .7em;
}


.allTDtext {
	background: #6D9A50;
	color: #000000;
	width: 70%;
}

.allTDtext a:link {
	color: #FF5555;
	font-size: 1.0em;
	background: #669999;
	background-color: transparent;
}

.allTDtext a:visited {
	color: #FF5555;
	font-size: 1.0em;
	background: #669999;
	background-color: transparent;
}

.cpaDesc {
	background: #EEEEEE;
	color: #777777;
	font-size: .7em;
}


.intelectTD {
	background: #336600;
	color: #FFFF00;
}

.intelectTD a:link {
	color: #FF9999;
	font-size: 1.0em;
	background: #1144AA;
}

.intelectTD a:visited {
	color: #FF9999;
	font-size: 1.0em;
	background: #1144AA;
}




.generalpageTD {
	border:1px solid #AAAAAA;
	background: #669999;
	text-align: center;
	font-weight: bold;
	color: #FFFFFF;
	font-size: 1.2em;
	text-decoration: none;
	height: 50px;
}

.generalpageTD a:link {
	color: #FFFFFF;
	text-decoration: none;
}

.generalpageTD a:visited {
	color: #FFFFFF;
	text-decoration: none;
}



.generalpageTD1 {
	border:1px solid #AAAAAA;
	background: #94B8B8;
	text-align: center;
	font-weight: bold;
	color: #FFFFFF;
	font-size: 1.2em;
	text-decoration: none;
	height: 50px;
}

.generalpageTD1 a:link {
	color: #FFFFFF;
	text-decoration: none;
}

.generalpageTD1 a:visited {
	color: #FFFFFF;
	text-decoration: none;
}






a.attach:link {
	background-color: transparent;
	color: #ffffff;
	text-decoration: none;
}

a.attach:visited {
	background-color: transparent;
	color: #ffffff;
	text-decoration: none;
}

a.attach:hover {
	background-color: transparent;
	color: #ffff00;
	text-decoration: none;
}



.notCompleteTD {
	background: #C2D6D6;
	text-align: center;
	color: #FFFFFF;
	font-size: 1.2em;
}
.completeTD {
	border:1px solid #AAAAAA;
	background: #669999;
	text-align: center;
	color: #FFFFCC;
	font-size: 1.2em;
}

.completeTD a:link {
	
	color: #ffffff;
	text-decoration: none;
}

.completeTD a:hover {
	color: #ffffff;
	text-decoration: underline;
}

.completeTD a:visited {
	color: #ffffff;
}


.complete{
	background: #669999;
	text-align: left;
	color: #000000;
	font-size: 1.0em;
	border:1px solid #AAAAAA;
}

.submited {
	background: #BBAAAA;
	text-align: left;
	color: #000000;
	font-size: 1.0em;
	border:1px solid #AAAAAA;
}


.notstart {
	background: #C2D6D6;
	text-align: left;
	color: #000000;
	font-size: 1.0em;
	border:1px solid #AAAAAA;
}


.submitedTD {
	border:1px solid #AAAAAA;
	background: #BBAAAA;
	text-align: center;
	color: #FFFFFF;
	font-size: 1.2em;
}

.submitedTD a:link {
	
	color: #FFFFFF;
	text-decoration: none;
}

.submitedTD a:hover {
	color: #FFFFFF;
	text-decoration: underline;
}

.submitedTD a:visited {
	color: #FFFFFF;
}







.pendingTD {
	background: #6D9A50;
	text-align: center;
	color: #000000;
	font-size: 1.2em;
}

.pendingTD a:link {
	color: #000000;
	text-decoration: none;
}

.pendingTD a:hover {
	color: #000000;
	text-decoration: underline;
}

.pendingTD a:visited {
	color: #000000;
}


.goal1TD {
	background: #A95100;
}

.goal2TD {
	background: #82B940;
}

.goal3TD {
	background: #82B940;	
}

.goal4TD {
	background: #545E8C;
}

.goal5TD {
	background: #000000;
	
}



.goal5TD, .goal5TD a:visited, .goal5TD a:link, .goal5TD a:hover {

	color: #FFFFFF;
	
	text-decoration: none;
}

.goal5TD a:hover {

	text-decoration: none;
}


.goal6TD {
	background: #A50800;
}

.goal1TD, .goal2TD, .goal3TD, .goal4TD, .goal5TD, .goal6TD {
	border: 1px solid White;
	font-size: 1.2em;
	color: White;
	text-align: center;
	font-weight: bold;
}


.selectedgoalTD {
/*	background: #778899; */
	font-size: 0.8em;
	text-align: center;
	vertical-align: top;
	width: 20%;
	color: #666666;
}

.goalTD, .goalTD a:visited, .goalTD a:link, .goalTD a:hover {
/*	background: #778899; */
	color: #666666;
	font-size: 0.9em;
}

.goalTD {
	vertical-align: top;
	text-align: center;
	width: 20%;
}

.criterion1, .criterion2, .criterion3, .criterion4, .criterion5, .criterion6 {
	text-align: center;
	width: 27%;
	border: 1px solid White;
	font-weight: normal;
	font-size: 0.8em;
	color: White;
}

.criterion1 a:link, .criterion2 a:link, .criterion3 a:link, .criterion4 a:link, .criterion5 a:link, .criterion6 a:link {
	font-weight: bold;
	color: White;
}

.criterion1 a:visited, .criterion2 a:visited, .criterion3 a:visited, .criterion4 a:visited, .criterion5 a:visited, .criterion6 a:visited {
	font-weight: bold;
	color: White;
}

.criterion1 {
	background: #A95100;
}

.criterion2 {
	background: #82B940;
}

.criterion3 {
	background: #82B940;
}

.criterion4 {
	background: #545E8C;	
}

.criterion5 {
	background: #99851A;
}

.criterion6 {
	background: #7C2854;
}

 td#contentscell {
	/*background: #778899;
	color: White;
	*/
	background: White;
	color: Black;
	padding: 5px;
	font-size: 0.8em;
	font-weight: normal;
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	font-variant : normal;
	font-style : normal;
	text-align: center;
}


.image {
	border : 0px solid #000000;
}

.imageTD {
	text-align: center;
}

td#mainTitle {
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	font-size: 1.8em;
	color : #000000;
	font-weight: bold;
	text-align: center;
	width: 60%;
	border: 2px solid #AAAAAA;
}

td#subTitle {
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	font-size: 0.9em;
	color : #000000;
	text-align: center;
	border: 2px solid #AAAAAA;
}


td#subTitle a:link{
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	color : #999999;
}

td#subTitle a:visited{
	color : #999999;
}

td#subTitle a:hover{
	color : #555555;
}


td#studName {
	background-color: #F7C602;
	font-size: 1.8em;
	color : #000000;
	font-weight: bold;
	text-align: center;
	width: 50%;
	border-bottom: 2px solid #FFFFFF;
}



td#schoolName {
	background-color: #F7C602;
	font-size: 1.2em;
	color : #000000;
	text-align: center;
	border-bottom: 2px solid #FFFFFF;
}


td#legend {
	font-size: 1.0em;
	color : #000000;
	text-align: left;
	border:1px solid #AAAAAA;
}

.nameCOP {
	font-size: 1.4em;
	color : #7777BB;
	font-weight: bold;
	text-align: center;
	width: 60%;
}

.contactInfoLabel {
	font-size: 0.7em;
	color : Silver;
	white-space: nowrap;
	font-weight : normal;
	font-style : italic;
}

.contactInfoData {
	font-size: 0.7em;
	color: White;
}

.contactInfo {
	font-size: 0.8em;
	color : #336600;
	text-align: center;	
}

.contactInfo a:link{
	color : #336600;
}

.contactInfo a:visited{
	color : #336600;
}

.photoCaption {
	font-size: 0.8em;
	color: #666699;
	font-weight: bold;
	vertical-align: top;
	text-align: center;
}

.reflectionTable {
	width: 90%;
}

.reflectionTD {
	font-size: 0.8em;
	width: 60%;
	text-align: left;
}

.reflectionLabel {
	font-weight: bold !important;
	font-size: 1.1em !important;
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	
}


.contentText{
	text-align: justify;
}

.reflectionText{
	font-weight: normal;
	font-size: 1.1em;
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	
}

.reflectionText a:link{
	color: #DDDDDD;
	background: transparent;
}

.reflectionText a:visited {
	color: #DDDDDD;
	background: transparent;
}

#textbox1{
text-align: center;
font-size: 1.1em;
font-weight: bold;
color : #7777BB;
font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
background: #FFFFFF;
padding: 2.0em;
border: 2px solid #AAAAAA;

}



.examples {
	text-align: left;
	font-size: 0.9em;
	font-weight: bold;
}

.moreInfo, .moreInfo a:link, .moreInfo a:visited {
	color: Black;
	text-align: center;
}

.moreInfo {
	font-size: 0.8em;
}

div.ospComments {
	background-color: #FFFFFF;
	margin: 15px;
	padding: 10px;
	vertical-align: top;
	border-top: 1px dashed #CC9900;
	border-bottom: 1px dashed #CC9900;
	border-right: 1px dashed #CC9900;
	border-left: 1px dashed #CC9900;
}

.ospComments h1 {}
.ospComments h2 {
	font-size: 1.1em;
	font-weight: bold;
	color : #336699;
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	font-variant : normal;
	font-style : normal;
	width: 100%;
	vertical-align : bottom;
	text-decoration : none;
	}
.ospComments h3 {
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	font-size:0.8em;
	font-weight: bold;
	color: Red;
}
.ospComments h4 {text-indent: 20px;color: #336699;}
.ospComments h4 a:link, a:visited   {color:#51698D; text-decoration: underline;}
.ospComments h4 a:hover   {color:#3A476B; text-decoration: underline;}
.ospComments h5 {}
.ospComments p {
margin-left: 30px;
font-size: 0.8em;
font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
color : #336699;
vertical-align : top;
}

.ospComments .pipe {color:#51698D;};
.ospComments table tr td {
	background-color: #FFFFFF;
	margin: 0px;
	padding: 0px;
	vertical-align: top;		
}

.ospComments fieldset {
	background-color: #DDDDFF;
	font-weight: bold;
	font-size: 0.8em;
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	color : #336699;
	margin: 0px;
	padding: 0px;
	vertical-align: top;		
}

.ospComments textarea {
	background-color: #DDDDFF;
	font-size: 0.8em;
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	color : #336699;
	margin: 0px;
	padding: 0px;
	vertical-align: top;		
}

.ospComments input {
	background-color: #DDDDFF;
	font-size: 0.8em;
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	color : #336699;
	margin: 0px;
	padding: 0px;
	vertical-align: top;		
}

.imageTD1 {
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	font-size: 0.9em;
	text-align: center;
	border: 1px solid #AAAAAA;
}

.imageTD1 a:link{
	font-family :  Arial, Tahoma, Verdana, Geneva, Helvetica, sans-serif;
	color : #999999;
}

.imageTD1 a:visited{
	color : #999999;
}

.imageTD1 a:hover{
	color : #555555;
}


.mmm {

	text-align: center;
	border: 1px solid #AAAAAA;
}

</style>






</head>

<body onload="init();">

<xsl:if test="presentationFiles/CascadingStyleSheet">
	<link type="text/css" rel="stylesheet">
	<xsl:attribute name="href">
		<xsl:value-of select="presentationFiles/CascadingStyleSheet/artifact/fileArtifact/uri"/>
	</xsl:attribute>
	</link>
</xsl:if>

<xsl:if test="presentationFiles/JavascriptFile">
	<script type="text/javascript">
		<xsl:attribute name="src">
			<xsl:value-of select="presentationFiles/JavascriptFile/artifact/fileArtifact/uri"/>
		</xsl:attribute>
	// Content switching functions by Jack Letourneau, February 2002
	// www.eigengrau.com
	</script>
</xsl:if>




<table width="100%" border="0" cellpadding="5" cellspacing="0" class="logoTable">

	<tr>
	<td align="center">	
		<xsl:if test="presentationFiles/SupportImages">
				<img border="0" class="image">
						<xsl:attribute name="src"><xsl:value-of select="presentationFiles/SupportImages/artifact/fileArtifact/uri"/></xsl:attribute>
				</img>	
		</xsl:if>	
	</td>
	</tr>
		
	
</table>






<table border="1">
	
		<tr>
		
		<!--************************************************************************** Left table start********************************************************************-->
			<td width="20%">
			 <table border="0" width="100%">
			 
			    <tr>
				<xsl:if test="presentationFiles/SupportImages2">
                 <td class="imageTD1">
					<img border="0" class="image">
						<xsl:attribute name="src"><xsl:value-of select="presentationFiles/SupportImages2/artifact/fileArtifact/uri"/></xsl:attribute>
				</img>	
				</td>
				</xsl:if>
				</tr>
				
			    <tr>
                <td>&nbsp;</td>
                </tr>      
				
				<tr>			
                <td id="subTitle">
				<xsl:choose>
							<xsl:when test="//contactInformation">
								<xsl:if test="//firstName">
									<xsl:value-of select="//firstName"/>&nbsp;
								</xsl:if>
								<xsl:if test="//middleName">
									<xsl:value-of select="//middleName"/>&nbsp;
								</xsl:if>
								<xsl:if test="//lastName">
									<xsl:value-of select="//lastName"/>
								</xsl:if>
								<xsl:if test="//addressOne">
									<br /><xsl:value-of select="//addressOne"/>
								</xsl:if>
								<xsl:if test="//addressTwo">
									<br /><xsl:value-of select="//addressTwo"/>
								</xsl:if>
								<xsl:if test="//addressCity">
									<br /><xsl:value-of select="//addressCity"/>&nbsp;
								</xsl:if>
								<xsl:if test="//addressState">
									<xsl:value-of select="//addressState"/>&nbsp;
								</xsl:if>
								<xsl:if test="//addressZip">
									<xsl:value-of select="//addressZip"/>
								</xsl:if>
								<xsl:if test="//addressCountry">
                  					<br /><xsl:value-of select="//addressCountry"/>
								</xsl:if>
								<br />
								<xsl:for-each select="//emails">
									<xsl:value-of select="emailType" />:&nbsp;<a><xsl:attribute name="href">mailto:<xsl:value-of select = "emailAddress" /></xsl:attribute><xsl:value-of select = "emailAddress" /></a><br />
								</xsl:for-each>
								<xsl:for-each select="//phoneNumbers">
				                  <xsl:value-of select="phoneType"/>:&nbsp;<xsl:value-of select="phoneNumber"/><br />
								</xsl:for-each>

							</xsl:when>
							<xsl:otherwise>
								<xsl:text>No contact info provided!</xsl:text>
							</xsl:otherwise>
							</xsl:choose>
				</td>
         </tr>
         
		 <tr>
         <td>&nbsp;</td>
         </tr>           
         
         
         <tr>
				
				<xsl:if test="presentationFiles/LogoImage">
			    <td rowspan="2" class="imageTD1">
					<img border="0" class="image">
						<xsl:attribute name="src"><xsl:value-of select="presentationFiles/LogoImage/artifact/fileArtifact/uri"/></xsl:attribute>
				</img>	
				<br/>
				
		<a target="_blank">
		<xsl:attribute name="href">
		<xsl:text>https://www.owens.edu/academic_dept/arts_sciences/programs.html</xsl:text>
		</xsl:attribute>Department of Teacher Education Associate of Arts Early  Childhood Education Degree Requirements
		</a>				
			<br/><br/>

				
		<xsl:if test="//resumeURL">		
						<a target="_blank"><xsl:attribute name="href"><xsl:value-of select="resumeURL/artifact/structuredData/resumeURL/linkURL"/></xsl:attribute>My Resume</a>	<br/><br/>
		   		
		</xsl:if>	
				
				 </td>	
				</xsl:if>	
				</tr>
      </table>
			
			
			</td>
		<!--************************************************************************** Left table end********************************************************************-->	
			<td width="80%">
			
			


<table width="100%" id="MainContent">


<tr>
	<td id="contentscell">
	<div class="selectedcontents" id="contents1">
	

 
         
  
    
    
    
    
    
        
    
    
    
    
    
   
    
          <br/><br/>     
         
    <!--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->     
         
         
     
		 <table width="100%" border="0" cellpadding="5" cellspacing="3" class="contentsTable2">
		 
				<tr>
                <td width="50%" class="goal5TD">Competency Standards<br /></td>
                
                <td width="16%" class="goal5TD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_level1"/></xsl:attribute><xsl:value-of select="$level1"/></a><br /></td>
                <td width="16%" class="goal5TD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_level2"/></xsl:attribute><xsl:value-of select="$level2"/></a><br /></td>
                <td width="17%" class="goal5TD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_level3"/></xsl:attribute><xsl:value-of select="$level3"/></a><br /></td>
                
				</tr>
				
				
				
	<!--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->     			
                <tr>
                
         
           
    
  
     <td  class="generalpageTD"><a  href="#" onMouseover="show('myDiv')" onMouseout="show('myDiv')"><xsl:value-of select="$criterion1"/></a><br /></td>
              
                <div id="myDiv" class="absolute" style="width:400px;">
				<p><xsl:value-of select="$glossary_criterion1"/></p>
				</div>

                
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion1"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level1"/></xsl:with-param>
				<xsl:with-param name="formId">00001</xsl:with-param>
				<xsl:with-param name="fileId">fileId01</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion1"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level2"/></xsl:with-param>
				<xsl:with-param name="formId">00002</xsl:with-param>
				<xsl:with-param name="fileId">fileId02</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="viewpage">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion1"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level3"/></xsl:with-param>
				</xsl:call-template>					

	
				</tr>
	
	
	<!--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->     			
                 <tr>
                
      <td  class="generalpageTD"><a  href="#" onMouseover="show('myDiv2')" onMouseout="hide('myDiv2')"><xsl:value-of select="$criterion2"/></a><br /></td>
              
                <div id="myDiv2" class="absolute" style="width:400px;">
				<p><xsl:value-of select="$glossary_criterion2"/></p>
				</div>
                
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion2"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level1"/></xsl:with-param>
				<xsl:with-param name="formId">00003</xsl:with-param>
				<xsl:with-param name="fileId">fileId03</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion2"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level2"/></xsl:with-param>
				<xsl:with-param name="formId">00004</xsl:with-param>
				<xsl:with-param name="fileId">fileId04</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="viewpage">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion2"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level3"/></xsl:with-param>
				</xsl:call-template>					

	
				</tr>
	
	
	<!--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->			
				
				 <tr>
                
                <td  class="generalpageTD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_criterion3"/></xsl:attribute><xsl:value-of select="$criterion3"/></a><br /></td>
                
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion3"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level1"/></xsl:with-param>
				<xsl:with-param name="formId">00005</xsl:with-param>
				<xsl:with-param name="fileId">fileId05</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion3"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level2"/></xsl:with-param>
				<xsl:with-param name="formId">00006</xsl:with-param>
				<xsl:with-param name="fileId">fileId06</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="viewpage">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion3"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level3"/></xsl:with-param>
				</xsl:call-template>					

	
				</tr>
	
	<!--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->			
	
	
				<tr>
                
                <td  class="generalpageTD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_criterion4"/></xsl:attribute><xsl:value-of select="$criterion4"/></a><br /></td>
                
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion4"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level1"/></xsl:with-param>
				<xsl:with-param name="formId">00007</xsl:with-param>
				<xsl:with-param name="fileId">fileId07</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion4"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level2"/></xsl:with-param>
				<xsl:with-param name="formId">00008</xsl:with-param>
				<xsl:with-param name="fileId">fileId08</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="viewpage">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion4"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level3"/></xsl:with-param>
				</xsl:call-template>					

	
				</tr>
	
	<!--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->			
	
			    <tr>
                
                <td  class="generalpageTD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_criterion5"/></xsl:attribute><xsl:value-of select="$criterion5"/></a><br /></td>
                
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion5"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level1"/></xsl:with-param>
				<xsl:with-param name="formId">00009</xsl:with-param>
				<xsl:with-param name="fileId">fileId09</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion5"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level2"/></xsl:with-param>
				<xsl:with-param name="formId">00010</xsl:with-param>
				<xsl:with-param name="fileId">fileId10</xsl:with-param>
				</xsl:call-template>	
				
				<td  class="notTD">&nbsp;</td>				

	
				</tr>
	
	
	<!--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->			
	
				<tr>
                
               <td  class="generalpageTD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_criterion6"/></xsl:attribute><xsl:value-of select="$criterion6"/></a><br /></td>
                
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion6"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level1"/></xsl:with-param>
				<xsl:with-param name="formId">00011</xsl:with-param>
				<xsl:with-param name="fileId">fileId11</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion6"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level2"/></xsl:with-param>
				<xsl:with-param name="formId">00012</xsl:with-param>
				<xsl:with-param name="fileId">fileId12</xsl:with-param>
				</xsl:call-template>	
				
				<td  class="notTD">&nbsp;</td>
	
				</tr>
	
	<!--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->			
	
				 <tr>
                
                <td  class="generalpageTD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_criterion7"/></xsl:attribute><xsl:value-of select="$criterion7"/></a><br /></td>
                
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion7"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level1"/></xsl:with-param>
				<xsl:with-param name="formId">00013</xsl:with-param>
				<xsl:with-param name="fileId">fileId13</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion7"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level2"/></xsl:with-param>
				<xsl:with-param name="formId">00014</xsl:with-param>
				<xsl:with-param name="fileId">fileId14</xsl:with-param>
				</xsl:call-template>	
				
				<td  class="notTD">&nbsp;</td>					

				</tr>
	
	
	<!--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->			
	
	
			    <tr>
                
                <td  class="generalpageTD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_criterion8"/></xsl:attribute><xsl:value-of select="$criterion8"/></a><br /></td>
                
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion8"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level1"/></xsl:with-param>
				<xsl:with-param name="formId">00015</xsl:with-param>
				<xsl:with-param name="fileId">fileId15</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion8"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level2"/></xsl:with-param>
				<xsl:with-param name="formId">00016</xsl:with-param>
				<xsl:with-param name="fileId">fileId16</xsl:with-param>
				</xsl:call-template>	
				
				<td  class="notTD">&nbsp;</td>					

				</tr>
	
	
	
	<!--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->			
	
	
			    <tr>
                
                <td  class="generalpageTD"><a  href="#"><xsl:attribute name="title"><xsl:value-of select="$glossary_criterion9"/></xsl:attribute><xsl:value-of select="$criterion9"/></a><br /></td>
                
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion9"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level1"/></xsl:with-param>
				<xsl:with-param name="formId">00017</xsl:with-param>
				<xsl:with-param name="fileId">fileId17</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="inartifact">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion9"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level2"/></xsl:with-param>
				<xsl:with-param name="formId">00018</xsl:with-param>
				<xsl:with-param name="fileId">fileId18</xsl:with-param>
				</xsl:call-template>	
				
				<xsl:call-template name="viewpage">
				<xsl:with-param name="crit"><xsl:value-of select="$criterion9"/></xsl:with-param>
				<xsl:with-param name="lev"><xsl:value-of select="$level3"/></xsl:with-param>
				</xsl:call-template>					

	
				</tr>
	
	
	<!--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->			
	
	<!--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////-->			
	
			
   
		</table>
     
	  <br/>
	  
 <table class="mmm" cellspacing="0" align="left" width="40%">
         <tr>			
               <td width="20px" class="notstart">&nbsp;</td>  <td id="legend">Not Started</td><td width="20px" class="submited">&nbsp;</td>  <td id="legend">Started</td>	<td width="20px" class="complete">&nbsp;</td>  <td id="legend">Completed</td>		
						
		</tr>	
</table>  

	  
	</div><!-- End of Home Page -->
	




	
	
	
	<!-- Participating in Inter-Health Professional Teams page#######################################################################-->
<div class="contents" id="contents31">


		<table border="0" cellpadding="5" cellspacing="0" class="navTable">
              <tr>
                <td class="goal5TD"><xsl:value-of select="$criterion"/></td>
              </tr>
              <tr>
                 <td id="subTitle"><a href="javascript:switchOn('contents1');">Home</a></td>
              </tr>
        </table>
	    <br/>


   
   
   

   <table border="0" cellpadding="5" cellspacing="5" class="contentsTable2">					  				
				<tr> 
				 <td class="goal5TD">
						<span class="reflectionLabel">Reflection:</span>	
						<br />
				</td>
			   </tr>
			   
			   
			   
<xsl:for-each select="//cell">
			<xsl:if test="scaffoldingCell/rootCriterion/description = $criterion">
				<xsl:if test="scaffoldingCell/level/description = $level">
				
				
				
						  <tr>
							
							<td class="contentText">
							
							<xsl:if test="wizardPage/reflections/reflection/artifact/structuredData/reflection/reflect"><span class="reflectionText"><xsl:value-of select="wizardPage/reflections/reflection/artifact/structuredData/reflection/reflect" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							
							
							</td>
						  </tr>
						
				
		
			
		<xsl:if test="wizardPage/attachments[normalize-space(.) != '']">
						
				  	    <table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  	   <div class="navTD"><hr />Supporting Materials</div>
							<tr>
						
							<td class="contentText">
								<form name="frmSupport1" id="frmSupport1" target="ospiMaterial">
							<xsl:attribute name="action">
								<xsl:choose>
									<xsl:when test="wizardPage/attachments/attachment/artifact/fileArtifact">
										<xsl:value-of select="wizardPage/attachments/attachment/artifact/fileArtifact/uri"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="wizardPage/attachments/attachment/artifact/structuredData/url/linkURL"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
								<select id="fileSel" size="1" onChange="javascript:document.getElementById('frmSupport1').action=this.options[this.selectedIndex].value;">
								<xsl:for-each select="wizardPage/attachments/attachment">
									<xsl:if test="artifact/fileArtifact">
										<option>
										<xsl:attribute name="value"><xsl:value-of select="artifact/fileArtifact/uri"/></xsl:attribute>
										<xsl:value-of select="artifact/metaData/displayName"/>
										</option>
									</xsl:if>
								</xsl:for-each>
								<xsl:if test="wizardPage/attachments/attachment/artifact/structuredData/url">
									<xsl:for-each select="wizardPage/attachments/attachment/artifact/structuredData/url">
										<option>
										<xsl:attribute name="value"><xsl:value-of select="linkURL"/></xsl:attribute>
										<xsl:value-of select="nameURL"/>
										</option>
									</xsl:for-each>
								</xsl:if>
								</select>
								<input type="submit" value="View"/>
								</form>
							</td>
					    </tr>
					  </table>

					</xsl:if>
									
			
			</xsl:if>
			</xsl:if>
			</xsl:for-each>									   
			   
	 <tr><td><hr /></td></tr>  		   
			   
          </table>   
  
  
          
         <br/>   

           
        
	    <br/>
	  
	</div><!-- End of  page -->	
	
	
	
	
	
	
	
	
	
	
	
















</td>
</tr>

</table>
			
			</td>
		</tr>
	
</table>



	<table border="0" cellpadding="5" cellspacing="0" class="contentsTable2">
             
             
			  <tr>
                <td colspan="4" class="goal6TD">&nbsp;</td>
              </tr>              
            <tr><td><br /><br /><br /><br /><hr /></td></tr>  
        </table>	  
	
	<br/><br/>      
         
  
</body>
</html>













<script type="text/javascript">
		<xsl:text>javascript:switchOn(</xsl:text>
		
		<xsl:choose>
								<xsl:when test="$reflection='display'">
									<xsl:text>'contents41'</xsl:text>
								</xsl:when>
									<xsl:otherwise>
											<xsl:choose>
											<xsl:when test="$criterion='0000'">
											<xsl:text>'contents1'</xsl:text>
											</xsl:when>
											<xsl:otherwise>
											<xsl:text>'contents31'</xsl:text>
											</xsl:otherwise>
											</xsl:choose>
								</xsl:otherwise>
		</xsl:choose>
					
		<xsl:text>);</xsl:text>
</script>
</xsl:template>
	
	
 
 
 
 
 
 
 <xsl:template name="inartifact" >
   <xsl:param name="lev"/>
   <xsl:param name="crit"/>
   <xsl:param name="formId"/>
   <xsl:param name="fileId"/>
   
 
   <xsl:for-each select="//cell">
			<xsl:if test="scaffoldingCell/rootCriterion/description = $crit">
				<xsl:if test="scaffoldingCell/level/description = $lev">
		<xsl:choose>
					
		<xsl:when test="wizardPage/attachments[normalize-space(.) != ''] or wizardPage/status='PENDING' or wizardPage/status='COMPLETE'">	
			<td class="submitedTD">
								<form target="ospiMaterial">
								<xsl:attribute name="name">
								<xsl:value-of select="$formId"/>
								</xsl:attribute>
								<xsl:attribute name="id">
								<xsl:value-of select="$formId"/>
								</xsl:attribute>
							<xsl:attribute name="action">
								<xsl:choose>
									<xsl:when test="wizardPage/attachments/attachment/artifact/fileArtifact">
										<xsl:value-of select="wizardPage/attachments/attachment/artifact/fileArtifact/uri"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="wizardPage/attachments/attachment/artifact/structuredData/url/linkURL"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
								<select size="1">
								<xsl:attribute name="id">
								<xsl:value-of select="$fileId"/>
								</xsl:attribute>
										<xsl:attribute name="onChange">
											<xsl:text>javascript:document.getElementById('</xsl:text><xsl:value-of select="$formId"/><xsl:text>').action=this.options[this.selectedIndex].value;</xsl:text>
										</xsl:attribute>
								<xsl:for-each select="wizardPage/attachments/attachment">
									<xsl:if test="artifact/fileArtifact">
										<option>
										<xsl:attribute name="value"><xsl:value-of select="artifact/fileArtifact/uri"/></xsl:attribute>
										<xsl:value-of select="artifact/metaData/displayName"/>
										</option>
									</xsl:if>
								</xsl:for-each>
								<xsl:if test="wizardPage/attachments/attachment/artifact/structuredData/url">
									<xsl:for-each select="wizardPage/attachments/attachment/artifact/structuredData/url">
										<option>
										<xsl:attribute name="value"><xsl:value-of select="linkURL"/></xsl:attribute>
										<xsl:value-of select="nameURL"/>
										</option>
									</xsl:for-each>
								</xsl:if>
								</select>
								<input type="submit" value="View"/>
								</form>
							</td>
		</xsl:when>							
		
		<xsl:otherwise>
		<td  class="notCompleteTD">&nbsp;</td>
		</xsl:otherwise>
		</xsl:choose>
									
			
			</xsl:if>
			</xsl:if>
			</xsl:for-each>						
  </xsl:template>				
	














 <xsl:template name="viewpage" >
   <xsl:param name="lev"/>
   <xsl:param name="crit"/>
 
   <xsl:for-each select="//cell">
			<xsl:if test="scaffoldingCell/rootCriterion/description = $crit">
				<xsl:if test="scaffoldingCell/level/description = $lev">
		<xsl:choose>
		
		<xsl:when test="wizardPage/attachments[normalize-space(.) != ''] and wizardPage/status!='COMPLETE'">		
			<td class="submitedTD">
			<a><xsl:attribute name="title"><xsl:value-of select="displayName"/></xsl:attribute><xsl:attribute name="href"><xsl:text>viewPresentation.osp?sakai.tool.placement.id=</xsl:text>            <xsl:value-of select="$sakai.tool.placement.id"/><xsl:text>&amp;id=</xsl:text><xsl:value-of select="$id"/><xsl:text>&amp;criterion=</xsl:text><xsl:value-of select="$crit"/> 
			<xsl:text>&amp;level=</xsl:text><xsl:value-of select="$lev"/></xsl:attribute>View</a></td>
		</xsl:when>
					
		<xsl:when test="wizardPage/status='PENDING'">	
			<td class="submitedTD">
			<a><xsl:attribute name="title"><xsl:value-of select="displayName"/></xsl:attribute><xsl:attribute name="href"><xsl:text>viewPresentation.osp?sakai.tool.placement.id=</xsl:text>            <xsl:value-of select="$sakai.tool.placement.id"/><xsl:text>&amp;id=</xsl:text><xsl:value-of select="$id"/><xsl:text>&amp;criterion=</xsl:text><xsl:value-of select="$crit"/> 
			<xsl:text>&amp;level=</xsl:text><xsl:value-of select="$lev"/></xsl:attribute>View</a></td>
		</xsl:when>
		
		<xsl:when test="wizardPage/status='COMPLETE'">		
			<td class="completeTD">
			<a><xsl:attribute name="title"><xsl:value-of select="displayName"/></xsl:attribute><xsl:attribute name="href"><xsl:text>viewPresentation.osp?sakai.tool.placement.id=</xsl:text>            <xsl:value-of select="$sakai.tool.placement.id"/><xsl:text>&amp;id=</xsl:text><xsl:value-of select="$id"/><xsl:text>&amp;criterion=</xsl:text><xsl:value-of select="$crit"/> 
			<xsl:text>&amp;level=</xsl:text><xsl:value-of select="$lev"/></xsl:attribute>View</a></td>
		</xsl:when>
		
		
		<xsl:otherwise>
		<td  class="notCompleteTD">&nbsp;</td>
		</xsl:otherwise>
		</xsl:choose>
									
			
			</xsl:if>
			</xsl:if>
			</xsl:for-each>						
  </xsl:template>				
	
</xsl:stylesheet>

