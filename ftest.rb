require "flammarion"

f = Flammarion::Engraving.new
text=File.read(ARGV[0])
text.each_line do |l|
  f.print l

end
f.wait_until_closed
