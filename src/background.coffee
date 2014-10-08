`module Two from "two"`

TiledBackground = Two.Renderable.extend
  ONSCREEN_ROW_COUNT: 6

  generateRenderCommands: ->
    commands = []
    worldTransform = @game.tyrian.layers.background1.worldMatrix.clone()
    # Begin drawing tiles at bottom of screen
    worldTransform.translate(0, @game.tyrian.BG_TILE_HEIGHT*@ONSCREEN_ROW_COUNT)

    numRows = @tiles.map1.length
    startRow = numRows - Math.floor(@background.yPosition / @game.tyrian.BG_TILE_HEIGHT) - 1
    endRow = startRow - @ONSCREEN_ROW_COUNT - 1

    for rowNumber in [startRow..endRow]
      break if rowNumber < 0

      for columnNumber, tileNumber of @tiles.map1[rowNumber]
        @spriteSheet.frame = @tiles.shapes[0][tileNumber] - 1

        tileTransform = worldTransform.clone()
        tileTransform.translate(columnNumber * @game.tyrian.BG_TILE_WIDTH,
                                (numRows - rowNumber - 1) * -@game.tyrian.BG_TILE_HEIGHT)

        commands.push { name: "setTransform", matrix: tileTransform }
        commands.push @spriteSheet.generateRenderCommands()

    commands

Background = Two.GameObject.extend
  spawn: ->
    sprites = @game.loader.loadSpritesheet "shapes/shapesz"
    tiles = @game.loader.loadJSON "levels/ep1/9"
    background = new Two.RenderNode(renderable:
      new TiledBackground(spriteSheet: sprites, tiles: tiles, background: @, game: @game))

    @game.tyrian.layers.background1.add background
    @yPosition = 0

  tick: ->
    player = @game.world.findByName "Player"

    # Crazy math taken from OpenTyrian source code. No idea how it works.
    tempW = Math.floor((260 - (player.transform.position.x - 36)) / (260 - 36) * (24 * 3) - 1)
    tempW = (tempW * 2) / 3
    tempW = tempW / 2
    tempW = Math.floor(tempW)

    @yPosition += @game.tyrian.TICKS_PER_SECOND / 60

    @game.tyrian.layers.background1.position.x = tempW - 24*2
    @game.tyrian.layers.background1.position.y = @yPosition

`export default Background`
