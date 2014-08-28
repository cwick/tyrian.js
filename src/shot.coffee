`module Two from "two"`

Shot = Two.GameObject.extend Two.Components.ArcadePhysics,
  initialize: ->
    @shotSprite = new Two.Sprite
      anchorPoint: [0,1]
      image: @game.loader.loadImage("player_shots")
      crop:
        x: 0
        y: 0
        width: 0
        height: 0

    @transform.add new Two.RenderNode(elements: [@shotSprite])
    @initialVelocity = [0, 0]
    @matchPosition = false
    @matchVelocity = false
    @slave = null

  spawn: (options) ->
    shotSpriteFrame = @game.loader.loadJSON("player_shots").frames[options.spriteNumber].frame
    @shotSprite.crop =
      x: shotSpriteFrame.x
      y: shotSpriteFrame.y
      width: shotSpriteFrame.w
      height: shotSpriteFrame.h

    @game.tyrian.layers.shots.add @transform

  update: ->
    position = @physics.position
    if position.x < -34 || position.x > 290 || position.y < -15 || position.y > 190
      @die()

    if @slave?
      slave = @slave.physics

      if @matchPosition
        position.x = slave.position.x

      if @matchVelocity
        @physics.velocity.y = slave.velocity.y + @initialVelocity[1]

`export default Shot`
