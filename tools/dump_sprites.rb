require 'json'
require 'RMagick'

MAX_SPRITES = 304

def load_palette
  JSON.parse File.open("out/palettes.json").read
end

def decode_sprite(data_string, index)
  data = data_string.unpack("C*")
  offset = data_string.unpack("S#{MAX_SPRITES}")[index]
  sprite = []
  width = -1
  height = 0
  width_counter = 0

  while data[offset] != 0x0f
    transparent_pixels = data[offset] & 0x0f
    opaque_pixels = (data[offset] & 0xf0) >> 4

    puts "#{transparent_pixels}, #{opaque_pixels}"

    width_counter += transparent_pixels + opaque_pixels

    transparent_pixels.times { sprite << -1 }

    if opaque_pixels == 0
      width = width_counter if width == -1
      height += 1
      width_counter = 0
    end

    opaque_pixels.times do
      offset += 1
      sprite << data[offset]
    end

    offset += 1
  end

  height += 1

  ((width*height) - sprite.length).times { sprite << -1 }

  puts sprite.inspect
  puts "Width: #{width}, Height: #{height}"
  puts "Length: #{sprite.length} bytes. width*height: #{width*height}"

  if width == -1
    nil
  else
    {
      data: sprite,
      width: width,
      height: height
    }
  end
end

def indexed_to_truecolor(indexed_data, palette_index=0)
  truecolor = []
  palettes = load_palette
  palette = palettes[palette_index]

  indexed_data.each do |i|
    color = palette[i]

    if i == -1
      truecolor += [0,0,0,0]
    else
      truecolor += [color["r"], color["g"], color["b"], 255]
    end
  end

  truecolor
end

def create_image(sprite)
  image = Magick::Image.new sprite[:width], sprite[:height]
  data = sprite[:data].map {|x| x*257 }

  image.import_pixels 0,0, sprite[:width], sprite[:height], "RGBA", data, Magick::ShortPixel
  image
end

open("../data/newsh2.shp", "rb") do |f|
  data_string = f.read
  (0..MAX_SPRITES-1).each do |i|
    sprite = decode_sprite(data_string, i)
    if sprite
      sprite[:data] = indexed_to_truecolor(sprite[:data])
      image = create_image(sprite)
      image.write "out/newsh2.shp.#{i+1}.png"
    end
  end
end

