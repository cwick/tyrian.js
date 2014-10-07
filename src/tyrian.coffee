`module Two from "two"`
`import WeaponTestState from "./weapon_test_state"`

constants =
  SCREEN_WIDTH: 320
  SCREEN_HEIGHT: 200
  BG_TILE_WIDTH: 24
  BG_TILE_HEIGHT: 28
  TICKS_PER_SECOND: 32

class GameDelegate
  domElementForGame: ->
    document.getElementById("tyrian-game")

  gameWillInitialize: (game) ->
    scale = 2

    game.canvas.width = constants.SCREEN_WIDTH * scale
    game.canvas.height = constants.SCREEN_HEIGHT * scale
    game.camera.width = constants.SCREEN_WIDTH
    game.camera.height = constants.SCREEN_HEIGHT

    game.renderer.backend.flipYAxis = true

    game.world.physics.arcade.collideWorldBounds = false

    Two.Sprite.defaultAnchorPoint = [0, 1]

    game.tyrian =
      viewport: new Two.TransformNode(position: [-constants.BG_TILE_WIDTH, 0])
      layers:
        shots: new Two.TransformNode()
        ships: new Two.TransformNode()
        background1: new Two.TransformNode()

    game.tyrian[k] = v for k,v of constants

  gameDidInitialize: (game) ->
    game.registerState "weapon_test", WeaponTestState

game = new Two.Game(delegate: new GameDelegate())

game.startFromInitialState("weapon_test")

