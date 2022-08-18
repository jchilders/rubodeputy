# frozen_string_literal: true

module Rubodeputy
  module ProgressListener
    extend self

    def on_step_succeeded(event)
      done_dirs << event.payload[:value]
    end

    def on_step_failed(event)
      failed_dirs << event.payload[:value]
    end

    def err_dirs
      @err_dirs ||= Set.new
    end

    def failed_dirs
      @failed_dirs ||= Set.new
    end

    def done_dirs
      @done_dirs ||= Set.new
    end

    def already_processed_dirs
      err_dirs + failed_dirs + done_dirs
    end
  end
end
