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

  (0..MAX_SPRITES-1).each do |i|
    sprite = decode_sprite2(data, i)
    next if sprite[:width] == 0 || sprite[:height] == 0
    create_image_from_sprite(sprite).write "../out/temp/player_ships/#{i}.png"
  end

end

open("../data/tyrian.shp", "rb") do |f|
  shape_count = f.read(2).unpack("S").first
  shape_offsets = []

  shape_count.times do
    shape_offsets << f.read(4).unpack("l").first
  end

  dump_player_ship_sprites(shape_offsets, f)

  # shape_offsets[0..6].each_with_index do |offset, table_number|
  #   f.seek offset
  #   load_sprites(f).each_with_index do |sprite, sprite_number|
  #     if sprite
  #       image = convert_sprite(sprite)
  #       image.write "../out/temp/#{table_number}_#{sprite_number}.png"
  #     end
  #   end
  # end
end


