MAX_SPRITES = 304

open("../data/newsh2.shp", "rb") do |f|
  data_string = f.read
  data = data_string.unpack("C*")

  blanks = 0

  data_string.unpack("S#{MAX_SPRITES}").each do |index|
    sprite = []
    width = -1
    height = 0
    counter = 0

    while data[index] != 0x0f
      transparent_pixels = data[index] & 0x0f
      opaque_pixels = (data[index] & 0xf0) >> 4

      puts "#{transparent_pixels}, #{opaque_pixels}"

      counter += transparent_pixels + opaque_pixels

      transparent_pixels.times { sprite << -1 }

      if opaque_pixels == 0
        width = counter if width == -1
        height += 1
      end

      opaque_pixels.times do
        index += 1
        sprite << data[index]
      end

      index += 1
    end

    height += 1

    ((width*height) - sprite.length).times { sprite << -1 }

    puts sprite.inspect
    puts "Width: #{width}, Height: #{height}"
    puts "Length: #{sprite.length} bytes. width*height: #{width*height}"

    blanks += 1 if width == -1
  end

  puts "Blanks: #{blanks}"
  puts "non-blanks: #{MAX_SPRITES - blanks}"
  puts "max sprites: #{MAX_SPRITES}"
end


