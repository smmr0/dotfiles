IRB.conf[:HISTORY_FILE] = Pathname.new(ENV['HOME']).join('.irb_history')
IRB.conf[:SAVE_HISTORY] = 1_000
IRB.conf[:EVAL_HISTORY] = 1_000 # Available via special `__` var; not saved to any file
