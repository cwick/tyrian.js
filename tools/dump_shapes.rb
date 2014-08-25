require_relative "file_lib"
require_relative "sprite_lib"

SHAPE_WIDTH = 24
SHAPE_HEIGHT = 28
SHAPE_SIZE = SHAPE_WIDTH * SHAPE_HEIGHT
MAX_SHAPES = 600

Dir.mkdir "../converted_data/temp/shapesx" unless File.exists? "../converted_data/temp/shapesx"

open("../data/shapesx.dat", "rb") do |f|
  (0..MAX_SHAPES-1).each do |z|
    is_shape_blank = (f.getbyte != 0)

    unless is_shape_blank
      shape = efread(JE_byte, SHAPE_SIZE, f).map do |e|
        if e == 0 then -1 else e end
      end

      shape = indexed_to_truecolor(shape)
      image = create_image_from_sprite(width: SHAPE_WIDTH, height: SHAPE_HEIGHT, data: shape)
      image.write("../converted_data/temp/shapesx/shape_#{z}.png")
    end
  end
end


