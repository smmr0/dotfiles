Pry::Prompt.add(
  :custom,
  nil
) do |context, nesting, pry_instance, sep|
  <<-PROMPT.gsub(/(\A|\n)\s*/, '')
    \033[1;35m#{pry_instance.config.prompt_name}
    \033[0m(\033[1;34m#{context}\033[0m)
    #{":\033[32m#{nesting}" unless nesting.zero?}
    \033[0m#{sep}#{' '}
  PROMPT
end
Pry::Prompt.add(
  :powerline,
  nil,
  %w[> *]
) do |context, nesting, pry_instance, sep|
  <<-PROMPT.gsub(/(\A|\n)\s*/, '')
    \033[1;97;#{case sep; when '>'; '45'; when '*'; '43'; end}m#{pry_instance.config.prompt_name}
    \033[21;#{case sep; when '>'; '35'; when '*'; '33'; end};44m
    \033[1;97;44m#{context}
    #{"\033[21;34;42m\033[1;97m#{nesting}" unless nesting.zero?}
    \033[21;#{nesting.zero? ? '34' : '32'};49m
    \033[0m
  PROMPT
end

Pry.config.prompt =
  case IRB.conf[:PROMPT_MODE]
  when :SIMPLE
    Pry::Prompt[:simple]
  else
    if ENV['POWERLINE'] == '1'
      Pry::Prompt[:powerline]
    else
      Pry::Prompt[:custom]
    end
  end
Pry.config.prompt_name = 'rails' if defined?(Rails)
Pry.config.color = true if ENV['RM_INFO'] # RubyMine
