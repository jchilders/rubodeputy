Application.register_provider(:progress) do
  prepare do
    require 'progress'
  end

  start do
    register(:progress, Progress.new)
    container[:progress].unmarshal_progress
  end

  stop do
    container[:progress].marshal_progress
  end
end
