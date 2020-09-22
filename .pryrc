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
    \033[1;97;44m#{context}
    #{"\033[21;34;42m\033[1;97m#{nesting}" unless nesting.zero?}
    \033[21;#{nesting.zero? ? '34' : '32'};49m
    \033[0m
  PROMPT
end

Pry.config.prompt =
  if defined?(IRB) && IRB.conf[:PROMPT_MODE] == :SIMPLE
    Pry::Prompt[:simple]
  else
    if Pry.config.color && ENV['POWERLINE'] == '1'
      Pry::Prompt[:custom_powerline]
    else
      Pry::Prompt[:custom]
    end
  end
Pry.config.prompt_name = 'rails' if defined?(Rails)
