# frozen_string_literal: true

require "dry/system/container"
require "dry/system/components"

class RubodeputyContainer < Dry::System::Container
  use :logging
  use :env, inferrer: -> { ENV.fetch("RACK_ENV", :development).to_sym }

  configure do |config|
    config.root = "."
  end
end
