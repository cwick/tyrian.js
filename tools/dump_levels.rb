def read_encrypted_pascal_string(f)
  len = f.getbyte
  if len != nil
    s = f.read len
    decrypt_pascal_string(s)
  end
end

def decrypt_pascal_string(s)
  crypt_key = [ 204, 129, 63, 255, 71, 19, 25, 62, 1, 99 ];
  bytes = s.bytes

  (bytes.length-1).downto(0).each do |i|
    bytes[i] ^= crypt_key[i % crypt_key.length]
    bytes[i] ^= bytes[i-1] if i > 0
  end

  bytes.pack("c*")
end

open("../data/levels1.dat", "rb") do |f|
  while s = read_encrypted_pascal_string(f)
    puts s
  end
end

