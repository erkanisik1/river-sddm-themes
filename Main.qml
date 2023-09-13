import QtQuick 2.8
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.1
import QtMultimedia 5.8
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.4

import "logic.js" as Logic
import "components"

Rectangle{
	id : root
	property date dateTime: new Date()
    property variant geometry: screenModel.geometry(screenModel.primary)
    width: geometry.width
    height: geometry.height 
    property string exobold : "components/Fonts/exo-bold.otf"
    property bool softwareRendering: true

    FontLoader{
        id : exoboldfont
        source : exobold
    }



    Item{
    	id: mainFrame
    	anchors.fill: parent

    	TextConstants {
        	id: textConstants
    	}

    	//Video Background
    	Rectangle{
    		id: mainFrameBackgroundVideo
    		anchors.fill: parent
    		visible: Logic.isVideo
    		color:"#111"

    		MediaPlayer{
    			id: previewPlayer
    			source: Logic.cfgBackground
    			onPositionChanged: { previewPlayer.pause()}
    		}
    		VideoOutput{
    			anchors.fill: parent
    			source: previewPlayer
    			fillMode: VideoOutput.PreserveAspectCrop
    		}
    		MediaPlayer{
    			id: videoPlayer
    			source: Logic.cfgBackground
    			autoPlay: true
    			loops: MediaPlayer.Infinite
    		}
    		VideoOutput{
    			anchors.fill: parent
    			source: videoPlayer
    			fillMode: VideoOutput.PreserveAspectCrop
    		}
    	}

    	Connections {
		    target: sddm
		    function loginFailed() {
		        password.placeholderText = textConstants.loginFailed;
		        password.placeholderTextColor = "white";
		        password.text = "";
		        password.focus = true;
		        errorMsgContainer.visible = true;
		    }
		}



		 // Shutdown button
	    Row {
	        anchors.top: parent.top
	        anchors.right: parent.right
	        anchors.rightMargin: 40
	        anchors.topMargin: 15

	        Item {
	            Image {
	                id: shutdown
	                height: 22
	                width: 22
	                source: "images/system-shutdown.svg"
	                fillMode: Image.PreserveAspectFit

	                MouseArea {
	                    anchors.fill: parent
	                    hoverEnabled: true
	                    onEntered: {
	                        shutdown.source = "images/system-shutdown-hover.svg"
	                        var component = Qt.createComponent(
	                                    "components/ShutdownToolTip.qml")
	                        if (component.status === Component.Ready) {
	                            var tooltip = component.createObject(shutdown)
	                            tooltip.x = -100
	                            tooltip.y = 40
	                            tooltip.destroy(600)
	                        }
	                    }
	                    onExited: {
	                        shutdown.source = "images/system-shutdown.svg"
	                    }
	                    onClicked: {
	                        shutdown.source = "images/system-shutdown-pressed.svg"
	                        sddm.powerOff()
	                    }
	                }
	            }
	        }
	    }

	    // Reboot button
	    Row {
	        anchors.top: parent.top
	        anchors.right: parent.right
	        anchors.rightMargin: 70
	        anchors.topMargin: 15

	        Item {
	            Image {
	                id: reboot
	                height: 22
	                width: 22
	                source: "images/system-reboot.svg"
	                fillMode: Image.PreserveAspectFit

	                MouseArea {
	                    anchors.fill: parent
	                    hoverEnabled: true
	                    onEntered: {
	                        reboot.source = "images/system-reboot-hover.svg"
	                        var component = Qt.createComponent(
	                                    "components/RebootToolTip.qml")
	                        if (component.status === Component.Ready) {
	                            var tooltip = component.createObject(reboot)
	                            tooltip.x = -100
	                            tooltip.y = 40
	                            tooltip.destroy(600)
	                        }
	                    }
	                    onExited: {
	                        reboot.source = "images/system-reboot.svg"
	                    }
	                    onClicked: {
	                        reboot.source = "images/system-reboot-pressed.svg"
	                        sddm.reboot()
	                    }
	                }
	            }
	        }
	    }

	    // Keyboard Select
	    Row {
	        anchors.top: parent.top
	        anchors.right: parent.right
	        anchors.rightMargin: 88
	        anchors.topMargin: 15
	        Text {
	            id: kb
	            color: "#eff0f1"
	            text: keyboard.layouts[keyboard.currentLayout].shortName
	            font.pointSize: 12
	            font.weight: Font.DemiBold
	            font.family: exoboldfont.name
	        }
	    }

	    // Session Select
	    Row {
	        anchors.top: parent.top
	        anchors.right: parent.right
	        anchors.rightMargin: 110
	        anchors.topMargin: 15

	         ComboBox {
	                    id: session
	                    height: 22
	                    width: 150
	                    model: sessionModel
	                    textRole: "name"
	                    displayText: ""
	                    currentIndex: sessionModel.lastIndex
	                    background: Rectangle {
	                    implicitWidth: parent.width
	                    implicitHeight: parent.height
	                    color: "transparent"
	                }


	                    delegate: MenuItem {
	                        id: menuitems
	                        width: slistview.width * 4
	                        text: session.textRole ? (Array.isArray(session.model) ? modelData[session.textRole] : model[session.textRole]) : modelData
	                        highlighted: session.highlightedIndex === index
	                        hoverEnabled: session.hoverEnabled
	                        onClicked: {
	                            ava.source = "/var/lib/AccountsService/icons/" + user.currentText
	                            session.currentIndex = index
	                            slistview.currentIndex = index
	                            session.popup.close()
	                        }
	                    }
	                    indicator: Rectangle{
	                        anchors.right: parent.right
	                        anchors.rightMargin: 9
	                        height: parent.height
	                        width: 22
	                        color: "transparent"
	                        Image{
	                            anchors.verticalCenter: parent.verticalCenter
	                            width: parent.width
	                            height: width
	                            fillMode: Image.PreserveAspectFit
	                            source: "images/conf.svg"
	                        }
	                    }
	                    popup: Popup {
	                        width: parent.width
	                        height: parent.height * menuitems.count
	                        implicitHeight: slistview.contentHeight
	                        margins: 0
	                        contentItem: ListView {
	                            id: slistview
	                            clip: true
	                            anchors.fill: parent
	                            model: session.model
	                            spacing: 0
	                            highlightFollowsCurrentItem: true
	                            currentIndex: session.highlightedIndex
	                            delegate: session.delegate
	                        }
	                    }

	                }
	    }

	    // Clock
	    Item {
		    width: parent.width
		   	Rectangle {
		       height: 300
		       width: 400
		       anchors.horizontalCenter: parent.horizontalCenter
		       color: "transparent"
		            Clock {
		            id: clock
		            visible: true
		            anchors.topMargin: 100
		            anchors.horizontalCenter: parent.horizontalCenter
		            //anchors.bottom: parent.bottom
		        }
		    }
		}

		Item {
	        width: dialog.width
	        height: dialog.height
	        anchors.horizontalCenter: parent.horizontalCenter
	        anchors.bottom: parent.bottom
	        Rectangle {
	            id: dialog
	            color: "transparent"
	            height: 270
	            width: 400
	        }

	        Grid {
	            columns: 1
	            spacing: 8
	            verticalItemAlignment: Grid.AlignVCenter
	            horizontalItemAlignment: Grid.AlignHCenter
	            anchors.horizontalCenter: parent.horizontalCenter

	            Column {
	                Item {
	                    Rectangle {
	                        id: mask
	                        width: 85
	                        height: 85
	                        radius: 100
	                        visible: false
	                    }

	                    DropShadow {
	                	    anchors.fill: mask
	                        width: mask.width
	                        height: mask.height
	                        horizontalOffset: 0
	                        verticalOffset: 0
	                        radius: 15.0
	                        samples: 15
	                        color: "#50000000"
	                        source: mask
	                    }
	                }
	                Image {
	                    id: ava
	                    width: 86
	                    height: 86
	                    fillMode: Image.PreserveAspectCrop
	                    layer.enabled: true
	                    layer.effect: OpacityMask {
	                        maskSource: mask
	                    }
	                    source: "/var/lib/AccountsService/icons/" + user.currentText
	                    onStatusChanged: {
	                        if (status == Image.Error)
	                            return source = "images/no_face.png"
	                        }
	                    }
	            }
	            // Custom ComboBox for hack colors on DropDownMenu
	            ComboBox {
	                id: user
	                height: 40
	                width: 226
	                textRole: "name"
	                currentIndex: userModel.lastIndex
	                model: userModel

	                background: Rectangle {
		                    implicitWidth: parent.width
		                    implicitHeight: parent.height
		                    Layout.alignment: Qt.AlignHCenter
		                    color: "transparent"
	                }
	                contentItem: Text {
	                       font.pointSize: 15
	                       text: user.currentText
	                       color: "white"
	                       font.bold: true
	                       font.family: exoboldfont.name
	                       anchors.horizontalCenter: parent.horizontalCenter
	                       verticalAlignment: Text.AlignVCenter
	                       horizontalAlignment: Text.AlignHCenter
	                }
	                delegate: MenuItem {
	                        font.bold: true
	                        width: parent.width - 24
	                        text: user.textRole ? (Array.isArray(
	                                                   user.model) ? modelData[user.textRole] : model[user.textRole]) : modelData
	                        highlighted: user.highlightedIndex === index
	                        hoverEnabled: user.hoverEnabled
	                        onClicked: {
	                            user.currentIndex = index
	                            ulistview.currentIndex = index
	                            user.popup.close()
	                            ava.source = ""
	                            ava.source = "/home/" + user.currentText + "/no_face.png"
	                        }
	                }
                    indicator: Rectangle{
	                        anchors.right: parent.right
	                        anchors.rightMargin: 9
	                        height: parent.height
	                        width: 24
	                        color: "transparent"
	                        Image{
	                            anchors.verticalCenter: parent.verticalCenter
	                            width: parent.width
	                            height: width
	                            fillMode: Image.PreserveAspectFit
	                            source: "images/go-down.svg"
	                        }
                    }
                    popup: Popup {
	                        width: parent.width
	                        height: parent.height * parent.count
	                        implicitHeight: ulistview.contentHeight
	                        margins: 0
	                        contentItem: ListView {
	                            id: ulistview
	                            clip: true
	                            anchors.fill: parent
	                            model: user.model
	                            spacing: 0
	                            highlightFollowsCurrentItem: true
	                            currentIndex: user.highlightedIndex
	                            delegate: user.delegate
	                        }
                    }
	            }
	            TextField {
	                id: password
	                height: 32
	                width: 250
	                color: "#fff"
	                echoMode: TextInput.Password
	                focus: true
	                placeholderText: "Password"
	                onAccepted: sddm.login(user.currentText, password.text, session.currentIndex)

	                background: Rectangle {
	                    implicitWidth: parent.width
	                    implicitHeight: parent.height
	                    color: "#fff"
	                    opacity: 0.2
	                    radius: 15
	                }

	                Image {
	                    id: caps
	                    width: 24
	                    height: 24
	                    opacity: 0
	                    state: keyboard.capsLock ? "activated" : ""
	                    anchors.right: password.right
	                    anchors.verticalCenter: parent.verticalCenter
	                    anchors.rightMargin: 10
	                    fillMode: Image.PreserveAspectFit
	                    source: "images/capslock.svg"
	                    sourceSize.width: 24
	                    sourceSize.height: 24
	                    states: [
	                            State {
	                                name: "activated"
	                                PropertyChanges {
	                                    target: caps
	                                    opacity: 1
	                                }
	                            },
	                            State {
	                                name: ""
	                                PropertyChanges {
	                                    target: caps
	                                    opacity: 0
	                                }
	                            }
	                    ]

	                    transitions: [
	                        Transition {
	                            to: "activated"
	                            NumberAnimation {
	                                target: caps
	                                property: "opacity"
	                                from: 0
	                                to: 1
	                                duration: imageFadeIn
	                            }
	                        },
                            Transition {
                                to: ""
                                NumberAnimation {
                                    target: caps
                                    property: "opacity"
                                    from: 1
                                    to: 0
                                    duration: imageFadeOut
                                }
                            }
	                    ]
	                }
	            }

	          	Label {
		            id: greetingLabel
		            color: "#fff"
		            style: softwareRendering ? Text.Outline : Text.Normal
		            styleColor: softwareRendering ? ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
		            font.pointSize:8
		            Layout.alignment: Qt.AlignHCenter
		            font.family: exoboldfont.name
		            font.bold: true
	            }
	            Keys.onPressed: {
	                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
	                    sddm.login(user.currentText, password.text, session.currentIndex)
	                    event.accepted = true
	                }
	            }
	        }
	    }



    }
}