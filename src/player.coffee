`module Two from "two"`

Player = Two.GameObject.extend Two.Components.ArcadePhysics,
  SHIP_SPEED: 45

  initialize: ->
    tyrianOrigin = @transform.add new Two.TransformNode(position: [-24 - 5, -7])
    @shipSprite = new Two.Sprite
      anchorPoint: [0,1]
      image: @game.loader.loadImage("player_ships")
      crop: { x: 210, y: 32, width: 24, height: 27 }

    tyrianOrigin.add new Two.RenderNode(elements: [@shipSprite])

    @physics.boundingBox.fromSprite @shipSprite
    @physics.boundingBox.y *= -1
    @physics.postUpdate = => @constrainToScreenBounds()
    @physics.maxVelocity = [4 * @SHIP_SPEED, 4 * @SHIP_SPEED]
    @physics.drag = [@physics.maxVelocity.x * (30/4), @physics.maxVelocity.y * (30/4)]

  spawn: ->
    @physics.position = [100, 180]

  update: ->
    @updateMovement()
    @updateBankAngle()

  updateMovement: ->
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

  updateBankAngle: ->
    bankAmount = @physics.velocity.x / @SHIP_SPEED
    bankFrame = Math.floor((bankAmount + 4)/2)

    @shipSprite.frame = bankFrame

  constrainToScreenBounds: ->
    if @physics.position.x < 40
      @physics.position.x = 40

    if @physics.position.x > 256
      @physics.position.x = 256

    if @physics.position.y < 10
      @physics.position.y = 10
      @physics.velocity.y = 0

    if @physics.position.y > 160
      @physics.position.y = 160
      @physics.velocity.y = 0


`export default Player`
