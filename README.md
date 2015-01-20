Resque-Scheduler-Example
==============================

This is a rails app that show how to use resque-scheduler to run delayed jobs and scheduled jobs

## Getting Started

**Dependencies**: Resque requires redis to run. Our initializer assumes redis is running locally. If you have another redis server running elsewhere, change it in `/config/initializers/resque.rb`.

Start the rails server and resque admin: `$ rails s`

- View the site at <http://localhost:3000>
- View the resque admin at <http://localhost:3000/resque>

Start the scheduler: `$ rake resque:scheduler`

Launch Resque worker: `$ rake resque:work QUEUE=*`
