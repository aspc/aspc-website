namespace :remote do
  desc "Reloads Nginx on Server"
  task :nginx do
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
end