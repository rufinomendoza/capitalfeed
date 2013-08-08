set :output, "#{path}/log/cron.log"
job_type :script, "'#{path}/script/:task' :output"

every 2.minutes do
  script "rss_update"
end