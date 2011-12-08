require 'guard'
require 'guard/guard'
require 'rake'

module Guard
  class Rake < Guard
    include ::Rake::DSL

    def initialize(watchers=[], options={})
      @task = options[:task]
      super
    end

    def start
      UI.info "Starting guard-rake #{@task}"
      load 'Rakefile'
      true
    end

    def stop
      UI.info "Stopping guard-rake #{@task}"
      true
    end

    def reload
      stop
      start
    end

    def run_all
      run_rake_task
    end

    def run_on_change(paths)
      run_rake_task
    end

    def run_rake_task
      UI.info "running #{@task}"
      task = ::Rake::Task[@task]
      reenable_task_and_prerequisites task
      task.invoke
    end
    
  private
    
    def reenable_task_and_prerequisites(task)
      task.reenable
      task.prerequisites.each { |pre| reenable_task_and_prerequisites(::Rake::Task[pre]) }
    end
    
  end
end
