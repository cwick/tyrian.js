`module Two from "two"`

Game = Two.Game.extend
  configure: ->
    scale = 2
    @canvas.width = 320 * scale
    @canvas.height = 200 * scale
    @camera.width = 320
    @camera.height = 200
    @renderer.backend.imageSmoothingEnabled = false
    @renderer.backend.flipYAxis = false

    @world.physics.arcade.collideWorldBounds = false

    @loader.baseDir = "converted_data"

    @loader.preloadImage "player_ships.png"
    @loader.preloadImage "pics/2.png"


    background = @scene.add new Two.TransformNode()
    background.add new Two.RenderNode(elements: [new Two.Sprite(anchorPoint: [0,1], image: @loader.loadImage("pics/2"))])

    @spawn "Player"

game = new Game()

game.registerEntity "Player", Two.GameObject.extend Two.Components.ArcadePhysics,
  SHIP_SPEED: 45

  initialize: ->
    tyrianOrigin = @transform.add new Two.TransformNode(position: [-24 - 5, -7])
    shipSprite = new Two.Sprite
      anchorPoint: [0,1]
      image: @game.loader.loadImage("player_ships")
      crop: { x: 210, y: 32, width: 24, height: 27 }

    tyrianOrigin.add new Two.RenderNode(elements: [shipSprite])

    @physics.boundingBox.fromSprite shipSprite
    @physics.boundingBox.y *= -1
    @physics.postUpdate = => @constrainToScreenBounds()
    @physics.maxVelocity = [4 * @SHIP_SPEED, 4 * @SHIP_SPEED]
    @physics.drag = [@physics.maxVelocity.x * (30/4), @physics.maxVelocity.y * (30/4)]

  spawn: ->
    @physics.position = [40, 10]

  update: ->
    @physics.acceleration.x = 0
    @physics.acceleration.y = 0

    if @game.input.keyboard.isKeyDown Two.Keys.LEFT
      @physics.acceleration.x -= 1
    if @game.input.keyboard.isKeyDown Two.Keys.RIGHT
      @physics.acceleration.x += 1

    if @game.input.keyboard.isKeyDown Two.Keys.UP
      @physics.acceleration.y -= 1
    if @game.input.keyboard.isKeyDown Two.Keys.DOWN
      @physics.acceleration.y += 1

    @physics.acceleration.x *= @physics.drag.x
    @physics.acceleration.y *= @physics.drag.y

  constrainToScreenBounds: ->
    if @physics.position.x < 40
      @physics.position.x = 40
      @physics.velocity.x = 0

    if @physics.position.x > 256
      @physics.position.x = 256
      @physics.velocity.x = 0

    if @physics.position.y < 10
      @physics.position.y = 10
      @physics.velocity.y = 0

    if @physics.position.y > 160
      @physics.position.y = 160
      @physics.velocity.y = 0

game.start()

