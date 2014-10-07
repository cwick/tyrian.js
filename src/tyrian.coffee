`module Two from "two"`
`import Player from "./player"`
`import Shot from "./shot"`
`import Weapon from "./weapon"`
`import WeaponTestState from "./weapon_test_state"`
`import Background from "./background"`

constants =
  SCREEN_WIDTH: 320
  SCREEN_HEIGHT: 200
  BG_TILE_WIDTH: 24
  BG_TILE_HEIGHT: 28
  TICKS_PER_SECOND: 32

Game = Two.Game.extend
  initialize: ->
    scale = 2

    @canvas.width = constants.SCREEN_WIDTH * scale
    @canvas.height = constants.SCREEN_HEIGHT * scale
    @camera.width = constants.SCREEN_WIDTH
    @camera.height = constants.SCREEN_HEIGHT

    @renderer.backend.flipYAxis = true

    @world.physics.arcade.collideWorldBounds = false

    Two.Sprite.defaultAnchorPoint = [0, 1]

    @tyrian =
      viewport: new Two.TransformNode(position: [-constants.BG_TILE_WIDTH, 0])
      layers:
        shots: new Two.TransformNode()
        ships: new Two.TransformNode()
        background1: new Two.TransformNode()

    @tyrian[k] = v for k,v of constants

game = new Game()
game.registerEntity "Player", Player
game.registerEntity "Shot", Shot
game.registerEntity "Weapon", Weapon
game.registerEntity "Background", Background
game.registerState "weapon_test", WeaponTestState

game.start("weapon_test")

