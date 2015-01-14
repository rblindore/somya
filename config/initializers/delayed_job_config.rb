Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
