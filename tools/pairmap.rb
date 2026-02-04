#p ARGV
result_separator = "\n"
pair_separator = "\t"
if ARGV[0] == '-z'
  result_separator = "\x00"
  pair_separator = "\x00"
  ARGV.shift
end
input_re = Regexp.new(ARGV[0])
output_template = ARGV[1]
inputs = ARGV[2...]
#p input_re
#p output_template
#p inputs

inputs.each do |input|
  print input
  print pair_separator
  print input.sub(input_re, output_template)
  print result_separator
end
