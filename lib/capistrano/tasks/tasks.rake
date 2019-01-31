namespace :remote do
  desc "Reloads Nginx on server"
  task :reload_nginx do
    on roles(:all) do
      execute :service, "nginx reload"
    end
  end

  desc "Print the deploy path"
  task :pwd_deploy do
    on roles(:all) do
      within current_path do
        execute "pwd"
      end
    end
  end

  desc "Show crontab for the application"
  task :show_crontab do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, "whenever #{fetch(:application)}"
      end
    end
  end

  desc "Update the crontab for the application"
  task :update_crontab do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
      end
    end
  end
end