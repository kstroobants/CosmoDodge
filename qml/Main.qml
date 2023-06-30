import Felgo 4.0
import QtQuick 2.0

GameWindow {
    id: gameWindow

    activeScene: scene

    screenWidth: 960
    screenHeight: 640

    EntityManager {
        id: entityManager
        entityContainer: scene
    }

    Scene {
        id: scene

        width: 480
        height: 320

        sceneAlignmentY: "bottom"

        Keys.forwardTo: player.controller

        Image {
            id: bg
            source: Qt.resolvedUrl("../assets/bgSpace.jpg")
            anchors.fill: scene.gameWindowAnchorItem
            anchors.horizontalCenter: scene.gameWindowAnchorItem.horizontalCenter
            anchors.bottom: scene.gameWindowAnchorItem.bottom
        }

        Player {
            id: player
            x: scene.width / 2
            y: 200
        }

    }
}
