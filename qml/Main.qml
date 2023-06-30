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

        // Forward keybaord access to the player
        Keys.forwardTo: player.controller

        // Keep score
        property int score: 0
        property int scoreBest: 0

        // Init the state
        state: "start"

        // Set the background to an image
        Image {
            id: bg
            source: Qt.resolvedUrl("../assets/bgSpace.jpg")
            anchors.fill: scene.gameWindowAnchorItem
            anchors.horizontalCenter: scene.gameWindowAnchorItem.horizontalCenter
            anchors.bottom: scene.gameWindowAnchorItem.bottom
        }

        // Add physics without gravity. Its needed to detect the collisions
        PhysicsWorld {
            debugDrawVisible: false
            updatesPerSecondForPhysics: 60
            gravity.y: 0
        }

        // Init the player/rocket at the bottom when the game starts
        Player {
            id: player
            x: (scene.width / 2) - width/2
            y: 200
            visible: scene.state !== "start"
        }

        // Make 8 asteroids. The location is changed below
        Repeater {
            id: repeater
            model: 8
            Asteroid {}
        }

        // Show the score when playing on the top
        Text {
            text: scene.score
            anchors.top: scene.gameWindowAnchorItem.top
            anchors.horizontalCenter: scene.gameWindowAnchorItem.horizontalCenter
            color: "#FBFBFB"
            font.pixelSize: 64
            visible: scene.state === "playing"
        }

        // Make the play button clickable and it changes the game state
        MouseArea {
            id: mouseArea
            anchors.fill: playImg
            onClicked: {
                // if the game is ready and you click the button we start the game
                if(scene.state === "start") {
                    scene.state = "playing"
                }
                // if the player is dead and you click the button we restart the game
                if(scene.state === "gameOver") {
                    scene.state = "playing"
                }
            }
            // Add feeling that the button is pressable
            onPressed: {
                playImg.opacity = 0.5
            }
            onReleased: {
                playImg.opacity = 1.0
            }
        }

        // Play button image at start and game over screen
        Image {
            id: playImg
            anchors.horizontalCenter: scene.horizontalCenter
            source: Qt.resolvedUrl("../assets/play.png")
            visible: scene.state !== "playing"
        }

        // Game name below the logo at start screen
        Image {
            id: startImgLogo
            anchors.bottom: startImgLogoText.top
            anchors.bottomMargin: 50
            anchors.horizontalCenter: scene.horizontalCenter
            source: Qt.resolvedUrl("../assets/spaceLogo.png")
            visible: scene.state === "start"
        }

        // Game logo at start screen
        Image {
            id: startImgLogoText
            anchors.bottom: playImg.top
            anchors.bottomMargin: 100
            anchors.horizontalCenter: scene.horizontalCenter
            source: Qt.resolvedUrl("../assets/logoText.png")
            visible: scene.state === "start"
        }

        // Game over text shown when game is over
        Image {
            id: gameOverImg
            anchors.bottom: scoreBoard.top
            anchors.bottomMargin: 50
            anchors.horizontalCenter: scene.horizontalCenter
            source: Qt.resolvedUrl("../assets/gameOver.png")
            visible: scene.state === "gameOver"
        }

        // Scoreboard shown when game is over
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

        // Scoreboard text
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

        // Scoreboard text
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

        // Scoreboard text
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

        // Scoreboard text
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

        // Init the position of the asteroids and stop the movement
        function initAsteroids() {
            for(var i = 0; i < repeater.count; i++) {
                var entity = repeater.itemAt(i);
                entity.x = utils.generateRandomValueBetween(0, scene.width-entity.width)
                entity.y = (-3.5*scene.height / repeater.count * i) -2.5*scene.height
                entity.stop();
            }
        }

        // Move the asteroids
        function moveAsteroids() {
            for(var i = 0; i < repeater.count; i++) {
                var entity = repeater.itemAt(i);
                entity.start();
            }
        }

        // Init the game
        function initGame() {
            scene.initAsteroids()
            player.stop()
        }

        // Game is starting
        function playGame() {
            scene.moveAsteroids()
            player.start()
            scene.score = 0
        }

        // Game over, update the best score
        function stopGame() {
            scene.initAsteroids()
            player.stop()
            if (scene.score > scene.scoreBest) {
                scene.scoreBest = scene.score
            }
        }

        // Run function when the game state changes
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

