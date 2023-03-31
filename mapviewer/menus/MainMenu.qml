// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
// modified by nls-jajuko@users.noreply.github.com

import QtQuick
import QtQuick.Controls
import QtLocation

MenuBar {
    id: menuBar

    property variant mapTypeMenu: mapTypeMenu

    signal selectMapType(variant mapType)

    function clearMenu(menu)
    {
        while (menu.count)
            menu.removeItem(menu.itemAt(0))
    }

    Menu {
        id: mapTypeMenu
        title: qsTr("Style")

        Component {
            id: mapTypeMenuActionComponent
            Action {

            }
        }
        function createMenu(map,styles)
        {
            clearMenu(mapTypeMenu)
            for (var i = 0; i<map.supportedMapTypes.length; i++) {
                var style = map.supportedMapTypes[i];
                var tr = styles.filter(s=>s.style===style.name).map(s=>s.tr)[0]||style.name;
                createMapTypeMenuItem(style, tr, map.activeMapType === style);
            }

        }

        function createMapTypeMenuItem(mapType, tr, checked)
        {
            var action = mapTypeMenuActionComponent.createObject(mapTypeMenu,
                                                                 { text: tr, checkable: true, checked: checked })
            action.triggered.connect(function(){selectMapType(mapType)})
            addAction(action)
        }
    }


}
