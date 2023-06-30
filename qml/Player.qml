import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"
    width: 20
    height: 48

    GameSpriteSequence {
        id: rocket
        anchors.centerIn: playerCollider

        // To show the engine is on of the rocket
        GameSprite {
            frameCount: 2
            frameRate: 5
            frameWidth: 20
            frameHeight: 48
            source: Qt.resolvedUrl("../assets/rocketSprite.png")
        }
    }

    // Keyboard access
    property alias controller: twoAxisController

    TwoAxisController {
        id: twoAxisController
    }

    // You loose when there is a collision with any asteroid
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

    // Keyboard movement in the x direction. Not possible to go out of the screen
    MovementAnimation {
        id: moveX
        target: parent
        property: "x"
        velocity: twoAxisController.xAxis*250
        running: false
        minPropertyValue: scene.gameWindowAnchorItem.x
        maxPropertyValue: scene.width-player.width
    }

    // Keyboard movement in the y direction. Not possible to go out of the screen
    MovementAnimation {
        id: moveY
        target: parent
        property: "y"
        velocity: - twoAxisController.yAxis*250
        running: false
        minPropertyValue: scene.gameWindowAnchorItem.y
        maxPropertyValue: scene.height-player.height
    }

    // Die and restart the game
    function die() {
        // Reset the position
        player.x = (scene.width / 2) - player.width/2
        player.y = 200

        // Set the state of the game
        scene.state = "gameOver"
    }

    // Stop keyboard movement and engine
    function stop() {
        moveX.stop()
        moveY.stop()
        rocket.running = false
    }

    // Start keyboard movement and engine
    function start() {
        moveX.start()
        moveY.start()
        rocket.running = true
    }

}
