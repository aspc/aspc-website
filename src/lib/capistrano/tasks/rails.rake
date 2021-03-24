namespace :rails do
    desc 'Interact with a remote rails console'
    task :console do
        on roles(:all) do
            ask :console_user, "username for peninsula.pomona.edu"
            run_interactively "bundle exec rails console #{fetch(:rails_env)}", fetch(:console_user)
        end
    end

    desc 'Interact with a remote rails dbconsole'
    task :dbconsole do
        on roles(:all) do
            ask :console_user, "username for peninsula.pomona.edu"
            run_interactively "bundle exec rails dbconsole #{fetch(:rails_env)}", fetch(:console_user)
        end
    end

    def run_interactively(command, user)
        info "Running `#{command}` as #{user}@#{host}"
        exec %Q(ssh #{user}@#{host} -t "bash --login -c 'cd #{fetch(:deploy_to)}/current && #{command}'")
    end
end