require 'json'
require 'RMagick'

MAX_SPRITES = 304

def decode_sprite2(data_string, index, palette=0)
  data = data_string.unpack("C*")
  offset = data_string.unpack("S#{MAX_SPRITES}")[index-1]
  sprite = []
  width = -1
  height = 0
  width_counter = 0

  while data[offset] != 0x0f
    transparent_pixels = data[offset] & 0x0f
    opaque_pixels = (data[offset] & 0xf0) >> 4

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

  if width == -1
    width = height = 0
  end

  {
    data: indexed_to_truecolor(sprite, palette),
    width: width,
    height: height
  }
end

def decode_sprite2x2(data_string, index, palette=0)
  ul = decode_sprite2(data_string, index, palette)
  ur = decode_sprite2(data_string, index+1, palette)
  ll = decode_sprite2(data_string, index+19, palette)
  lr = decode_sprite2(data_string, index+20, palette)

  create_sprite_2x2(ul, ur, ll, lr)
end

def dump_sprites2x2(data, sprites, dirname, palette=0)
  out_dir = "../assets/temp/#{dirname}"
  Dir.mkdir out_dir unless File.exists? out_dir

  sprites.each do |i|
    decode_sprite2x2(data, i, palette).write "PNG32:#{out_dir}/#{i}.png"
  end
end

def dump_sprites2(data, sprites, dirname, palette=0)
  out_dir = "../assets/temp/#{dirname}"
  Dir.mkdir out_dir unless File.exists? out_dir

  sprites.each do |i|
    sprite = decode_sprite2(data, i, palette)
    if sprite[:width] > 0 && sprite[:height] > 0
      create_image_from_sprite(sprite).write "PNG32:#{out_dir}/#{i}.png"
    end
  end
end

def create_sprite_2x2(ul, ur, ll, lr)
  width = [ul[:width] + ur[:width], ll[:width] + lr[:width]].max
  height = [ul[:height] + ll[:height], ur[:height] + lr[:height]].max

  raise "empty sprite" if width == 0 || height == 0

  height = [ll[:height] + 14, height].max

  image = Magick::Image.new(width, height) { self.background_color = "transparent" }

  # Upper Left
  if ul[:width] > 0 && ul[:height] > 0
    image.import_pixels 0,0, ul[:width], ul[:height], "RGBA", ul[:data], Magick::ShortPixel
  end

  # Upper Right
  if ur[:width] > 0 && ur[:height] > 0
    raise "too wide" if (ur[:width] + 12) > width
    image.import_pixels 12,0, ur[:width], ur[:height], "RGBA", ur[:data], Magick::ShortPixel
  end

  # Lower Left
  if ll[:width] > 0 && ll[:height] > 0
    image.import_pixels 0,14, ll[:width], ll[:height], "RGBA", ll[:data], Magick::ShortPixel
  end

  # Lower Right
  if lr[:width] > 0 && lr[:height] > 0
    image.import_pixels 12,14, lr[:width], lr[:height], "RGBA", lr[:data], Magick::ShortPixel
  end

  image
end

def create_image_from_sprite(sprite)
  image = Magick::Image.new(sprite[:width], sprite[:height])
  image.import_pixels(
    0,0,
    sprite[:width],
    sprite[:height],
    "RGBA",
    sprite[:data],
    Magick::ShortPixel)
  image
end

def load_palettes
  JSON.parse File.open("../assets/palettes.json").read
end

def indexed_to_truecolor(indexed_data, palette_index=0)
  truecolor = Array.new(indexed_data.length*4)
  palettes = load_palettes
  palette = palettes[palette_index]

  indexed_data.each_with_index do |pixel, i|
    color = palette[pixel]

    if pixel == -1
      truecolor[i*4] = 0
      truecolor[i*4+1] = 0
      truecolor[i*4+2] = 0
      truecolor[i*4+3] = 0
    else
      truecolor[i*4] = color["r"]*257
      truecolor[i*4+1] = color["g"]*257
      truecolor[i*4+2] = color["b"]*257
      truecolor[i*4+3] = 255*257
    end
  end

  truecolor
end


