/*
 *   Copyright 2016 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
 
import QtQuick 2.8
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5
import org.kde.plasma.core 2.0

ColumnLayout {
    
    property string exobold : "Fonts/exo-bold.otf"

   
    FontLoader{
        id : exoboldfont
        source : exobold
    }

    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software
       Label {
        text: Qt.formatTime(timeSource.data["Local"]["DateTime"], "hh:mm:ss")
        color: "white"
        opacity: 0.5
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 65
        font.bold: true
        Layout.alignment: Qt.AlignHCenter
        font.family: exoboldfont.name

    }
    Label {
        text: Qt.formatDateTime(new Date(), "d MMMM yyyy, dddd")
        color: "white"
        opacity: 0.5
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 20
        font.weight: Font.DemiBold
        font.capitalization: Font.Capitalize
        Layout.alignment: Qt.AlignHCenter
        font.family: exoboldfont.name

    }
 
    DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }

}
