import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"
    width: 20
    height: 48

    GameSpriteSequence {
        id: ship
        anchors.centerIn: playerCollider

        GameSprite {
            frameCount: 2
            frameRate: 5
            frameWidth: 20
            frameHeight: 48
            source: Qt.resolvedUrl("../assets/shipSprite.png")
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
        fixture.onContactChanged: {
            var otherEntity = other.getBody().target
            var otherEntityType = otherEntity.entityType
            if(otherEntityType === "asteroid") {
                player.die()
            }
        }
    }

    MovementAnimation {
        id: moveX
        target: parent
        property: "x"
        velocity: twoAxisController.xAxis*250
        running: false
        minPropertyValue: scene.gameWindowAnchorItem.x
        maxPropertyValue: scene.width-player.width
    }

    MovementAnimation {
        id: moveY
        target: parent
        property: "y"
        velocity: - twoAxisController.yAxis*250
        running: false
        minPropertyValue: scene.gameWindowAnchorItem.y
        maxPropertyValue: scene.height-player.height
    }

    // die and restart game
    function die() {
        // reset position
        player.x = (scene.width / 2) - player.width/2
        player.y = 200
        scene.state = "gameOver"
    }

    function stop() {
        moveX.stop()
        moveY.stop()
        ship.running = false
    }

    function start() {
        moveX.start()
        moveY.start()
        ship.running = true
    }

}
