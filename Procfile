web: bundle exec puma -C config/puma.rb
resque: bundle exec rake environment resque:work QUEUES=* TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7
