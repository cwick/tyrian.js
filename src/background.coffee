`module Two from "two"`

Background = Two.GameObject.extend
  spawn: ->
    @yPosition = 0

    sprites = @game.loader.loadSpritesheet "shapes/shapesz"
    level = @game.loader.loadJSON "levels/ep1/9"

    for rowNumber in [283..299]
      for columnNumber, tileNumber of level.map1[rowNumber]
        tile = sprites.clone()
        tile.frame = level.shapes[0][tileNumber] - 1
        tileTransform = new Two.TransformNode(position: [columnNumber*24, (rowNumber-283-10)*28])
        tileTransform.add new Two.RenderNode(elements: [tile])
        @game.tyrian.layers.background1.add tileTransform

  tick: ->
    player = @game.world.findByName "Player"
    tempW = Math.floor((260 - (player.transform.position.x - 36)) / (260 - 36) * (24 * 3) - 1)
    tempW = (tempW * 2) / 3
    tempW = tempW / 2
    tempW = Math.floor(tempW)

    @yPosition += @game.tyrian.TICKS_PER_SECOND / 60

    @game.tyrian.layers.background1.position.x = tempW - 24*2
    @game.tyrian.layers.background1.position.y = Math.round(@yPosition)

`export default Background`
