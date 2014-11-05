namespace :git_rev do
  desc "setup this heroku app for git rev"
  task :heroku_setup do |t, args|
    GitRev::Heroku.setup
  end
end
