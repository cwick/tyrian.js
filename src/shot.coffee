`module Two from "two"`

Shot = Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.Transform
    @addComponent Two.Components.ArcadePhysics

    @shotSprite = @game.loader.loadSpritesheet("player_shots").clone()
    @transform.add new Two.RenderNode(renderable: @shotSprite)
    @initialVelocity = [0, 0]
    @matchPosition = false
    @matchVelocity = false
    @slave = null

  objectDidSpawn: (options) ->
    @shotSprite.frame = options.spriteNumber
    @game.tyrian.layers.shots.add @transform

  tick: ->
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
