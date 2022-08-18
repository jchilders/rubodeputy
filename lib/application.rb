require "dry/system/container"

class Application < Dry::System::Container
  # include Dry::Events::Publisher[:rubodeputy]
  # register_event("users.created")

  configure do |config|
    config.root = Pathname(__dir__)
    config.component_dirs.add "components"
  end
end

Application.finalize!

at_exit do
  Application.stop(:progress) if Application.registered?(:progress)
end
