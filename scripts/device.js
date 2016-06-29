// JavaScript Document
var deviceXml; //create the XML object to hold the HeDGe XML.
var deviceParent; //element holding the shield SVG.
var deviceXslt; //to hold XSLT.
var	deviceSvg; //document to hold generated device SVG.
var gallery; //to display previously-created devices.
var gallerySize = 8;
var galleryInputImage = {width:80, height:92};

function loadXMLDoc(dname) {
	if (window.XMLHttpRequest) {
		xhttp = new XMLHttpRequest();
		}
	else {
		xhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	xhttp.open("GET",dname,false);
	xhttp.send("");
	return xhttp.responseXML;
}

function xml2Str(xmlNode) { // convert XML to string:
   try {
      // Gecko- and Webkit-based browsers (Firefox, Chrome), Opera.
      return (new XMLSerializer()).serializeToString(xmlNode);
  }
  catch (e) {
     try {
        // Internet Explorer.
        return xmlNode.xml;
     }
     catch (e) {  
        //Other browsers without XML Serializer
        alert('Xmlserializer not supported');
     }
   }
   return false;
}

function str2Xml(string) { // convert string to XML:
	var xmlDoc;
	if (window.DOMParser) {
			//parser = new DOMParser();
			//xmlDoc = parser.parseFromString(string,"text/xml");
			var parser = new DOMParser();
			xmlDoc = parser.parseFromString(string, "text/xml");
	}
	else { // Internet Explorer
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.async="false";
		xmlDoc.loadXML(string); 
	}
	return xmlDoc;
}

function createDeviceXml() {
	try {
		deviceXml = loadXMLDoc("device.xml");
		deviceSvg = loadXMLDoc("device.svg");
		//document.getElementById("device").appendChild(deviceSvg);
	}
	catch(ex) {
		alert(ex);
	}
}

function displayResult() { // convert HeDGe XML to SVG and display the various outputs.
	var xmlString1 = xml2Str(deviceXml);
	document.getElementById("xmlSource").value = xmlString1;
	var xmlString2;
	deviceSvg = document.querySelector("#device svg");
	var selectedChargeIndex = document.getElementById("chargemainmenu").selectedIndex;
	var outputSvg = transformXml(deviceXml,deviceXslt); // output SVG.
	xmlString2 = xml2Str(outputSvg);
	document.getElementById("svgSource").value = xmlString2;
	deviceParent.replaceChild(outputSvg, deviceSvg);
}

function transformXml (xml, xslt) {
	try {
		// code for Mozilla, Firefox, Opera, etc.
		xsltProcessor = new XSLTProcessor();
		xsltProcessor.importStylesheet(xslt);
		resultDeviceDoc = xsltProcessor.transformToFragment(xml, document);
		return resultDeviceDoc;
	}
	catch(ex) {
		alert(ex);
	}
}

function createChargeMenu (chargeMenuId) {
	var chargesXml = loadXMLDoc("library.xml");
	var xsltdoc2 = loadXMLDoc("librarytohtmlselect.xslt");
	var chargesMenuHtml;
	try {
		// code for IE
//		if (window.ActiveXObject) {
//			ex = chargesXml.transformNode(xsltdoc2);
//			chargesMenuHtml = ex.innerHTML;
//			}
		// code for Mozilla, Firefox, Opera, etc.
		/*else*/ if (document.implementation && document.implementation.createDocument) {
			xsltProcessor2 = new XSLTProcessor();
			xsltProcessor2.importStylesheet(xsltdoc2);
			resultDocument2 = xsltProcessor2.transformToFragment(chargesXml,document);
			chargesMenuHtml = resultDocument2.firstChild.innerHTML;
		}
	}
	catch(ex) {
		alert(ex);
	}
	document.getElementById(chargeMenuId).innerHTML = chargesMenuHtml;
}

function initialize() {
	deviceParent = document.getElementById("device");
	deviceXslt = loadXMLDoc("devicetosvgshield.xslt");
	createDeviceXml();
	displayGallery();
	displayResult();
	createChargeMenu("chargemainmenu"); //build the main charge menu up from the library.
	document.frmDesign.reset(); //reset the design form when the document (re)loads.
	document.frmDevice.reset();
	// XPath example
	//var paragraphCount = document.evaluate( 'count(//p)', document, null, XPathResult.ANY_TYPE, null );
	//alert( 'This document contains ' + paragraphCount.numberValue + ' paragraph elements' );
}

function updateDevice(element, attribute, value) { // On change of controls, update the device and re-display the result.
	//alert("element: " + element + "; attribute: " + attribute + "; value: " + value);
	try {
		xmlElementNode = deviceXml.getElementsByTagName(element);
		xmlElementNode.setAttribute(attribute, value);
	}
	catch(ex) {
		//alert(ex);
		try {
			xmlElementNode = deviceXml.getElementsByTagName(element)[0];
			xmlAttributeNode = xmlElementNode.getAttributeNode(attribute);
			xmlAttributeNode.nodeValue = value;
		}
		catch(ex) {
			alert(ex);
		}
	}
	displayResult();
}

// A number of slots are available for storing and retrieving device designs to
// and from browser local storage.
function saveToGallery (slotInput) {
	var gallerySlot = slotInput.id;
	// Store the object
	localStorage.setItem(gallerySlot, xml2Str(deviceXml));
	// generate image for button
	var svgThumb = createThumbnail(gallerySlot);
	gallery.replaceChild(svgThumb, slotInput);
}

function displayGallery () {
	gallery = document.getElementById("gallery");
	// Retrieve the devices from storage
	var retrievedDevices = new Array;
	var slotInput;
	//var svgDevice = new Array;
	var outputSvg;
	//var svg = new Array; // the created, temporary device transformed to SVG and appended to document.
	for (i = 0; i < gallerySize; i++) {
		// Create a series of filled slots (buttons with images of devices for loading)
		// and empty slots (buttons for saving current device to)
		var gallerySlot = "slot" + i;
		var svgSlot = "svg" + i;
		if (localStorage.getItem(gallerySlot)) {
			// if this slot holds a saved design, load xml device, transform to svg
			retrievedDevices[i] = createThumbnail(gallerySlot);
			gallery.appendChild(retrievedDevices[i]);
		} else {
			// set image to an empty slot placeholder
			slotInput = document.createElement("img");//input
			slotInput.setAttribute("id", gallerySlot);
			slotInput.setAttribute("width", galleryInputImage.width);
			slotInput.setAttribute("height", galleryInputImage.height);
			// clicking on an empty slot should store the current device there;
			slotInput.setAttribute("onclick", "saveToGallery(this); return false;");
			slotInput.setAttribute("src", "device.svg");//assets/images/shieldicon.png
			gallery.appendChild(slotInput);
		}
	}
}

function retrieveFromGallery (slotInput) {
	// retrieve device XML from local storage, transform it to SVG and display it
	var gallerySlot = slotInput.id;
	var xmlString = localStorage.getItem(gallerySlot);
	deviceXml = str2Xml(xmlString);
	displayResult();
}

function createThumbnail (slot) {
	// create a thumbnail image for a device which acts as a button to select it
	var slotNumber = slot.substr(4); // 5th character (onward) is integer
	var retrievedDevice = str2Xml(localStorage.getItem(slot));
	var outputSvg = transformXml(retrievedDevice, deviceXslt); // output SVG.
	var svg = outputSvg.querySelector("svg");
	// set some attributes on root svg element
	svg.setAttribute("id", slot);
	svg.setAttribute("onclick", "retrieveFromGallery(this); return false;");
	svg.setAttribute("width", galleryInputImage.width + "px");
	svg.setAttribute("height", galleryInputImage.height + "px");
	// to avoid id clashes with other svg device instances, we need to change
	// all the ids to unique values, and update the references to them
	// selection method based on http://www.w3.org/TR/selectors-api/#examples0
	var ids = svg.querySelectorAll("[id]");
	var hrefs = svg.querySelectorAll("[*|href], use"); // select all elements with hrefs pointing to elements within the SVG document
	var xlinkns = "http://www.w3.org/1999/xlink";
	for (var i = 0; i < ids.length; i++) {
		var newid = ids[i].getAttribute("id") + slotNumber;
		ids[i].setAttribute("id", newid);
	}
	for (var j = 0; j < hrefs.length; j++) {
		var href = hrefs[j].getAttributeNS(xlinkns, "href");
		//var hrefNS = href.namespaceURI;
		if (href) {
			var newhref = href + slotNumber;
			hrefs[j].setAttributeNS(xlinkns, "href", newhref);
		}
	}
	return outputSvg;
}

function createNewWindow (input) {
	var docType = input.title;
	var windowName = input.id;//label
	var doc = str2Xml(input.value);
	var strWindowFeatures = "menubar=yes,location=yes,resizable=yes,scrollbars=yes,status=yes";
	var windowObjectReference = window.open("", windowName, strWindowFeatures);//[, strWindowFeatures]
	windowObjectReference.document.open("image/svg+xml");
	windowObjectReference.document.write(input.value);
}
