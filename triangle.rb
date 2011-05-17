#!/usr/bin/env ruby
def triangle(n)
	tri=0;
	(0..n).each do |i|
		tri += i;
	end
	return tri
end

puts triangle(3)
