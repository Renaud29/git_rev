Easily refer to your Rails app's current git revision.

### Installation & Usage

In your `Gemfile`:

``` ruby
gem "git_rev", github: "waymondo/git_rev"
```

In your Rails code, you can refer to your current SHA with:

``` ruby
Rails.application.config.git_rev
```

If you want to expose the revision to JavaScript too, add the following to your `application.js`:

``` javascript
//= require git_rev
```

This will set the SHA hash to `window.gitRev`.

### Heroku

When you precompile assets on Heroku, it happens within a dedicated slug which doesn't have access to the application's `.git/` folder. In order to update Heroku with the latest revision, you can install a git `post-receive` hook that will set this in your heroku app automatically:

```
bundle exec rake git_rev:heroku_setup
```
