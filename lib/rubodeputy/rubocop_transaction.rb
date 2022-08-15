# frozen_string_literal: true

require "dry/transaction"
require "dry/monads"
require "English"

class RubocopTransaction
  include Dry::Transaction
  include Dry::Monads[:result, :do]

  check :dir_exists
  step :autocorrect

  def autocorrect(dir)
    `rubocop --autocorrect --fail-level E #{dir}`
    $CHILD_STATUS.success? ? Success(:rubocop_success) : Failure(:rubocop_error)
  end

  def dir_exists(dir)
    Dir.exist? dir
  end
end
