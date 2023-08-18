require 'pathname'

Dir[Pathname.new(__dir__).join('irb_customizations.d', '*.rb')].each do |f|
  require f
end
