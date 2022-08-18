# frozen_string_literal: true

require "dry/transaction"

module Rubodeputy
  class CorrectTransaction
    include Dry::Transaction

    check :valid?
    check :unprocessed?
    step :autocorrect

    private

      def valid?(dir)
        Dir.exist?(dir)
      end

      def unprocessed?(dir)
        !Rubodeputy::ProgressListener.already_processed_dirs.include?(dir)
      end

      def autocorrect(dir)
        files = DirWalker.files_for_dir(dir).join(" ")
        `rubocop --autocorrect --fail-level E #{files}`
        if $CHILD_STATUS.success?
          Success(dir)
        else
          Failure(dir)
        end
      end
  end
end
