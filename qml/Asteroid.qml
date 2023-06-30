import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: asteroid
    entityType: "asteroid"
    width: 48
    height: 48

    Image {
        id: asteroidImg
        source: Qt.resolvedUrl("../assets/asteroids.png")
        anchors.fill: asteroid
    }

    BoxCollider {
        id: asteroidCollider
        width: parent.width
        height: parent.height
        bodyType: Body.Dynamic
        collisionTestingOnlyMode: true // No external forces
    }

    // Move the object from top to bottom with an increasing velocity
    MovementAnimation {
        id: moveY
        target: parent
        property: "y"
        velocity: 150 + 5*scene.score
        running: false
    }

    onYChanged: {
        // Check if object passed the bottom of the screen
        if(y > scene.height) {
            // Place the object back to the top
            y = -2.5*scene.height
            x = utils.generateRandomValueBetween(0, scene.width-width)

            // Increase the score as it is dodged
            scene.score += 1
        }
    }

    // Stop the movevement of the object
    function stop() {
        moveY.stop()
    }

    // Start the movevement of the object
    function start() {
        moveY.start()
    }

}
