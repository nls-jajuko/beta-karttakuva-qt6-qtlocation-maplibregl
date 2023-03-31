// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
// modified by nls-jajuko@users.noreply.github.com

#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQuick/QQuickWindow>
#include <QSGRendererInterface>
#include <QString>


int main(int argc, char *argv[])
{
    QVariantMap parameters;
    parameters["latitude"] = 60.17796;
    parameters["longitude"] = 24.8071;
    parameters["zoomLevel"] = 13;


    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
    QGuiApplication application(argc, argv);

    QQmlApplicationEngine engine;

    engine.addImportPath(QStringLiteral(":/imports"));
    engine.load(QUrl(QStringLiteral("qrc:///mapviewer.qml")));


    QObject *item = engine.rootObjects().constFirst();

    QMetaObject::invokeMethod(
        item, "createMap",
        Q_ARG(QVariant, QVariant::fromValue(parameters))
    );

    return application.exec();

}
