# Railties – Gluing the [`Engine`](https://api.rubyonrails.org/classes/Rails/Engine.html) to the Rails
Railties is responsible for gluing all frameworks together. Overall, it:
  * handles the bootstrapping process for a Rails application;
  * manages the `rails` command line interface;
  * and provides the Rails generators core.

## Download
The latest version of Railties can be installed with RubyGems:
  * gem install railties

Source code can be downloaded as part of the Rails project on GitHub
  * [github.com/rails/rails/tree/main/railties](https://github.com/rails/rails/tree/main/railties)

## License
Railties is released under the MIT license:
  * [opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)

## Support
[`API`](https://api.rubyonrails.org/classes/Rails/API.html) documentation is at
  * [api.rubyonrails.org](https://api.rubyonrails.org)

Bug reports can be filed for the Ruby on Rails project here:
  * [github.com/rails/rails/issues](https://github.com/rails/rails/issues)

Feature requests should be discussed on the rubyonrails-core forum here:
  * [discuss.rubyonrails.org/c/rubyonrails-core](https://discuss.rubyonrails.org/c/rubyonrails-core)

Namespace
  * MODULE [Rails::API](https://api.rubyonrails.org/classes/Rails/API.html)
  * MODULE [Rails::Command](https://api.rubyonrails.org/classes/Rails/Command.html)
  * MODULE [Rails::Configuration](https://api.rubyonrails.org/classes/Rails/Configuration.html)
  * MODULE [Rails::Generators](https://api.rubyonrails.org/classes/Rails/Generators.html)
  * MODULE [Rails::Info](https://api.rubyonrails.org/classes/Rails/Info.html)
  * MODULE [Rails::Initializable](https://api.rubyonrails.org/classes/Rails/Initializable.html)
  * MODULE [Rails::Paths](https://api.rubyonrails.org/classes/Rails/Paths.html)
  * MODULE [Rails::Rack](https://api.rubyonrails.org/classes/Rails/Rack.html)
  * MODULE [Rails::VERSION](https://api.rubyonrails.org/classes/Rails/VERSION.html)
  * CLASS [Rails::AppBuilder](https://api.rubyonrails.org/classes/Rails/AppBuilder.html)
  * CLASS [Rails::Application](https://api.rubyonrails.org/classes/Rails/Application.html)
  * CLASS [Rails::CodeStatistics](https://api.rubyonrails.org/classes/Rails/CodeStatistics.html)
  * CLASS [Rails::Console](https://api.rubyonrails.org/classes/Rails/Console.html)
  * CLASS [Rails::DBConsole](https://api.rubyonrails.org/classes/Rails/DBConsole.html)
  * CLASS [Rails::Engine](https://api.rubyonrails.org/classes/Rails/Engine.html)
  * CLASS [Rails::HealthController](https://api.rubyonrails.org/classes/Rails/HealthController.html)
  * CLASS [Rails::PluginBuilder](https://api.rubyonrails.org/classes/Rails/PluginBuilder.html)
  * CLASS [Rails::Railtie](https://api.rubyonrails.org/classes/Rails/Railtie.html)
  * CLASS [Rails::Server](https://api.rubyonrails.org/classes/Rails/Server.html)
  * CLASS [Rails::SourceAnnotationExtractor](https://api.rubyonrails.org/classes/Rails/SourceAnnotationExtractor.html)

Methods

A

B

C

E

G

P

R

V

## Attributes
|  [RW]   | app_class  |
| --- | --- |
|  [W]   | application  |
|  [RW]   | cache  |
|  [RW]   | logger  |

## Class Public methods

###  **application**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-application)
Source: [show](javascript:toggleSource\('method-c-application_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L44)

```

# File railties/lib/rails.rb, line 44
def application
  @application ||= (app_class.instance if app_class)
end
```

###  **autoloaders**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-autoloaders)
Source: [show](javascript:toggleSource\('method-c-autoloaders_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L133)

# File railties/lib/rails.rb, line 133
def autoloaders
  application.autoloaders
end
```

###  **backtrace_cleaner**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-backtrace_cleaner)
Source: [show](javascript:toggleSource\('method-c-backtrace_cleaner_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L55)

# File railties/lib/rails.rb, line 55
def backtrace_cleaner
  @backtrace_cleaner ||= Rails::BacktraceCleaner.new
end
```

###  **configuration**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-configuration)
The [`Configuration`](https://api.rubyonrails.org/classes/Rails/Configuration.html) instance used to configure the Rails environment
Source: [show](javascript:toggleSource\('method-c-configuration_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L51)

# File railties/lib/rails.rb, line 51
def configuration
  application.config
end
```

###  **env**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-env)
Returns the current Rails environment.

```
Rails. # => "development"
Rails..development? # => true
Rails..production? # => false
Rails..local? # => true              true for "development" and "test", false for anything else

Source: [show](javascript:toggleSource\('method-c-env_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L74)

# File railties/lib/rails.rb, line 74
def env
  @_env ||= ActiveSupport::EnvironmentInquirer.new(ENV["RAILS_ENV"].presence || ENV["RACK_ENV"].presence || "development")
end
```

###  **env=**(environment) [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-env-3D)
Sets the Rails environment.

```
Rails. = "staging" # => "staging"

Source: [show](javascript:toggleSource\('method-c-env-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L81)

# File railties/lib/rails.rb, line 81
def env=(environment)
  @_env = ActiveSupport::EnvironmentInquirer.new(environment)
end
```

###  **error**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-error)
Returns the [`ActiveSupport::ErrorReporter`](https://api.rubyonrails.org/classes/ActiveSupport/ErrorReporter.html) of the current Rails project, otherwise it returns `nil` if there is no project.

```
Rails.error.handle(IOError)

# ...

Rails.error.report(error)

Source: [show](javascript:toggleSource\('method-c-error_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L92)

# File railties/lib/rails.rb, line 92
def error
  ActiveSupport.error_reporter
end
```

###  **event**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-event)
Returns the [`ActiveSupport::EventReporter`](https://api.rubyonrails.org/classes/ActiveSupport/EventReporter.html) of the current Rails project, otherwise it returns `nil` if there is no project.

```
Rails.event.notify("my_event", { message: "Hello, world!" })

Source: [show](javascript:toggleSource\('method-c-event_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L100)

# File railties/lib/rails.rb, line 100
def event
  ActiveSupport.event_reporter
end
```

###  **gem_version**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-gem_version)
Returns the currently loaded version of Rails as a `Gem::Version`.
Source: [show](javascript:toggleSource\('method-c-gem_version_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails/gem_version.rb#L5)

# File railties/lib/rails/gem_version.rb, line 5
def self.gem_version
  Gem::Version.new VERSION::STRING
end
```

###  **groups**(*groups) [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-groups)
Returns all Rails groups for loading based on:
  * The Rails environment;
  * The environment variable RAILS_GROUPS;
  * The optional envs given as argument and the hash with group dependencies;

```
Rails.groups assets: [:development, :test]

# => [:default, "development", :assets] for Rails.env == "development"

# => [:default, "production"]           for Rails.env == "production"

Source: [show](javascript:toggleSource\('method-c-groups_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L113)

# File railties/lib/rails.rb, line 113
def groups(*groups)
  hash = groups.extract_options!
  env = Rails.env
  groups.unshift(:default, env)
  groups.concat ENV["RAILS_GROUPS"].to_s.split(",")
  groups.concat hash.map { |k, v| k if v.map(:to_s).include?(env) }
  groups.compact!
  groups.uniq!
  groups
end
```

###  **public_path**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-public_path)
Returns a [`Pathname`](https://api.rubyonrails.org/classes/Pathname.html) object of the public folder of the current Rails project, otherwise it returns `nil` if there is no project:

```
Rails.public_path

# => #<Pathname:/Users/someuser/some/path/project/public>

Source: [show](javascript:toggleSource\('method-c-public_path_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L129)

# File railties/lib/rails.rb, line 129
def public_path
  application  Pathname.new(application.paths["public"].first)
end
```

###  **root**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-root)
Returns a [`Pathname`](https://api.rubyonrails.org/classes/Pathname.html) object of the current Rails project, otherwise it returns `nil` if there is no project:

```
Rails.root

# => #<Pathname:/Users/someuser/some/path/project>

Source: [show](javascript:toggleSource\('method-c-root_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails.rb#L64)

# File railties/lib/rails.rb, line 64
def root
  application  application.config.root
end
```

###  **version**() [Link](https://api.rubyonrails.org/classes/Rails.html#method-c-version)
Returns the currently loaded version of Rails as a string.
Source: [show](javascript:toggleSource\('method-c-version_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/railties/lib/rails/version.rb#L7)

# File railties/lib/rails/version.rb, line 7
def self.version
  VERSION::STRING
end
```