## 1. First Contact
When you create an application using the `rails` command, you are in fact using a Rails generator. After that, you can get a list of all available generators by invoking `bin/rails generate`:

```
$rails new myapp
$cd myapp
$bin/rails generate

```
Copy
To create a Rails application we use the `rails` global command which uses the version of Rails installed via `gem install rails`. When inside the directory of your application, we use the `bin/rails` command which uses the version of Rails bundled with the application.
You will get a list of all generators that come with Rails. To see a detailed description of a particular generator, invoke the generator with the `--help` option. For example:

```
$bin/rails generate scaffold --help

```
Copy

## 2. Creating Your First Generator
Generators are built on top of [Thor](https://github.com/rails/thor), which provides powerful options for parsing and a great API for manipulating files.
Let's build a generator that creates an initializer file named `initializer.rb` inside `config/initializers`. The first step is to create a file at `lib/generators/initializer_generator.rb` with the following content:

```
class InitializerGenerator  Rails::Generators::Base
  def create_initializer_file
    create_file "config/initializers/initializer.rb", <<~RUBY
      # Add initialization content here
    RUBY
  end
end

```
Copy
Our new generator is quite simple: it inherits from [`Rails::Generators::Base`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Base.html) and has one method definition. When a generator is invoked, each public method in the generator is executed sequentially in the order that it is defined. Our method invokes [`create_file`](https://www.rubydoc.info/gems/thor/Thor/Actions#create_file-instance_method), which will create a file at the given destination with the given content.
To invoke our new generator, we run:

```
$bin/rails generate initializer

```
Copy
Before we go on, let's see the description of our new generator:

```
$bin/rails generate initializer --help

```
Copy
Rails is usually able to derive a good description if a generator is namespaced, such as `ActiveRecord::Generators::ModelGenerator`, but not in this case. We can solve this problem in two ways. The first way to add a description is by calling [`desc`](https://www.rubydoc.info/gems/thor/Thor#desc-class_method) inside our generator:

```
class InitializerGenerator  Rails::Generators::Base
  desc "This generator creates an initializer file at config/initializers"
  def create_initializer_file
    create_file "config/initializers/initializer.rb", <<~RUBY
      # Add initialization content here
    RUBY
  end
end

```
Copy
Now we can see the new description by invoking `--help` on the new generator.
The second way to add a description is by creating a file named `USAGE` in the same directory as our generator. We are going to do that in the next step.

## 3. Creating Generators with Generators
Generators themselves have a generator. Let's remove our `InitializerGenerator` and use `bin/rails generate generator` to generate a new one:

```
$rm lib/generators/initializer_generator.rb

$bin/rails generate generator initializer
      create  lib/generators/initializer
      create  lib/generators/initializer/initializer_generator.rb
      create  lib/generators/initializer/USAGE
      create  lib/generators/initializer/templates
      invoke  test_unit
      create    test/lib/generators/initializer_generator_test.rb

```
Copy
This is the generator just created:

```
class InitializerGenerator  Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)
end

```
Copy
First, notice that the generator inherits from [`Rails::Generators::NamedBase`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/NamedBase.html) instead of `Rails::Generators::Base`. This means that our generator expects at least one argument, which will be the name of the initializer and will be available to our code via `name`.
We can see that by checking the description of the new generator:

```
$bin/rails generate initializer --help
Usage:
  bin/rails generate initializer NAME [options]

```
Copy
Also, notice that the generator has a class method called [`source_root`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Base.html#method-c-source_root). This method points to the location of our templates, if any. By default it points to the `lib/generators/initializer/templates` directory that was just created.
In order to understand how generator templates work, let's create the file `lib/generators/initializer/templates/initializer.rb` with the following content:

```

# Add initialization content here

```
Copy
And let's change the generator to copy this template when invoked:

```
class InitializerGenerator  Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

def copy_initializer_file
    copy_file "initializer.rb", "config/initializers/#{file_name}.rb"
  end
end

```
Copy
Now let's run our generator:

```
$bin/rails generate initializer core_extensions
      create  config/initializers/core_extensions.rb

$cat config/initializers/core_extensions.rb

```
Copy
We see that [`copy_file`](https://www.rubydoc.info/gems/thor/Thor/Actions#copy_file-instance_method) created `config/initializers/core_extensions.rb` with the contents of our template. (The `file_name` method used in the destination path is inherited from `Rails::Generators::NamedBase`.)

## 4. Generator Command Line Options
Generators can support command line options using [`class_option`](https://www.rubydoc.info/gems/thor/Thor/Base/ClassMethods#class_option-instance_method). For example:

```
class InitializerGenerator  Rails::Generators::NamedBase
  class_option :scope, type: :string, default: "app"
end

```
Copy
Now our generator can be invoked with a `--scope` option:

```
$bin/rails generate initializer theme --scope dashboard

```
Copy
Option values are accessible in generator methods via [`options`](https://www.rubydoc.info/gems/thor/Thor/Base#options-instance_method):

```
def copy_initializer_file
  @scope = options["scope"]
end

## 5. Generator Resolution
When resolving a generator's name, Rails looks for the generator using multiple file names. For example, when you run `bin/rails generate initializer core_extensions`, Rails tries to load each of the following files, in order, until one is found:
  * `rails/generators/initializer/initializer_generator.rb`
  * `generators/initializer/initializer_generator.rb`
  * `rails/generators/initializer_generator.rb`
  * `generators/initializer_generator.rb`

If none of these are found, an error will be raised.
We put our generator in the application's `lib/` directory because that directory is in `$LOAD_PATH`, thus allowing Rails to find and load the file.

## 6. Overriding Rails Generator Templates
Rails will also look in multiple places when resolving generator template files. One of those places is the application's `lib/templates/` directory. This behavior allows us to override the templates used by Rails' built-in generators. For example, we could override the [scaffold controller template](https://github.com/rails/rails/blob/main/railties/lib/rails/generators/rails/scaffold_controller/templates/controller.rb.tt) or the [scaffold view templates](https://github.com/rails/rails/tree/main/railties/lib/rails/generators/erb/scaffold/templates).
To see this in action, let's create a `lib/templates/erb/scaffold/index.html.erb.tt` file with the following contents:

```
<%%= @%= plural_table_name %>.count %> <%= human_name.pluralize %>

```
Copy
Note that the template is an ERB template that renders _another_ ERB template. So any `<%` that should appear in the _resulting_ template must be escaped as `<%%` in the _generator_ template.
Now let's run Rails' built-in scaffold generator:

```
$bin/rails generate scaffold Post title:string
      ...
      create      app/views/posts/index.html.erb
      ...

```
Copy
The contents of `app/views/posts/index.html.erb` is:

```
<%= @posts.count %> Posts

## 7. Overriding Rails Generators
Rails' built-in generators can be configured via [`config.generators`](https://guides.rubyonrails.org/configuring.html#configuring-generators), including overriding some generators entirely.
First, let's take a closer look at how the scaffold generator works.

```
$bin/rails generate scaffold User name:string
      invoke  active_record
      create    db/migrate/20230518000000_create_users.rb
      create    app/models/user.rb
      invoke    test_unit
      create      test/models/user_test.rb
      create      test/fixtures/users.yml
      invoke  resource_route
       route    resources :users
      invoke  scaffold_controller
      create    app/controllers/users_controller.rb
      invoke    erb
      create      app/views/users
      create      app/views/users/index.html.erb
      create      app/views/users/edit.html.erb
      create      app/views/users/show.html.erb
      create      app/views/users/new.html.erb
      create      app/views/users/_form.html.erb
      create      app/views/users/_user.html.erb
      invoke    resource_route
      invoke    test_unit
      create      test/controllers/users_controller_test.rb
      create      test/system/users_test.rb
      invoke    helper
      create      app/helpers/users_helper.rb
      invoke      test_unit
      invoke    jbuilder
      create      app/views/users/index.json.jbuilder
      create      app/views/users/show.json.jbuilder

```
Copy
From the output, we can see that the scaffold generator invokes other generators, such as the `scaffold_controller` generator. And some of those generators invoke other generators too. In particular, the `scaffold_controller` generator invokes several other generators, including the `helper` generator.
Let's override the built-in `helper` generator with a new generator. We'll name the generator `my_helper`:

```
$bin/rails generate generator rails/my_helper
      create  lib/generators/rails/my_helper
      create  lib/generators/rails/my_helper/my_helper_generator.rb
      create  lib/generators/rails/my_helper/USAGE
      create  lib/generators/rails/my_helper/templates
      invoke  test_unit
      create    test/lib/generators/rails/my_helper_generator_test.rb

```
Copy
And in `lib/generators/rails/my_helper/my_helper_generator.rb` we'll define the generator as:

```
class Rails::MyHelperGenerator  Rails::Generators::NamedBase
  def create_helper_file
    create_file "app/helpers/#{file_name}_helper.rb", <<~RUBY
      module #{class_name}Helper
        # I'm helping!
      end
    RUBY
  end
end

```
Copy
Finally, we need to tell Rails to use the `my_helper` generator instead of the built-in `helper` generator. For that we use `config.generators`. In `config/application.rb`, let's add:

```
config.generators do |g|
  g.helper :my_helper
end

```
Copy
Now if we run the scaffold generator again, we see the `my_helper` generator in action:

```
$bin/rails generate scaffold Article body:text
      ...
      invoke  scaffold_controller
      ...
      invoke    my_helper
      create      app/helpers/articles_helper.rb
      ...

```
Copy
You may notice that the output for the built-in `helper` generator includes "invoke test_unit", whereas the output for `my_helper` does not. Although the `helper` generator does not generate tests by default, it does provide a hook to do so using [`hook_for`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Base.html#method-c-hook_for). We can do the same by including `hook_for :test_framework, as: :helper` in the `MyHelperGenerator` class. See the `hook_for` documentation for more information.

### 7.1. Generators Fallbacks
Another way to override specific generators is by using _fallbacks_. A fallback allows a generator namespace to delegate to another generator namespace.
For example, let's say we want to override the `test_unit:model` generator with our own `my_test_unit:model` generator, but we don't want to replace all of the other `test_unit:*` generators such as `test_unit:controller`.
First, we create the `my_test_unit:model` generator in `lib/generators/my_test_unit/model/model_generator.rb`:

```
module MyTestUnit
  class ModelGenerator  Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

def do_different_stuff
      say "Doing different stuff..."
    end
  end
end

```
Copy
Next, we use `config.generators` to configure the `test_framework` generator as `my_test_unit`, but we also configure a fallback such that any missing `my_test_unit:*` generators resolve to `test_unit:*`:

```
config.generators do |g|
  g.test_framework :my_test_unit, fixture: false
  g.fallbacks[:my_test_unit] = :test_unit
end

```
Copy
Now when we run the scaffold generator, we see that `my_test_unit` has replaced `test_unit`, but only the model tests have been affected:

```
$bin/rails generate scaffold Comment body:text
      invoke  active_record
      create    db/migrate/20230518000000_create_comments.rb
      create    app/models/comment.rb
      invoke    my_test_unit
    Doing different stuff...
      invoke  resource_route
       route    resources :comments
      invoke  scaffold_controller
      create    app/controllers/comments_controller.rb
      invoke    erb
      create      app/views/comments
      create      app/views/comments/index.html.erb
      create      app/views/comments/edit.html.erb
      create      app/views/comments/show.html.erb
      create      app/views/comments/new.html.erb
      create      app/views/comments/_form.html.erb
      create      app/views/comments/_comment.html.erb
      invoke    resource_route
      invoke    my_test_unit
      create      test/controllers/comments_controller_test.rb
      create      test/system/comments_test.rb
      invoke    helper
      create      app/helpers/comments_helper.rb
      invoke      my_test_unit
      invoke    jbuilder
      create      app/views/comments/index.json.jbuilder
      create      app/views/comments/show.json.jbuilder

## 8. Application Templates
Application templates are a little different from generators. While generators add files to an existing Rails application (models, views, etc.), templates are used to automate the setup of a new Rails application. Templates are Ruby scripts (typically named `template.rb`) that customize new Rails applications right after they are generated.
Let's see how to use a template while creating a new Rails application.

### 8.1. Creating and Using Templates
Let's start with a sample template Ruby script. The below template adds Devise to the `Gemfile` after asking the user and also allows the user to name the Devise user model. After `bundle install` has been run, the template runs the Devise generators and also runs migrations. Finally, the template does `git add` and `git commit`.

# template.rb
if yes?("Would you like to install Devise?")
  gem "devise"
  devise_model = ask("What would you like the user model to be called?", default: "User")
end

after_bundle do
  if devise_model
    generate "devise:install"
    generate "devise", devise_model
    rails_command "db:migrate"
  end

git add: ".", commit: %(-m 'Initial commit')
end

```
Copy
To apply this template while creating a new Rails application, you need to provide the location of the template using the `-m` option:

```
$rails new blog -m ~/template.rb

```
Copy
The above will create a new Rails application called `blog` that has Devise gem configured.
You can also apply templates to an existing Rails application by using `app:template` command. The location of the template needs to be passed in via the `LOCATION` environment variable:

```
$bin/rails app:template LOCATION=~/template.rb

```
Copy
Templates don't have to be stored locally, you can also specify a URL instead of a path:

```
$rails new blog -m https://example.com/template.rb
$bin/rails app:template LOCATION=https://example.com/template.rb

```
Copy
Caution should be taken when executing remote scripts from third parties. Since the template is a plain Ruby script, it can easily contain code that compromises your local machine (such as download a virus, delete files or upload your private files to a server).
The above `template.rb` file uses helper methods such as `after_bundle` and `rails_command` and also adds user interactivity with methods like `yes?`. All of these methods are part of the [Rails Template API](https://edgeapi.rubyonrails.org/classes/Rails/Generators/Actions.html). The following sections shows how to use more of these methods with examples.

## 9. Rails Generators API
Generators and the template Ruby scripts have access to several helper methods using a [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) (Domain Specific Language). These methods are part of the Rails Generators API and you can find more details at [`Thor::Actions`](https://www.rubydoc.info/gems/thor/Thor/Actions) and [`Rails::Generators::Actions`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html) API documentation.
Here's another example of a typical Rails template that scaffolds a model, runs migrations, and commits the changes with git:

# template.rb
generate(:scaffold, "person name:string")
route "root to: 'people#index'"
rails_command("db:migrate")

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

```
Copy
All code snippets in the examples below can be used in a template file, such as the `template.rb` file above.

### 9.1. add_source
The [`add_source`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-add_source) method adds the given source to the generated application's `Gemfile`.

```
add_source "https://rubygems.org"

```
Copy
If a block is given, gem entries in the block are wrapped into the source group. For example, if you need to source a gem from `"http://gems.github.com"`:

```
add_source "http://gems.github.com/" do
  gem "rspec-rails"
end

### 9.2. after_bundle
The [`after_bundle`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/AppGenerator.html#method-i-after_bundle) method registers a callback to be executed after the gems are bundled. For example, it would make sense to run the "install" command for `tailwindcss-rails` and `devise` only after those gems are bundled:

# Install gems
after_bundle do

# Install TailwindCSS
  rails_command "tailwindcss:install"

# Install Devise
  generate "devise:install"
end

```
Copy
The callbacks get executed even if `--skip-bundle` has been passed.

### 9.3. environment
The [`environment`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-environment) method adds a line inside the `Application` class for `config/application.rb`. If `options[:env]` is specified, the line is appended to the corresponding file in `config/environments`.

```
environment 'config.action_mailer.default_url_options = {host: "http://yourwebsite.example.com"}', env: "production"

```
Copy
The above will add the config line to `config/environments/production.rb`.

### 9.4. gem
The [`gem`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-gem) helper adds an entry for the given gem to the generated application's `Gemfile`.
For example, if your application depends on the gems `devise` and `tailwindcss-rails`:

```
gem "devise"
gem "tailwindcss-rails"

```
Copy
Note that this method only adds the gem to the `Gemfile`, it does not install the gem.
You can also specify an exact version:

```
gem "devise", "~> 4.9.4"

```
Copy
And you can also add comments that will be added to the `Gemfile`:

```
gem "devise", comment: "Add devise for authentication."

### 9.5. gem_group
The [`gem_group`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-gem_group) helper wraps gem entries inside a group. For example, to load `rspec-rails` only in the `development` and `test` groups:

```
gem_group :development, :test do
  gem "rspec-rails"
end

### 9.6. generate
You can even call a generator from inside a `template.rb` with the [`generate`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-generate) method. The following runs the `scaffold` rails generator with the given arguments:

```
generate(:scaffold, "person", "name:string", "address:text", "age:number")

### 9.7. git
Rails templates let you run any git command with the [`git`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-git) helper:

```
git :init
git add: "."
git commit: "-a -m 'Initial commit'"

### 9.8. initializer, vendor, lib, file
The [`initializer`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-initializer) helper method adds an initializer to the generated application's `config/initializers` directory.
After adding the below to the `template.rb` file, you can use `Object#not_nil?` and `Object#not_blank?` in your application:

```
initializer "not_methods.rb", <<-CODE
  class Object
    def not_nil?
      !nil?
    end

def not_blank?
      !blank?
    end
  end
CODE

```
Copy
Similarly, the [`lib`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-lib) method creates a file in the `lib/` directory and [`vendor`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-vendor) method creates a file in the `vendor/` directory.
There is also a `file` method (which is an alias for [`create_file`](https://www.rubydoc.info/gems/thor/Thor/Actions#create_file-instance_method)), which accepts a relative path from `Rails.root` and creates all the directories and files needed:

```
file "app/components/foo.rb", <<-CODE
  class Foo
  end
CODE

```
Copy
The above will create the `app/components` directory and put `foo.rb` in there.

### 9.9. rakefile
The [`rakefile`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-rakefile) method creates a new Rake file under `lib/tasks` with the given tasks:

```
rakefile("bootstrap.rake") do
  <<-TASK
    namespace :boot do
      task :strap do
        puts "I like boots!"
      end
    end
  TASK
end

```
Copy
The above creates `lib/tasks/bootstrap.rake` with a `boot:strap` rake task.

### 9.10. run
The [`run`](https://www.rubydoc.info/gems/thor/Thor/Actions#run-instance_method) method executes an arbitrary command. Let's say you want to remove the `README.rdoc` file:

```
run "rm README.rdoc"

### 9.11. rails_command
You can run the Rails commands in the generated application with the [`rails_command`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-rails_command) helper. Let's say you want to migrate the database at some point in the template ruby script:

```
rails_command "db:migrate"

```
Copy
Commands can be run with a different Rails environment:

```
rails_command "db:migrate", env: "production"

```
Copy
You can also run commands that should abort application generation if they fail:

```
rails_command "db:migrate", abort_on_failure: true

### 9.12. route
The [`route`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Actions.html#method-i-route) method adds an entry to the `config/routes.rb` file. To make `PeopleController#index` the default page for the application, we can add:

```
route "root to: 'person#index'"

```
Copy
There are also many helper methods that can manipulate the local file system, such as [`copy_file`](https://www.rubydoc.info/gems/thor/Thor/Actions#copy_file-instance_method), [`create_file`](https://www.rubydoc.info/gems/thor/Thor/Actions#create_file-instance_method), [`insert_into_file`](https://www.rubydoc.info/gems/thor/Thor/Actions#insert_into_file-instance_method), and [`inside`](https://www.rubydoc.info/gems/thor/Thor/Actions#inside-instance_method). You can see the [Thor API documentation](https://www.rubydoc.info/gems/thor/Thor/Actions) for details. Here is an example of one such method:

### 9.13. inside
This [`inside`](https://www.rubydoc.info/gems/thor/Thor/Actions#inside-instance_method) method enables you to run a command from a given directory. For example, if you have a copy of edge rails that you wish to symlink from your new apps, you can do this:

```
inside("vendor") do
  run "ln -s ~/my-forks/rails rails"
end

```
Copy
There are also methods that allow you to interact with the user from the Ruby template, such as [`ask`](https://www.rubydoc.info/gems/thor/Thor/Shell/Basic#ask-instance_method), [`yes`](https://www.rubydoc.info/gems/thor/Thor/Shell/Basic#yes%3F-instance_method), and [`no`](https://www.rubydoc.info/gems/thor/Thor/Shell/Basic#no%3F-instance_method). You can learn about all user interactivity methods in the [Thor Shell documentation](https://www.rubydoc.info/gems/thor/Thor/Shell/Basic). Let's see examples of using `ask`, `yes?` and `no?`:

### 9.14. ask
The [`ask`](https://www.rubydoc.info/gems/thor/Thor/Shell/Basic#ask-instance_method) methods allows you to get feedback from the user and use it in your templates. Let's say you want your user to name the new shiny library you're adding:

```
lib_name = ask("What do you want to call the shiny library?")
lib_name << ".rb" unless lib_name.index(".rb")

lib lib_name, <<-CODE
  class Shiny
  end
CODE

### 9.15. yes? or no?
These methods let you ask questions from templates and decide the flow based on the user's answer. Let's say you want to prompt the user to run migrations:

```
rails_command("db:migrate") if yes?("Run database migrations?")

# no? questions acts the opposite of yes?

## 10. Testing Generators
Rails provides testing helper methods via [`Rails::Generators::Testing::Behavior`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Testing/Behavior.html), such as:

If running tests against generators you will need to set `RAILS_LOG_TO_STDOUT=true` in order for debugging tools to work.

```
RAILS_LOG_TO_STDOUT=true ./bin/test test/generators/actions_test.rb

```
Copy
In addition to those, Rails also provides additional assertions via [`Rails::Generators::Testing::Assertions`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Generators/Testing/Assertions.html).