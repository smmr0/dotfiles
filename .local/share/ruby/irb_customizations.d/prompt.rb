require 'irb'

IRB.conf[:PROMPT] ||= {}
IRB.conf[:PROMPT].merge!(
  SUMMER: {
    PROMPT_I: '%N(%m)> ',
    PROMPT_N: '%N(%m):%i> ',
    PROMPT_S: '%N(%m):%l> ',
    PROMPT_C: '%N(%m):%i> ',
    RETURN: "=> %s\n"
  },
  SUMMER_COLOR: {
    PROMPT_I:
      <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
        \033[1;35m%N
        \033[1;0m(\033[1;34m%m\033[0m)
        #{'> '}
      PROMPT
    PROMPT_N:
      <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
        \033[1;35m%N
        \033[1;0m(\033[1;34m%m\033[0m)
        :\033[32m%i
        \033[0m#{'> '}
      PROMPT
    PROMPT_S:
      <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
        \033[1;35m%N
        \033[1;0m(\033[1;34m%m\033[0m)
        :\033[32m%l
        \033[0m#{'> '}
      PROMPT
    PROMPT_C:
      <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
        \033[1;35m%N
        \033[1;0m(\033[1;34m%m\033[0m)
        :\033[32m%i
        \033[0m#{'> '}
      PROMPT
    RETURN: "=> %s\n"
  },
  SUMMER_POWERLINE: {
    PROMPT_I:
      <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
        \033[1;97;45m%N
        \033[21;24;35;44m
        \033[1;97m%m
        \033[21;24;34;42m
        \033[21;24;34;49m
        \033[0m
      PROMPT
    PROMPT_N:
      <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
        \033[1;97;45m%N
        \033[21;24;35;44m
        \033[1;97m%m
        \033[21;24;34;42m
        \033[1;97m%i
        \033[21;24;32;49m
        \033[0m
      PROMPT
    PROMPT_S:
      <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
        \033[1;97;45m%N
        \033[21;24;35;44m
        \033[1;97m%m
        \033[21;24;34;42m
        \033[1;97m%l
        \033[21;24;32;49m
        \033[0m
      PROMPT
    PROMPT_C:
      <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
        \033[1;97;45m%N
        \033[21;24;35;44m
        \033[1;97m%m
        \033[21;24;34;42m
        \033[1;97m%i
        \033[21;24;32;49m
        \033[0m
      PROMPT
    RETURN: "=> %s\n"
  }
)
if defined?(Rails)
  IRB.conf[:IRB_NAME] =
    IRB.conf[:IRB_NAME].gsub(
      /\Airb\b/,
      if Rails::VERSION::MAJOR >= 6
        Rails.application.class.module_parent_name
      else
        Rails.application.class.parent_name
      end
    )
  IRB.conf[:PROMPT].merge!(
    SUMMER_RAILS: {
      PROMPT_I: "%N:#{Rails.env}(%m)> ",
      PROMPT_N: "%N:#{Rails.env}(%m):%i> ",
      PROMPT_S: "%N:#{Rails.env}(%m):%l> ",
      PROMPT_C: "%N:#{Rails.env}(%m):%i> ",
      RETURN: "=> %s\n"
    },
    SUMMER_RAILS_COLOR: {
      PROMPT_I:
        <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
          \033[1;35m%N:
          \033[1;#{Rails.env.production? ? '31' : '36'}m#{Rails.env}
          \033[0m(\033[1;34m%m\033[0m)
          #{'> '}
        PROMPT
      PROMPT_N:
        <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
          \033[1;35m%N:
          \033[1;#{Rails.env.production? ? '31' : '36'}m#{Rails.env}
          \033[0m(\033[1;34m%m\033[0m)
          :\033[32m%i
          \033[0m#{'> '}
        PROMPT
      PROMPT_S:
        <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
          \033[1;35m%N:
          \033[1;#{Rails.env.production? ? '31' : '36'}m#{Rails.env}
          \033[0m(\033[1;34m%m\033[0m)
          :\033[32m%l
          \033[0m#{'> '}
        PROMPT
      PROMPT_C:
        <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
          \033[1;35m%N:
          \033[1;#{Rails.env.production? ? '31' : '36'}m#{Rails.env}
          \033[0m(\033[1;34m%m\033[0m)
          :\033[32m%i
          \033[0m#{'> '}
        PROMPT
      RETURN: "=> %s\n"
    },
    SUMMER_RAILS_POWERLINE: {
      PROMPT_I:
        <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
          \033[1;97;45m%N
          \033[21;24;35;#{Rails.env.production? ? '41' : '46'}m
          \033[1;97m#{Rails.env}
          \033[21;24;#{Rails.env.production? ? '31' : '36'};44m
          \033[1;97m%m
          \033[21;24;34;49m
          \033[0m
        PROMPT
      PROMPT_N:
        <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
          \033[1;97;45m%N
          \033[21;24;35;#{Rails.env.production? ? '41' : '46'}m
          \033[1;97m#{Rails.env}
          \033[21;24;#{Rails.env.production? ? '31' : '36'};44m
          \033[1;97m%m
          \033[21;24;34;42m
          \033[1;97m%i
          \033[21;24;32;49m
          \033[0m
        PROMPT
      PROMPT_S:
        <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
          \033[1;97;45m%N
          \033[21;24;35;#{Rails.env.production? ? '41' : '46'}m
          \033[1;97m#{Rails.env}
          \033[21;24;#{Rails.env.production? ? '31' : '36'};44m
          \033[1;97m%m
          \033[21;24;34;42m
          \033[1;97m%l
          \033[21;24;32;49m
          \033[0m
        PROMPT
      PROMPT_C:
        <<~PROMPT.gsub(/(\A|\n)\s*/, ''),
          \033[1;97;45m%N
          \033[21;24;35;#{Rails.env.production? ? '41' : '46'}m
          \033[1;97m#{Rails.env}
          \033[21;24;#{Rails.env.production? ? '31' : '36'};44m
          \033[1;97m%m
          \033[21;24;34;42m
          \033[1;97m%i
          \033[21;24;32;49m
          \033[0m
        PROMPT
      RETURN: "=> %s\n"
    }
  )
end

if IRB.conf[:PROMPT_MODE] == :DEFAULT
  IRB.conf[:PROMPT_MODE] =
    if defined?(Rails)
      if IRB.conf[:USE_COLORIZE]
        if ENV['POWERLINE'] && !ENV['POWERLINE'].empty?
          :SUMMER_RAILS_POWERLINE
        else
          :SUMMER_RAILS_COLOR
        end
      else
        :SUMMER_RAILS
      end
    else
      if IRB.conf[:USE_COLORIZE]
        if ENV['POWERLINE'] && !ENV['POWERLINE'].empty?
          :SUMMER_POWERLINE
        else
          :SUMMER_COLOR
        end
      else
        :SUMMER
      end
    end
end
