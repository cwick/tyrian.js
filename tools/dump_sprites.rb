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
        if column_count < sprite[:width]
          pixels << -1
        end
        print "."
        column_count += 1
      end

    when 254 # next pixel row
      (sprite[:width] - column_count).times { print "."; pixels << -1 }
      puts
      row_count += 1
      column_count = 0
    when 253 # 1 transparent pixel
      if column_count < sprite[:width]
        pixels << -1
      end
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

  if column_count > 0
    (sprite[:width] - column_count).times { print "."; pixels << -1 }
    column_count = 0
    row_count += 1
  end

  missing_rows = sprite[:height] - row_count

  if missing_rows > 0
    (missing_rows*sprite[:width]).times { pixels << -1 }
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

open("../data/tyrian.shp", "rb") do |f|
  shape_count = f.read(2).unpack("S").first
  shape_offsets = []

  shape_count.times do
    shape_offsets << f.read(4).unpack("l").first
  end

  shape_offsets[0..6].each_with_index do |offset, table_number|
    f.seek offset
    load_sprites(f).each_with_index do |sprite, sprite_number|
      if sprite
        image = convert_sprite(sprite)
        image.write "../out/temp/#{table_number}_#{sprite_number}.png"
      end
    end
  end
#
#   (0..MAX_SPRITES-1).step(38).each do |offset|
#     (0..16).step(2).each do |x|
#       i = offset + x
#       ul = create_sprite(data_string, i)
#       ur = create_sprite(data_string, i+1)
#       ll = create_sprite(data_string, i+19)
#       lr = create_sprite(data_string, i+20)
#
#       image = create_image(ul, ur, ll, lr)
#       if image
#         image.write "../out/temp/#{i+1}.png"
#         puts i+1
#       end
#     end
#   end
end


