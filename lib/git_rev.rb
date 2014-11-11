require 'git_rev/version'

class GitRev
  def self.head
    if Rails.env.development?
      ENV['GIT_REV'] = `git rev-parse --short HEAD`.chomp
    else
      ENV['GIT_REV']
    end
  end

  module Heroku
    extend self

    def git_dir
      `git rev-parse --git-dir`.chomp
    end

    def pre_push_file
      File.join(git_dir, 'hooks', 'pre-push')
    end

    def setup
      append(pre_push_file, 0777) do |body, f|
        f.puts pre_push_hook if body !~ /GIT_REV/
      end
    end

    def pre_push_hook
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
    rake_tasks do
      load "tasks.rake"
    end
  end
end
