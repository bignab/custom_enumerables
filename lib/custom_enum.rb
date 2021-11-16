# frozen_string_literal: true

# Adding customized versions of enumerables to the Enumerable module
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for item in self
      yield item
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    index = 0
    for item in self
      yield item, index
      index += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []
    my_each do |item|
      arr.push(item) if yield(item)
    end
    arr
  end

  def my_all?
    if block_given?
      my_each do |item|
        return false unless yield(item)
      end
    else
      my_each do |item|
        return false if item == false || item.nil?
      end
    end
    true
  end

  def my_any?(pattern = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
    elsif pattern
      my_each { |item| return true if pattern === item }
    else
      my_each { |item| return true unless item == false || item.nil? }
    end
    false
  end

  def my_none?(pattern = nil)
    if block_given?
      my_each { |item| return false if yield(item) }
    elsif pattern
      my_each { |item| return false if pattern === item }
    else
      my_each { |item| return false if item == true }
    end
    true
  end

  def my_count(argument = nil)
    count = 0
    if block_given?
      my_each { |item| count += 1 if yield(item) }
    elsif argument
      my_each { |item| count += 1 if argument == item }
    else
      my_each { count += 1 }
    end
    count
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    arr = []
    my_each { |item| arr.push(yield(item)) }
    arr
  end

  def my_inject(initial = nil)
    memo = if initial.nil?
             self.to_a[0]
           else
             initial
           end
    my_each_with_index do |item, index|
      next if (index == 0 && initial.nil?)

      memo = yield(memo, item)
    end
    memo
  end
end

# ['a', 'b', 'c'].my_each_with_index { |item, index| puts "#{item} index: #{index}" }
# ['a', 'b', 'c'].each_with_index { |item, index| puts "#{item} index: #{index}" }

# puts [1, 2, 3, 4, 5].my_select { |item| item.even? }
# puts [1, 2, 3, 4, 5].select { |item| item.even? }

# puts %w[ant bear cat].my_all? { |word| word.length >= 3 }
# puts %w[ant bear cat].all? { |word| word.length >= 3 }
# puts [nil, true, 99].all?
# puts [nil, true, 99].my_all?

# puts %w[ant bear cat].any? { |word| word.length >= 3 }
# [nil, true, 99].any?(Integer)
# puts %w[ant bear cat].my_any? { |word| word.length >= 3 }
# [nil, true, 99].my_any?(Integer)

# puts %w{ant bear cat}.none? { |word| word.length == 5 } #=> true
# puts %w{ant bear cat}.none? { |word| word.length >= 4 } #=> false
# puts %w{ant bear cat}.none?(/d/)                        #=> true
# puts [1, 3.14, 42].none?(Float)                         #=> false
# puts [].none?                                           #=> true
# puts [nil].none?                                        #=> true
# puts [nil, false].none?                                 #=> true
# puts [nil, false, true].none?                           #=> false
# puts ' '
# puts %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
# puts %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
# puts %w{ant bear cat}.my_none?(/d/)                        #=> true
# puts [1, 3.14, 42].my_none?(Float)                         #=> false
# puts [].my_none?                                           #=> true
# puts [nil].my_none?                                        #=> true
# puts [nil, false].my_none?                                 #=> true
# puts [nil, false, true].my_none?                           #=> false

# puts ary = [1, 2, 4, 2]
# puts ary.count               #=> 4
# puts ary.count(2)            #=> 2
# puts ary.count{ |x| x%2==0 } #=> 3
# puts
# puts ary = [1, 2, 4, 2]
# puts ary.my_count               #=> 4
# puts ary.my_count(2)            #=> 2
# puts ary.my_count{ |x| x%2==0 } #=> 3

# p (1..4).map { |i| i*i }      #=> [1, 4, 9, 16]
# p (1..4).map { "cat"  }       #=> ["cat", "cat", "cat", "cat"]
# puts
# p (1..4).my_map { |i| i*i }   #=> [1, 4, 9, 16]
# p (1..4).my_map { "cat"  }    #=> ["cat", "cat", "cat", "cat"]

puts (5..10).inject { |sum, n| sum + n }
puts (5..10).my_inject { |sum, n| sum + n }

longest = %w{ cat sheep bear }.my_inject do |memo, word|
  memo.length > word.length ? memo : word
end

puts longest