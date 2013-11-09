require 'prettys'

# inspecting string and coloring 'is' with default color
puts "This is some string and it is awesome.".prettys("is")

# inspecting hash and coloring numbers with bold blue color
hash = { a: 1, b: 2, c: 3 }
puts hash.prettys(/[0-9]/, { color: :blue, bold: true })

# inspecting array with strings on a green background
array = [1, 2, 'string', 3, 4, 'another_string', 5, 6]
puts array.prettys(/"[^"]+"/, { color: :green, type: :background })