require 'RMagick'
require_relative "./sprite_lib"

def load_sprites(f)
  sprites = []

  count = f.read(2).unpack("S").first
  count.times do
    sprites << load_sprite(f)
  end

  sprites
end

def load_sprite(f)
  return if f.getbyte == 0

  width = f.read(2).unpack("S").first
  height = f.read(2).unpack("S").first
  size = f.read(2).unpack("S").first

  data = f.read(size).unpack("C*")

  {
    width: width,
    height: height,
    size: size,
    data: data
  }
end

def convert_sprite(sprite)
  puts "#{sprite[:width]}x#{sprite[:height]}"
  pixels = []
  i = 0
  row_count = 0
  column_count = 0

  while i < sprite[:data].length
    case sprite[:data][i]
    when 255 # transparent pixels
      i += 1
      # next byte tells how many
      sprite[:data][i].times do
        pixels << -1
        print "."
        column_count += 1
      end

    when 254 # next pixel row
      (sprite[:width] - column_count).times { print "."; pixels << -1 }
      puts
      row_count += 1
      column_count = 0
    when 253 # 1 transparent pixel
      pixels << -1
      column_count += 1
      print "."
    else  # set a pixel
      pixels << sprite[:data][i]
      print "X"
      column_count += 1
    end

    if column_count >= sprite[:width]
      column_count = 0
      row_count += 1
      puts
    end

    i += 1
  end

  puts
  puts "pixel count = #{pixels.length}. w*h = #{sprite[:width]*sprite[:height]}"
  raise "bad pixels" unless sprite[:width]*sprite[:height] == pixels.length

  image = Magick::Image.new(sprite[:width], sprite[:height])
  image.import_pixels(
    0,0,
    sprite[:width],
    sprite[:height],
    "RGBA",
    indexed_to_truecolor(pixels),
    Magick::ShortPixel)
  image
end

def dump_player_ship_sprites(offsets, f)
  start_offset = offsets[8]
  end_offset = offsets[9]
  size = end_offset - start_offset

  f.seek start_offset
  data = f.read size


  sprites = [122, 120, 118, 116, 114, 78, 76, 196, 154, 152, 156, 158, 160, 194, 198, 234, 236, 84, 192, 232, 82, 190, 230, 228, 80]

  dump_sprites2x2(data, sprites, "player_ships")
end

def dump_player_shot_sprites(offsets, f)
  start_offset = offsets[7]
  end_offset = offsets[8]
  size = end_offset - start_offset

  f.seek start_offset
  data = f.read size

  dump_sprites2(data, (0..MAX_SPRITES-1), "player_shots")
end

def dump_powerup_sprites(offsets, f)
  start_offset = offsets[9]
  end_offset = offsets[10]
  size = end_offset - start_offset

  f.seek start_offset
  data = f.read size

  sprites = [10, 126, 162, 128, 122, 124, 152, 154, 156, 158, 160, 162, 164, 166, 168, 190, 192, 194, 196, 198, 200, 202, 204, 206, 228, 230, 232, 234, 236, 238, 240, 242, 244, 266, 268, 270, 272, 274, 276, 278, 280, 282, 40, 42, 44, 46, 48, 54, 6, 8, 82, 84, 86, 90, 92]

  dump_sprites2x2(data, sprites, "powerups")
end

def dump_newsh1(data)
  sprites = [0, 2, 4, 6, 8, 10, 12, 14, 16, 38, 40, 42, 44, 46, 48, 50, 52, 54, 76, 78, 80, 82, 84, 86, 88, 90, 92, 114, 116, 118, 120, 122, 124, 126, 128, 130, 152, 154, 156, 158, 160, 162, 164, 166, 168, 190, 192, 194, 196, 198, 200, 202, 204, 206, 228, 230, 232, 234, 236, 238, 240, 242, 244, 266, 268, 270, 272, 274, 276, 278, 280, 282]

  dump_sprites2x2(data, sprites, "newsh1")
end

open("../data/tyrian.shp", "rb") do |f|
  shape_count = f.read(2).unpack("S").first
  shape_offsets = []

  shape_count.times do
    shape_offsets << f.read(4).unpack("l").first
  end

  # dump_player_ship_sprites(shape_offsets, f)
  # dump_player_shot_sprites(shape_offsets, f)
  dump_powerup_sprites(shape_offsets, f)
end

open("../data/newsh1.shp", "rb") do |f|
  data = f.read
  dump_newsh1(data)
end


