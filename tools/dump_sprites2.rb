require_relative "./sprite_lib"

open("../data/newsh1.shp", "rb") do |f|
  data_string = f.read

  (0..MAX_SPRITES-1).step(38).each do |offset|
    (0..16).step(2).each do |x|
      i = offset + x
      ul = decode_sprite2(data_string, i)
      ur = decode_sprite2(data_string, i+1)
      ll = decode_sprite2(data_string, i+19)
      lr = decode_sprite2(data_string, i+20)

      image = create_sprite_2x2(ul, ur, ll, lr)
      if image
        image.write "../out/temp/#{i+1}.png"
        puts i+1
      end
    end
  end
end

