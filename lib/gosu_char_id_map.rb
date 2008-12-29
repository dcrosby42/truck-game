module GosuCharIdMap

  Char = {
    'a' => 0,
    'b' => 11,
    'c' => 8,
    'd' => 2,
    'e' => 14,
    'f' => 3,
    'g' => 5,
    'h' => 4,
    'i' => 34,
    'j' => 38,
    'k' => 40,
    'l' => 37,
    'm' => 46,
    'n' => 45,
    'o' => 31,
    'p' => 35,
    'q' => 12,
    'r' => 15,
    's' => 1,
    't' => 17,
    'u' => 32,
    'v' => 9,
    'w' => 13,
    'x' => 7,
    'y' => 16,
    'z' => 6,
    ' ' => 49,
  }

  Id = {}
  Char.each do |letter, int|
    Id[int] = letter
  end
  
end

class Fixnum
  def gosu_letter
    GosuCharIdMap::Id[self]
  end
end
