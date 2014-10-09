`module Two from "two"`

Player = Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.Transform
    @addComponent Two.Components.ArcadePhysics
    tyrianOrigin = @transform.node.add new Two.TransformNode(position: [-5, -7])

    @shipSprite = @loadShip 233

    tyrianOrigin.add new Two.RenderNode(renderable: @shipSprite)

    @physics.body.boundingBox.fromSprite @shipSprite
    @physics.body.boundingBox.y *= -1
    @physics.body.postUpdate = => @constrainToScreenBounds()
    @physics.body.maxVelocity = [@maxVelocity, @maxVelocity]
    @physics.body.drag = [@acceleration/2, @acceleration/2]

  maxVelocity: Two.Property
    get: -> 4 * @game.tyrian.TICKS_PER_SECOND

  acceleration: Two.Property
    get: -> Math.pow @game.tyrian.TICKS_PER_SECOND, 2

  spawn: ->
    @physics.body.position = [110, 160]
    @game.tyrian.layers.ships.add @transform.node
    @weapon = @game.spawn "Weapon", weaponNumber: 155, attachTo: @

  tick: ->
    @updateMovement()
    @updateBankAngle()
    @fireShots()

  updateMovement: ->
    @physics.body.acceleration.x = 0
    @physics.body.acceleration.y = 0

    if @game.input.keyboard.isKeyDown Two.Keys.LEFT
      @physics.body.acceleration.x -= 1
    if @game.input.keyboard.isKeyDown Two.Keys.RIGHT
      @physics.body.acceleration.x += 1

    if @game.input.keyboard.isKeyDown Two.Keys.UP
      @physics.body.acceleration.y -= 1
    if @game.input.keyboard.isKeyDown Two.Keys.DOWN
      @physics.body.acceleration.y += 1

    @physics.body.acceleration.x *= @acceleration
    @physics.body.acceleration.y *= @acceleration

  updateBankAngle: ->
    bankAmount = @physics.body.velocity.x / @game.tyrian.TICKS_PER_SECOND
    bankFrame = Math.floor((bankAmount)/2)

    @shipSprite.frame = bankFrame

  fireShots: ->
    @weapon.fireShots() if @game.input.keyboard.isKeyDown(Two.Keys.SPACEBAR)

  switchWeapon: (weaponNumber) ->
    @weapon.spawn weaponNumber: weaponNumber

  constrainToScreenBounds: ->
    if @physics.body.position.x < 40
      @physics.body.position.x = 40

    if @physics.body.position.x > 256
      @physics.body.position.x = 256

    if @physics.body.position.y < 10
      @physics.body.position.y = 10
      @physics.body.velocity.y = 0

    if @physics.body.position.y > 160
      @physics.body.position.y = 160
      @physics.body.velocity.y = 0

  loadShip: (num) ->
    ships = @game.loader.loadJSON("player_ships").frames
    frames = {}

    # Set up sprites for ship banking angles
    frames[0] = ships[num].frame
    frames[1] = ships[num+2].frame
    frames[-1] = ships[num-2].frame
    frames[2] = ships[num+4].frame
    frames[-2] = ships[num-4].frame

    shipSprite = new Two.Sprite
      image: @game.loader.loadImage("player_ships")

    for name, frame of frames
      shipSprite.addFrame name,
        x: frame.x
        y: frame.y
        width: frame.w
        height: frame.h

    shipSprite.frame = 0
    shipSprite

`export default Player`
