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

        property int score: 0
        property int scoreBest: 0

        state: "start"

        Image {
            id: bg
            source: Qt.resolvedUrl("../assets/bgSpace.jpg")
            anchors.fill: scene.gameWindowAnchorItem
            anchors.horizontalCenter: scene.gameWindowAnchorItem.horizontalCenter
            anchors.bottom: scene.gameWindowAnchorItem.bottom
        }

        PhysicsWorld {
            debugDrawVisible: false
            updatesPerSecondForPhysics: 60
            gravity.y: 0
        }

        Player {
            id: player
            x: (scene.width / 2) - width/2
            y: 200
            visible: scene.state !== "start"
        }

        Repeater {
            id: repeater
            model: 8
            Asteroid {}
        }

        Text {
            text: scene.score
            anchors.top: scene.gameWindowAnchorItem.top
            anchors.horizontalCenter: scene.gameWindowAnchorItem.horizontalCenter
            color: "#FBFBFB"
            font.pixelSize: 64
            visible: scene.state === "playing"
        }

        MouseArea {
            id: mouseArea
            anchors.fill: playImg
            onClicked: {
                if(scene.state === "start") { // if the game is ready and you click the screen we start the game
                    scene.state = "playing"
                }
                if(scene.state === "gameOver") // if the player is dead and you click the screen we restart the game
                {
                    scene.state = "playing"
                }
            }
            onPressed: {
                playImg.opacity = 0.5
            }
            onReleased: {
                playImg.opacity = 1.0
            }
        }

        Image {
            id: playImg
            anchors.horizontalCenter: scene.horizontalCenter
            source: Qt.resolvedUrl("../assets/play.png")
            visible: scene.state !== "playing"
        }

        Image {
            id: startImgLogo
            anchors.bottom: startImgLogoText.top
            anchors.bottomMargin: 50
            anchors.horizontalCenter: scene.horizontalCenter
            source: Qt.resolvedUrl("../assets/spaceLogo.png")
            visible: scene.state === "start"
        }

        Image {
            id: startImgLogoText
            anchors.bottom: playImg.top
            anchors.bottomMargin: 100
            anchors.horizontalCenter: scene.horizontalCenter
            source: Qt.resolvedUrl("../assets/logoText.png")
            visible: scene.state === "start"
        }

        Image {
            id: gameOverImg
            anchors.bottom: scoreBoard.top
            anchors.bottomMargin: 50
            anchors.horizontalCenter: scene.horizontalCenter
            source: Qt.resolvedUrl("../assets/gameOver.png")
            visible: scene.state === "gameOver"
        }

        Rectangle {
            id: scoreBoard
            anchors.bottom: playImg.top
            anchors.bottomMargin: 100
            anchors.horizontalCenter: scene.horizontalCenter
            width: gameOverImg.width
            height: 150
            color: "#FBFBFB"
            border.color: "#48BEFD"
            border.width: 5
            radius: 10
            visible: scene.state === "gameOver"
        }

        Text {
            text: "Score"
            anchors.right: scoreBoard.right
            anchors.rightMargin: 30
            anchors.top: scoreBoard.top
            anchors.topMargin: 25
            color: "#1C69A1"
            font.pixelSize: 32
            visible: scene.state === "gameOver"
        }

        Text {
            text: "Best"
            anchors.left: scoreBoard.left
            anchors.leftMargin: 30
            anchors.top: scoreBoard.top
            anchors.topMargin: 25
            color: "#1C69A1"
            font.pixelSize: 32
            visible: scene.state === "gameOver"
        }

        Text {
            text: scene.score
            anchors.right: scoreBoard.right
            anchors.rightMargin: 30
            anchors.top: scoreBoard.top
            anchors.topMargin: 75
            color: "#1C69A1"
            font.pixelSize: 32
            visible: scene.state === "gameOver"
        }

        Text {
            text: scene.scoreBest
            anchors.left: scoreBoard.left
            anchors.leftMargin: 30
            anchors.top: scoreBoard.top
            anchors.topMargin: 75
            color: "#1C69A1"
            font.pixelSize: 32
            visible: scene.state === "gameOver"
        }

        function initAsteroids() {
            for(var i = 0; i < repeater.count; i++) {
                var entity = repeater.itemAt(i);
                entity.x = utils.generateRandomValueBetween(0, scene.width-entity.width)
                entity.y = (-3.5*scene.height / repeater.count * i) -2.5*scene.height
                entity.stop();
            }
        }

        function moveAsteroids() {
            for(var i = 0; i < repeater.count; i++) {
                var entity = repeater.itemAt(i);
                entity.start();
            }
        }

        function initGame() {
            scene.initAsteroids()
            player.stop()
        }

        function playGame() {
            scene.moveAsteroids()
            player.start()
            scene.score = 0
        }

        function stopGame() {
            scene.initAsteroids()
            player.stop()
            if (scene.score > scene.scoreBest) {
                scene.scoreBest = scene.score
            }
        }

        states: [
            State {
                name: "start"
                StateChangeScript {
                    script: {
                        scene.initGame()
                    }
                }
            },
            State {
                name: "playing"
                StateChangeScript {
                    script: {
                        scene.playGame()
                    }
                }
            },
            State {
                name: "gameOver"
                StateChangeScript {
                    script: {
                        scene.stopGame()
                    }
                }
            }
        ]

    }
}

