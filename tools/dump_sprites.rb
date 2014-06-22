require 'RMagick'
require_relative "./sprite_lib"

PCX_NUM = 13

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

def convert_sprite(sprite, palette=0)
  return nil unless sprite
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
        column_count += 1
      end

    when 254 # next pixel row
      (sprite[:width] - column_count).times { pixels << -1 }
      row_count += 1
      column_count = 0
    when 253 # 1 transparent pixel
      pixels << -1
      column_count += 1
    else  # set a pixel
      pixels << sprite[:data][i]
      column_count += 1
    end

    if column_count >= sprite[:width]
      column_count = 0
      row_count += 1
    end

    i += 1
  end

  # puts
  puts "pixel count = #{pixels.length}. w*h = #{sprite[:width]*sprite[:height]}"
  raise "bad pixels" unless sprite[:width]*sprite[:height] == pixels.length

  image = Magick::Image.new(sprite[:width], sprite[:height])
  image.import_pixels(
    0,0,
    sprite[:width],
    sprite[:height],
    "RGBA",
    indexed_to_truecolor(pixels, palette),
    Magick::ShortPixel)
  image
end

def dump_player_ship_sprites(offsets, f)
  start_offset = offsets[8]
  end_offset = offsets[9]
  size = end_offset - start_offset

  f.seek start_offset
  data = f.read size

  sprites = [122, 120, 118, 116, 114, 78, 76, 196, 154, 152, 156, 158, 160, 194, 198, 234, 236, 84, 192, 232, 82, 190, 230, 228, 80].map {|x| x+1}

  dump_sprites2x2(data, sprites, "player_ships")
end

def dump_player_shot_sprites(offsets, f)
  start_offset = offsets[7]
  end_offset = offsets[8]
  size = end_offset - start_offset

  f.seek start_offset
  data = f.read size

  dump_sprites2(data, (1..MAX_SPRITES), "player_shots")
end

def dump_powerup_sprites(offsets, f)
  start_offset = offsets[9]
  end_offset = offsets[10]
  size = end_offset - start_offset

  f.seek start_offset
  data = f.read size

  sprites = [10, 126, 162, 128, 122, 124, 152, 154, 156, 158, 160, 162, 164, 166, 168, 190, 192, 194, 196, 198, 200, 202, 204, 206, 228, 230, 232, 234, 236, 238, 240, 242, 244, 266, 268, 270, 272, 274, 276, 278, 280, 282, 40, 42, 44, 46, 48, 54, 6, 8, 82, 84, 86, 90, 92].map {|x| x+1}

  dump_sprites2x2(data, sprites, "powerups")
end

def dump_coin_sprites(offsets, f)
  start_offset = offsets[10]
  end_offset = offsets[11]
  size = end_offset - start_offset

  f.seek start_offset
  data = f.read size


  sprites = (1..MAX_SPRITES)
  dump_sprites2(data, sprites, "coins")
end

def dump_newsh1(data)
  sprites = [0, 2, 4, 6, 8, 10, 12, 14, 16, 38, 40, 42, 44, 46, 48, 50, 52, 54, 76, 78, 80, 82, 84, 86, 88, 90, 92, 114, 116, 118, 120, 122, 124, 126, 128, 130, 152, 154, 156, 158, 160, 162, 164, 166, 168, 190, 192, 194, 196, 198, 200, 202, 204, 206, 228, 230, 232, 234, 236, 238, 240, 242, 244, 266, 268, 270, 272, 274, 276, 278, 280, 282].map {|x| x+1}

  dump_sprites2x2(data, sprites, "newsh1")
end

def dump_option_sprites(offsets, f)
  Dir.mkdir "../converted_data/temp/option_sprites" unless File.exists? "../converted_data/temp/option_sprites"
  f.seek offsets[5]
  sprites = load_sprites(f)
  sprites.each_with_index do |s, i|
    if s
      convert_sprite(s).write "../converted_data/temp/option_sprites/#{i}.png"
    end
  end
end

def dump_font_sprites(offsets, f)
  Dir.mkdir "../converted_data/temp/font_sprites" unless File.exists? "../converted_data/temp/font_sprites"
  f.seek offsets[0]
  sprites = load_sprites(f)
  sprites.each_with_index do |s, i|
    if s
      convert_sprite(s).write "../converted_data/temp/font_sprites/#{i}.png"
    end
  end
end

def dump_small_font_sprites(offsets, f)
  Dir.mkdir "../converted_data/temp/small_font_sprites" unless File.exists? "../converted_data/temp/small_font_sprites"
  f.seek offsets[1]
  sprites = load_sprites(f)
  sprites.each_with_index do |s, i|
    if s
      convert_sprite(s).write "../converted_data/temp/small_font_sprites/#{i}.png"
    end
  end
end

def dump_tiny_font_sprites(offsets, f)
  Dir.mkdir "../converted_data/temp/tiny_font_sprites" unless File.exists? "../converted_data/temp/tiny_font_sprites"
  f.seek offsets[2]
  sprites = load_sprites(f)
  sprites.each_with_index do |s, i|
    if s
      convert_sprite(s).write "../converted_data/temp/tiny_font_sprites/#{i}.png"
    end
  end
end

def dump_planet_sprites(offsets, f)
  Dir.mkdir "../converted_data/temp/planet_sprites" unless File.exists? "../converted_data/temp/planet_sprites"
  f.seek offsets[3]
  sprites = load_sprites(f)
  sprites.each_with_index do |s, i|
    if s
      convert_sprite(s, 17).write "../converted_data/temp/planet_sprites/#{i}.png"
    end
  end
end

def dump_weapon_sprites(offsets, f)
  Dir.mkdir "../converted_data/temp/weapon_sprites" unless File.exists? "../converted_data/temp/weapon_sprites"
  f.seek offsets[6]
  sprites = load_sprites(f)
  sprites.each_with_index do |s, i|
    if s
      convert_sprite(s).write "../converted_data/temp/weapon_sprites/#{i}.png"
    end
  end
end

def dump_pics(offsets, f)
  pcx_pal = [ 0, 7, 5, 8, 10, 5, 18, 19, 19, 20, 21, 22, 5 ]
  out_dir = "../converted_data/temp/pics"
  Dir.mkdir out_dir unless File.exists? out_dir

  (0..PCX_NUM-1).each do |pic_num|
    offset = offsets[pic_num]
    size = offsets[pic_num+1] - offsets[pic_num]
    f.seek offset
    raw_pic_data = f.read(size).unpack("C*")
    pic_data = []

    p = 0
    i = 0

    while i < 320*200
      if raw_pic_data[p] & 0xc0 == 0xc0
        (raw_pic_data[p] & 0x3f).times do
          pic_data << raw_pic_data[p+1]
          i += 1
        end
        p += 2
      else
        pic_data << raw_pic_data[p]
        p += 1
        i += 1
      end
    end

    puts "expected length = #{320*200}. actual = #{pic_data.length}"

    create_image_from_sprite({
      width: 320,
      height: 200,
      data: indexed_to_truecolor(pic_data, pcx_pal[pic_num])
    }).write "#{out_dir}/#{pic_num}.png"
  end
end

open("../data/tyrian.pic", "rb") do |f|
  f.read(2)
  pic_offsets = []

  (0..PCX_NUM-1).each do
    pic_offsets << f.read(4).unpack("l").first
  end

  pic_offsets << f.size

  dump_pics pic_offsets, f
end

open("../data/tyrian.shp", "rb") do |f|
  shape_count = f.read(2).unpack("S").first
  shape_offsets = []

  shape_count.times do
    shape_offsets << f.read(4).unpack("l").first
  end

  dump_coin_sprites(shape_offsets, f)
  dump_weapon_sprites(shape_offsets, f)
  dump_planet_sprites(shape_offsets, f)
  dump_tiny_font_sprites(shape_offsets, f)
  dump_small_font_sprites(shape_offsets, f)
  dump_font_sprites(shape_offsets, f)
  dump_option_sprites(shape_offsets, f)
  dump_player_ship_sprites(shape_offsets, f)
  dump_player_shot_sprites(shape_offsets, f)
  dump_powerup_sprites(shape_offsets, f)
end

open("../data/newsh1.shp", "rb") do |f|
  data = f.read
  dump_newsh1(data)
end

