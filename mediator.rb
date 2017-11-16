class TextField
  attr_accessor :value
  def initialize
    @value = ""
  end
end

class TextFieldWithObserver < TextField
  attr_reader :observers

  def initialize
    @observers = []
    super
  end

  def value=(value)
    super
    observers.each { |observer| observer.text_field_changed }
  end
end

class List
  attr_accessor :words

  def initialize(words)
    @words = words
  end
end

class ListSearchMediator
  def initialize(text_field, list)
    @text_field = text_field
    @text_field.observers << self
    @list = list
  end

  def text_field_changed
    @list.words = @list.words.inject([]) do |narrowed_list, word|
      if word.start_with?(@text_field.value)
        narrowed_list.push(word)
      end
      narrowed_list
    end
  end
end

list = List.new(["apple", "avocado", "banana", "kiwi", "mango", "watermelon"])
text_field = TextFieldWithObserver.new
mediator = ListSearchMediator.new(text_field, list)

text_field.value = "a"
puts list.words.inspect # ["apple", "avocado"]

text_field.value = "av"
puts list.words.inspect # ["avocado"]