require 'set'

def to_dictionary
  File.readlines('dictionary.txt').map(&:chomp)
end

def adjacent_words(word, dictionary=to_dictionary)
  chars = word.split('')
  dict = Set.new []
  chars.each_with_index do |char, index|
    duplicate = chars.dup
    duplicate[index] = '.'
    duplicate.unshift('^')
    duplicate << '$'
    regex = duplicate.join('')
    dict +=  dictionary.select{ |word| word =~ %r(#{regex}) }
  end
  dict
end

def explore_words(source, dictionary)
  words_to_expand = [source]
  candidate_words = Set.new to_dictionary
    .select { |word| word.length == source.length }
  all_reachable_words = [source]
  all_reachable_words += adjacent_words(source, candidate_words).to_a

  until words_to_expand.empty? do
    adj_words = adjacent_words(words_to_expand.pop, candidate_words)
    adj_words.each do |adj_word|
      words_to_expand << adj_word
      all_reachable_words << adj_word
      candidate_words.delete(adj_word)
    end
  end
  all_reachable_words
end

def find_chain(source, target, dictionary)
  words_to_expand = [source]
  candidate_words = Set.new to_dictionary
    .select { |word| word.length == source.length }

  parents = {}
  target_found = false
  until target_found do
    p words_to_expand

    expanded_word = words_to_expand.shift
    adj_words = adjacent_words(expanded_word, candidate_words)
    adj_words.each do |adj_word|
      words_to_expand << adj_word
      parents[adj_word] = expanded_word
      if adj_word == target
        target_found = true
        break
      end
      candidate_words.delete(adj_word)
    end
  end

  source_found = false
  parent = target
  chain = []
  until source_found do
    chain << parent
    parent = parents[parent]
    if parent == source
      source_found = true
    end
  end
  chain << source
  puts chain.reverse
end
