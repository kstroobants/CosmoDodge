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
        collisionTestingOnlyMode: true
    }

    MovementAnimation {
        id: moveY
        target: parent
        property: "y"
        velocity: 150
        running: true
    }

    onYChanged: {
        if(y > scene.height) {
            y = -2.5*scene.height
            x = utils.generateRandomValueBetween(0, scene.width-width)
        }
    }

}
