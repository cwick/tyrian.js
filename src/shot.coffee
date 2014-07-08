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

  spawn: (options) ->
    shotSpriteFrame = @game.loader.loadObject("player_shots").frames[options.spriteNumber].frame
    @shotSprite.crop =
      x: shotSpriteFrame.x
      y: shotSpriteFrame.y
      width: shotSpriteFrame.w
      height: shotSpriteFrame.h

    @game.tyrian.layers.shots.add @transform

`export default Shot`
