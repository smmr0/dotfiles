class Pry
  class Command
    class Huh < Wtf
      match(/huh([?!]*)/)
      options listing: 'huh?'
      banner Wtf.banner.gsub('wtf', 'huh')
    end
  end
end

Pry.config.color =
  ENV['TERM'] == 'xterm-color' ||
  (ENV['TERM'] && ENV['TERM'].end_with?('-256color')) ||
  ENV['RM_INFO'] # RubyMine

Pry::Prompt.add(
  :custom,
  nil
) do |context, nesting, pry_instance, sep|
  if pry_instance.color
    <<-PROMPT.gsub(/(\A|\n)\s*/, '')
      \033[1;35m#{pry_instance.config.prompt_name}
      \033[0m(\033[1;34m#{context}\033[0m)
      #{":\033[32m#{nesting}" unless nesting.zero?}
      \033[0m#{"#{sep} "}
    PROMPT
  else
    <<-PROMPT.gsub(/(\A|\n)\s*/, '')
      #{pry_instance.config.prompt_name}
      (#{context})
      #{":#{nesting}" unless nesting.zero?}
      #{"#{sep} "}
    PROMPT
  end
end
Pry::Prompt.add(
  :custom_powerline,
  nil,
  %w[> *]
) do |context, nesting, pry_instance, sep|
  <<-PROMPT.gsub(/(\A|\n)\s*/, '')
    \033[1;97;#{case sep; when '>' then '45'; when '*' then '43'; end}m#{pry_instance.config.prompt_name}
    \033[21;#{case sep; when '>' then '35'; when '*' then '33'; end};44m
    \033[1;97m#{context}
    #{"\033[21;34;42m\033[1;97m#{nesting}" unless nesting.zero?}
    \033[21;#{nesting.zero? ? '34' : '32'};49m
    \033[0m
  PROMPT
end
Pry::Prompt.add(
  :custom_rails,
  nil
) do |context, nesting, pry_instance, sep|
  project_name =
    if Rails::VERSION::MAJOR >= 6
      Rails.application.class.module_parent_name
    else
      Rails.application.class.parent_name
    end

  if pry_instance.color
    <<-PROMPT.gsub(/(\A|\n)\s*/, '')
      \033[1;35m#{project_name}:
      \033[1;#{Rails.env.production? ? '31' : '36'}m#{Rails.env}
      \033[0m(\033[1;34m#{context}\033[0m)
      #{":\033[32m#{nesting}" unless nesting.zero?}
      \033[0m#{"#{sep} "}
    PROMPT
  else
    <<-PROMPT.gsub(/(\A|\n)\s*/, '')
      #{project_name}:
      #{Rails.env}
      (#{context})
      #{":#{nesting}" unless nesting.zero?}
      #{"#{sep} "}
    PROMPT
  end
end
Pry::Prompt.add(
  :custom_rails_powerline,
  nil,
  %w[> *]
) do |context, nesting, pry_instance, sep|
  project_name =
    if Rails::VERSION::MAJOR >= 6
      Rails.application.class.module_parent_name
    else
      Rails.application.class.parent_name
    end

  <<-PROMPT.gsub(/(\A|\n)\s*/, '')
    \033[1;97;#{case sep; when '>' then '45'; when '*' then '43'; end}m#{project_name}
    \033[21;#{case sep; when '>' then '35'; when '*' then '33'; end};#{Rails.env.production? ? '41' : '46'}m
    \033[1;97m#{Rails.env}
    \033[21;#{Rails.env.production? ? '31' : '36'};44m
    \033[1;97m#{context}
    #{"\033[21;34;42m\033[1;97m#{nesting}" unless nesting.zero?}
    \033[21;#{nesting.zero? ? '34' : '32'};49m
    \033[0m
  PROMPT
end

Pry.config.prompt =
  if defined?(IRB) && IRB.conf[:PROMPT_MODE] == :SIMPLE
    Pry::Prompt[:simple]
  else
    if defined?(Rails)
      if Pry.config.color && ENV['POWERLINE'] == '1'
        Pry::Prompt[:custom_rails_powerline]
      else
        Pry::Prompt[:custom_rails]
      end
    else
      if Pry.config.color && ENV['POWERLINE'] == '1'
        Pry::Prompt[:custom_powerline]
      else
        Pry::Prompt[:custom]
      end
    end
  end

Pry.config.prompt_name = 'rails' if defined?(Rails)

Pry::Commands.add_command(Pry::Command::Huh)
