import QtQuick 2.12
import QtQuick.Dialogs 1.0
import QtQuick.Window 2.13
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0


Window {
	id : root
	width: 500
    height: 600
	maximumHeight : height
	minimumHeight : height
	maximumWidth : width
	minimumWidth : width
	title:"SYERGIE KML TO CSV CONVERTER"
	color : "#064663"
    visible: true
    //flags: Qt.WindowMaximized //Qt.Dialog
	
	Text{
	x: 10
	y:30
	text:"SYERGIE KML CONVERTER"
	font.pixelSize:25
	font.bold: true
	color :"#FFB200"
	}
	
	
	Text{
	x:10
	y:90
	text:".KML TO .CSV CONVERTER : "
	font.pixelSize:20
	color :"#FFB200"
	}
	
	
	Button {
		x :10
		y :130
		width : 120
		text: "Browse file .KML"
		
		palette {
        button: "#FFB200"
		buttonText: "black"
		}
		
		onClicked:{
			fileDialog.visible = true
			
		}
		
	}
	
	Text{
	id : file_target
	x:10
	y:180
	width : parent.width
	font.family: "Helvetica"
	wrapMode: Text.WordWrap 
	horizontalAlignment:Text.AlignJustify //Text.AlignHCenter //Text.AlignJustify
	text:"output file name"
	font.pixelSize:12
	color :"#FFB200"
	}
	
	
	
	
	Button {
		x :330
		y :130
		width : 150
		text: "Convert .KML to .CSV"
		
		palette {
        button: "#FFB200"
		buttonText: "black"
		}
		
		onClicked:{
			backend.convert("yes", file_name.text)
		}
		
	}
	
	
	TextField{
	id : file_name
	anchors.horizontalCenter: parent.horizontalCenter
	width : parent.width - 20
	x: 10
	y: 250
	text : "output file name"
	}
	
	
	
	
	Text{
	id : status
	x: 150
	y: 140
	font.family: "Helvetica"
	text:"STATUS"
	font.pixelSize:14
	color :"#FFB200"
	}
	
	
	Text{
	x:10
	y:350
	text:".CSV TO .JS CONVERTER : "
	font.pixelSize:20
	color :"#FFB200"
	}
	
	
	
	
	Button {
		x :10
		y :380
		width : 120
		text: "Browse file .CSV"
		
		palette {
			button: "#FFB200"
			buttonText: "black"
		}
		
		onClicked:{
			filecsv.visible = true
			
			
			
		}
	}
	
	
	
	Button {
		x :330
		y :380
		width : 150
		text: "Convert .CSV to .JS"
		
		palette {
        button: "#FFB200"
		buttonText: "black"
		}
		
		
		onClicked:{
			backend.convert("yes_1", file_name_1.text)
			backend.convert_js(file_name_1.text)
			
		}
		
	}
	
	
	Text{
		id : file_target_2
		x:10
		y:430
		width : parent.width
		font.family: "Helvetica"
		wrapMode: Text.WordWrap 
		horizontalAlignment:Text.AlignJustify //Text.AlignHCenter //Text.AlignJustify
		text:"file : "
		font.pixelSize:12
		color :"#FFB200"
	}
	
	
	
	TextField{
	id : file_name_1
	anchors.horizontalCenter: parent.horizontalCenter
	width : parent.width - 20
	x: 10
	y: 490
	text : "output file name"
	}
	
	
	
	
	
	FileDialog {
		id: fileDialog
		title: "Please choose a file"
		folder: shortcuts.home
		//selectFolder : true
		nameFilters: [ "*.kml" ]
		visible : false
    
	onAccepted: {
        console.log("You chose: " + fileDialog.fileUrls)
		backend.folder_read(fileDialog.fileUrls)
		fileDialog.visible = false
    }
    
	onRejected: {
        console.log("Canceled")
		fileDialog.visible = false
    }
    
	}
	
	
	
	
	
	
	FileDialog {
		id: filecsv
		title: "Please choose a file"
		folder: shortcuts.home
		
		nameFilters: [ "*.csv" ]
		visible : false
    
	onAccepted: {
        console.log("You chose: " + filecsv.fileUrls)
		backend.folder_csv_read(filecsv.fileUrls)
		filecsv.visible = false
    }
    
	onRejected: {
        console.log("Canceled")
		filecsv.visible = false
    }
    
	}
	
	
	
	
	
	Timer{
		id:variable_transfer
		interval: 50
		repeat: true
		running: true
		onTriggered: {
			//console.log("print")
			file_target.text = "file : " + backend.folder_write()
			status.text = "Status : " + backend.status()
			file_target_2.text = "file : " + backend.folder_csv_write()
		}
		}
	
}
