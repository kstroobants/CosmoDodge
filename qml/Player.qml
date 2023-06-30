import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"
    width: 48
    height: 48

    GameSpriteSequence {
        id: ship
        anchors.centerIn: playerCollider

        GameSprite {
            frameCount: 2
            frameRate: 5
            frameWidth: 48
            frameHeight: 48
            source: Qt.resolvedUrl("../assets/shipSprite2.png")
        }
    }

    property alias controller: twoAxisController

    TwoAxisController {
        id: twoAxisController
    }

    BoxCollider {
        id: playerCollider
        width: parent.width
        height: parent.height
        bodyType: Body.Dynamic
        collisionTestingOnlyMode: true
    }

    MovementAnimation {
        id: moveX
        target: parent
        property: "x"
        velocity: twoAxisController.xAxis*250
        running: true
        minPropertyValue: scene.gameWindowAnchorItem.x
        maxPropertyValue: scene.width-player.width
    }

    MovementAnimation {
        id: moveY
        target: parent
        property: "y"
        velocity: - twoAxisController.yAxis*250
        running: true
        minPropertyValue: scene.gameWindowAnchorItem.y
        maxPropertyValue: scene.height-player.height
    }

}
