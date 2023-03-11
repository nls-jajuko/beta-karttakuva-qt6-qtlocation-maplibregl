/****************************************************************************
**
** Copyright (C) 2022 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick
import QtQuick.Controls
import QtLocation
import QtPositioning
import "../helper.js" as Helper

Map {
    id: map
    property int lastX : -1
    property int lastY : -1
    property int pressX : -1
    property int pressY : -1
    property int jitterThreshold : 30
    property variant scaleLengths: [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000,
        10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]

    center {
        latitude: 60.17796
        longitude: 24.8071
    }



    function calculateScale()
    {
        var coord1, coord2, dist, text, f
        f = 0
        coord1 = map.toCoordinate(Qt.point(0,scale.y))
        coord2 = map.toCoordinate(Qt.point(0+scaleImage.sourceSize.width,scale.y))
        dist = Math.round(coord1.distanceTo(coord2))

        if (dist === 0) {
            // not visible
        } else {
            for (var i = 0; i < scaleLengths.length-1; i++) {
                if (dist < (scaleLengths[i] + scaleLengths[i+1]) / 2 ) {
                    f = scaleLengths[i] / dist
                    dist = scaleLengths[i]
                    break;
                }
            }
            if (f === 0) {
                f = dist / scaleLengths[i]
                dist = scaleLengths[i]
            }
        }

        text = Helper.formatDistance(dist)
        scaleImage.width = (scaleImage.sourceSize.width * f) - 2 * scaleImageLeft.sourceSize.width
        scaleText.text = text
    }

    zoomLevel:  (maximumZoomLevel - minimumZoomLevel)/2

    // Enable pan, flick, and pinch gestures to zoom in and out
    gesture.acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.FlickGesture |
                              MapGestureArea.PinchGesture | MapGestureArea.RotationGesture | MapGestureArea.TiltGesture
    gesture.flickDeceleration: 3000
    gesture.enabled: true
    focus: true
    onCopyrightLinkActivated: Qt.openUrlExternally(link)

    onCenterChanged:{
        scaleTimer.restart()
    }

    onZoomLevelChanged:{
        scaleTimer.restart()
    }

    onWidthChanged:{
        scaleTimer.restart()
    }

    onHeightChanged:{
        scaleTimer.restart()
    }

    Component.onCompleted: {
    }

    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Plus) {
                            map.zoomLevel++;
                        } else if (event.key === Qt.Key_Minus) {
                            map.zoomLevel--;
                        } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Right ||
                                   event.key === Qt.Key_Up   || event.key === Qt.Key_Down) {
                            var dx = 0;
                            var dy = 0;

                            switch (event.key) {

                                case Qt.Key_Left: dx = map.width / 4; break;
                                case Qt.Key_Right: dx = -map.width / 4; break;
                                case Qt.Key_Up: dy = map.height / 4; break;
                                case Qt.Key_Down: dy = -map.height / 4; break;

                            }

                            var mapCenterPoint = Qt.point(map.width / 2.0 - dx, map.height / 2.0 - dy);
                            map.center = map.toCoordinate(mapCenterPoint);
                        }
                    }


    MapQuickItem {
        id: esbo
        sourceItem: Rectangle { width: 14; height: 14; color: "#e41e25"; border.width: 2; border.color: "white"; smooth: true; radius: 7 }
        coordinate {
            latitude: 60.17796
            longitude: 24.8071
        }
        opacity: 1.0
        anchorPoint: Qt.point(sourceItem.width/2, sourceItem.height/2)
    }

    Item {
        id: scale
        z: map.z + 3
        visible: scaleText.text !== "0 m"
        anchors.bottom: parent.bottom;
        anchors.right: parent.right
        anchors.margins: 20
        height: scaleText.height * 2
        width: scaleImage.width

        Image {
            id: scaleImageLeft
            source: "../resources/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImage.left
        }
        Image {
            id: scaleImage
            source: "../resources/scale.png"
            anchors.bottom: parent.bottom
            anchors.right: scaleImageRight.left
        }
        Image {
            id: scaleImageRight
            source: "../resources/scale_end.png"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
        }
        Label {
            id: scaleText
            color: "#004EAE"
            anchors.centerIn: parent
            text: "0 m"
        }
        Component.onCompleted: {
            map.calculateScale();
        }
    }

    Timer {
        id: scaleTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            map.calculateScale()
        }
    }

    MouseArea {
        id: mouseArea
        property variant lastCoordinate
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: (mouse) => {
                       map.lastX = mouse.x
                       map.lastY = mouse.y
                       map.pressX = mouse.x
                       map.pressY = mouse.y
                       lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                   }

        onPositionChanged: (mouse) => {
                               if (mouse.button === Qt.LeftButton) {
                                   map.lastX = mouse.x
                                   map.lastY = mouse.y
                               }
                           }

        onDoubleClicked: (mouse) => {
                             var mouseGeoPos = map.toCoordinate(Qt.point(mouse.x, mouse.y));
                             var preZoomPoint = map.fromCoordinate(mouseGeoPos, false);
                             if (mouse.button === Qt.LeftButton) {
                                 map.zoomLevel = Math.floor(map.zoomLevel + 1)
                             } else if (mouse.button === Qt.RightButton) {
                                 map.zoomLevel = Math.floor(map.zoomLevel - 1)
                             }
                             var postZoomPoint = map.fromCoordinate(mouseGeoPos, false);
                             var dx = postZoomPoint.x - preZoomPoint.x;
                             var dy = postZoomPoint.y - preZoomPoint.y;

                             var mapCenterPoint = Qt.point(map.width / 2.0 + dx, map.height / 2.0 + dy);
                             map.center = map.toCoordinate(mapCenterPoint);

                             lastX = -1;
                             lastY = -1;
                         }

        onPressAndHold: (mouse) => {
                            if (Math.abs(map.pressX - mouse.x ) < map.jitterThreshold
                                && Math.abs(map.pressY - mouse.y ) < map.jitterThreshold) {
                            }
                        }
    }
}
