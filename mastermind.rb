RESPONSES = %w(B0C0 B0C1 B0C2 B0C3 B0C4 B1C0 B1C1 B1C2 B1C3 B2C0 B2C1 B2C2 B3C0 B4C0)

PATTERNS = (1111..9999).map(&:to_s).reject {|el| el =~ /[7890]/ }
SECRET_CODE = PATTERNS.sample

def compare(move, pattern)
  secret = pattern.dup # duplicate to avoid mutations

  bulls = 0
  4.times do |i|
    next unless secret[i].eql?(move[i])

    bulls += 1    # increment bulls count
    secret[i] = '0' # remove digit from guess for correct cows calculating
  end

  cows = 0
  4.times do |i|
    next unless secret.include?(move[i])

    cows += 1    # increment cows count
    secret[i] = '0' # remove digit from guess for correct cows calculating
  end

  "B#{bulls}C#{cows}"
end

def min_removed_count(pattern, from_patterns)
  remained_counts = RESPONSES.map do |resp|
    from_patterns.select {|el| compare(pattern, el).eql?(resp) }.size
  end

  minimum_removed = from_patterns.size - remained_counts.max
end

# =================== entry point ===================
patterns = PATTERNS.dup
(1..12).each do |move_number|
  print "Make your move ##{move_number}: "
  move = gets.chomp
  raise "Invalid format" unless move =~ /^[1-6]{4}$/

  abort("Congrats! You won with just #{move_number} move(s)") if move.eql?(SECRET_CODE)

  p current_response = compare(move, SECRET_CODE)
  p patterns.select! { |el| compare(move, el).eql?(current_response) }

# ================== MAIN ALGO BEGIN ==================
  all_minimums = PATTERNS.map {|el| [min_removed_count(el, patterns), el]}
  minimax = all_minimums.max.first # [117, "3757"].first
  p all_minimaxes = all_minimums.select {|el| el[0].eql?(minimax) }

  p minimaxes_in_patterns = all_minimaxes.map(&:last).intersection(patterns)
# =================== MAIN ALGO END ===================

  puts '*'*77, "select first element from the last non-empty array as YOUR NEXT MOVE\nif first array has MORE THEN ONE record"
rescue
  puts '*'*77, "Invalid input. Please enter exactly 4 digits, each from 1 to 6."
  retry
end

puts '*'*77, '*'*27 + " Sorry, but you LOOSE! " + '*'*27, '*'*77
