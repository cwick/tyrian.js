`module Two from "two"`
`import Player from "./player"`
`import Shot from "./shot"`
`import Weapon from "./weapon"`
`import WeaponTestState from "./weapon_test_state"`
`import Background from "./background"`

Game = Two.Game.extend
  initialize: ->
    scale = 2
    GAME_WIDTH = 320
    GAME_HEIGHT = 200

    @canvas.width = GAME_WIDTH * scale
    @canvas.height = GAME_HEIGHT * scale
    @camera.width = GAME_WIDTH
    @camera.height = GAME_HEIGHT

    @renderer.backend.flipYAxis = true

    @world.physics.arcade.collideWorldBounds = false

    Two.Sprite.defaultAnchorPoint = [0, 1]

    @tyrian =
      TICKS_PER_SECOND: 32
      viewport: new Two.TransformNode(position: [-24, 0])
      layers:
        shots: new Two.TransformNode()
        ships: new Two.TransformNode()
        background1: new Two.TransformNode()

game = new Game()
game.registerEntity "Player", Player
game.registerEntity "Shot", Shot
game.registerEntity "Weapon", Weapon
game.registerEntity "Background", Background
game.registerState "weapon_test", WeaponTestState

game.start("weapon_test")

