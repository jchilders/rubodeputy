# frozen_string_literal: true

class RubocopTransaction
  inclue Dry::Transaction

  step :hello

  def hello
    bool = true
    bool ? Success(:yay) : Failure(:boo)
  end
end
