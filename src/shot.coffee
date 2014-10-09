`module Two from "two"`

Shot = Two.GameObject.extend
  initialize: ->
    @addComponent Two.Components.Transform
    @addComponent Two.Components.ArcadePhysics

    @shotSprite = @game.loader.loadSpritesheet("player_shots").clone()
    @transform.node.add new Two.RenderNode(renderable: @shotSprite)
    @initialVelocity = [0, 0]
    @matchPosition = false
    @matchVelocity = false
    @slave = null

  spawn: (options) ->
    @shotSprite.frame = options.spriteNumber
    @game.tyrian.layers.shots.add @transform.node

  tick: ->
    position = @physics.body.position
    if position.x < -34 || position.x > 290 || position.y < -15 || position.y > 190
      @die()

    if @slave?
      slave = @slave.physics.body

      if @matchPosition
        position.x = slave.position.x

      if @matchVelocity
        @physics.body.velocity.y = slave.velocity.y + @initialVelocity[1]

`export default Shot`
