# Generated from mapviewer.pro.

cmake_minimum_required(VERSION 3.16)
project(qml_location_mapviewer LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if(NOT DEFINED INSTALL_EXAMPLESDIR)
  set(INSTALL_EXAMPLESDIR "examples")
endif()

set(INSTALL_EXAMPLEDIR "${INSTALL_EXAMPLESDIR}/location/mapviewer")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS Qml)
find_package(Qt6 COMPONENTS Network)
find_package(Qt6 COMPONENTS Quick)
find_package(Qt6 COMPONENTS Positioning)
find_package(Qt6 COMPONENTS Location)
find_package(Qt6 REQUIRED COMPONENTS OpenGL)

qt_add_executable(qml_location_mapviewer WIN32 MACOSX_BUNDLE
    main.cpp
)
target_link_libraries(qml_location_mapviewer PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Location
    Qt::Network
    Qt::Positioning
    Qt::Qml
    Qt::Quick
    Qt::OpenGL
)


# Resources:
set(mapviewer_resource_files
    "helper.js"
    "map/CircleItem.qml"
    "map/ImageItem.qml"
    "map/MapComponent.qml"
    "mapviewer.qml"
    "menus/MainMenu.qml"
    "stylejson/kiinteistojaotus-maastokartta-3857.json"
    "stylejson/kiinteistojaotus-ortokuva-3857.json"
    "stylejson/kiinteistojaotus-taustakarttarasteri-3857.json"
    "stylejson/maastokartta-3857.json"
    "stylejson/taustakartta-3857.json"
    "resources/icon.png"
    "resources/scale.png"
    "resources/scale_end.png"

)

qt6_add_resources(qml_location_mapviewer "mapviewer"
    PREFIX
        "/"
    FILES
        ${mapviewer_resource_files}
)

if(QT_FEATURE_geoservices_maplibregl)
    target_link_libraries(qml_location_mapviewer PUBLIC
        Qt::Sql
    )
endif()

install(TARGETS qml_location_mapviewer
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
