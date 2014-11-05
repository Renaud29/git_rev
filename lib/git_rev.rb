require 'git_rev/version'

class GitRev
  module Heroku
    extend self

    def git_dir
      `git rev-parse --git-dir`.chomp
    end

    def post_receive_file
      File.join(git_dir, 'hooks', 'post-receive')
    end

    def setup
      append(post_receive_file, 0777) do |body, f|
        f.puts post_receive_hook if body !~ /git_rev/
      end
    end

    def post_receive_hook
      <<-eos
#!/bin/sh
remote="$1"
url="$2"
if [[ $url =~ heroku ]] ; then
    hash_name=GIT_REV
    hash=$(git rev-parse --short HEAD)
    echo Setting $hash_name to $hash on app $remote
    heroku config:set $hash_name=$hash --app $remote
fi
exit 0
eos
    end

    def append(file, *args)
      Dir.mkdir(File.dirname(file)) unless File.directory?(File.dirname(file))
      body = File.read(file) if File.exist?(file)
      File.open(file, 'a', *args) do |f|
        yield body, f
      end
    end
    protected :append
  end

  class Engine < Rails::Engine
    config.git_rev = (ENV['GIT_REV'] || `git rev-parse --short HEAD`.chomp)
    config.to_prepare { GitRev::Engine.setup! }
    rake_tasks do
      load "tasks.rake"
    end
  end
end
