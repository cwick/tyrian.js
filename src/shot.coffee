`module Two from "two"`

Shot = Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.Transform
    @addComponent Two.Components.ArcadePhysics

    @shotSprite = @game.loader.loadSpritesheet("player_shots").clone()
    @transform.add new Two.RenderNode(renderable: @shotSprite)
    @initialVelocity = new Two.Vector2d()
    @matchPosition = false
    @matchVelocity = false
    @slave = null

  prepareToSpawn: (options) ->
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
        @physics.velocity.y = slave.velocity.y + @initialVelocity.y

`export default Shot`
