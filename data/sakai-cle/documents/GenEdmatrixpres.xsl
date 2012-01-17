<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
		<!ENTITY nbsp "&#160;">
		<!ENTITY apos "&#039;">
		<!ENTITY acute "&#180;">
		<!ENTITY lsquo "&#180;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" />
<xsl:output encoding="UTF-8" indent="no"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    omit-xml-declaration="no" />
	
<xsl:variable name="cr1Name" select="'Written Communication'" />
<xsl:variable name="cr2Name" select="'Critical Thinking'" />
<xsl:variable name="cr3Name" select="'Information Retrieval and Technology'" />
<xsl:variable name="cr4Name" select="'Quantitative Reasoning'" />
<xsl:variable name="cr5Name" select="'Oral Communication'" />
<xsl:variable name="cr6Name" select="'Understanding Self and Community'" />
<xsl:template match="ospiPresentation">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title><xsl:text>General Education Matrix Presentation</xsl:text></title>
	
	
	
	<style type="text/css">
	
	
	/*
	KCC light blue: #4186C5
*/

body {
	font-family : Arial, Helvetica, sans-serif;
}
table#tabmenu {
	margin-bottom: 1em;
}
td.tab, td.selectedtab, td.tabspacer, td#contentscell {
	/* border: 1px solid Gray; */
}
td.tabspacer {
	border-width: 0 0 1px;
}
td.tab, td.selectedtab {
	width: 20%;
	padding: 2px 5px;
}
td.tab {
	background: Silver;
	cursor: pointer;
}
td.selectedtab {
	border-bottom: 0;
}
td.selectedtab, td#contentscell {
	background: White;
}
td#contentscell {
	border-width: 0 1px 1px;
	padding: 5px;
}
div.contents {
	display: none;
}
div.selectedcontents {
	display: block;
}
td.introheader {
	color : #4186C5;
	font-size : 1.8em;
	font-weight : bold;
	font-family : "Times New Roman", Times, serif;
}
span#maintitle {
	font-size : 1.6em;
	font-weight : bold;
	color : #4186C5;
	font-family : "Times New Roman", Times, serif;
}
span#subtitle {
	font-size : 1.0em;
	font-weight : bold;
	color : Black;
}
div#footer {
	font-size : 0.6em;
	color : Gray;
	text-align : right;
}
td.navTD, td.navTDnoLink {
	border: 1px solid Gray;
	background : #EEEEEE;
	font-size: 0.8em;
	width: 14%;
}
td.navTDnoLink {
	color: #4186C5;
	font-weight: bold;
}
.contentImg {
	border: 1px solid Black;
}
span#contactinfo {
	color : Black;
	font-size: 0.8em;
	font-weight: normal;
}
.imgcaption {
	color : Black;
	font-size : 0.7em;
	font-weight : bold;
	text-align : center;
	width: 50%;
}
 a:visited, a:link {
	color: #4186C5;
}
a:hover {
	color: #FF6600;
}
.contentTable {
	border: 1px solid Gray;
}
.contentLabel {
	color : Black;
	font-size : 0.7em;
	font-weight: normal;
	vertical-align: top;
	border-right: 1px solid Gray;
	background : #EEEEEE;
	width: 25%;
	text-align: right;
}
.contentText {
	color : Black;
	font-size : 0.7em;
	font-weight: normal;
	vertical-align: top;
}
div.contentsubheader {
	color: #4186C5;
	font-family : "Times New Roman", Times, serif;
	font-size : 1.4em;
	font-weight: bold;
}
div.contentsubheader2 {
	color: Black;
	font-family : "Times New Roman", Times, serif;
	font-size : 1.0em;
	font-weight: bold;
}
div.ospComments {
	font-family : Verdana, Tahoma, Arial, Helvetica, sans-serif;
	font-size : 0.8em;
	background-color: #F2F2F2;
	margin: 15px;
	padding: 10px;
	vertical-align: top;
	border: 1px dashed #999999;
}
h2 {
	font-size: 1.2em;
	font-weight: bold;
	color: #666666;
}

h3 {
	font-size: 1.0em;
	font-weight: bold;
	color: #666666;
}
.chefLabel {
	font-size: 0.8em;
	font-family : Tahoma, Verdana, Geneva, Arial, Helvetica, sans-serif;
	color : Black;
	margin: 0px;
	padding: 0px;
	vertical-align: top;	
}

	
	
	</style>	
	
	
	
	
</head>
<body>
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
<div>

      <table id="tabmenu" border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td id="contentscell">
			  <!-- beginning of Intro content //-->
              <div class="contents" id="contents1">
			  	<table width="85%" border="0" cellspacing="3" cellpadding="3" align="center">
				  <tr>
					<td colspan="7" align="center" class="introheader">
					<img>
						<xsl:attribute name="src">
							<xsl:value-of select="presentationFiles/KCCbanner/artifact/fileArtifact/uri"/>
						</xsl:attribute>
					</img><br />General Education - <xsl:value-of select="presentationProperties/presentationOptions/matrixLevel"/></td>
				  </tr>
				  <tr>
					<td align="center" class="navTDnoLink">Intro</td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents3');"><xsl:copy-of select="$cr1Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents4');"><xsl:copy-of select="$cr2Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents5');"><xsl:copy-of select="$cr3Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents6');"><xsl:copy-of select="$cr4Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents7');"><xsl:copy-of select="$cr5Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents8');"><xsl:copy-of select="$cr6Name" /></a></td>
				  </tr>
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->
				  <tr>
					<td colspan="7" align="center">
					<table width="100%">
						<tr>
							<xsl:if test="//introImg">
								<td align="center" class="imgcaption" valign="top">
									<img class="contentImg">
										<xsl:attribute name="src">
											<xsl:value-of select="//introImg/artifact/fileArtifact/uri"/>
										</xsl:attribute>
									</img><br />
									<xsl:if test="//introCaption">
										<xsl:value-of select="//introCaption"/>
									</xsl:if>
								</td>
							</xsl:if>
							<td align="center">
								<span id="maintitle"><xsl:value-of select="//mainTitleText"/></span><br />
						<span id="subtitle"><xsl:value-of select="//subTitleText"/></span><br /><br />
						<span id="contactinfo">
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
							
						</span>
							</td>
						</tr>
						<td></td>
					</table>
					</td>
				  </tr>
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->
				</table>
			  </div>
			  <!-- end of Intro content //-->
			  
			  <!-- beginning of Criterion 1 content //-->
              <div class="contents" id="contents3">
			  <table width="85%" border="0" cellspacing="3" cellpadding="3" align="center">
				  <tr>
					<td colspan="7" align="center" class="introheader">
					<img>
						<xsl:attribute name="src">
							<xsl:value-of select="presentationFiles/KCCbanner/artifact/fileArtifact/uri"/>
						</xsl:attribute>
					</img><br />General Education - <xsl:value-of select="presentationProperties/presentationOptions/matrixLevel"/></td>
				  </tr>
				  <tr>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents1');">Intro</a></td>
					<td align="center" class="navTDnoLink"><xsl:copy-of select="$cr1Name" /></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents4');"><xsl:copy-of select="$cr2Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents5');"><xsl:copy-of select="$cr3Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents6');"><xsl:copy-of select="$cr4Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents7');"><xsl:copy-of select="$cr5Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents8');"><xsl:copy-of select="$cr6Name" /></a></td>
				  </tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->
				  
				  <tr>
					<td colspan="7" align="center" valign="top">
					<table width="100%">
						<tr>
							<xsl:if test="//criterion1Img">
								<td align="center" valign="top" class="imgcaption">
									<img class="contentImg">
										<xsl:attribute name="src">
											<xsl:value-of select="//criterion1Img/artifact/fileArtifact/uri"/>
										</xsl:attribute>
									</img><br />
									<xsl:if test="//criterion1Caption">
										<xsl:value-of select="//criterion1Caption"/>
									</xsl:if>
								</td>
							</xsl:if>
							<td align="center">
								<div class="contentsubheader"><xsl:copy-of select="$cr1Name" /></div><br/>
								<div class="contentsubheader2">Standards:</div><br/>
								<div class="contentText">
									Written communication is an integral part of every content area and discipline. Use writing to discover and articulate ideas.
<ol>
<li>Identify and analyze the audience and purpose for any intended communication.</li>
<li>Choose language, style, and organization appropriate to particular purposes and audiences.</li>
<li>Gather information and document sources appropriately.</li>
<li>Express a main idea as a thesis, hypothesis, or other appropriate statement.</li>
<li>Develop a main idea clearly and concisely with appropriate content.</li>
<li>Demonstrate mastery of the conventions of writing, including grammar, spelling, and mechanics.</li>
<li>Demonstrate proficiency in revision and editing.</li>
<li>Develop a personal voice in written communication.</li>
</ol>
								</div>
							</td>
						</tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->

		<xsl:for-each select="//cell">
			<xsl:if test="scaffoldingCell/rootCriterion/description = $cr1Name">
				<xsl:if test="scaffoldingCell/level/description = //presentationProperties/presentationOptions/matrixLevel">
				
	<xsl:if test="wizardPage/attachments or wizardPage/status='PENDING' or wizardPage/status='COMPLETE'">				
				
				 
	
	  <tr>
				  	<td colspan="7">
				<xsl:if test="wizardPage/pageForms[normalize-space(.) != '']">
						<div class="contentsubheader">General Education Evidence:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/pageForms/pageForm">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/pageForms/pageForm" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/genEducation">
					<xsl:if test="context"><span class="reflectionText"><b>Context of Work:</b><br/><xsl:value-of select="context" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="dates"><span class="reflectionText"><b>Dates of Work:</b><br/><xsl:value-of select="dates" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="description"><span class="reflectionText"><b>Description of Work:</b><br/><xsl:value-of select="description" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="selfEvaluation"><span class="reflectionText"><b>Self-Evaluation of Work:</b><br/><xsl:value-of select="selfEvaluation" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>
						
				
						
					

						<xsl:if test="wizardPage/attachments[normalize-space(.) != '']">
						<div class="contentsubheader2">Supporting Materials</div>
				  	    <table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
							<tr>
							<td class="contentLabel">Files and URLs</td>
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

					<xsl:if test="wizardPage/reflections[normalize-space(.) != '']">
						<div class="contentsubheader">Reflection:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/reflections/reflection">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/reflections/reflection" >
						  <tr>
							<!--<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>-->
								<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/reflection">
					<xsl:if test="explainOrigins"><span class="reflectionText"><b>The origins of my work:</b><br/>&nbsp;<xsl:value-of select="explainOrigins" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="describeChose"><span class="reflectionText"><b>Why I chose the subject matter:</b><br/><xsl:value-of select="describeChose" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="explainFulfills"><span class="reflectionText"><b>How the work fulfills the standard:</b><br/><xsl:value-of select="explainFulfills" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="challenged"><span class="reflectionText"><b>How has the work challenged me to grow personally, academically, and professionally:</b><br/><xsl:value-of select="challenged" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="contribute"><span class="reflectionText"><b>How might the work could contribute to my life long learning:</b><br/><xsl:value-of select="contribute" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>

						<xsl:if test="wizardPage/feedback[normalize-space(.) != '']">
						<div class="contentsubheader">Feedback:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/feedback/feedback">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/feedback/feedback" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/feedback">
					<xsl:if test="comments"><span class="reflectionText"><xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						  
						  </table>
						</xsl:if>
	
	
	
	<xsl:if test="wizardPage/evaluations[normalize-space(.) != '']">
						<div class="contentsubheader">Evaluation:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/evaluations/evaluation">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/evaluations/evaluation" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/evaluation">
					<xsl:if test="evaluationLevel"><span class="reflectionText"><b>Evaluation Level:</b><br/>&nbsp;<xsl:value-of select="evaluationLevel" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="comments"><span class="reflectionText"><b>Comments:</b><br/>&nbsp;<xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
				
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>		
	
	
							  
						  
						  
						  
						</table>
						</xsl:if>

				  	</td>
				  </tr>
				  </xsl:if>
				  </xsl:if>
			</xsl:if>
		</xsl:for-each>
				  
					</table>
					</td>
				  </tr>
				  
				</table>
			  </div>
			  <!-- end of Criterion 1 content //-->
			  
			  <!-- beginning of Criterion 2 content //-->
              <div class="contents" id="contents4">
			  <table width="85%" border="0" cellspacing="3" cellpadding="3" align="center">
				  <tr>
					<td colspan="7" align="center" class="introheader">
					<img>
						<xsl:attribute name="src">
							<xsl:value-of select="presentationFiles/KCCbanner/artifact/fileArtifact/uri"/>
						</xsl:attribute>
					</img><br />General Education - <xsl:value-of select="presentationProperties/presentationOptions/matrixLevel"/></td>
				  </tr>
				  <tr>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents1');">Intro</a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents3');"><xsl:copy-of select="$cr1Name" /></a></td>
					<td align="center" class="navTDnoLink"><xsl:copy-of select="$cr2Name" /></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents5');"><xsl:copy-of select="$cr3Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents6');"><xsl:copy-of select="$cr4Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents7');"><xsl:copy-of select="$cr5Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents8');"><xsl:copy-of select="$cr6Name" /></a></td>
				  </tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->
				  
				  <tr>
					<td colspan="7" align="center" valign="top">
					<table width="100%">
						<tr>
							<xsl:if test="//criterion2Img">
								<td align="center" valign="top" class="imgcaption">
									<img class="contentImg">
										<xsl:attribute name="src">
											<xsl:value-of select="//criterion2Img/artifact/fileArtifact/uri"/>
										</xsl:attribute>
									</img><br />
									<xsl:if test="//criterion2Caption">
										<xsl:value-of select="//criterion2Caption"/>
									</xsl:if>
								</td>
							</xsl:if>
							<td align="center">
								<div class="contentsubheader"><xsl:copy-of select="$cr2Name" /></div><br/>
								<div class="contentsubheader2">Standards:</div><br/>
								<div class="contentText">
									Critical thinking, an analytical and creative process, is essential to every content area and discipline. It is an integral part of information retrieval and technology, oral communication, quantitative reasoning, and written communication.
<ol>
<li>Identify and state problems, issues, arguments, and questions contained in a body of information.</li>
<li>Identify and analyze assumptions and underlying points of view relating to an issue or problem.</li>
<li>Formulate research questions that require descriptive and explanatory analyses.</li>
<li>Recognize and understand multiple modes of inquiry, including investigative methods based on observation and analysis.</li>
<li>Evaluate a problem, distinguishing between relevant and irrelevant facts, opinions, assumptions, issues, values, and biases through the use of appropriate evidence.</li>
<li>Apply problem-solving techniques and skills, including the rules of logic and logical sequence.</li>
<li>Synthesize information from various sources, drawing appropriate conclusions.</li>
<li>Communicate clearly and concisely the methods and results of logical reasoning.</li>
<li>Reflect upon and evaluate their thought processes, value systems, and world views in comparison to those of others.</li>
</ol>
								</div>
							</td>
						</tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->

		<xsl:for-each select="//cell">
	
			
			<xsl:if test="scaffoldingCell/rootCriterion/description = $cr2Name">
				<xsl:if test="scaffoldingCell/level/description = //presentationProperties/presentationOptions/matrixLevel">
				<xsl:if test="wizardPage/attachments or wizardPage/status='PENDING' or wizardPage/status='COMPLETE'">				
				
				 
	
	  <tr>
				  	<td colspan="7">
				<xsl:if test="wizardPage/pageForms[normalize-space(.) != '']">
						<div class="contentsubheader">General Education Evidence:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/pageForms/pageForm">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/pageForms/pageForm" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/genEducation">
					<xsl:if test="context"><span class="reflectionText"><b>Context of Work:</b><br/><xsl:value-of select="context" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="dates"><span class="reflectionText"><b>Dates of Work:</b><br/><xsl:value-of select="dates" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="description"><span class="reflectionText"><b>Description of Work:</b><br/><xsl:value-of select="description" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="selfEvaluation"><span class="reflectionText"><b>Self-Evaluation of Work:</b><br/><xsl:value-of select="selfEvaluation" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>
						
				
						
					

						<xsl:if test="wizardPage/attachments[normalize-space(.) != '']">
						<div class="contentsubheader2">Supporting Materials</div>
				  	    <table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
							<tr>
							<td class="contentLabel">Files and URLs</td>
							<td class="contentText">
								<form name="frmSupport2" id="frmSupport2" target="ospiMaterial">
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
								<select id="fileSel" size="1" onChange="javascript:document.getElementById('frmSupport2').action=this.options[this.selectedIndex].value;">
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

						<xsl:if test="wizardPage/reflections[normalize-space(.) != '']">
						<div class="contentsubheader">Reflection:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/reflections/reflection">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/reflections/reflection" >
						  <tr>
							<!--<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>-->
								<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/reflection">
					<xsl:if test="explainOrigins"><span class="reflectionText"><b>The origins of my work:</b><br/>&nbsp;<xsl:value-of select="explainOrigins" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="describeChose"><span class="reflectionText"><b>Why I chose the subject matter:</b><br/><xsl:value-of select="describeChose" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="explainFulfills"><span class="reflectionText"><b>How the work fulfills the standard:</b><br/><xsl:value-of select="explainFulfills" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="challenged"><span class="reflectionText"><b>How has the work challenged me to grow personally, academically, and professionally:</b><br/><xsl:value-of select="challenged" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="contribute"><span class="reflectionText"><b>How might the work could contribute to my life long learning:</b><br/><xsl:value-of select="contribute" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>

						<xsl:if test="wizardPage/feedback[normalize-space(.) != '']">
						<div class="contentsubheader">Feedback:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/feedback/feedback">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/feedback/feedback" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/feedback">
					<xsl:if test="comments"><span class="reflectionText"><xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						  
						  </table>
						</xsl:if>
	
	
	
	<xsl:if test="wizardPage/evaluations[normalize-space(.) != '']">
						<div class="contentsubheader">Evaluation:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/evaluations/evaluation">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/evaluations/evaluation" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/evaluation">
					<xsl:if test="evaluationLevel"><span class="reflectionText"><b>Evaluation Level:</b><br/>&nbsp;<xsl:value-of select="evaluationLevel" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="comments"><span class="reflectionText"><b>Comments:</b><br/>&nbsp;<xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
				
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>		
	
	
							  
						  
						  
						  
						</table>
						</xsl:if>

				  	</td>
				  </tr>
				  </xsl:if>
				  </xsl:if>
			</xsl:if>
		</xsl:for-each>
				  
					</table>
					</td>
				  </tr>
				  
				</table>
			  </div>
			  <!-- end of Criterion 2 content //-->

			  <!-- beginning of Criterion 3 content //-->
              <div class="contents" id="contents5">
			  <table width="85%" border="0" cellspacing="3" cellpadding="3" align="center">
				  <tr>
					<td colspan="7" align="center" class="introheader">
					<img>
						<xsl:attribute name="src">
							<xsl:value-of select="presentationFiles/KCCbanner/artifact/fileArtifact/uri"/>
						</xsl:attribute>
					</img><br />General Education - <xsl:value-of select="presentationProperties/presentationOptions/matrixLevel"/></td>
				  </tr>
				  <tr>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents1');">Intro</a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents3');"><xsl:copy-of select="$cr1Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents4');"><xsl:copy-of select="$cr2Name" /></a></td>
					<td align="center" class="navTDnoLink"><xsl:copy-of select="$cr3Name" /></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents6');"><xsl:copy-of select="$cr4Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents7');"><xsl:copy-of select="$cr5Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents8');"><xsl:copy-of select="$cr6Name" /></a></td>
				  </tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->
				  
				  <tr>
					<td colspan="7" align="center" valign="top">
					<table width="100%">
						<tr>
							<xsl:if test="//criterion3Img">
								<td align="center" valign="top" class="imgcaption">
									<img class="contentImg">
										<xsl:attribute name="src">
											<xsl:value-of select="//criterion3Img/artifact/fileArtifact/uri"/>
										</xsl:attribute>
									</img><br />
									<xsl:if test="//criterion3Caption">
										<xsl:value-of select="//criterion3Caption"/>
									</xsl:if>
								</td>
							</xsl:if>
							<td align="center">
								<div class="contentsubheader"><xsl:copy-of select="$cr3Name" /></div><br/>
								<div class="contentsubheader2">Standards:</div><br/>
								<div class="contentText">
									Information retrieval and technology are integral parts of every content area and discipline.
<ol>
<li>Use print and electronic information technology ethically and responsibly.</li>
<li>Demonstrate knowledge of basic vocabulary, concepts, and operations of information retrieval and technology.</li>
<li>Recognize, identify, and define an information need.</li>
<li>Access and retrieve information through print and electronic media, evaluating the accuracy and authenticity of that information.</li>
<li>Create, manage, organize, and communicate information through electronic media.</li>
<li>Recognize changing technologies and make informed choices about their appropriateness and use.</li>
</ol>
								</div>
							</td>
						</tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->

		<xsl:for-each select="GenEdmatrix/artifact/cells/cell">
			<xsl:if test="scaffoldingCell/rootCriterion/description = $cr3Name">
				<xsl:if test="scaffoldingCell/level/description = //presentationProperties/presentationOptions/matrixLevel">
				 <xsl:if test="wizardPage/attachments or wizardPage/status='PENDING' or wizardPage/status='COMPLETE'">				
				
				 
	
	  <tr>
				  	<td colspan="7">
				<xsl:if test="wizardPage/pageForms[normalize-space(.) != '']">
						<div class="contentsubheader">General Education Evidence:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/pageForms/pageForm">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/pageForms/pageForm" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/genEducation">
					<xsl:if test="context"><span class="reflectionText"><b>Context of Work:</b><br/><xsl:value-of select="context" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="dates"><span class="reflectionText"><b>Dates of Work:</b><br/><xsl:value-of select="dates" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="description"><span class="reflectionText"><b>Description of Work:</b><br/><xsl:value-of select="description" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="selfEvaluation"><span class="reflectionText"><b>Self-Evaluation of Work:</b><br/><xsl:value-of select="selfEvaluation" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>
						
				
						
					

						<xsl:if test="wizardPage/attachments[normalize-space(.) != '']">
						<div class="contentsubheader2">Supporting Materials</div>
				  	    <table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
							<tr>
							<td class="contentLabel">Files and URLs</td>
							<td class="contentText">
								<form name="frmSupport3" id="frmSupport3" target="ospiMaterial">
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
								<select id="fileSel" size="1" onChange="javascript:document.getElementById('frmSupport3').action=this.options[this.selectedIndex].value;">
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

					<xsl:if test="wizardPage/reflections[normalize-space(.) != '']">
						<div class="contentsubheader">Reflection:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/reflections/reflection">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/reflections/reflection" >
						  <tr>
							<!--<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>-->
								<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/reflection">
					<xsl:if test="explainOrigins"><span class="reflectionText"><b>The origins of my work:</b><br/>&nbsp;<xsl:value-of select="explainOrigins" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="describeChose"><span class="reflectionText"><b>Why I chose the subject matter:</b><br/><xsl:value-of select="describeChose" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="explainFulfills"><span class="reflectionText"><b>How the work fulfills the standard:</b><br/><xsl:value-of select="explainFulfills" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="challenged"><span class="reflectionText"><b>How has the work challenged me to grow personally, academically, and professionally:</b><br/><xsl:value-of select="challenged" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="contribute"><span class="reflectionText"><b>How might the work could contribute to my life long learning:</b><br/><xsl:value-of select="contribute" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>

						<xsl:if test="wizardPage/feedback[normalize-space(.) != '']">
						<div class="contentsubheader">Feedback:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/feedback/feedback">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/feedback/feedback" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/feedback">
					<xsl:if test="comments"><span class="reflectionText"><xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						  
						  </table>
						</xsl:if>
	
	
	
	<xsl:if test="wizardPage/evaluations[normalize-space(.) != '']">
						<div class="contentsubheader">Evaluation:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/evaluations/evaluation">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/evaluations/evaluation" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/evaluation">
					<xsl:if test="evaluationLevel"><span class="reflectionText"><b>Evaluation Level:</b><br/>&nbsp;<xsl:value-of select="evaluationLevel" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="comments"><span class="reflectionText"><b>Comments:</b><br/>&nbsp;<xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
				
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>		
	
	
							  
						  
						  
						  
						</table>
						</xsl:if>

				  	</td>
				  </tr>
				  </xsl:if>
				  </xsl:if>
			</xsl:if>
		</xsl:for-each>
				  
					</table>
					</td>
				  </tr>
				  
				</table>
			  </div>
			  <!-- end of Criterion 3 content //-->

			  <!-- beginning of Criterion 4 content //-->
              <div class="contents" id="contents6">
			  <table width="85%" border="0" cellspacing="3" cellpadding="3" align="center">
				  <tr>
					<td colspan="7" align="center" class="introheader">
					<img>
						<xsl:attribute name="src">
							<xsl:value-of select="presentationFiles/KCCbanner/artifact/fileArtifact/uri"/>
						</xsl:attribute>
					</img><br />General Education - <xsl:value-of select="presentationProperties/presentationOptions/matrixLevel"/></td>
				  </tr>
				  <tr>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents1');">Intro</a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents3');"><xsl:copy-of select="$cr1Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents4');"><xsl:copy-of select="$cr2Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents5');"><xsl:copy-of select="$cr3Name" /></a></td>
					<td align="center" class="navTDnoLink"><xsl:copy-of select="$cr4Name" /></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents7');"><xsl:copy-of select="$cr5Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents8');"><xsl:copy-of select="$cr6Name" /></a></td>
				  </tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->
				  
				  <tr>
					<td colspan="7" align="center" valign="top">
					<table width="100%">
						<tr>
							<xsl:if test="//criterion4Img">
								<td align="center" valign="top" class="imgcaption">
									<img class="contentImg">
										<xsl:attribute name="src">
											<xsl:value-of select="//criterion4Img/artifact/fileArtifact/uri"/>
										</xsl:attribute>
									</img><br />
									<xsl:if test="//criterion4Caption">
										<xsl:value-of select="//criterion4Caption"/>
									</xsl:if>
								</td>
							</xsl:if>
							<td align="center">
								<div class="contentsubheader"><xsl:copy-of select="$cr4Name" /></div><br/>
								<div class="contentsubheader2">Standards:</div><br/>
								<div class="contentText">
									Quantitative reasoning can have applications in all content areas and disciplines.
<ol>
<li>Apply numeric, graphic, and symbolic skills and other forms of quantitative reasoning accurately and appropriately.</li>
<li>Demonstrate mastery of mathematical concepts, skills, and applications, using technology when appropriate.</li>
<li>Communicate clearly and concisely the methods and results of quantitative problem solving.</li>
<li>Formulate and test hypotheses using numerical experimentation.</li>
<li>Define quantitative issues and problems, gather relevant information, analyze that information, and present results.</li>
<li>Assess the validity of statistical conclusions.</li>
</ol>
								</div>
							</td>
						</tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->

		<xsl:for-each select="GenEdmatrix/artifact/cells/cell">
			<xsl:if test="scaffoldingCell/rootCriterion/description = $cr4Name">
				<xsl:if test="scaffoldingCell/level/description = //presentationProperties/presentationOptions/matrixLevel">
				  <xsl:if test="wizardPage/attachments or wizardPage/status='PENDING' or wizardPage/status='COMPLETE'">				
				
				 
	
	  <tr>
				  	<td colspan="7">
				<xsl:if test="wizardPage/pageForms[normalize-space(.) != '']">
						<div class="contentsubheader">General Education Evidence:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/pageForms/pageForm">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/pageForms/pageForm" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/genEducation">
					<xsl:if test="context"><span class="reflectionText"><b>Context of Work:</b><br/><xsl:value-of select="context" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="dates"><span class="reflectionText"><b>Dates of Work:</b><br/><xsl:value-of select="dates" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="description"><span class="reflectionText"><b>Description of Work:</b><br/><xsl:value-of select="description" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="selfEvaluation"><span class="reflectionText"><b>Self-Evaluation of Work:</b><br/><xsl:value-of select="selfEvaluation" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>
						
				
						
					

						<xsl:if test="wizardPage/attachments[normalize-space(.) != '']">
						<div class="contentsubheader2">Supporting Materials</div>
				  	    <table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
							<tr>
							<td class="contentLabel">Files and URLs</td>
							<td class="contentText">
								<form name="frmSupport4" id="frmSupport4" target="ospiMaterial">
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
								<select id="fileSel" size="1" onChange="javascript:document.getElementById('frmSupport4').action=this.options[this.selectedIndex].value;">
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

					<xsl:if test="wizardPage/reflections[normalize-space(.) != '']">
						<div class="contentsubheader">Reflection:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/reflections/reflection">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/reflections/reflection" >
						  <tr>
							<!--<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>-->
								<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/reflection">
					<xsl:if test="explainOrigins"><span class="reflectionText"><b>The origins of my work:</b><br/>&nbsp;<xsl:value-of select="explainOrigins" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="describeChose"><span class="reflectionText"><b>Why I chose the subject matter:</b><br/><xsl:value-of select="describeChose" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="explainFulfills"><span class="reflectionText"><b>How the work fulfills the standard:</b><br/><xsl:value-of select="explainFulfills" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="challenged"><span class="reflectionText"><b>How has the work challenged me to grow personally, academically, and professionally:</b><br/><xsl:value-of select="challenged" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="contribute"><span class="reflectionText"><b>How might the work could contribute to my life long learning:</b><br/><xsl:value-of select="contribute" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>

						<xsl:if test="wizardPage/feedback[normalize-space(.) != '']">
						<div class="contentsubheader">Feedback:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/feedback/feedback">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/feedback/feedback" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/feedback">
					<xsl:if test="comments"><span class="reflectionText"><xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						  
						  </table>
						</xsl:if>
	
	
	
	<xsl:if test="wizardPage/evaluations[normalize-space(.) != '']">
						<div class="contentsubheader">Evaluation:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/evaluations/evaluation">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/evaluations/evaluation" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/evaluation">
					<xsl:if test="evaluationLevel"><span class="reflectionText"><b>Evaluation Level:</b><br/>&nbsp;<xsl:value-of select="evaluationLevel" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="comments"><span class="reflectionText"><b>Comments:</b><br/>&nbsp;<xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
				
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>		
	
	
							  
						  
						  
						  
						</table>
						</xsl:if>

				  	</td>
				  </tr>
				  </xsl:if>
				  </xsl:if>
			</xsl:if>
		</xsl:for-each>
				  
					</table>
					</td>
				  </tr>
				  
				</table>
			  </div>
			  <!-- end of Criterion 4 content //-->

			  <!-- beginning of Criterion 5 content //-->
              <div class="contents" id="contents7">
			  <table width="85%" border="0" cellspacing="3" cellpadding="3" align="center">
				  <tr>
					<td colspan="7" align="center" class="introheader">
					<img>
						<xsl:attribute name="src">
							<xsl:value-of select="presentationFiles/KCCbanner/artifact/fileArtifact/uri"/>
						</xsl:attribute>
					</img><br />General Education - <xsl:value-of select="presentationProperties/presentationOptions/matrixLevel"/></td>
				  </tr>
				  <tr>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents1');">Intro</a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents3');"><xsl:copy-of select="$cr1Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents4');"><xsl:copy-of select="$cr2Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents5');"><xsl:copy-of select="$cr3Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents6');"><xsl:copy-of select="$cr4Name" /></a></td>
					<td align="center" class="navTDnoLink"><xsl:copy-of select="$cr5Name" /></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents8');"><xsl:copy-of select="$cr6Name" /></a></td>
				  </tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->
				  
				  <tr>
					<td colspan="7" align="center" valign="top">
					<table width="100%">
						<tr>
							<xsl:if test="//criterion5Img">
								<td align="center" valign="top" class="imgcaption">
									<img class="contentImg">
										<xsl:attribute name="src">
											<xsl:value-of select="//criterion5Img/artifact/fileArtifact/uri"/>
										</xsl:attribute>
									</img><br />
									<xsl:if test="//criterion5Caption">
										<xsl:value-of select="//criterion5Caption"/>
									</xsl:if>
								</td>
							</xsl:if>
							<td align="center">
								<div class="contentsubheader"><xsl:copy-of select="$cr5Name" /></div><br/>
								<div class="contentsubheader2">Standards:</div><br/>
								<div class="contentText">
									Oral communication is an integral part of every content area and discipline.
<ol>
<li>Identify and analyze the audience and purpose of any intended communication.</li>
<li>Gather, evaluate, select, and organize information for the communication.</li>
<li>Use language, techniques, and strategies appropriate to the audience and occasion.</li>
<li>Speak clearly and confidently, using the voice, volume, tone, and articulation appropriate to the audience and occasion.</li>
<li>Summarize, analyze, and evaluate oral communications and ask coherent questions as needed.</li>
<li>Use competent oral expression to initiate and sustain discussions.</li>
</ol>
								</div>
							</td>
						</tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->

		<xsl:for-each select="GenEdmatrix/artifact/cells/cell">
			<xsl:if test="scaffoldingCell/rootCriterion/description = $cr5Name">
				<xsl:if test="scaffoldingCell/level/description = //presentationProperties/presentationOptions/matrixLevel">
				 <xsl:if test="wizardPage/attachments or wizardPage/status='PENDING' or wizardPage/status='COMPLETE'">				
				
				 
	
	  <tr>
				  	<td colspan="7">
				<xsl:if test="wizardPage/pageForms[normalize-space(.) != '']">
						<div class="contentsubheader">General Education Evidence:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/pageForms/pageForm">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/pageForms/pageForm" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/genEducation">
					<xsl:if test="context"><span class="reflectionText"><b>Context of Work:</b><br/><xsl:value-of select="context" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="dates"><span class="reflectionText"><b>Dates of Work:</b><br/><xsl:value-of select="dates" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="description"><span class="reflectionText"><b>Description of Work:</b><br/><xsl:value-of select="description" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="selfEvaluation"><span class="reflectionText"><b>Self-Evaluation of Work:</b><br/><xsl:value-of select="selfEvaluation" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>
						
				
						
					

						<xsl:if test="wizardPage/attachments[normalize-space(.) != '']">
						<div class="contentsubheader2">Supporting Materials</div>
				  	    <table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
							<tr>
							<td class="contentLabel">Files and URLs</td>
							<td class="contentText">
								<form name="frmSupport5" id="frmSupport5" target="ospiMaterial">
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
								<select id="fileSel" size="1" onChange="javascript:document.getElementById('frmSupport5').action=this.options[this.selectedIndex].value;">
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

						<xsl:if test="wizardPage/reflections[normalize-space(.) != '']">
						<div class="contentsubheader">Reflection:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/reflections/reflection">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/reflections/reflection" >
						  <tr>
							<!--<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>-->
								<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/reflection">
					<xsl:if test="explainOrigins"><span class="reflectionText"><b>The origins of my work:</b><br/>&nbsp;<xsl:value-of select="explainOrigins" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="describeChose"><span class="reflectionText"><b>Why I chose the subject matter:</b><br/><xsl:value-of select="describeChose" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="explainFulfills"><span class="reflectionText"><b>How the work fulfills the standard:</b><br/><xsl:value-of select="explainFulfills" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="challenged"><span class="reflectionText"><b>How has the work challenged me to grow personally, academically, and professionally:</b><br/><xsl:value-of select="challenged" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="contribute"><span class="reflectionText"><b>How might the work could contribute to my life long learning:</b><br/><xsl:value-of select="contribute" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>

						<xsl:if test="wizardPage/feedback[normalize-space(.) != '']">
						<div class="contentsubheader">Feedback:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/feedback/feedback">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/feedback/feedback" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/feedback">
					<xsl:if test="comments"><span class="reflectionText"><xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						  
						  </table>
						</xsl:if>
	
	
	
	<xsl:if test="wizardPage/evaluations[normalize-space(.) != '']">
						<div class="contentsubheader">Evaluation:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/evaluations/evaluation">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/evaluations/evaluation" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/evaluation">
					<xsl:if test="evaluationLevel"><span class="reflectionText"><b>Evaluation Level:</b><br/>&nbsp;<xsl:value-of select="evaluationLevel" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="comments"><span class="reflectionText"><b>Comments:</b><br/>&nbsp;<xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
				
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>		
	
	
							  
						  
						  
						  
						</table>
						</xsl:if>

				  	</td>
				  </tr>
				  </xsl:if>
				  </xsl:if>
			</xsl:if>
		</xsl:for-each>
				  
					</table>
					</td>
				  </tr>
				  
				</table>
			  </div>
			  <!-- end of Criterion 5 content //-->

			  <!-- beginning of Criterion 6 content //-->
              <div class="contents" id="contents8">
			  <table width="85%" border="0" cellspacing="3" cellpadding="3" align="center">
				  <tr>
					<td colspan="7" align="center" class="introheader">
					<img>
						<xsl:attribute name="src">
							<xsl:value-of select="presentationFiles/KCCbanner/artifact/fileArtifact/uri"/>
						</xsl:attribute>
					</img><br />General Education - <xsl:value-of select="presentationProperties/presentationOptions/matrixLevel"/></td>
				  </tr>
				  <tr>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents1');">Intro</a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents3');"><xsl:copy-of select="$cr1Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents4');"><xsl:copy-of select="$cr2Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents5');"><xsl:copy-of select="$cr3Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents6');"><xsl:copy-of select="$cr4Name" /></a></td>
					<td align="center" class="navTD"><a href="javascript:switchOn('contents7');"><xsl:copy-of select="$cr5Name" /></a></td>
					<td align="center" class="navTDnoLink"><xsl:copy-of select="$cr6Name" /></td>
				  </tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->
				  
				  <tr>
					<td colspan="7" align="center" valign="top">
					<table width="100%">
						<tr>
							<xsl:if test="//criterion6Img">
								<td align="center" valign="top" class="imgcaption">
									<img class="contentImg">
										<xsl:attribute name="src">
											<xsl:value-of select="//criterion6Img/artifact/fileArtifact/uri"/>
										</xsl:attribute>
									</img><br />
									<xsl:if test="//criterion6Caption">
										<xsl:value-of select="//criterion6Caption"/>
									</xsl:if>
								</td>
							</xsl:if>
							<td align="center">
								<div class="contentsubheader"><xsl:copy-of select="$cr6Name" /></div><br/>
								<div class="contentsubheader2">Standards:</div><br/>
								<div class="contentText">
									Kapi'olani Community College emphasizes an understanding of one's self and one's relationship to the community, the region, and the world.
<ol>
<li>Demonstrate an awareness of the relationship between the environment and one's own fundamental physiological and psychological processes.</li>
<li>Examine critically and appreciate the values and beliefs of one's own culture and those of other cultures separated in time or space from one's own.</li>
<li>Communicate effectively and acknowledge opposing viewpoints.</li>
<li>Use the study of a second language as a window to cultural understanding.</li>
<li>Demonstrate an understanding of ethical, civic and social issues relevant to Hawai'i's and the world's past, present and future.</li>
</ol>
								</div>
							</td>
						</tr>
				  
				  <tr><td colspan="7">&nbsp;</td></tr><!-- spacer //-->

		<xsl:for-each select="GenEdmatrix/artifact/cells/cell">
			<xsl:if test="scaffoldingCell/rootCriterion/description = $cr6Name">
				<xsl:if test="scaffoldingCell/level/description = //presentationProperties/presentationOptions/matrixLevel">
				  <xsl:if test="wizardPage/attachments or wizardPage/status='PENDING' or wizardPage/status='COMPLETE'">				
				
				 
	
	  <tr>
				  	<td colspan="7">
				<xsl:if test="wizardPage/pageForms[normalize-space(.) != '']">
						<div class="contentsubheader">General Education Evidence:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/pageForms/pageForm">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/pageForms/pageForm" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/genEducation">
					<xsl:if test="context"><span class="reflectionText"><b>Context of Work:</b><br/><xsl:value-of select="context" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="dates"><span class="reflectionText"><b>Dates of Work:</b><br/><xsl:value-of select="dates" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="description"><span class="reflectionText"><b>Description of Work:</b><br/><xsl:value-of select="description" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="selfEvaluation"><span class="reflectionText"><b>Self-Evaluation of Work:</b><br/><xsl:value-of select="selfEvaluation" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>
						
				
						
					

						<xsl:if test="wizardPage/attachments[normalize-space(.) != '']">
						<div class="contentsubheader2">Supporting Materials</div>
				  	    <table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
							<tr>
							<td class="contentLabel">Files and URLs</td>
							<td class="contentText">
								<form name="frmSupport6" id="frmSupport6" target="ospiMaterial">
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
								<select id="fileSel" size="1" onChange="javascript:document.getElementById('frmSupport6').action=this.options[this.selectedIndex].value;">
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

						<xsl:if test="wizardPage/reflections[normalize-space(.) != '']">
						<div class="contentsubheader">Reflection:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/reflections/reflection">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/reflections/reflection" >
						  <tr>
							<!--<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>-->
								<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/reflection">
					<xsl:if test="explainOrigins"><span class="reflectionText"><b>The origins of my work:</b><br/>&nbsp;<xsl:value-of select="explainOrigins" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="describeChose"><span class="reflectionText"><b>Why I chose the subject matter:</b><br/><xsl:value-of select="describeChose" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="explainFulfills"><span class="reflectionText"><b>How the work fulfills the standard:</b><br/><xsl:value-of select="explainFulfills" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="challenged"><span class="reflectionText"><b>How has the work challenged me to grow personally, academically, and professionally:</b><br/><xsl:value-of select="challenged" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="contribute"><span class="reflectionText"><b>How might the work could contribute to my life long learning:</b><br/><xsl:value-of select="contribute" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						</table>
						</xsl:if>

						<xsl:if test="wizardPage/feedback[normalize-space(.) != '']">
						<div class="contentsubheader">Feedback:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/feedback/feedback">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/feedback/feedback" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/feedback">
					<xsl:if test="comments"><span class="reflectionText"><xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>	
						  
						  </table>
						</xsl:if>
	
	
	
	<xsl:if test="wizardPage/evaluations[normalize-space(.) != '']">
						<div class="contentsubheader">Evaluation:</div>
					</xsl:if>
						
					<xsl:if test="wizardPage/evaluations/evaluation">
				  		<table width="100%" border="0" cellspacing="0" cellpadding="3" class="contentTable">
				  		<xsl:for-each select="wizardPage/evaluations/evaluation" >
						  <tr>
							<td class="contentLabel"><xsl:value-of select="artifact/metaData/displayName" disable-output-escaping="yes"/></td>
							<td class="contentText">
							<xsl:for-each select="artifact/structuredData/evaluation">
					<xsl:if test="evaluationLevel"><span class="reflectionText"><b>Evaluation Level:</b><br/>&nbsp;<xsl:value-of select="evaluationLevel" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					<xsl:if test="comments"><span class="reflectionText"><b>Comments:</b><br/>&nbsp;<xsl:value-of select="comments" disable-output-escaping="yes"/></span><br/><br/></xsl:if>
					
				
							</xsl:for-each>
							
							</td>
						  </tr>
						  </xsl:for-each>		
	
	
							  
						  
						  
						  
						</table>
						</xsl:if>

				  	</td>
				  </tr>
				  </xsl:if>
				  </xsl:if>
			</xsl:if>
		</xsl:for-each>
				  
					</table>
					</td>
				  </tr>
				  
				</table>
			  </div>
			  <!-- end of Criterion 6 content //-->

            </td>
          </tr>
      </table>

      <script type="text/javascript">
        // <![CDATA[

        // Put a call to switchOn somewhere in the body,
        // or else there won't be any tab displayed
        // by default on page load.

        switchOn('contents1');

        // ]]>
      </script>
		<hr id="footerHR" />
</div>
</body>
</html>
</xsl:template>
</xsl:stylesheet>