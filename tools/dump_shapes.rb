require_relative "file_lib"
require_relative "sprite_lib"

SHAPE_WIDTH = 24
SHAPE_HEIGHT = 28
SHAPE_SIZE = SHAPE_WIDTH * SHAPE_HEIGHT
MAX_SHAPES = 600

def dump_shapes(shape_code)
  Dir.mkdir "../converted_data/temp/shapes#{shape_code}" unless File.exists? "../converted_data/temp/shapes#{shape_code}"

  open("../data/shapes#{shape_code}.dat", "rb") do |f|
    (0..MAX_SHAPES-1).each do |z|
      is_shape_blank = (f.getbyte != 0)

      if is_shape_blank
        shape = Array.new(SHAPE_SIZE, -1)
      else
        shape = efread(JE_byte, SHAPE_SIZE, f).map do |e|
          if e == 0 then -1 else e end
        end
      end

      shape = indexed_to_truecolor(shape)
      image = create_image_from_sprite(width: SHAPE_WIDTH, height: SHAPE_HEIGHT, data: shape)
      image.write("PNG32:../converted_data/temp/shapes#{shape_code}/shape_#{z}.png")
    end
  end
end

# %w( \) w x y z).each do |code| dump_shapes(code) end
%w(z).each do |code| dump_shapes(code) end


