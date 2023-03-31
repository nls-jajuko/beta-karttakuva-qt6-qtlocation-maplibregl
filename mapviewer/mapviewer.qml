// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
// modified by nls-jajuko@users.noreply.github.com

import QtQuick
import QtQuick.Controls
import QtLocation
import QtPositioning
import "map"
import "menus"

ApplicationWindow {
    id: appWindow
    property variant map


    property variant styles : [{
            tr: qsTr("Maastokartta"),
            style: "qrc:/stylejson/maastokartta-3857.json"
        },{
            tr: qsTr("Taustakartta"),
            style: "qrc:/stylejson/taustakartta-3857.json"
        },{
            tr: qsTr("Kiinteistöjaotus maastokartta"),
            style: "qrc:/stylejson/kiinteistojaotus-maastokartta-3857.json"
        },{
            tr: qsTr("Kiinteistöjaotus ortokuva"),
            style: "qrc:/stylejson/kiinteistojaotus-ortokuva-3857.json"
        },{
            tr: qsTr("Kiinteistöjaotus taustakarttarasteri"),
            style: "qrc:/stylejson/kiinteistojaotus-taustakarttarasteri-3857.json"
        }
    ];

    property variant styleParam : PluginParameter {
        name: 'maplibregl.mapping.additional_style_urls';
        value: styles.map(s=>s.style).join(',');

    };
    property variant parameters: [
        appWindow.styleParam
    ];

    title: qsTr("BetaKarttakuva")
    height: 640
    width: 360
    visible: true
    menuBar: mainMenu

    MainMenu {
        id: mainMenu

        onSelectMapType: (mapType) => {
                             for (var i = 0; i < mapTypeMenu.count; i++) {
                                 mapTypeMenu.actionAt(i).checked = mapTypeMenu.actionAt(i).text === mapType.name
                             }
                             mapView.map.activeMapType = mapType
                         }
    }




    StackView {
        id: stackView
        anchors.fill: parent
        focus: true
        initialItem: Item {
            id: page

            MapComponent{
                id: mapView
                width: page.width
                height: page.height

                map.plugin: Plugin { name : 'maplibregl' ; parameters: appWindow.parameters }

            }

        }

        function closeForm()
        {
            pop(page)
        }
    }

    function createMap(params)
    {
        mapView.map.center = {
            latitude: params.latitude,
            longitude: params.longitude
        }

        mapView.map.zoomLevel = params.zoomLevel;


        mainMenu.mapTypeMenu.createMenu(mapView.map,styles)
    }


}
