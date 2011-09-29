      // <![CDATA[
      // Tab menu functions by Jack Letourneau, February 2002
      // http://eigengrau.com/

      function switchOn(contents) {
        switchAllOff();
        document.getElementById(contents).className = 'selectedcontents';
      }

      function clearContents() {
        // Hides all DIVs in TD ID="contentscell"
        contentsCell = document.getElementById('contentscell');
        contentsArray = contentsCell.childNodes;
        for (var j=0; j<contentsArray.length; j++) {
          contentsArray[j].className = 'contents';
        }
      }

      function switchAllOff() {
        clearContents();
      }
	  

      function displayReflection(section,contents) {
        switchAllReflOff(section);
        document.getElementById(contents).className = 'selectedcontents';
      }
	  
      function clearReflContents(section) {
        // Hides all DIVs in ID="materialsreflections"
        contentsCell = document.getElementById(section);
        contentsArray = contentsCell.childNodes;
        for (var j=0; j<contentsArray.length; j++) {
          contentsArray[j].className = 'contents';
        }
      }

      function switchAllReflOff(section) {
        clearReflContents(section);
      }

      // ]]>