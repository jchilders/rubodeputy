# frozen_string_literal: true

module Rubodeputy
  module ProgressListener
    extend self

    NOTIFICATIONS = []

    def on_step_succeeded(event)
      dir = event.payload[:value]
      done_dirs << dir
    end

    def on_step_failed(event)
      dir = event.payload[:value]
      failed_dirs << dir
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
