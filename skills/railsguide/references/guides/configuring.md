## 1. Locations for Initialization Code
Rails offers four standard spots to place initialization code:
  * `config/application.rb`
  * Environment-specific configuration files
  * Initializers
  * After-initializers

## 2. Running Code Before Rails
In the rare event that your application needs to run some code before Rails itself is loaded, put it above the call to `require "rails/all"` in `config/application.rb`.

## 3. Configuring Rails Components
In general, the work of configuring Rails means configuring the components of Rails, as well as configuring Rails itself. The configuration file `config/application.rb` and environment-specific configuration files (such as `config/environments/production.rb`) allow you to specify the various settings that you want to pass down to all of the components.
For example, you could add this setting to `config/application.rb` file:

```
config.time_zone = "Central Time (US & Canada)"

```
Copy
This is a setting for Rails itself. If you want to pass settings to individual Rails components, you can do so via the same `config` object in `config/application.rb`:

```
config.active_record.schema_format = :ruby

```
Copy
Rails will use that particular setting to configure Active Record.
Use the public configuration methods over calling directly to the associated class. e.g. `Rails.application.config.action_mailer.options` instead of `ActionMailer::Base.options`.
If you need to apply configuration directly to a class, use a [lazy load hook](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/LazyLoadHooks.html) in an initializer to avoid autoloading the class before initialization has completed. This will break because autoloading during initialization cannot be safely repeated when the app reloads.

### 3.1. Versioned Default Values
[`config.load_defaults`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Application/Configuration.html#method-i-load_defaults) loads default configuration values for a target version and all versions prior. For example, `config.load_defaults 6.1` will load defaults for all versions up to and including version 6.1.
Below are the default values associated with each target version. In cases of conflicting values, newer versions take precedence over older versions.

#### 3.1.1. Default Values for Target Version 8.1
  * `config.action_controller.action_on_path_relative_redirect`: `:raise`
  * `config.action_controller.escape_json_responses`: `false`
  * `config.action_view.remove_hidden_field_autocomplete`: `true`
  * `config.action_view.render_tracker`: `:ruby`
  * `config.active_record.raise_on_missing_required_finder_order_columns`: `true`
  * `config.active_support.escape_js_separators_in_json`: `false`
  * `config.yjit`: `!Rails.env.local?`

#### 3.1.2. Default Values for Target Version 8.0
  * `config.action_dispatch.strict_freshness`: `true`

#### 3.1.3. Default Values for Target Version 7.2
  * `config.active_record.postgresql_adapter_decode_dates`: `true`
  * `config.active_record.validate_migration_timestamps`: `true`
  * `config.active_storage.web_image_content_types`: `%w( image/png image/jpeg image/gif image/webp )`

#### 3.1.4. Default Values for Target Version 7.1
  * `config.action_dispatch.debug_exception_log_level`: `:error`
  * `config.action_dispatch.default_headers`: `{ "X-Frame-Options" => "SAMEORIGIN", "X-XSS-Protection" => "0", "X-Content-Type-Options" => "nosniff", "X-Permitted-Cross-Domain-Policies" => "none", "Referrer-Policy" => "strict-origin-when-cross-origin" }`
  * `config.action_text.sanitizer_vendor`: `Rails::HTML::Sanitizer.best_supported_vendor`
  * `config.action_view.sanitizer_vendor`: `Rails::HTML::Sanitizer.best_supported_vendor`
  * `config.active_record.before_committed_on_all_records`: `true`
  * `config.active_record.belongs_to_required_validates_foreign_key`: `false`
  * `config.active_record.default_column_serializer`: `nil`
  * `config.active_record.encryption.hash_digest_class`: `OpenSSL::Digest::SHA256`
  * `config.active_record.encryption.support_sha1_for_non_deterministic_encryption`: `false`
  * `config.active_record.generate_secure_token_on`: `:initialize`
  * `config.active_record.marshalling_format_version`: `7.1`
  * `config.active_record.query_log_tags_format`: `:sqlcommenter`
  * `config.active_record.raise_on_assign_to_attr_readonly`: `true`
  * `config.active_record.run_after_transaction_callbacks_in_order_defined`: `true`
  * `config.active_record.run_commit_callbacks_on_first_saved_instances_in_transaction`: `false`
  * `config.active_record.sqlite3_adapter_strict_strings_by_default`: `true`
  * `config.active_support.cache_format_version`: `7.1`
  * `config.active_support.message_serializer`: `:json_allow_marshal`
  * `config.active_support.raise_on_invalid_cache_expiration_time`: `true`
  * `config.active_support.use_message_serializer_for_metadata`: `true`
  * `config.add_autoload_paths_to_load_path`: `false`
  * `config.dom_testing_default_html_version`: `defined?(Nokogiri::HTML5) ? :html5 : :html4`
  * `config.log_file_size`: `100 * 1024 * 1024`
  * `config.precompile_filter_parameters`: `true`

#### 3.1.5. Default Values for Target Version 7.0
  * `config.action_controller.action_on_open_redirect`: `:raise`
  * `config.action_controller.wrap_parameters_by_default`: `true`
  * `config.action_dispatch.cookies_serializer`: `:json`
  * `config.action_dispatch.default_headers`: `{ "X-Frame-Options" => "SAMEORIGIN", "X-XSS-Protection" => "0", "X-Content-Type-Options" => "nosniff", "X-Download-Options" => "noopen", "X-Permitted-Cross-Domain-Policies" => "none", "Referrer-Policy" => "strict-origin-when-cross-origin" }`
  * `config.action_mailer.smtp_timeout`: `5`
  * `config.action_view.apply_stylesheet_media_default`: `false`
  * `config.action_view.button_to_generates_button_tag`: `true`
  * `config.active_record.automatic_scope_inversing`: `true`
  * `config.active_record.partial_inserts`: `false`
  * `config.active_record.verify_foreign_keys_for_fixtures`: `true`
  * `config.active_storage.multiple_file_field_include_hidden`: `true`
  * `config.active_storage.variant_processor`: `:vips`
  * `config.active_storage.video_preview_arguments`: `"-vf 'select=eq(n\\,0)+eq(key\\,1)+gt(scene\\,0.015),loop=loop=-1:size=2,trim=start_frame=1' -frames:v 1 -f image2"`
  * `config.active_support.cache_format_version`: `7.0`
  * `config.active_support.executor_around_test_case`: `true`
  * `config.active_support.hash_digest_class`: `OpenSSL::Digest::SHA256`
  * `config.active_support.key_generator_hash_digest_class`: `OpenSSL::Digest::SHA256`

#### 3.1.6. Default Values for Target Version 6.1
  * `ActiveSupport.utc_to_local_returns_utc_offset_times`: `true`
  * `config.action_dispatch.cookies_same_site_protection`: `:lax`
  * `config.action_dispatch.ssl_default_redirect_status`: `308`
  * `config.action_mailbox.queues.incineration`: `nil`
  * `config.action_mailbox.queues.routing`: `nil`
  * `config.action_mailer.deliver_later_queue_name`: `nil`
  * `config.action_view.form_with_generates_remote_forms`: `false`
  * `config.action_view.preload_links_header`: `true`
  * `config.active_job.retry_jitter`: `0.15`
  * `config.active_record.has_many_inversing`: `true`
  * `config.active_storage.queues.analysis`: `nil`
  * `config.active_storage.queues.purge`: `nil`
  * `config.active_storage.track_variants`: `true`

#### 3.1.7. Default Values for Target Version 6.0
  * `config.action_dispatch.use_cookies_with_metadata`: `true`
  * `config.action_mailer.delivery_job`: `"ActionMailer::MailDeliveryJob"`
  * `config.action_view.default_enforce_utf8`: `false`
  * `config.active_record.collection_cache_versioning`: `true`
  * `config.active_storage.queues.analysis`: `:active_storage_analysis`
  * `config.active_storage.queues.purge`: `:active_storage_purge`

#### 3.1.8. Default Values for Target Version 5.2
  * `config.action_controller.default_protect_from_forgery`: `true`
  * `config.action_dispatch.use_authenticated_cookie_encryption`: `true`
  * `config.action_view.form_with_generates_ids`: `true`
  * `config.active_record.cache_versioning`: `true`
  * `config.active_support.hash_digest_class`: `OpenSSL::Digest::SHA1`
  * `config.active_support.use_authenticated_message_encryption`: `true`

#### 3.1.9. Default Values for Target Version 5.1
  * `config.action_view.form_with_generates_remote_forms`: `true`
  * `config.assets.unknown_asset_fallback`: `false`

#### 3.1.10. Default Values for Target Version 5.0
  * `config.action_controller.forgery_protection_origin_check`: `true`
  * `config.action_controller.per_form_csrf_tokens`: `true`
  * `config.active_record.belongs_to_required_by_default`: `true`
  * `config.ssl_options`: `{ hsts: { subdomains: true } }`

### 3.2. Rails General Configuration
The following configuration methods are to be called on a `Rails::Railtie` object, such as a subclass of `Rails::Engine` or `Rails::Application`.

#### 3.2.1. `config.add_autoload_paths_to_load_path`
Says whether autoload paths have to be added to `$LOAD_PATH`. It is recommended to be set to `false` in `:zeitwerk` mode early, in `config/application.rb`. Zeitwerk uses absolute paths internally, and applications running in `:zeitwerk` mode do not need `require_dependency`, so models, controllers, jobs, etc. do not need to be in `$LOAD_PATH`. Setting this to `false` saves Ruby from checking these directories when resolving `require` calls with relative paths, and saves Bootsnap work and RAM, since it does not need to build an index for them.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 7.1  | `false`  |
The `lib` directory is not affected by this flag, it is added to `$LOAD_PATH` always.

#### 3.2.2. `config.after_initialize`
Takes a block which will be run _after_ Rails has finished initializing the application. That includes the initialization of the framework itself, engines, and all the application's initializers in `config/initializers`. Note that this block _will_ be run for rake tasks. Useful for configuring values set up by other initializers:

```
config.after_initialize do
  ActionView::Base.sanitized_allowed_tags.delete "div"
end

```
Copy

#### 3.2.3. `config.after_routes_loaded`
Takes a block which will be run after Rails has finished loading the application routes. This block will also be run whenever routes are reloaded.

```
config.after_routes_loaded do

# Code that does something with Rails.application.routes
end

#### 3.2.4. `config.allow_concurrency`
Controls whether requests should be handled concurrently. This should only be set to `false` if application code is not thread safe. Defaults to `true`.

#### 3.2.5. `config.asset_host`
Sets the host for the assets. Useful when CDNs are used for hosting assets, or when you want to work around the concurrency constraints built-in in browsers using different domain aliases. Shorter version of `config.action_controller.asset_host`.

#### 3.2.6. `config.assume_ssl`
Makes application believe that all requests are arriving over SSL. This is useful when proxying through a load balancer that terminates SSL, the forwarded request will appear as though it's HTTP instead of HTTPS to the application. This makes redirects and cookie security target HTTP instead of HTTPS. This middleware makes the server assume that the proxy already terminated SSL, and that the request really is HTTPS.

#### 3.2.7. `config.autoflush_log`
Enables writing log file output immediately instead of buffering. Defaults to `true`.

#### 3.2.8. `config.autoload_lib(ignore:)`
This method adds `lib` to `config.autoload_paths` and `config.eager_load_paths`.
Normally, the `lib` directory has subdirectories that should not be autoloaded or eager loaded. Please, pass their name relative to `lib` in the required `ignore` keyword argument. For example,

```
config.autoload_lib(ignore: %w(assets tasks generators))

```
Copy
Please, see more details in the [autoloading guide](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html).

#### 3.2.9. `config.autoload_lib_once(ignore:)`
The method `config.autoload_lib_once` is similar to `config.autoload_lib`, except that it adds `lib` to `config.autoload_once_paths` instead.
By calling `config.autoload_lib_once`, classes and modules in `lib` can be autoloaded, even from application initializers, but won't be reloaded.

#### 3.2.10. `config.autoload_once_paths`
Accepts an array of paths from which Rails will autoload constants that won't be wiped per request. Relevant if reloading is enabled, which it is by default in the `development` environment. Otherwise, all autoloading happens only once. All elements of this array must also be in `autoload_paths`. Default is an empty array.

#### 3.2.11. `config.autoload_paths`
Accepts an array of paths from which Rails will autoload constants. Default is an empty array. Since [Rails 6](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#autoloading), it is not recommended to adjust this. See [Autoloading and Reloading Constants](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#autoload-paths).

#### 3.2.12. `config.beginning_of_week`
Sets the default beginning of week for the application. Accepts a valid day of week as a symbol (e.g. `:monday`).

#### 3.2.13. `config.cache_classes`
Old setting equivalent to `!config.enable_reloading`. Supported for backwards compatibility.

#### 3.2.14. `config.cache_store`
Configures which cache store to use for Rails caching. Options include one of the symbols `:memory_store`, `:file_store`, `:mem_cache_store`, `:null_store`, `:redis_cache_store`, or an object that implements the cache API. Defaults to `:file_store`. See [Cache Stores](https://guides.rubyonrails.org/caching_with_rails.html#cache-stores) for per-store configuration options.

#### 3.2.15. `config.colorize_logging`
Specifies whether or not to use ANSI color codes when logging information. Defaults to `true`.

#### 3.2.16. `config.consider_all_requests_local`
Is a flag. If `true` then any error will cause detailed debugging information to be dumped in the HTTP response, and the `Rails::Info` controller will show the application runtime context in `/rails/info/properties`. `true` by default in the development and test environments, and `false` in production. For finer-grained control, set this to `false` and implement `show_detailed_exceptions?` in controllers to specify which requests should provide debugging information on errors.

#### 3.2.17. `config.console`
Allows you to set the class that will be used as console when you run `bin/rails console`. It's best to run it in the `console` block:

```
console do

# this block is called only when running console,

# so we can safely require pry here
  require "pry"
  config.console = Pry
end

#### 3.2.18. `config.content_security_policy_nonce_auto`
See [Adding a Nonce](https://guides.rubyonrails.org/security.html#adding-a-nonce) in the Security Guide

#### 3.2.19. `config.content_security_policy_nonce_directives`
See [Adding a Nonce](https://guides.rubyonrails.org/security.html#adding-a-nonce) in the Security Guide

#### 3.2.20. `config.content_security_policy_nonce_generator`
See [Adding a Nonce](https://guides.rubyonrails.org/security.html#adding-a-nonce) in the Security Guide

#### 3.2.21. `config.content_security_policy_report_only`
See [Reporting Violations](https://guides.rubyonrails.org/security.html#reporting-violations) in the Security Guide

#### 3.2.22. `config.credentials.content_path`
The path of the encrypted credentials file.
Defaults to `config/credentials/#{Rails.env}.yml.enc` if it exists, or `config/credentials.yml.enc` otherwise.
In order for the `bin/rails credentials` commands to recognize this value, it must be set in `config/application.rb` or `config/environments/#{Rails.env}.rb`.

#### 3.2.23. `config.credentials.key_path`
The path of the encrypted credentials key file.
Defaults to `config/credentials/#{Rails.env}.key` if it exists, or `config/master.key` otherwise.
In order for the `bin/rails credentials` commands to recognize this value, it must be set in `config/application.rb` or `config/environments/#{Rails.env}.rb`.

#### 3.2.24. `config.debug_exception_response_format`
Sets the format used in responses when errors occur in the development environment. Defaults to `:api` for API only apps and `:default` for normal apps.

#### 3.2.25. `config.disable_sandbox`
Controls whether or not someone can start a console in sandbox mode. This is helpful to avoid a long running session of sandbox console, that could lead a database server to run out of memory. Defaults to `false`.

#### 3.2.26. `config.dom_testing_default_html_version`
Controls whether an HTML4 parser or an HTML5 parser is used by default by the test helpers in Action View, Action Dispatch, and `rails-dom-testing`.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:html4`  |
| 7.1  |  `:html5` (see NOTE)  |
Nokogiri's HTML5 parser is not supported on JRuby, so on JRuby platforms Rails will fall back to `:html4`.

#### 3.2.27. `config.eager_load`
When `true`, eager loads all registered `config.eager_load_namespaces`. This includes your application, engines, Rails frameworks, and any other registered namespace.

#### 3.2.28. `config.eager_load_namespaces`
Registers namespaces that are eager loaded when `config.eager_load` is set to `true`. All namespaces in the list must respond to the `eager_load!` method.

#### 3.2.29. `config.eager_load_paths`
Accepts an array of paths from which Rails will eager load on boot if `config.eager_load` is true. Defaults to every folder in the `app` directory of the application.

#### 3.2.30. `config.enable_reloading`
If `config.enable_reloading` is true, application classes and modules are reloaded in between web requests if they change. Defaults to `true` in the `development` environment, and `false` in the `production` environment.
The predicate `config.reloading_enabled?` is also defined.

#### 3.2.31. `config.encoding`
Sets up the application-wide encoding. Defaults to UTF-8.

#### 3.2.32. `config.exceptions_app`
Sets the exceptions application invoked by the `ShowException` middleware when an exception happens. Defaults to `ActionDispatch::PublicExceptions.new(Rails.public_path)`.

#### 3.2.33. `config.file_watcher`
Is the class used to detect file updates in the file system when `config.reload_classes_only_on_change` is `true`. Rails ships with `ActiveSupport::FileUpdateChecker`, the default, and `ActiveSupport::EventedFileUpdateChecker`. Custom classes must conform to the `ActiveSupport::FileUpdateChecker` API.
Using `ActiveSupport::EventedFileUpdateChecker` depends on the [listen](https://github.com/guard/listen) gem:

```
group :development do
  gem "listen", "~> 3.5"
end

```
Copy
On Linux and macOS no additional gems are needed, but some are required [for *BSD](https://github.com/guard/listen#on-bsd) and [for Windows](https://github.com/guard/listen#on-windows).
Note that [some setups are unsupported](https://github.com/guard/listen#issues--limitations).

#### 3.2.34. `config.filter_parameters`
Used for filtering out the parameters that you don't want shown in the logs, such as passwords or credit card numbers. It also filters out sensitive values of database columns when calling `#inspect` on an Active Record object. By default, Rails filters out passwords by adding the following filters in `config/initializers/filter_parameter_logging.rb`.

```
Rails.application.config.filter_parameters += [
  :passw, :email, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :cvv, :cvc
]

```
Copy
Parameters filter works by partial matching regular expression.

#### 3.2.35. `config.filter_redirect`
Used for filtering out redirect urls from application logs.

```
Rails.application.config.filter_redirect += ["s3.amazonaws.com", /private-match/]

```
Copy
The redirect filter works by testing that urls include strings or match regular expressions.

#### 3.2.36. `config.force_ssl`
Forces all requests to be served over HTTPS, and sets "https://" as the default protocol when generating URLs. Enforcement of HTTPS is handled by the `ActionDispatch::SSL` middleware, which can be configured via `config.ssl_options`.

#### 3.2.37. `config.helpers_paths`
Defines an array of additional paths to load view helpers.

#### 3.2.38. `config.host_authorization`
Accepts a hash of options to configure the HostAuthorization middleware

#### 3.2.39. `config.hosts`
An array of strings, regular expressions, or `IPAddr` used to validate the `Host` header. Used by the HostAuthorization middleware to help prevent DNS rebinding attacks.

#### 3.2.40. `config.javascript_path`
Sets the path where your app's JavaScript lives relative to the `app` directory and the default value is `javascript`. An app's configured `javascript_path` will be excluded from `autoload_paths`.

#### 3.2.41. `config.log_file_size`
Defines the maximum size of the Rails log file in bytes. Defaults to `104_857_600` (100 MiB) in development and test, and unlimited in all other environments.

#### 3.2.42. `config.log_formatter`
Defines the formatter of the Rails logger. This option defaults to an instance of `ActiveSupport::Logger::SimpleFormatter` for all environments. If you are setting a value for `config.logger` you must manually pass the value of your formatter to your logger before it is wrapped in an `ActiveSupport::TaggedLogging` instance, Rails will not do it for you.

#### 3.2.43. `config.log_level`
Defines the verbosity of the Rails logger. This option defaults to `:debug` for all environments except production, where it defaults to `:info`. The available log levels are: `:debug`, `:info`, `:warn`, `:error`, `:fatal`, and `:unknown`.

#### 3.2.44. `config.log_tags`
Accepts a list of methods that the `request` object responds to, a `Proc` that accepts the `request` object, or something that responds to `to_s`. This makes it easy to tag log lines with debug information like subdomain and request id - both very helpful in debugging multi-user production applications.

#### 3.2.45. `config.logger`
Is the logger that will be used for `Rails.logger` and any related Rails logging such as `ActiveRecord::Base.logger`. It defaults to an instance of `ActiveSupport::TaggedLogging` that wraps an instance of `ActiveSupport::Logger` which outputs a log to the `log/` directory. You can supply a custom logger, to get full compatibility you must follow these guidelines:
  * To support a formatter, you must manually assign a formatter from the `config.log_formatter` value to the logger.
  * To support tagged logs, the log instance must be wrapped with `ActiveSupport::TaggedLogging`.
  * To support silencing, the logger must include `ActiveSupport::LoggerSilence` module. The `ActiveSupport::Logger` class already includes these modules.

```
class MyLogger  ::Logger
  include ActiveSupport::LoggerSilence
end

mylogger           = MyLogger.new(STDOUT)
mylogger.formatter = config.log_formatter
config.logger      = ActiveSupport::TaggedLogging.new(mylogger)

#### 3.2.46. `config.middleware`
Allows you to configure the application's middleware. This is covered in depth in the Configuring Middleware section below.

#### 3.2.47. `config.precompile_filter_parameters`
When `true`, will precompile `config.filter_parameters` using [`ActiveSupport::ParameterFilter.precompile_filters`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/ParameterFilter.html#method-c-precompile_filters).
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.1  | `true`  |

#### 3.2.48. `config.public_file_server.enabled`
Configures whether Rails should serve static files from the public directory. Defaults to `true`.
If the server software (e.g. NGINX or Apache) should serve static files instead, set this value to `false`.

#### 3.2.49. `config.railties_order`
Allows manually specifying the order that Railties/Engines are loaded. The default value is `[:all]`.

```
config.railties_order = [Blog::Engine, :main_app, :all]

#### 3.2.50. `config.rake_eager_load`
When `true`, eager load the application when running Rake tasks. Defaults to `false`.

#### 3.2.51. `config.relative_url_root`
Can be used to tell Rails that you are [deploying to a subdirectory](https://guides.rubyonrails.org/configuring.html#deploy-to-a-subdirectory-relative-url-root). The default is `ENV['RAILS_RELATIVE_URL_ROOT']`.

#### 3.2.52. `config.reload_classes_only_on_change`
Enables or disables reloading of classes only when tracked files change. By default tracks everything on autoload paths and is set to `true`. If `config.enable_reloading` is `false`, this option is ignored.

#### 3.2.53. `config.require_master_key`
Causes the app to not boot if a master key hasn't been made available through `ENV["RAILS_MASTER_KEY"]` or the `config/master.key` file.

#### 3.2.54. `config.sandbox_by_default`
When `true`, rails console starts in sandbox mode. To start rails console in non-sandbox mode, `--no-sandbox` must be specified. This is helpful to avoid accidental writing to the production database. Defaults to `false`.

#### 3.2.55. `config.secret_key_base`
The fallback for specifying the input secret for an application's key generator. It is recommended to leave this unset, and instead to specify a `secret_key_base` in `config/credentials.yml.enc`. See the [`secret_key_base` API documentation](https://api.rubyonrails.org/v8.1.3/classes/Rails/Application.html#method-i-secret_key_base) for more information and alternative configuration methods.

#### 3.2.56. `config.server_timing`
When `true`, adds the `ServerTiming` middleware to the middleware stack. Defaults to `false`, but is set to `true` in the default generated `config/environments/development.rb` file.

#### 3.2.57. `config.session_options`
Additional options passed to `config.session_store`. You should use `config.session_store` to set this instead of modifying it yourself.

```
config.session_store :cookie_store, key: "_your_app_session"
config.session_options # => {key: "_your_app_session"}

#### 3.2.58. `config.session_store`
Specifies what class to use to store the session. Possible values are `:cache_store`, `:cookie_store`, `:mem_cache_store`, a custom store, or `:disabled`. `:disabled` tells Rails not to deal with sessions.
This setting is configured via a regular method call, rather than a setter. This allows additional options to be passed:

```
config.session_store :cookie_store, key: "_your_app_session"

```
Copy
If a custom store is specified as a symbol, it will be resolved to the `ActionDispatch::Session` namespace:

```

# use ActionDispatch::Session::MyCustomStore as the session store
config.session_store :my_custom_store

```
Copy
The default store is a cookie store with the application name as the session key.

#### 3.2.59. `config.silence_healthcheck_path`
Specifies the path of the health check that should be silenced in the logs. Uses `Rails::Rack::SilenceRequest` to implement the silencing. All in service of keeping health checks from clogging the production logs, especially for early-stage applications.

```
config.silence_healthcheck_path = "/up"

#### 3.2.60. `config.ssl_options`
Configuration options for the [`ActionDispatch::SSL`](https://api.rubyonrails.org/v8.1.3/classes/ActionDispatch/SSL.html) middleware.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `{}`  |
| 5.0  | `{ hsts: { subdomains: true } }`  |

#### 3.2.61. `config.time_zone`
Sets the default time zone for the application and enables time zone awareness for Active Record.

#### 3.2.62. `config.x`
Used to easily add nested custom configuration to the application config object

```
  config.x.payment_processing.schedule = :daily
  Rails.configuration.x.payment_processing.schedule # => :daily

```
Copy
See Custom Configuration

#### 3.2.63. `config.yjit`
Enables YJIT as of Ruby 3.3, to bring sizeable performance improvements. If you are deploying to a memory constrained environment you may want to set this to `false`. Additionally, you can pass a hash to configure YJIT options such as `{ stats: true }`.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.2  | `true`  |
| 8.1  | `!Rails.env.local?`  |

### 3.3. Configuring Assets

#### 3.3.1. `config.assets.css_compressor`
Defines the CSS compressor to use. It is set by default by `sass-rails`. The unique alternative value at the moment is `:yui`, which uses the `yui-compressor` gem.

#### 3.3.2. `config.assets.js_compressor`
Defines the JavaScript compressor to use. Possible values are `:terser`, `:closure`, `:uglifier`, and `:yui`, which require the use of the `terser`, `closure-compiler`, `uglifier`, or `yui-compressor` gems respectively.

#### 3.3.3. `config.assets.gzip`
A flag that enables the creation of gzipped version of compiled assets, along with non-gzipped assets. Set to `true` by default.

#### 3.3.4. `config.assets.paths`
Contains the paths which are used to look for assets. Appending paths to this configuration option will cause those paths to be used in the search for assets.

#### 3.3.5. `config.assets.precompile`
Allows you to specify additional assets (other than `application.css` and `application.js`) which are to be precompiled when `bin/rails assets:precompile` is run.

#### 3.3.6. `config.assets.unknown_asset_fallback`
Allows you to modify the behavior of the asset pipeline when an asset is not in the pipeline, if you use sprockets-rails 3.2.0 or newer.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 5.1  | `false`  |

#### 3.3.7. `config.assets.prefix`
Defines the prefix where assets are served from. Defaults to `/assets`.

#### 3.3.8. `config.assets.manifest`
Defines the full path to be used for the asset precompiler's manifest file. Defaults to a file named `manifest-<random>.json` in the `config.assets.prefix` directory within the public folder.

#### 3.3.9. `config.assets.digest`
Enables the use of SHA256 fingerprints in asset names. Set to `true` by default.

#### 3.3.10. `config.assets.debug`
Disables the concatenation and compression of assets.

#### 3.3.11. `config.assets.version`
Is an option string that is used in SHA256 hash generation. This can be changed to force all files to be recompiled.

#### 3.3.12. `config.assets.compile`
Is a boolean that can be used to turn on live Sprockets compilation in production.

#### 3.3.13. `config.assets.logger`
Accepts a logger conforming to the interface of Log4r or the default Ruby `Logger` class. Defaults to the same configured at `config.logger`. Setting `config.assets.logger` to `false` will turn off served assets logging.

#### 3.3.14. `config.assets.quiet`
Disables logging of assets requests. Set to `true` by default in `config/environments/development.rb`.

### 3.4. Configuring Generators
Rails allows you to alter what generators are used with the `config.generators` method. This method takes a block:

```
config.generators do |g|
  g.orm :active_record
  g.test_framework :test_unit
end

```
Copy
The full set of methods that can be used in this block are as follows:
  * `force_plural` allows pluralized model names. Defaults to `false`.
  * `helper` defines whether or not to generate helpers. Defaults to `true`.
  * `integration_tool` defines which integration tool to use to generate integration tests. Defaults to `:test_unit`.
  * `system_tests` defines which integration tool to use to generate system tests. Defaults to `:test_unit`.
  * `orm` defines which orm to use. Defaults to `false` and will use Active Record by default.
  * `resource_controller` defines which generator to use for generating a controller when using `bin/rails generate resource`. Defaults to `:controller`.
  * `resource_route` defines whether a resource route definition should be generated or not. Defaults to `true`.
  * `scaffold_controller` different from `resource_controller`, defines which generator to use for generating a _scaffolded_ controller when using `bin/rails generate scaffold`. Defaults to `:scaffold_controller`.
  * `test_framework` defines which test framework to use. Defaults to `false` and will use minitest by default.
  * `template_engine` defines which template engine to use, such as ERB or Haml. Defaults to `:erb`.
  * `apply_rubocop_autocorrect_after_generate!` applies RuboCop's autocorrect feature after Rails generators are run.

### 3.5. Configuring Middleware
Every Rails application comes with a standard set of middleware which it uses in this order in the development environment:

#### 3.5.1. `ActionDispatch::HostAuthorization`
Prevents against DNS rebinding and other `Host` header attacks. It is included in the development environment by default with the following configuration:

```
Rails.application.config.hosts = [
  IPAddr.new("0.0.0.0/0"),        # All IPv4 addresses.
  IPAddr.new("::/0"),             # All IPv6 addresses.
  "localhost",                    # The localhost reserved domain.
  ENV["RAILS_DEVELOPMENT_HOSTS"]  # Additional comma-separated hosts for development.
]

```
Copy
In other environments `Rails.application.config.hosts` is empty and no `Host` header checks will be done. If you want to guard against header attacks on production, you have to manually permit the allowed hosts with:

```
Rails.application.config.hosts << "product.com"

```
Copy
The host of a request is checked against the `hosts` entries with the case operator (`#===`), which lets `hosts` support entries of type `Regexp`, `Proc` and `IPAddr` to name a few. Here is an example with a regexp.

# Allow requests from subdomains like `www.product.com` and

# `beta1.product.com`.
Rails.application.config.hosts << /.*\.product\.com/

```
Copy
The provided regexp will be wrapped with both anchors (`\A` and `\z`) so it must match the entire hostname. `/product.com/`, for example, once anchored, would fail to match `www.product.com`.
A special case is supported that allows you to permit the domain and all sub-domains:

# Allow requests from the domain itself `product.com` and subdomains like `www.product.com` and `beta1.product.com`.
Rails.application.config.hosts << ".product.com"

```
Copy
You can exclude certain requests from Host Authorization checks by setting `config.host_authorization.exclude`:

# Exclude requests for the /healthcheck/ path from host checking
Rails.application.config.host_authorization = {
  exclude: ->(request) { request.path.include?("healthcheck") }
}

```
Copy
When a request comes to an unauthorized host, a default Rack application will run and respond with `403 Forbidden`. This can be customized by setting `config.host_authorization.response_app`. For example:

```
Rails.application.config.host_authorization = {
  response_app: -> env do
    [400, { "Content-Type" => "text/plain" }, ["Bad Request"]]
  end
}

#### 3.5.2. `ActionDispatch::ServerTiming`
Adds the [`Server-Timing`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Server-Timing) header to the response, which includes performance metrics from the server. This data can be viewed by inspecting the response in the Network panel of the browser's Developer Tools. Most browsers provide a Timing tab that visualizes the data.

#### 3.5.3. `ActionDispatch::SSL`
Forces every request to be served using HTTPS. Enabled if `config.force_ssl` is set to `true`. Options passed to this can be configured by setting `config.ssl_options`.

#### 3.5.4. `ActionDispatch::Static`
Is used to serve static assets. Disabled if `config.public_file_server.enabled` is `false`. Set `config.public_file_server.index_name` if you need to serve a static directory index file that is not named `index`. For example, to serve `main.html` instead of `index.html` for directory requests, set `config.public_file_server.index_name` to `"main"`.

#### 3.5.5. `ActionDispatch::Executor`
Allows thread safe code reloading. Disabled if `config.allow_concurrency` is `false`, which causes `Rack::Lock` to be loaded. `Rack::Lock` wraps the app in mutex so it can only be called by a single thread at a time.

#### 3.5.6. `ActiveSupport::Cache::Strategy::LocalCache`
Serves as a basic memory backed cache. This cache is not thread safe and is intended only for serving as a temporary memory cache for a single thread.

#### 3.5.7. `Rack::Runtime`
Sets an `X-Runtime` header, containing the time (in seconds) taken to execute the request.

#### 3.5.8. `Rails::Rack::Logger`
Notifies the logs that the request has begun. After request is complete, flushes all the logs.

#### 3.5.9. `ActionDispatch::ShowExceptions`
Rescues any exception returned by the application and renders nice exception pages if the request is local or if `config.consider_all_requests_local` is set to `true`. If `config.action_dispatch.show_exceptions` is set to `:none`, exceptions will be raised regardless.

#### 3.5.10. `ActionDispatch::RequestId`
Makes a unique X-Request-Id header available to the response and enables the `ActionDispatch::Request#uuid` method. Configurable with `config.action_dispatch.request_id_header`.

#### 3.5.11. `ActionDispatch::RemoteIp`
Checks for IP spoofing attacks and gets valid `client_ip` from request headers. Configurable with the `config.action_dispatch.ip_spoofing_check`, and `config.action_dispatch.trusted_proxies` options.

#### 3.5.12. `Rack::Sendfile`
Intercepts responses whose body is being served from a file and replaces it with a server specific X-Sendfile header. Configurable with `config.action_dispatch.x_sendfile_header`.

#### 3.5.13. `ActionDispatch::Callbacks`
Runs the prepare callbacks before serving the request.

#### 3.5.14. `ActionDispatch::Cookies`
Sets cookies for the request.

#### 3.5.15. `ActionDispatch::Session::CookieStore`
Is responsible for storing the session in cookies. An alternate middleware can be used for this by changing `config.session_store`.

#### 3.5.16. `ActionDispatch::Flash`
Sets up the `flash` keys. Only available if `config.session_store` is set to a value.

#### 3.5.17. `Rack::MethodOverride`
Allows the method to be overridden if `params[:_method]` is set. This is the middleware which supports the PATCH, PUT, and DELETE HTTP method types.

#### 3.5.18. `Rack::Head`
Returns an empty body for all HEAD requests. It leaves all other requests unchanged.

#### 3.5.19. Adding Custom Middleware
Besides these usual middleware, you can add your own by using the `config.middleware.use` method:

```
config.middleware.use Magical::Unicorns

```
Copy
This will put the `Magical::Unicorns` middleware on the end of the stack. You can use `insert_before` if you wish to add a middleware before another.

```
config.middleware.insert_before Rack::Head, Magical::Unicorns

```
Copy
Or you can insert a middleware to exact position by using indexes. For example, if you want to insert `Magical::Unicorns` middleware on top of the stack, you can do it, like so:

```
config.middleware.insert_before 0, Magical::Unicorns

```
Copy
There's also `insert_after` which will insert a middleware after another:

```
config.middleware.insert_after Rack::Head, Magical::Unicorns

```
Copy
Middlewares can also be completely swapped out and replaced with others:

```
config.middleware.swap ActionController::Failsafe, Lifo::Failsafe

```
Copy
Middlewares can be moved from one place to another:

```
config.middleware.move_before ActionDispatch::Flash, Magical::Unicorns

```
Copy
This will move the `Magical::Unicorns` middleware before `ActionDispatch::Flash`. You can also move it after:

```
config.middleware.move_after ActionDispatch::Flash, Magical::Unicorns

```
Copy
They can also be removed from the stack completely:

```
config.middleware.delete Rack::MethodOverride

### 3.6. Configuring i18n
All these configuration options are delegated to the `I18n` library.

#### 3.6.1. `config.i18n.available_locales`
Defines the permitted available locales for the app. Defaults to all locale keys found in locale files, usually only `:en` on a new application.

#### 3.6.2. `config.i18n.default_locale`
Sets the default locale of an application used for i18n. Defaults to `:en`.

#### 3.6.3. `config.i18n.enforce_available_locales`
Ensures that all locales passed through i18n must be declared in the `available_locales` list, raising an `I18n::InvalidLocale` exception when setting an unavailable locale. Defaults to `true`. It is recommended not to disable this option unless strongly required, since this works as a security measure against setting any invalid locale from user input.

#### 3.6.4. `config.i18n.load_path`
Sets the path Rails uses to look for locale files. Defaults to `config/locales/**/*.{yml,rb}`.

#### 3.6.5. `config.i18n.raise_on_missing_translations`
Determines whether an error should be raised for missing translations. If `true`, views and controllers raise `I18n::MissingTranslationData`. If `:strict`, models also raise the error. This defaults to `false`.

#### 3.6.6. `config.i18n.fallbacks`
Sets fallback behavior for missing translations. Here are 3 usage examples for this option:
  * You can set the option to `true` for using default locale as fallback, like so:

```
config.i18n.fallbacks = true

```
Copy
  * Or you can set an array of locales as fallback, like so:

```
config.i18n.fallbacks = [:tr, :en]

```
Copy
  * Or you can set different fallbacks for locales individually. For example, if you want to use `:tr` for `:az` and `:de`, `:en` for `:da` as fallbacks, you can do it, like so:

```
config.i18n.fallbacks = { az: :tr, da: [:de, :en] }
#or
config.i18n.fallbacks.map = { az: :tr, da: [:de, :en] }

### 3.7. Configuring Active Model

#### 3.7.1. `config.active_model.i18n_customize_full_message`
Controls whether the [`Error#full_message`](https://api.rubyonrails.org/v8.1.3/classes/ActiveModel/Error.html#method-i-full_message) format can be overridden in an i18n locale file. Defaults to `false`.
When set to `true`, `full_message` will look for a format at the attribute and model level of the locale files. The default format is `"%{attribute} %{message}"`, where `attribute` is the name of the attribute, and `message` is the validation-specific message. The following example overrides the format for all `Person` attributes, as well as the format for a specific `Person` attribute (`age`).

```
class Person
  include ActiveModel::Validations

attr_accessor :name, :age

validates :name, :age, presence: true
end

```
en:
  activemodel: # or activerecord:
    errors:
      models:
        person:
          # Override the format for all Person attributes:
          format: "Invalid%{attribute}(%{message})"
          attributes:
            age:
              # Override the format for the age attribute:
              format: "%{message}"
              blank: "Pleasefillinyour%{attribute}"

```
irb>person = Person.new.tap(:valid?)

irb>person.errors.full_messages
=> [
  "Invalid Name (can't be blank)",
  "Please fill in your Age"
]

irb>person.errors.messages
=> {
  :name => ["can't be blank"],
  :age  => ["Please fill in your Age"]
}

### 3.8. Configuring Active Record
`config.active_record` includes a variety of configuration options:

#### 3.8.1. `config.active_record.logger`
Accepts a logger conforming to the interface of Log4r or the default Ruby Logger class, which is then passed on to any new database connections made. You can retrieve this logger by calling `logger` on either an Active Record model class or an Active Record model instance. Set to `nil` to disable logging.

#### 3.8.2. `config.active_record.primary_key_prefix_type`
Lets you adjust the naming for primary key columns. By default, Rails assumes that primary key columns are named `id` (and this configuration option doesn't need to be set). There are two other choices:
  * `:table_name` would make the primary key for the Customer class `customerid`.
  * `:table_name_with_underscore` would make the primary key for the Customer class `customer_id`.

#### 3.8.3. `config.active_record.table_name_prefix`
Lets you set a global string to be prepended to table names. If you set this to `northwest_`, then the Customer class will look for `northwest_customers` as its table. The default is an empty string.

#### 3.8.4. `config.active_record.table_name_suffix`
Lets you set a global string to be appended to table names. If you set this to `_northwest`, then the Customer class will look for `customers_northwest` as its table. The default is an empty string.

#### 3.8.5. `config.active_record.schema_migrations_table_name`
Lets you set a string to be used as the name of the schema migrations table.

#### 3.8.6. `config.active_record.internal_metadata_table_name`
Lets you set a string to be used as the name of the internal metadata table.

#### 3.8.7. `config.active_record.protected_environments`
Lets you set an array of names of environments where destructive actions should be prohibited.

#### 3.8.8. `config.active_record.pluralize_table_names`
Specifies whether Rails will look for singular or plural table names in the database. If set to `true` (the default), then the Customer class will use the `customers` table. If set to `false`, then the Customer class will use the `customer` table.
Some Rails generators and installers (notably `active_storage:install` and `action_text:install`) create tables with plural names regardless of this setting. If you set `pluralize_table_names` to `false`, you will need to manually rename those tables after installation to maintain consistency. This limitation exists because these installers use fixed table names in their migrations for compatibility reasons.

#### 3.8.9. `config.active_record.default_timezone`
Determines whether to use `Time.local` (if set to `:local`) or `Time.utc` (if set to `:utc`) when pulling dates and times from the database. The default is `:utc`.

#### 3.8.10. `config.active_record.schema_format`
Controls the format for dumping the database schema to a file. The options are `:ruby` (the default) for a database-independent version that depends on migrations, or `:sql` for a set of (potentially database-dependent) SQL statements. This can be overridden per-database by setting `schema_format` in your database configuration.

#### 3.8.11. `config.active_record.error_on_ignored_order`
Specifies if an error should be raised if the order of a query is ignored during a batch query. The options are `true` (raise error) or `false` (warn). Default is `false`.

#### 3.8.12. `config.active_record.timestamped_migrations`
Controls whether migrations are numbered with serial integers or with timestamps. The default is `true`, to use timestamps, which are preferred if there are multiple developers working on the same application.

#### 3.8.13. `config.active_record.automatically_invert_plural_associations`
Controls whether Active Record will automatically look for inverse relations with a pluralized name.
Example:

```
class Post  ApplicationRecord
  has_many :comments
end

class Comment  ApplicationRecord
  belongs_to :post
end

```
Copy
In the above case Active Record used to only look for a `:comment` (singular) association in `Post`, and won't find it.
With this option enabled, it will also look for a `:comments` association. In the vast majority of cases having the inverse association discovered is beneficial as it can prevent some useless queries, but it may cause backward compatibility issues with legacy code that doesn't expect it.
This behavior can be disabled on a per-model basis:

```
class Comment  ApplicationRecord
  self.automatically_invert_plural_associations = false

belongs_to :post
end

```
Copy
And on a per-association basis:

```
class Comment  ApplicationRecord
  self.automatically_invert_plural_associations = true

belongs_to :post, inverse_of: nil
end

```
Copy
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |

#### 3.8.14. `config.active_record.validate_migration_timestamps`
Controls whether to validate migration timestamps. When set, an error will be raised if the timestamp prefix for a migration is more than a day ahead of the timestamp associated with the current time. This is done to prevent forward-dating of migration files, which can impact migration generation and other migration commands. `config.active_record.timestamped_migrations` must be set to `true`.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.2  | `true`  |

#### 3.8.15. `config.active_record.db_warnings_action`
Controls the action to be taken when an SQL query produces a warning. The following options are available:
  * `:ignore` - Database warnings will be ignored. This is the default.
  * `:log` - Database warnings will be logged via `ActiveRecord.logger` at the `:warn` level.
  * `:raise` - Database warnings will be raised as `ActiveRecord::SQLWarning`.
  * `:report` - Database warnings will be reported to subscribers of Rails' error reporter.
  * Custom proc - A custom proc can be provided. It should accept a `SQLWarning` error object.
For example:

```
config.active_record.db_warnings_action = ->(warning) do

# Report to custom exception reporting service
  Bugsnag.notify(warning.message) do |notification|
    notification.add_metadata(:warning_code, warning.code)
    notification.add_metadata(:warning_level, warning.level)
  end
end

#### 3.8.16. `config.active_record.db_warnings_ignore`
Specifies an allowlist of warning codes and messages that will be ignored, regardless of the configured `db_warnings_action`. The default behavior is to report all warnings. Warnings to ignore can be specified as Strings or Regexps. For example:

```
  config.active_record.db_warnings_action = :raise

# The following warnings will not be raised
  config.active_record.db_warnings_ignore = [
    /Invalid utf8mb4 character string/,
    "An exact warning message",
    "1062", # MySQL Error 1062: Duplicate entry
  ]

#### 3.8.17. `config.active_record.migration_strategy`
Controls the strategy class used to perform schema statement methods in a migration. The default class delegates to the connection adapter. Custom strategies should inherit from `ActiveRecord::Migration::ExecutionStrategy`, or may inherit from `DefaultStrategy`, which will preserve the default behavior for methods that aren't implemented:

```
class CustomMigrationStrategy  ActiveRecord::Migration::DefaultStrategy
  def drop_table(*)
    raise "Dropping tables is not supported!"
  end
end

config.active_record.migration_strategy = CustomMigrationStrategy

#### 3.8.18. `config.active_record.schema_versions_formatter`
Controls the formatter class used by schema dumper to format versions information. Custom class can be provided to change the default behavior:

```
class CustomSchemaVersionsFormatter
  def initialize(connection)
    @connection = connection
  end

def format(versions)
    # Special sorting of versions to reduce the likelihood of conflicts.
    sorted_versions = versions.sort { |a, b| b.to_s.reverse <=> a.to_s.reverse }

sql = +"INSERT INTO schema_migrations (version) VALUES\n"
    sql << sorted_versions.map { |v| "(#{@connection.quote(v)})" }.join(",\n")
    sql << ";"
    sql
  end
end

config.active_record.schema_versions_formatter = CustomSchemaVersionsFormatter

#### 3.8.19. `config.active_record.lock_optimistically`
Controls whether Active Record will use optimistic locking and is `true` by default.

#### 3.8.20. `config.active_record.cache_timestamp_format`
Controls the format of the timestamp value in the cache key. Default is `:usec`.

#### 3.8.21. `config.active_record.record_timestamps`
Is a boolean value which controls whether or not timestamping of `create` and `update` operations on a model occur. The default value is `true`.

#### 3.8.22. `config.active_record.partial_inserts`
Is a boolean value and controls whether or not partial writes are used when creating new records (i.e. whether inserts only set attributes that are different from the default).
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 7.0  | `false`  |

#### 3.8.23. `config.active_record.partial_updates`
Is a boolean value and controls whether or not partial writes are used when updating existing records (i.e. whether updates only set attributes that are dirty). Note that when using partial updates, you should also use optimistic locking `config.active_record.lock_optimistically` since concurrent updates may write attributes based on a possibly stale read state. The default value is `true`.

#### 3.8.24. `config.active_record.maintain_test_schema`
Is a boolean value which controls whether Active Record should try to keep your test database schema up-to-date with `db/schema.rb` (or `db/structure.sql`) when you run your tests. The default is `true`.

#### 3.8.25. `config.active_record.dump_schema_after_migration`
Is a flag which controls whether or not schema dump should happen (`db/schema.rb` or `db/structure.sql`) when you run migrations. This is set to `false` in `config/environments/production.rb` which is generated by Rails. The default value is `true` if this configuration is not set.

#### 3.8.26. `config.active_record.dump_schemas`
Controls which database schemas will be dumped when calling `db:schema:dump`. The options are `:schema_search_path` (the default) which dumps any schemas listed in `schema_search_path`, `:all` which always dumps all schemas regardless of the `schema_search_path`, or a string of comma separated schemas.

#### 3.8.27. `config.active_record.before_committed_on_all_records`
Enable before_committed! callbacks on all enrolled records in a transaction. The previous behavior was to only run the callbacks on the first copy of a record if there were multiple copies of the same record enrolled in the transaction.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.1  | `true`  |

#### 3.8.28. `config.active_record.belongs_to_required_by_default`
Is a boolean value and controls whether a record fails validation if `belongs_to` association is not present.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `nil`  |
| 5.0  | `true`  |

#### 3.8.29. `config.active_record.belongs_to_required_validates_foreign_key`
Enable validating only parent-related columns for presence when the parent is mandatory. The previous behavior was to validate the presence of the parent record, which performed an extra query to get the parent every time the child record was updated, even when parent has not changed.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 7.1  | `false`  |

#### 3.8.30. `config.active_record.marshalling_format_version`
When set to `7.1`, enables a more efficient serialization of Active Record instance with `Marshal.dump`.
This changes the serialization format, so models serialized this way cannot be read by older (< 7.1) versions of Rails. However, messages that use the old format can still be read, regardless of whether this optimization is enabled.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `6.1`  |
| 7.1  | `7.1`  |

#### 3.8.31. `config.active_record.action_on_strict_loading_violation`
Enables raising or logging an exception if strict_loading is set on an association. The default value is `:raise` in all environments. It can be changed to `:log` to send violations to the logger instead of raising.

#### 3.8.32. `config.active_record.strict_loading_by_default`
Is a boolean value that either enables or disables strict_loading mode by default. Defaults to `false`.

#### 3.8.33. `config.active_record.strict_loading_mode`
Sets the mode in which strict loading is reported. Defaults to `:all`. It can be changed to `:n_plus_one_only` to only report when loading associations that will lead to an N + 1 query.

#### 3.8.34. `config.active_record.index_nested_attribute_errors`
Allows errors for nested `has_many` relationships to be displayed with an index as well as the error. Defaults to `false`.

#### 3.8.35. `config.active_record.use_schema_cache_dump`
Enables users to get schema cache information from `db/schema_cache.yml` (generated by `bin/rails db:schema:cache:dump`), instead of having to send a query to the database to get this information. Defaults to `true`.

#### 3.8.36. `config.active_record.cache_versioning`
Indicates whether to use a stable `#cache_key` method that is accompanied by a changing version in the `#cache_version` method.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 5.2  | `true`  |

#### 3.8.37. `config.active_record.collection_cache_versioning`
Enables the same cache key to be reused when the object being cached of type `ActiveRecord::Relation` changes by moving the volatile information (max updated at and count) of the relation's cache key into the cache version to support recycling cache key.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 6.0  | `true`  |

#### 3.8.38. `config.active_record.has_many_inversing`
Enables setting the inverse record when traversing `belongs_to` to `has_many` associations.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 6.1  | `true`  |

#### 3.8.39. `config.active_record.automatic_scope_inversing`
Enables automatically inferring the `inverse_of` for associations with a scope.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.0  | `true`  |

#### 3.8.40. `config.active_record.destroy_association_async_job`
Allows specifying the job that will be used to destroy the associated records in background. It defaults to `ActiveRecord::DestroyAssociationAsyncJob`.

#### 3.8.41. `config.active_record.destroy_association_async_batch_size`
Allows specifying the maximum number of records that will be destroyed in a background job by the `dependent: :destroy_async` association option. All else equal, a lower batch size will enqueue more, shorter-running background jobs, while a higher batch size will enqueue fewer, longer-running background jobs. This option defaults to `nil`, which will cause all dependent records for a given association to be destroyed in the same background job.

#### 3.8.42. `config.active_record.queues.destroy`
Allows specifying the Active Job queue to use for destroy jobs. When this option is `nil`, purge jobs are sent to the default Active Job queue (see `config.active_job.default_queue_name`). It defaults to `nil`.

#### 3.8.43. `config.active_record.enumerate_columns_in_select_statements`
When `true`, will always include column names in `SELECT` statements, and avoid wildcard `SELECT * FROM ...` queries. This avoids prepared statement cache errors when adding columns to a PostgreSQL database for example. Defaults to `false`.

#### 3.8.44. `config.active_record.verify_foreign_keys_for_fixtures`
Ensures all foreign key constraints are valid after fixtures are loaded in tests. Supported by PostgreSQL and SQLite only.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.0  | `true`  |

#### 3.8.45. `config.active_record.raise_on_assign_to_attr_readonly`
Enable raising on assignment to attr_readonly attributes. The previous behavior would allow assignment but silently not persist changes to the database.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.1  | `true`  |

#### 3.8.46. `config.active_record.run_commit_callbacks_on_first_saved_instances_in_transaction`
When multiple Active Record instances change the same record within a transaction, Rails runs `after_commit` or `after_rollback` callbacks for only one of them. This option specifies how Rails chooses which instance receives the callbacks.
When `true`, transactional callbacks are run on the first instance to save, even though its instance state may be stale.
When `false`, transactional callbacks are run on the instances with the freshest instance state. Those instances are chosen as follows:
  * In general, run transactional callbacks on the last instance to save a given record within the transaction.
  * There are two exceptions:
    * If the record is created within the transaction, then updated by another instance, `after_create_commit` callbacks will be run on the second instance. This is instead of the `after_update_commit` callbacks that would naively be run based on that instance’s state.
    * If the record is destroyed within the transaction, then `after_destroy_commit` callbacks will be fired on the last destroyed instance, even if a stale instance subsequently performed an update (which will have affected 0 rows).

The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 7.1  | `false`  |

#### 3.8.47. `config.active_record.default_column_serializer`
The serializer implementation to use if none is explicitly specified for a given column.
Historically `serialize` and `store` while allowing to use alternative serializer implementations, would use `YAML` by default, but it's not a very efficient format and can be the source of security vulnerabilities if not carefully employed.
As such it is recommended to prefer stricter, more limited formats for database serialization.
Unfortunately there isn't really any suitable defaults available in Ruby's standard library. `JSON` could work as a format, but the `json` gems will cast unsupported types to strings which may lead to bugs.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `YAML`  |
| 7.1  | `nil`  |

#### 3.8.48. `config.active_record.run_after_transaction_callbacks_in_order_defined`
When `true`, `after_commit` callbacks are executed in the order they are defined in a model. When `false`, they are executed in reverse order.
All other callbacks are always executed in the order they are defined in a model (unless you use `prepend: true`).
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.1  | `true`  |

#### 3.8.49. `config.active_record.query_log_tags_enabled`
Specifies whether or not to enable adapter-level query comments. Defaults to `false`, but is set to `true` in the default generated `config/environments/development.rb` file.
When this is set to `true` database prepared statements will be automatically disabled.

#### 3.8.50. `config.active_record.query_log_tags`
Define an `Array` specifying the key/value tags to be inserted in an SQL comment. Defaults to `[ :application, :controller, :action, :job ]`. The available tags are: `:application`, `:controller`, `:namespaced_controller`, `:action`, `:job`, and `:source_location`.
Calculating the `:source_location` of a query can be slow, so you should consider its impact if using it in a production environment.

#### 3.8.51. `config.active_record.query_log_tags_format`
A `Symbol` specifying the formatter to use for tags. Valid values are `:sqlcommenter` and `:legacy`.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:legacy`  |
| 7.1  | `:sqlcommenter`  |

#### 3.8.52. `config.active_record.cache_query_log_tags`
Specifies whether or not to enable caching of query log tags. For applications that have a large number of queries, caching query log tags can provide a performance benefit when the context does not change during the lifetime of the request or job execution. Defaults to `false`.

#### 3.8.53. `config.active_record.query_log_tags_prepend_comment`
Specifies whether or not to prepend query log tags comment to the query.
By default comments are appended at the end of the query. Certain databases, such as MySQL will truncate the query text. This is the case for slow query logs and the results of querying some InnoDB internal tables where the length of the query is more than 1024 bytes. In order to not lose the log tags comments from the queries, you can prepend the comments using this option.
Defaults to `false`.

#### 3.8.54. `config.active_record.schema_cache_ignored_tables`
Define the list of table that should be ignored when generating the schema cache. It accepts an `Array` of strings, representing the table names, or regular expressions.

#### 3.8.55. `config.active_record.verbose_query_logs`
Specifies if source locations of methods that call database queries should be logged below relevant queries. By default, the flag is `true` in development and `false` in all other environments.

#### 3.8.56. `config.active_record.sqlite3_adapter_strict_strings_by_default`
Specifies whether the SQLite3Adapter should be used in a strict strings mode. The use of a strict strings mode disables double-quoted string literals.
SQLite has some quirks around double-quoted string literals. It first tries to consider double-quoted strings as identifier names, but if they don't exist it then considers them as string literals. Because of this, typos can silently go unnoticed. For example, it is possible to create an index for a non existing column. See [SQLite documentation](https://www.sqlite.org/quirks.html#double_quoted_string_literals_are_accepted) for more details.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.1  | `true`  |

#### 3.8.57. `config.active_record.postgresql_adapter_decode_dates`
Specifies whether the PostgresqlAdapter should decode date columns.

```
ActiveRecord::Base.connection
     .select_value("select '2024-01-01'::date").class #=> Date

```
Copy
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.2  | `true`  |

#### 3.8.58. `config.active_record.async_query_executor`
Specifies how asynchronous queries are pooled.
It defaults to `nil`, which means `load_async` is disabled and instead directly executes queries in the foreground. For queries to actually be performed asynchronously, it must be set to either `:global_thread_pool` or `:multi_thread_pool`.
`:global_thread_pool` will use a single pool for all databases the application connects to. This is the preferred configuration for applications with only a single database, or applications which only ever query one database shard at a time.
`:multi_thread_pool` will use one pool per database, and each pool size can be configured individually in `database.yml` through the `max_threads` and `min_threads` properties. This can be useful to applications regularly querying multiple databases at a time, and that need to more precisely define the max concurrency.

#### 3.8.59. `config.active_record.global_executor_concurrency`
Used in conjunction with `config.active_record.async_query_executor = :global_thread_pool`, defines how many asynchronous queries can be executed concurrently.
Defaults to `4`.
This number must be considered in accordance with the database connection pool size configured in `database.yml`. The connection pool should be large enough to accommodate both the foreground threads (ie. web server or job worker threads) and background threads.
For each process, Rails will create one global query executor that uses this many threads to process async queries. Thus, the pool size should be at least `thread_count + global_executor_concurrency + 1`. For example, if your web server has a maximum of 3 threads, and `global_executor_concurrency` is set to 4, then your pool size should be at least 8.

#### 3.8.60. `config.active_record.yaml_column_permitted_classes`
Defaults to `[Symbol]`. Allows applications to include additional permitted classes to `safe_load()` on the `ActiveRecord::Coders::YAMLColumn`.

#### 3.8.61. `config.active_record.use_yaml_unsafe_load`
Defaults to `false`. Allows applications to opt into using `unsafe_load` on the `ActiveRecord::Coders::YAMLColumn`.

#### 3.8.62. `config.active_record.raise_int_wider_than_64bit`
Defaults to `true`. Determines whether to raise an exception or not when the PostgreSQL adapter is provided an integer that is wider than signed 64bit representation.

#### 3.8.63. `config.active_record.generate_secure_token_on`
Controls when to generate a value for `has_secure_token` declarations. By default, generate the value when the model is initialized:

```
class User  ApplicationRecord
  has_secure_token
end

record = User.new
record.token # => "fwZcXX6SkJBJRogzMdciS7wf"

```
Copy
With `config.active_record.generate_secure_token_on = :create`, generate the value when the model is created:

# config/application.rb

config.active_record.generate_secure_token_on = :create

# app/models/user.rb
class User  ApplicationRecord
  has_secure_token on: :create
end

record = User.new
record.token # => nil
record.save!
record.token # => "fwZcXX6SkJBJRogzMdciS7wf"

```
Copy
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:create`  |
| 7.1  | `:initialize`  |

#### 3.8.64. `config.active_record.permanent_connection_checkout`
Controls whether `ActiveRecord::Base.connection` raises an error, emits a deprecation warning, or neither.
`ActiveRecord::Base.connection` checkouts a database connection from the pool and keeps it leased until the end of the request or job. This behavior can be undesirable in environments that use many more threads or fibers than there is available connections.
This configuration can be used to track down and eliminate code that calls `ActiveRecord::Base.connection` and migrate it to use `ActiveRecord::Base.with_connection` instead.
The value can be set to `:disallowed`, `:deprecated`, or `true` to respectively raise an error, emit a deprecation warning, or neither.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |

#### 3.8.65. `config.active_record.database_cli`
Controls which CLI tool will be used for accessing the database when running `bin/rails dbconsole`. By default the standard tool for the database will be used (e.g. `psql` for PostgreSQL and `mysql` for MySQL). The option takes a hash which specifies the tool per-database system, and an array can be used where fallback options are required:

config.active_record.database_cli = { postgresql: "pgcli", mysql: %w[ mycli mysql ] }

#### 3.8.66. `config.active_record.use_legacy_signed_id_verifier`
Controls whether signed IDs are generated and verified using legacy options. Can be set to:
  * `:generate_and_verify` (default) - Generate and verify signed IDs using the following legacy options:

```
{ digest: "SHA256", serializer: JSON, url_safe: true }

```
Copy
  * `:verify` - Generate and verify signed IDs using options from [`Rails.application.message_verifiers`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Application.html#method-i-message_verifiers), but fall back to verifying with the same options as `:generate_and_verify`.
  * false - Generate and verify signed IDs using options from [`Rails.application.message_verifiers`](https://api.rubyonrails.org/v8.1.3/classes/Rails/Application.html#method-i-message_verifiers) only.

The purpose of this setting is to provide a smooth transition to a unified configuration for all message verifiers. Having a unified configuration makes it more straightforward to rotate secrets and upgrade signing algorithms.
Setting this to false may cause old signed IDs to become unreadable if `Rails.application.message_verifiers` is not properly configured. Use [`MessageVerifiers#rotate`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/MessageVerifiers.html#method-i-rotate) or [`MessageVerifiers#prepend`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/MessageVerifiers.html#method-i-prepend) to configure `Rails.application.message_verifiers` with the appropriate options, such as `:digest` and `:url_safe`.

#### 3.8.67. `ActiveRecord::ConnectionAdapters::Mysql2Adapter.emulate_booleans` and `ActiveRecord::ConnectionAdapters::TrilogyAdapter.emulate_booleans`
Controls whether the Active Record MySQL adapter will consider all `tinyint(1)` columns as booleans. Defaults to `true`.

#### 3.8.68. `ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.create_unlogged_tables`
Controls whether database tables created by PostgreSQL should be "unlogged", which can speed up performance but adds a risk of data loss if the database crashes. It is highly recommended that you do not enable this in a production environment. Defaults to `false` in all environments.
To enable this for tests:

# config/environments/test.rb

ActiveSupport.on_load(:active_record_postgresqladapter) do
  self.create_unlogged_tables = true
end

#### 3.8.69. `ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type`
Controls what native type the Active Record PostgreSQL adapter should use when you call `datetime` in a migration or schema. It takes a symbol which must correspond to one of the configured `NATIVE_DATABASE_TYPES`. The default is `:timestamp`, meaning `t.datetime` in a migration will create a "timestamp without time zone" column.
To use "timestamp with time zone":

ActiveSupport.on_load(:active_record_postgresqladapter) do
  self.datetime_type = :timestamptz
end

```
Copy
You should run `bin/rails db:migrate` to rebuild your schema.rb if you change this.

#### 3.8.70. `ActiveRecord::SchemaDumper.ignore_tables`
Accepts an array of tables that should _not_ be included in any generated schema file.

#### 3.8.71. `ActiveRecord::SchemaDumper.fk_ignore_pattern`
Allows setting a different regular expression that will be used to decide whether a foreign key's name should be dumped to db/schema.rb or not. By default, foreign key names starting with `fk_rails_` are not exported to the database schema dump. Defaults to `/^fk_rails_[0-9a-f]{10}$/`.

#### 3.8.72. `config.active_record.encryption.support_unencrypted_data`
When `true`, unencrypted data can be read normally. When `false`, it will raise errors. Default: `false`.

#### 3.8.73. `config.active_record.encryption.extend_queries`
When `true`, queries referencing deterministically encrypted attributes will be modified to include additional values if needed. Those additional values will be the clean version of the value (when `config.active_record.encryption.support_unencrypted_data` is `true`) and values encrypted with previous encryption schemes, if any (as provided with the `previous:` option). Default: `false`.

#### 3.8.74. `config.active_record.encryption.encrypt_fixtures`
When `true`, encryptable attributes in fixtures will be automatically encrypted when loaded. Default: `false`.

#### 3.8.75. `config.active_record.encryption.store_key_references`
When `true`, a reference to the encryption key is stored in the headers of the encrypted message. This makes for faster decryption when multiple keys are in use. Default: `false`.

#### 3.8.76. `config.active_record.encryption.add_to_filter_parameters`
When `true`, encrypted attribute names are added automatically to `config.filter_parameters` and won't be shown in logs. Default: `true`.

#### 3.8.77. `config.active_record.encryption.excluded_from_filter_parameters`
You can configure a list of params that won't be filtered out when `config.active_record.encryption.add_to_filter_parameters` is true. Default: `[]`.

#### 3.8.78. `config.active_record.encryption.validate_column_size`
Adds a validation based on the column size. This is recommended to prevent storing huge values using highly compressible payloads. Default: `true`.

#### 3.8.79. `config.active_record.encryption.primary_key`
The key or lists of keys used to derive root data encryption keys. The way they are used depends on the key provider configured. It's preferred to configure it via the `active_record_encryption.primary_key` credential.

#### 3.8.80. `config.active_record.encryption.deterministic_key`
The key or list of keys used for deterministic encryption. It's preferred to configure it via the `active_record_encryption.deterministic_key` credential.

#### 3.8.81. `config.active_record.encryption.key_derivation_salt`
The salt used when deriving keys. It's preferred to configure it via the `active_record_encryption.key_derivation_salt` credential.

#### 3.8.82. `config.active_record.encryption.forced_encoding_for_deterministic_encryption`
The default encoding for attributes encrypted deterministically. You can disable forced encoding by setting this option to `nil`. It's `Encoding::UTF_8` by default.

#### 3.8.83. `config.active_record.encryption.hash_digest_class`
Sets the digest algorithm used by Active Record Encryption.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `OpenSSL::Digest::SHA1`  |
| 7.1  | `OpenSSL::Digest::SHA256`  |

#### 3.8.84. `config.active_record.encryption.support_sha1_for_non_deterministic_encryption`
Enables support for decrypting existing data encrypted using a SHA-1 digest class. When `false`, it will only support the digest configured in `config.active_record.encryption.hash_digest_class`.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 7.1  | `false`  |

#### 3.8.85. `config.active_record.encryption.compressor`
The compressor used to compress encrypted payloads. The default is `Zlib`. You can use your own compressor by setting this to a class that responds to `deflate` and `inflate`.

#### 3.8.86. `config.active_record.protocol_adapters`
When using a URL to configure the database connection, this option provides a mapping from the protocol to the underlying database adapter. For example, this means the environment can specify `DATABASE_URL=mysql://localhost/database` and Rails will map `mysql` to the `mysql2` adapter, but the application can also override these mappings:

```
config.active_record.protocol_adapters.mysql = "trilogy"

```
Copy
If no mapping is found, the protocol is used as the adapter name.

#### 3.8.87. `config.active_record.deprecated_associations_options`
If present, this has to be a hash with keys `:mode` and/or `:backtrace`:

```
config.active_record.deprecated_associations_options = { mode: :notify, backtrace: true }

```
Copy
  * In `:warn` mode, accessing the deprecated association is reported by the Active Record logger. This is the default mode.
  * In `:raise` mode, usage raises an `ActiveRecord::DeprecatedAssociationError` with a similar message and a clean backtrace in the exception object.
  * In `:notify` mode, a `deprecated_association.active_record` Active Support notification is published. Please, see details about its payload in the [Active Support Instrumentation guide](https://guides.rubyonrails.org/active_support_instrumentation.html).

Backtraces are disabled by default. If `:backtrace` is true, warnings include a clean backtrace in the message, and notifications have a `:backtrace` key in the payload with an array of clean `Thread::Backtrace::Location` objects. Exceptions always have a clean stack trace.
Clean backtraces are computed using the Active Record backtrace cleaner.

#### 3.8.88. `config.active_record.raise_on_missing_required_finder_order_columns`
Raises an error when order dependent finder methods (e.g. `#first`, `#second`) are called without `order` values on the relation, and the model does not have any order columns (`implicit_order_column`, `query_constraints`, or `primary_key`) to fall back on.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 8.1  | `true`  |

### 3.9. Configuring Action Controller
`config.action_controller` includes a number of configuration settings:

#### 3.9.1. `config.action_controller.asset_host`
Sets the host for the assets. Useful when CDNs are used for hosting assets rather than the application server itself. You should only use this if you have a different configuration for Action Mailer, otherwise use `config.asset_host`.

#### 3.9.2. `config.action_controller.perform_caching`
Configures whether the application should perform the caching features provided by the Action Controller component. Set to `false` in the development environment, `true` in production. If it's not specified, the default will be `true`.

#### 3.9.3. `config.action_controller.default_static_extension`
Configures the extension used for cached pages. Defaults to `.html`.

#### 3.9.4. `config.action_controller.include_all_helpers`
Configures whether all view helpers are available everywhere or are scoped to the corresponding controller. If set to `false`, `UsersHelper` methods are only available for views rendered as part of `UsersController`. If `true`, `UsersHelper` methods are available everywhere. The default configuration behavior (when this option is not explicitly set to `true` or `false`) is that all view helpers are available to each controller.

#### 3.9.5. `config.action_controller.logger`
Accepts a logger conforming to the interface of Log4r or the default Ruby Logger class, which is then used to log information from Action Controller. Set to `nil` to disable logging.

#### 3.9.6. `config.action_controller.request_forgery_protection_token`
Sets the token parameter name for RequestForgery. Calling `protect_from_forgery` sets it to `:authenticity_token` by default.

#### 3.9.7. `config.action_controller.allow_forgery_protection`
Enables or disables CSRF protection. By default this is `false` in the test environment and `true` in all other environments.

#### 3.9.8. `config.action_controller.forgery_protection_origin_check`
Configures whether the HTTP `Origin` header should be checked against the site's origin as an additional CSRF defense.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 5.0  | `true`  |

#### 3.9.9. `config.action_controller.per_form_csrf_tokens`
Configures whether CSRF tokens are only valid for the method/action they were generated for.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 5.0  | `true`  |

#### 3.9.10. `config.action_controller.default_protect_from_forgery`
Determines whether forgery protection is added on `ActionController::Base`.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 5.2  | `true`  |

#### 3.9.11. `config.action_controller.relative_url_root`
Can be used to tell Rails that you are [deploying to a subdirectory](https://guides.rubyonrails.org/configuring.html#deploy-to-a-subdirectory-relative-url-root). The default is `config.relative_url_root`.

#### 3.9.12. `config.action_controller.permit_all_parameters`
Sets all the parameters for mass assignment to be permitted by default. The default value is `false`.

#### 3.9.13. `config.action_controller.action_on_unpermitted_parameters`
Controls behavior when parameters that are not explicitly permitted are found. The default value is `:log` in test and development environments, `false` otherwise. The values can be:
  * `false` to take no action
  * `:log` to emit an `ActiveSupport::Notifications.instrument` event on the `unpermitted_parameters.action_controller` topic and log at the DEBUG level
  * `:raise` to raise a `ActionController::UnpermittedParameters` exception

#### 3.9.14. `config.action_controller.always_permitted_parameters`
Sets a list of permitted parameters that are permitted by default. The default values are `['controller', 'action']`.

#### 3.9.15. `config.action_controller.enable_fragment_cache_logging`
Determines whether to log fragment cache reads and writes in verbose format as follows:

```
Read fragment views/v1/2914079/v1/2914079/recordings/70182313-20160225015037000000/d0bdf2974e1ef6d31685c3b392ad0b74 (0.6ms)
Rendered messages/_message.html.erb in 1.2 ms [cache hit]
Write fragment views/v1/2914079/v1/2914079/recordings/70182313-20160225015037000000/3b4e249ac9d168c617e32e84b99218b5 (1.1ms)
Rendered recordings/threads/_thread.html.erb in 1.5 ms [cache miss]

```
Copy
By default it is set to `false` which results in following output:

```
Rendered messages/_message.html.erb in 1.2 ms [cache hit]
Rendered recordings/threads/_thread.html.erb in 1.5 ms [cache miss]

#### 3.9.16. `config.action_controller.raise_on_missing_callback_actions`
Raises an `AbstractController::ActionNotFound` when the action specified in callback's `:only` or `:except` options is missing in the controller.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.1  |  `true` (development and test), `false` (other envs)  |

#### 3.9.17. `config.action_controller.raise_on_open_redirects`
Protect an application from unintentionally redirecting to an external host (also known as an "open redirect") by making external redirects opt-in.
When this configuration is set to `true`, an `ActionController::Redirecting::UnsafeRedirectError` will be raised when a URL with an external host is passed to [redirect_to](https://api.rubyonrails.org/v8.1.3/classes/ActionController/Redirecting.html#method-i-redirect_to). If an open redirect should be allowed, then `allow_other_host: true` can be added to the call to `redirect_to`.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |

#### 3.9.18. `config.action_controller.action_on_open_redirect`
Controls how Rails handles open redirect attempts (redirects to external hosts).
**Note:** This configuration replaces the deprecated `config.action_controller.raise_on_open_redirects` option, which will be removed in a future Rails version. The new configuration provides more flexible control over open redirect protection.
When set to `:log`, Rails will log a warning when an open redirect is detected. When set to `:notify`, Rails will publish an `open_redirect.action_controller` notification event. When set to `:raise`, Rails will raise an `ActionController::Redirecting::UnsafeRedirectError`.
If `raise_on_open_redirects` is set to `true`, it will take precedence over this configuration for backward compatibility, effectively forcing `:raise` behavior.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:log`  |
| 7.0  | `:raise`  |

#### 3.9.19. `config.action_controller.action_on_path_relative_redirect`
Controls how Rails handles paths relative URL redirects.
When set to `:log` (default), Rails will log a warning when a path relative URL redirect is detected. When set to `:notify`, Rails will publish an `unsafe_redirect.action_controller` notification event. When set to `:raise`, Rails will raise an `ActionController::Redirecting::UnsafeRedirectError`.
This helps detect potentially unsafe redirects that could be exploited for open redirect attacks.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:log`  |
| 8.1  | `:raise`  |

#### 3.9.20. `config.action_controller.log_query_tags_around_actions`
Determines whether controller context for query tags will be automatically updated via an `around_filter`. The default value is `true`.

#### 3.9.21. `config.action_controller.wrap_parameters_by_default`
Before Rails 7.0, new applications were generated with an initializer named `wrap_parameters.rb` that enabled parameter wrapping in `ActionController::Base` for JSON requests.
Setting this configuration value to `true` has the same behavior as the initializer, allowing applications to remove the initializer if they do not wish to customize parameter wrapping behavior.
Regardless of this value, applications can continue to customize the parameter wrapping behavior as before in an initializer or per controller.
See [`ParamsWrapper`](https://api.rubyonrails.org/v8.1.3/classes/ActionController/ParamsWrapper.html) for more information on parameter wrapping.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.0  | `true`  |

#### 3.9.22. `config.action_controller.allowed_redirect_hosts`
Specifies a list of allowed hosts for redirects. `redirect_to` will allow redirects to them without raising an `UnsafeRedirectError` error.

#### 3.9.23. `ActionController::Base.wrap_parameters`
Configures the [`ParamsWrapper`](https://api.rubyonrails.org/v8.1.3/classes/ActionController/ParamsWrapper.html). This can be called at the top level, or on individual controllers.

#### 3.9.24. `config.action_controller.escape_json_responses`
Configures the JSON renderer to escape HTML entities and Unicode characters that are invalid in JavaScript.
This is useful if you relied on the JSON response having those characters escaped to embed the JSON document in <script> tags in HTML.
This is mainly for compatibility when upgrading Rails applications, otherwise you can use the `:escape` option for `render json:` in specific controller actions.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 8.1  | `false`  |

### 3.10. Configuring Action Dispatch

#### 3.10.1. `config.action_dispatch.cookies_serializer`
Specifies which serializer to use for cookies. Accepts the same values as `config.active_support.message_serializer`, plus `:hybrid` which is an alias for `:json_allow_marshal`.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:marshal`  |
| 7.0  | `:json`  |

#### 3.10.2. `config.action_dispatch.debug_exception_log_level`
Configures the log level used by the [`ActionDispatch::DebugExceptions`](https://api.rubyonrails.org/v8.1.3/classes/ActionDispatch/DebugExceptions.html) middleware when logging uncaught exceptions during requests.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:fatal`  |
| 7.1  | `:error`  |

#### 3.10.3. `config.action_dispatch.default_headers`
Is a hash with HTTP headers that are set by default in each response.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  |
```
{  "X-Frame-Options" => "SAMEORIGIN",  "X-XSS-Protection" => "1; mode=block",  "X-Content-Type-Options" => "nosniff",  "X-Download-Options" => "noopen",  "X-Permitted-Cross-Domain-Policies" => "none",  "Referrer-Policy" => "strict-origin-when-cross-origin"}
```
 |
| 7.0  |
```
{  "X-Frame-Options" => "SAMEORIGIN",  "X-XSS-Protection" => "0",  "X-Content-Type-Options" => "nosniff",  "X-Download-Options" => "noopen",  "X-Permitted-Cross-Domain-Policies" => "none",  "Referrer-Policy" => "strict-origin-when-cross-origin"}
```
 |
| 7.1  |
```
{  "X-Frame-Options" => "SAMEORIGIN",  "X-XSS-Protection" => "0",  "X-Content-Type-Options" => "nosniff",  "X-Permitted-Cross-Domain-Policies" => "none",  "Referrer-Policy" => "strict-origin-when-cross-origin"}
```
 |

#### 3.10.4. `config.action_dispatch.default_charset`
Specifies the default character set for all renders. Defaults to `nil`.

#### 3.10.5. `config.action_dispatch.tld_length`
Sets the TLD (top-level domain) length for the application. Defaults to `1`.

#### 3.10.6. `config.action_dispatch.domain_extractor`
Configures the domain extraction strategy used by Action Dispatch for parsing host names into domain and subdomain components. This must be an object that responds to `domain_from(host, tld_length)` and `subdomains_from(host, tld_length)` methods.
Defaults to `ActionDispatch::Http::URL::DomainExtractor`, which provides the standard domain parsing logic. You can provide a custom extractor to implement specialized domain parsing behavior:

```
class CustomDomainExtractor
  def self.domain_from(host, tld_length)
    # Custom domain extraction logic
  end

def self.subdomains_from(host, tld_length)
    # Custom subdomain extraction logic
  end
end

config.action_dispatch.domain_extractor = CustomDomainExtractor

#### 3.10.7. `config.action_dispatch.ignore_accept_header`
Is used to determine whether to ignore accept headers from a request. Defaults to `false`.

#### 3.10.8. `config.action_dispatch.x_sendfile_header`
Specifies server specific X-Sendfile header. This is useful for accelerated file sending from server. For example it can be set to 'X-Sendfile' for Apache.

#### 3.10.9. `config.action_dispatch.http_auth_salt`
Sets the HTTP Auth salt value. Defaults to `'http authentication'`.

#### 3.10.10. `config.action_dispatch.signed_cookie_salt`
Sets the signed cookies salt value. Defaults to `'signed cookie'`.

#### 3.10.11. `config.action_dispatch.encrypted_cookie_salt`
Sets the encrypted cookies salt value. Defaults to `'encrypted cookie'`.

#### 3.10.12. `config.action_dispatch.encrypted_signed_cookie_salt`
Sets the signed encrypted cookies salt value. Defaults to `'signed encrypted cookie'`.

#### 3.10.13. `config.action_dispatch.authenticated_encrypted_cookie_salt`
Sets the authenticated encrypted cookie salt. Defaults to `'authenticated encrypted cookie'`.

#### 3.10.14. `config.action_dispatch.encrypted_cookie_cipher`
Sets the cipher to be used for encrypted cookies. This defaults to `"aes-256-gcm"`.

#### 3.10.15. `config.action_dispatch.signed_cookie_digest`
Sets the digest to be used for signed cookies. This defaults to `"SHA1"`.

#### 3.10.16. `config.action_dispatch.cookies_rotations`
Allows rotating secrets, ciphers, and digests for encrypted and signed cookies.

#### 3.10.17. `config.action_dispatch.use_authenticated_cookie_encryption`
Controls whether signed and encrypted cookies use the AES-256-GCM cipher or the older AES-256-CBC cipher.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 5.2  | `true`  |

#### 3.10.18. `config.action_dispatch.use_cookies_with_metadata`
Enables writing cookies with the purpose metadata embedded.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 6.0  | `true`  |

#### 3.10.19. `config.action_dispatch.perform_deep_munge`
Configures whether `deep_munge` method should be performed on the parameters. See [Security Guide](https://guides.rubyonrails.org/security.html#unsafe-query-generation) for more information. It defaults to `true`.

#### 3.10.20. `config.action_dispatch.rescue_responses`
Configures what exceptions are assigned to an HTTP status. It accepts a hash and you can specify pairs of exception/status.

# It's good to use #[]= or #merge! to respect the default values
config.action_dispatch.rescue_responses["MyAuthenticationError"] = :unauthorized

```
Copy
Use `ActionDispatch::ExceptionWrapper.rescue_responses` to observe the configuration. By default, it is defined as:

```
{
  "ActionController::RoutingError" => :not_found,
  "AbstractController::ActionNotFound" => :not_found,
  "ActionController::MethodNotAllowed" => :method_not_allowed,
  "ActionController::UnknownHttpMethod" => :method_not_allowed,
  "ActionController::NotImplemented" => :not_implemented,
  "ActionController::UnknownFormat" => :not_acceptable,
  "ActionDispatch::Http::MimeNegotiation::InvalidType" => :not_acceptable,
  "ActionController::MissingExactTemplate" => :not_acceptable,
  "ActionController::InvalidAuthenticityToken" => :unprocessable_entity,
  "ActionController::InvalidCrossOriginRequest" => :unprocessable_entity,
  "ActionDispatch::Http::Parameters::ParseError" => :bad_request,
  "ActionController::BadRequest" => :bad_request,
  "ActionController::ParameterMissing" => :bad_request,
  "Rack::QueryParser::ParameterTypeError" => :bad_request,
  "Rack::QueryParser::InvalidParameterError" => :bad_request,
  "ActiveRecord::RecordNotFound" => :not_found,
  "ActiveRecord::StaleObjectError" => :conflict,
  "ActiveRecord::RecordInvalid" => :unprocessable_entity,
  "ActiveRecord::RecordNotSaved" => :unprocessable_entity
}

```
Copy
Any exceptions that are not configured will be mapped to 500 Internal Server Error.

#### 3.10.21. `config.action_dispatch.cookies_same_site_protection`
Configures the default value of the `SameSite` attribute when setting cookies. When set to `nil`, the `SameSite` attribute is not added. To allow the value of the `SameSite` attribute to be configured dynamically based on the request, a proc may be specified. For example:

```
config.action_dispatch.cookies_same_site_protection = ->(request) do
  :strict unless request.user_agent == "TestAgent"
end

```
Copy
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `nil`  |
| 6.1  | `:lax`  |

#### 3.10.22. `config.action_dispatch.ssl_default_redirect_status`
Configures the default HTTP status code used when redirecting non-GET/HEAD requests from HTTP to HTTPS in the `ActionDispatch::SSL` middleware.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `307`  |
| 6.1  | `308`  |

#### 3.10.23. `config.action_dispatch.log_rescued_responses`
Enables logging those unhandled exceptions configured in `rescue_responses`. It defaults to `true`.

#### 3.10.24. `config.action_dispatch.show_exceptions`
The `config.action_dispatch.show_exceptions` configuration controls how Action Pack (specifically the [`ActionDispatch::ShowExceptions`](https://guides.rubyonrails.org/configuring.html#actiondispatch-showexceptions) middleware) handles exceptions raised while responding to requests.
Setting the value to `:all` configures Action Pack to rescue from exceptions and render corresponding error pages. For example, Action Pack would rescue from an `ActiveRecord::RecordNotFound` exception and render the contents of `public/404.html` with a `404 Not found` status code.
Setting the value to `:rescuable` configures Action Pack to rescue from exceptions defined in [`config.action_dispatch.rescue_responses`](https://guides.rubyonrails.org/configuring.html#config-action-dispatch-rescue-responses), and raise all others. For example, Action Pack would rescue from `ActiveRecord::RecordNotFound`, but would raise a `NoMethodError`.
Setting the value to `:none` configures Action Pack to raise all exceptions.
  * `:all` - render error pages for all exceptions
  * `:rescuable` - render error pages for exceptions declared by [`config.action_dispatch.rescue_responses`](https://guides.rubyonrails.org/configuring.html#config-action-dispatch-rescue-responses)
  * `:none` - raise all exceptions

| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 7.1  | `:all`  |

#### 3.10.25. `config.action_dispatch.strict_freshness`
Configures whether the `ActionDispatch::ETag` middleware should prefer the `ETag` header over the `Last-Modified` header when both are present in the response.
If set to `true`, when both headers are present only the `ETag` is considered as specified by RFC 7232 section 6.
If set to `false`, when both headers are present, both headers are checked and both need to match for the response to be considered fresh.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 8.0  | `true`  |

#### 3.10.26. `config.action_dispatch.always_write_cookie`
Cookies will be written at the end of a request if they marked as insecure, if the request is made over SSL, or if the request is made to an onion service.
If set to `true`, cookies will be written even if this criteria is not met.
This defaults to `true` in `development`, and `false` in all other environments.

#### 3.10.27. `config.action_dispatch.verbose_redirect_logs`
Specifies if source locations of redirects should be logged below relevant log lines. By default, the flag is `true` in development and `false` in all other environments.

#### 3.10.28. `ActionDispatch::Callbacks.before`
Takes a block of code to run before the request.

#### 3.10.29. `ActionDispatch::Callbacks.after`
Takes a block of code to run after the request.

### 3.11. Configuring Action View
`config.action_view` includes a small number of configuration settings:

#### 3.11.1. `config.action_view.cache_template_loading`
Controls whether or not templates should be reloaded on each request. Defaults to `!config.enable_reloading`.

#### 3.11.2. `config.action_view.field_error_proc`
Provides an HTML generator for displaying errors that come from Active Model. The block is evaluated within the context of an Action View template. The default is

```
Proc.new { |html_tag, instance| content_tag :div, html_tag, class: "field_with_errors" }

#### 3.11.3. `config.action_view.default_form_builder`
Tells Rails which form builder to use by default. The default is `ActionView::Helpers::FormBuilder`. If you want your form builder class to be loaded after initialization (so it's reloaded on each request in development), you can pass it as a `String`.

#### 3.11.4. `config.action_view.logger`
Accepts a logger conforming to the interface of Log4r or the default Ruby Logger class, which is then used to log information from Action View. Set to `nil` to disable logging.

#### 3.11.5. `config.action_view.erb_trim_mode`
Controls if certain ERB syntax should trim. It defaults to `'-'`, which turns on trimming of tail spaces and newline when using `<%= -%>` or `<%= =%>`. Setting this to anything else will turn off trimming support.

#### 3.11.6. `config.action_view.frozen_string_literal`
Compiles the ERB template with the `# frozen_string_literal: true` magic comment, making all string literals frozen and saving allocations. Set to `true` to enable it for all views.

#### 3.11.7. `config.action_view.embed_authenticity_token_in_remote_forms`
Allows you to set the default behavior for `authenticity_token` in forms with `remote: true`. By default it's set to `false`, which means that remote forms will not include `authenticity_token`, which is helpful when you're fragment-caching the form. Remote forms get the authenticity from the `meta` tag, so embedding is unnecessary unless you support browsers without JavaScript. In such case you can either pass `authenticity_token: true` as a form option or set this config setting to `true`.

#### 3.11.8. `config.action_view.prefix_partial_path_with_controller_namespace`
Determines whether or not partials are looked up from a subdirectory in templates rendered from namespaced controllers. For example, consider a controller named `Admin::ArticlesController` which renders this template:

```
<%= render @article %>

```
Copy
The default setting is `true`, which uses the partial at `/admin/articles/_article.erb`. Setting the value to `false` would render `/articles/_article.erb`, which is the same behavior as rendering from a non-namespaced controller such as `ArticlesController`.

#### 3.11.9. `config.action_view.automatically_disable_submit_tag`
Determines whether `submit_tag` should automatically disable on click, this defaults to `true`.

#### 3.11.10. `config.action_view.debug_missing_translation`
Determines whether to wrap the missing translations key in a `<span>` tag or not. This defaults to `true`.

#### 3.11.11. `config.action_view.form_with_generates_remote_forms`
Determines whether `form_with` generates remote forms or not.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| 5.1  | `true`  |
| 6.1  | `false`  |

#### 3.11.12. `config.action_view.form_with_generates_ids`
Determines whether `form_with` generates ids on inputs.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 5.2  | `true`  |

#### 3.11.13. `config.action_view.default_enforce_utf8`
Determines whether forms are generated with a hidden tag that forces older versions of Internet Explorer to submit forms encoded in UTF-8.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 6.0  | `false`  |

#### 3.11.14. `config.action_view.image_loading`
Specifies a default value for the `loading` attribute of `<img>` tags rendered by the `image_tag` helper. For example, when set to `"lazy"`, `<img>` tags rendered by `image_tag` will include `loading="lazy"`, which [instructs the browser to wait until an image is near the viewport to load it](https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/loading#lazy). (This value can still be overridden per image by passing e.g. `loading: "eager"` to `image_tag`.) Defaults to `nil`.

#### 3.11.15. `config.action_view.image_decoding`
Specifies a default value for the `decoding` attribute of `<img>` tags rendered by the `image_tag` helper. Defaults to `nil`.

#### 3.11.16. `config.action_view.annotate_rendered_view_with_filenames`
Determines whether to annotate rendered view with template file names. This defaults to `false`.

#### 3.11.17. `config.action_view.preload_links_header`
Determines whether `javascript_include_tag` and `stylesheet_link_tag` will generate a `link` header that preload assets.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `nil`  |
| 6.1  | `true`  |

#### 3.11.18. `config.action_view.button_to_generates_button_tag`
When `false`, `button_to` will render a `<button>` or an `<input>` inside a `<form>` depending on how content is passed (`<form>` omitted for brevity):

```
<%= button_to "Content", "/" %>

# => <input type="submit" value="Content"

<%= button_to "/" do %>
  Content
<% end %>

# => <button type="submit"Content</button>

```
Copy
Setting this value to `true` makes `button_to` generate a `<button>` tag inside the `<form>` in both cases.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.0  | `true`  |

#### 3.11.19. `config.action_view.apply_stylesheet_media_default`
Determines whether `stylesheet_link_tag` will render `screen` as the default value for the `media` attribute when it's not provided.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 7.0  | `false`  |

#### 3.11.20. `config.action_view.prepend_content_exfiltration_prevention`
Determines whether or not the `form_tag` and `button_to` helpers will produce HTML tags prepended with browser-safe (but technically invalid) HTML that guarantees their contents cannot be captured by any preceding unclosed tags. The default value is `false`.

#### 3.11.21. `config.action_view.sanitizer_vendor`
Configures the set of HTML sanitizers used by Action View by setting `ActionView::Helpers::SanitizeHelper.sanitizer_vendor`. The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  | Which parses markup as  |
| --- | --- | --- |
| (original)  | `Rails::HTML4::Sanitizer`  | HTML4  |
| 7.1  |  `Rails::HTML5::Sanitizer` (see NOTE)  | HTML5  |
`Rails::HTML5::Sanitizer` is not supported on JRuby, so on JRuby platforms Rails will fall back to `Rails::HTML4::Sanitizer`.

#### 3.11.22. `config.action_view.remove_hidden_field_autocomplete`
When enabled, hidden inputs generated by `form_tag`, `token_tag`, `method_tag`, and the hidden parameter fields included in `button_to` forms will omit the `autocomplete="off"` attribute.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 8.1  | `true`  |

#### 3.11.23. `config.action_view.render_tracker`
Configures the strategy for tracking dependencies between Action View templates.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:regex`  |
| 8.1  | `:ruby`  |

### 3.12. Configuring Action Mailbox
`config.action_mailbox` provides the following configuration options:

#### 3.12.1. `config.action_mailbox.logger`
Contains the logger used by Action Mailbox. It accepts a logger conforming to the interface of Log4r or the default Ruby Logger class. The default is `Rails.logger`.

```
config.action_mailbox.logger = ActiveSupport::Logger.new(STDOUT)

#### 3.12.2. `config.action_mailbox.incinerate_after`
Accepts an `ActiveSupport::Duration` indicating how long after processing `ActionMailbox::InboundEmail` records should be destroyed. It defaults to `30.days`.

# Incinerate inbound emails 14 days after processing.
config.action_mailbox.incinerate_after = 14.days

#### 3.12.3. `config.action_mailbox.queues.incineration`
Accepts a symbol indicating the Active Job queue to use for incineration jobs. When this option is `nil`, incineration jobs are sent to the default Active Job queue (see `config.active_job.default_queue_name`).
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:action_mailbox_incineration`  |
| 6.1  | `nil`  |

#### 3.12.4. `config.action_mailbox.queues.routing`
Accepts a symbol indicating the Active Job queue to use for routing jobs. When this option is `nil`, routing jobs are sent to the default Active Job queue (see `config.active_job.default_queue_name`).
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:action_mailbox_routing`  |
| 6.1  | `nil`  |

#### 3.12.5. `config.action_mailbox.storage_service`
Accepts a symbol indicating the Active Storage service to use for uploading emails. When this option is `nil`, emails are uploaded to the default Active Storage service (see `config.active_storage.service`).

### 3.13. Configuring Action Mailer
There are a number of settings available on `config.action_mailer`:

#### 3.13.1. `config.action_mailer.asset_host`
Sets the host for the assets. Useful when CDNs are used for hosting assets rather than the application server itself. You should only use this if you have a different configuration for Action Controller, otherwise use `config.asset_host`.

#### 3.13.2. `config.action_mailer.logger`
Accepts a logger conforming to the interface of Log4r or the default Ruby Logger class, which is then used to log information from Action Mailer. Set to `nil` to disable logging.

#### 3.13.3. `config.action_mailer.smtp_settings`
Allows detailed configuration for the `:smtp` delivery method. It accepts a hash of options, which can include any of these options:
  * `:address` - Allows you to use a remote mail server. Just change it from its default "localhost" setting.
  * `:port` - On the off chance that your mail server doesn't run on port 25, you can change it.
  * `:domain` - If you need to specify a HELO domain, you can do it here.
  * `:user_name` - If your mail server requires authentication, set the username in this setting.
  * `:password` - If your mail server requires authentication, set the password in this setting.
  * `:authentication` - If your mail server requires authentication, you need to specify the authentication type here. This is a symbol and one of `:plain`, `:login`, `:cram_md5`.
  * `:enable_starttls` - Use STARTTLS when connecting to your SMTP server and fail if unsupported. It defaults to `false`.
  * `:enable_starttls_auto` - Detects if STARTTLS is enabled in your SMTP server and starts to use it. It defaults to `true`.
  * `:openssl_verify_mode` - When using TLS, you can set how OpenSSL checks the certificate. This is useful if you need to validate a self-signed and/or a wildcard certificate. This can be the name of one of the OpenSSL verify constants, `'none'` or `'peer'` - or the constant directly `OpenSSL::SSL::VERIFY_NONE` or `OpenSSL::SSL::VERIFY_PEER`, respectively.
  * `:ssl/:tls` - Enables the SMTP connection to use SMTP/TLS (SMTPS: SMTP over direct TLS connection).
  * `:open_timeout` - Number of seconds to wait while attempting to open a connection.
  * `:read_timeout` - Number of seconds to wait until timing-out a read(2) call.

Additionally, it is possible to pass any [configuration option `Mail::SMTP` respects](https://github.com/mikel/mail/blob/master/lib/mail/network/delivery_methods/smtp.rb).

#### 3.13.4. `config.action_mailer.smtp_timeout`
Prior to version 2.8.0, the `mail` gem did not configure any default timeouts for its SMTP requests. This configuration enables applications to configure default values for both `:open_timeout` and `:read_timeout` in the `mail` gem so that requests do not end up stuck indefinitely.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `nil`  |
| 7.0  |

#### 3.13.5. `config.action_mailer.sendmail_settings`
Allows detailed configuration for the `:sendmail` delivery method. It accepts a hash of options, which can include any of these options:
  * `:location` - The location of the sendmail executable. Defaults to `/usr/sbin/sendmail`.
  * `:arguments` - The command line arguments. Defaults to `%w[ -i ]`.

#### 3.13.6. `config.action_mailer.file_settings`
Configures the `:file` delivery method. It accepts a hash of options, which can include:
  * `:location` - The location where files are saved. Defaults to `"#{Rails.root}/tmp/mails"`.
  * `:extension` - The file extension. Defaults to the empty string.

#### 3.13.7. `config.action_mailer.raise_delivery_errors`
Specifies whether to raise an error if email delivery cannot be completed. It defaults to `true`.

#### 3.13.8. `config.action_mailer.delivery_method`
Defines the delivery method and defaults to `:smtp`. See the [configuration section in the Action Mailer guide](https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration) for more info.

#### 3.13.9. `config.action_mailer.perform_deliveries`
Specifies whether mail will actually be delivered and is `true` by default. It can be convenient to set it to `false` for testing.

#### 3.13.10. `config.action_mailer.default_options`
Configures Action Mailer defaults. Use to set options like `from` or `reply_to` for every mailer. These default to:

```
{
  mime_version:  "1.0",
  charset:       "UTF-8",
  content_type: "text/plain",
  parts_order:  ["text/plain", "text/enriched", "text/html"]
}

```
Copy
Assign a hash to set additional options:

```
config.action_mailer.default_options = {
  from: "noreply@example.com"
}

#### 3.13.11. `config.action_mailer.observers`
Registers observers which will be notified when mail is delivered.

```
config.action_mailer.observers = ["MailObserver"]

#### 3.13.12. `config.action_mailer.interceptors`
Registers interceptors which will be called before mail is sent.

```
config.action_mailer.interceptors = ["MailInterceptor"]

#### 3.13.13. `config.action_mailer.preview_interceptors`
Registers interceptors which will be called before mail is previewed.

```
config.action_mailer.preview_interceptors = ["MyPreviewMailInterceptor"]

#### 3.13.14. `config.action_mailer.preview_paths`
Specifies the locations of mailer previews. Appending paths to this configuration option will cause those paths to be used in the search for mailer previews.

```
config.action_mailer.preview_paths << "#{Rails.root}/lib/mailer_previews"

#### 3.13.15. `config.action_mailer.show_previews`
Enable or disable mailer previews. By default this is `true` in development.

```
config.action_mailer.show_previews = false

#### 3.13.16. `config.action_mailer.perform_caching`
Specifies whether the mailer templates should perform fragment caching or not. If it's not specified, the default will be `true`.

#### 3.13.17. `config.action_mailer.deliver_later_queue_name`
Specifies the Active Job queue to use for the default delivery job (see `config.action_mailer.delivery_job`). When this option is set to `nil`, delivery jobs are sent to the default Active Job queue (see `config.active_job.default_queue_name`).
Mailer classes can override this to use a different queue. Note that this only applies when using the default delivery job. If your mailer is using a custom job, its queue will be used.
Ensure that your Active Job adapter is also configured to process the specified queue, otherwise delivery jobs may be silently ignored.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:mailers`  |
| 6.1  | `nil`  |

#### 3.13.18. `config.action_mailer.delivery_job`
Specifies delivery job for mail.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `ActionMailer::MailDeliveryJob`  |
| 6.0  | `"ActionMailer::MailDeliveryJob"`  |

### 3.14. Configuring Active Support
There are a few configuration options available in Active Support:

#### 3.14.1. `config.active_support.bare`
Enables or disables the loading of `active_support/all` when booting Rails. Defaults to `nil`, which means `active_support/all` is loaded.

#### 3.14.2. `config.active_support.test_order`
Sets the order in which the test cases are executed. Possible values are `:random` and `:sorted`. Defaults to `:random`.

#### 3.14.3. `config.active_support.escape_html_entities_in_json`
Enables or disables the escaping of HTML entities in JSON serialization. Defaults to `true`.

#### 3.14.4. `config.active_support.use_standard_json_time_format`
Enables or disables serializing dates to ISO 8601 format. Defaults to `true`.

#### 3.14.5. `config.active_support.time_precision`
Sets the precision of JSON encoded time values. Defaults to `3`.

#### 3.14.6. `config.active_support.hash_digest_class`
Allows configuring the digest class to use to generate non-sensitive digests, such as the ETag header.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `OpenSSL::Digest::MD5`  |
| 5.2  | `OpenSSL::Digest::SHA1`  |
| 7.0  | `OpenSSL::Digest::SHA256`  |

#### 3.14.7. `config.active_support.key_generator_hash_digest_class`
Allows configuring the digest class to use to derive secrets from the configured secret base, such as for encrypted cookies.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `OpenSSL::Digest::SHA1`  |
| 7.0  | `OpenSSL::Digest::SHA256`  |

#### 3.14.8. `config.active_support.use_authenticated_message_encryption`
Specifies whether to use AES-256-GCM authenticated encryption as the default cipher for encrypting messages instead of AES-256-CBC.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 5.2  | `true`  |

#### 3.14.9. `config.active_support.message_serializer`
Specifies the default serializer used by [`ActiveSupport::MessageEncryptor`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/MessageEncryptor.html) and [`ActiveSupport::MessageVerifier`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/MessageVerifier.html) instances. To make migrating between serializers easier, the provided serializers include a fallback mechanism to support multiple deserialization formats:
| Serializer  | Serialize and deserialize  | Fallback deserialize  |
| --- | --- | --- |
| `:marshal`  | `Marshal`  |  `ActiveSupport::JSON`, `ActiveSupport::MessagePack`  |
| `:json`  | `ActiveSupport::JSON`  | `ActiveSupport::MessagePack`  |
| `:json_allow_marshal`  | `ActiveSupport::JSON`  |  `ActiveSupport::MessagePack`, `Marshal`  |
| `:message_pack`  | `ActiveSupport::MessagePack`  | `ActiveSupport::JSON`  |
| `:message_pack_allow_marshal`  | `ActiveSupport::MessagePack`  |  `ActiveSupport::JSON`, `Marshal`  |
`Marshal` is a potential vector for deserialization attacks in cases where a message signing secret has been leaked. _If possible, choose a serializer that does not support`Marshal`._
The `:message_pack` and `:message_pack_allow_marshal` serializers support roundtripping some Ruby types that are not supported by JSON, such as `Symbol`. They can also provide improved performance and smaller payload sizes. However, they require the [`msgpack` gem](https://rubygems.org/gems/msgpack).
Each of the above serializers will emit a [`message_serializer_fallback.active_support`](https://guides.rubyonrails.org/active_support_instrumentation.html#message-serializer-fallback-active-support) event notification when they fall back to an alternate deserialization format, allowing you to track how often such fallbacks occur.
Alternatively, you can specify any serializer object that responds to `dump` and `load` methods. For example:

```
config.active_support.message_serializer = YAML

```
Copy
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:marshal`  |
| 7.1  | `:json_allow_marshal`  |

#### 3.14.10. `config.active_support.use_message_serializer_for_metadata`
When `true`, enables a performance optimization that serializes message data and metadata together. This changes the message format, so messages serialized this way cannot be read by older (< 7.1) versions of Rails. However, messages that use the old format can still be read, regardless of whether this optimization is enabled.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.1  | `true`  |

#### 3.14.11. `config.active_support.cache_format_version`
Specifies which serialization format to use for the cache. Possible values are `7.0`, and `7.1`.
`7.0` serializes cache entries more efficiently.
`7.1` further improves efficiency, and allows expired and version-mismatched cache entries to be detected without deserializing their values. It also includes an optimization for bare string values such as view fragments.
All formats are backward and forward compatible, meaning cache entries written in one format can be read when using another format. This behavior makes it easy to migrate between formats without invalidating the entire cache.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| 7.0  | `7.0`  |
| 7.1  | `7.1`  |

#### 3.14.12. `config.active_support.deprecation`
Configures the behavior of deprecation warnings. See [`Deprecation::Behavior`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/Deprecation/Behavior.html#method-i-behavior-3D) for a description of the available options.
In the default generated `config/environments` files, this is set to `:log` for development and `:stderr` for test, and it is omitted for production in favor of `config.active_support.report_deprecations`.

#### 3.14.13. `config.active_support.disallowed_deprecation`
Configures the behavior of disallowed deprecation warnings. See [`Deprecation::Behavior`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/Deprecation/Behavior.html#method-i-behavior-3D) for a description of the available options.
This option is intended for development and test. For production, favor `config.active_support.report_deprecations`.

#### 3.14.14. `config.active_support.disallowed_deprecation_warnings`
Configures deprecation warnings that the Application considers disallowed. This allows, for example, specific deprecations to be treated as hard failures.

#### 3.14.15. `config.active_support.report_deprecations`
When `false`, disables all deprecation warnings, including disallowed deprecations, from the [application’s deprecators](https://api.rubyonrails.org/v8.1.3/classes/Rails/Application.html#method-i-deprecators). This includes all the deprecations from Rails and other gems that may add their deprecator to the collection of deprecators, but may not prevent all deprecation warnings emitted from ActiveSupport::Deprecation.
In the default generated `config/environments` files, this is set to `false` for production.

#### 3.14.16. `config.active_support.isolation_level`
Configures the locality of most of Rails internal state. If you use a fiber based server or job processor (e.g. `falcon`), you should set it to `:fiber`. Otherwise it is best to use `:thread` locality. Defaults to `:thread`.

#### 3.14.17. `config.active_support.executor_around_test_case`
Configure the test suite to call `Rails.application.executor.wrap` around test cases. This makes test cases behave closer to an actual request or job. Several features that are normally disabled in test, such as Active Record query cache and asynchronous queries will then be enabled.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.0  | `true`  |

#### 3.14.18. `ActiveSupport::Logger.silencer`
Is set to `false` to disable the ability to silence logging in a block. The default is `true`.

#### 3.14.19. `ActiveSupport::Cache::Store.logger`
Specifies the logger to use within cache store operations.

#### 3.14.20. `ActiveSupport.utc_to_local_returns_utc_offset_times`
Configures [`ActiveSupport::TimeZone.utc_to_local`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/TimeZone.html#method-i-utc_to_local) to return a time with a UTC offset instead of a UTC time incorporating that offset.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 6.1  | `true`  |

#### 3.14.21. `config.active_support.raise_on_invalid_cache_expiration_time`
Specifies whether an `ArgumentError` should be raised if `Rails.cache` [`fetch`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/Cache/Store.html#method-i-fetch) or [`write`](https://api.rubyonrails.org/v8.1.3/classes/ActiveSupport/Cache/Store.html#method-i-write) are given an invalid `expires_at` or `expires_in` time.
Options are `true` and `false`. If `false`, the exception will be reported as `handled` and logged instead.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.1  | `true`  |

#### 3.14.22. `config.active_support.event_reporter_context_store`
Configures a custom context store for the Event Reporter. The context store is used to manage metadata that should be attached to every event emitted by the reporter.
By default, the Event Reporter uses `ActiveSupport::EventContext` which stores context in fiber-local storage.
To use a custom context store, set this config to a class that implements the context store interface:

# config/application.rb
config.active_support.event_reporter_context_store = CustomContextStore

class CustomContextStore
  class << self
    def context
      # Return the context hash
    end

def set_context(context_hash)
      # Append context_hash to the existing context store
    end

def clear
      # Clear the stored context
    end
  end
end

```
Copy
Defaults to `nil`, which means the default `ActiveSupport::EventContext` store is used.

#### 3.14.23. `config.active_support.escape_js_separators_in_json`
Specifies whether LINE SEPARATOR (U+2028) and PARAGRAPH SEPARATOR (U+2029) are escaped when generating JSON.
Historically these characters were not valid inside JavaScript literal strings but that changed in ECMAScript 2019. As such it's no longer a concern in modern browsers: <https://caniuse.com/mdn-javascript_builtins_json_json_superset>.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `true`  |
| 8.1  | `false`  |

### 3.15. Configuring Active Job
`config.active_job` provides the following configuration options:

#### 3.15.1. `config.active_job.queue_adapter`
Sets the adapter for the queuing backend. The default adapter is `:async`. For an up-to-date list of built-in adapters see the [ActiveJob::QueueAdapters API documentation](https://api.rubyonrails.org/v8.1.3/classes/ActiveJob/QueueAdapters.html).

# Be sure to have the adapter's gem in your Gemfile

# and follow the adapter's specific installation

# and deployment instructions.
config.active_job.queue_adapter = :sidekiq

#### 3.15.2. `config.active_job.default_queue_name`
Can be used to change the default queue name. By default this is `"default"`.

```
config.active_job.default_queue_name = :medium_priority

#### 3.15.3. `config.active_job.queue_name_prefix`
Allows you to set an optional, non-blank, queue name prefix for all jobs. By default it is blank and not used.
The following configuration would queue the given job on the `production_high_priority` queue when run in production:

```
config.active_job.queue_name_prefix = Rails.env

```
class GuestsCleanupJob  ActiveJob::Base
  queue_as :high_priority
  #....
end

#### 3.15.4. `config.active_job.queue_name_delimiter`
Has a default value of `'_'`. If `queue_name_prefix` is set, then `queue_name_delimiter` joins the prefix and the non-prefixed queue name.
The following configuration would queue the provided job on the `video_server.low_priority` queue:

# prefix must be set for delimiter to be used
config.active_job.queue_name_prefix = "video_server"
config.active_job.queue_name_delimiter = "."

```
class EncoderJob  ActiveJob::Base
  queue_as :low_priority
  #....
end

#### 3.15.5. `config.active_job.logger`
Accepts a logger conforming to the interface of Log4r or the default Ruby Logger class, which is then used to log information from Active Job. You can retrieve this logger by calling `logger` on either an Active Job class or an Active Job instance. Set to `nil` to disable logging.

#### 3.15.6. `config.active_job.custom_serializers`
Allows to set custom argument serializers. Defaults to `[]`.

#### 3.15.7. `config.active_job.log_arguments`
Controls if the arguments of a job are logged. Defaults to `true`.

#### 3.15.8. `config.active_job.verbose_enqueue_logs`
Specifies if source locations of methods that enqueue background jobs should be logged below relevant enqueue log lines. By default, the flag is `true` in development and `false` in all other environments.

#### 3.15.9. `config.active_job.retry_jitter`
Controls the amount of "jitter" (random variation) applied to the delay time calculated when retrying failed jobs.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `0.0`  |
| 6.1  | `0.15`  |

#### 3.15.10. `config.active_job.log_query_tags_around_perform`
Determines whether job context for query tags will be automatically updated via an `around_perform`. The default value is `true`.

### 3.16. Configuring Action Cable

#### 3.16.1. `config.action_cable.url`
Accepts a string for the URL for where you are hosting your Action Cable server. You would use this option if you are running Action Cable servers that are separated from your main application.

#### 3.16.2. `config.action_cable.mount_path`
Accepts a string for where to mount Action Cable, as part of the main server process. Defaults to `/cable`. You can set this as nil to not mount Action Cable as part of your normal Rails server.
You can find more detailed configuration options in the [Action Cable Overview](https://guides.rubyonrails.org/action_cable_overview.html#configuration).

#### 3.16.3. `config.action_cable.precompile_assets`
Determines whether the Action Cable assets should be added to the asset pipeline precompilation. It has no effect if Sprockets is not used. The default value is `true`.

#### 3.16.4. `config.action_cable.allow_same_origin_as_host`
Determines whether an origin matching the cable server itself will be permitted. The default value is `true`.
Set to false to disable automatic access for same-origin requests, and strictly allow only the configured origins.

#### 3.16.5. `config.action_cable.allowed_request_origins`
Determines the request origins which will be accepted by the cable server. The default value is `/https?:\/\/localhost:\d+/` in the `development` environment.

### 3.17. Configuring Active Storage
`config.active_storage` provides the following configuration options:

#### 3.17.1. `config.active_storage.variant_processor`
Accepts a symbol `:mini_magick`, `:vips`, or `:disabled` specifying whether or not variant transformations and blob analysis will be performed with MiniMagick or ruby-vips.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `:mini_magick`  |
| 7.0  | `:vips`  |

#### 3.17.2. `config.active_storage.analyzers`
Accepts an array of classes indicating the analyzers available for Active Storage blobs. By default, this is defined as:

```
config.active_storage.analyzers = [
  ActiveStorage::Analyzer::ImageAnalyzer::Vips,
  ActiveStorage::Analyzer::ImageAnalyzer::ImageMagick,
  ActiveStorage::Analyzer::VideoAnalyzer,
  ActiveStorage::Analyzer::AudioAnalyzer
]

```
Copy
The image analyzers can extract width and height of an image blob; the video analyzer can extract width, height, duration, angle, aspect ratio, and presence/absence of video/audio channels of a video blob; the audio analyzer can extract duration and bit rate of an audio blob.
If you want to disable analyzers, you can set this to an empty array:

```
config.active_storage.analyzers = []

#### 3.17.3. `config.active_storage.previewers`
Accepts an array of classes indicating the image previewers available in Active Storage blobs. By default, this is defined as:

```
config.active_storage.previewers = [ActiveStorage::Previewer::PopplerPDFPreviewer, ActiveStorage::Previewer::MuPDFPreviewer, ActiveStorage::Previewer::VideoPreviewer]

```
Copy
`PopplerPDFPreviewer` and `MuPDFPreviewer` can generate a thumbnail from the first page of a PDF blob; `VideoPreviewer` from the relevant frame of a video blob.

#### 3.17.4. `config.active_storage.paths`
Accepts a hash of options indicating the locations of previewer/analyzer commands. The default is `{}`, meaning the commands will be looked for in the default path. Can include any of these options:
  * `:ffprobe` - The location of the ffprobe executable.
  * `:mutool` - The location of the mutool executable.
  * `:ffmpeg` - The location of the ffmpeg executable.

```
config.active_storage.paths[:ffprobe] = "/usr/local/bin/ffprobe"

#### 3.17.5. `config.active_storage.variable_content_types`
Accepts an array of strings indicating the content types that Active Storage can transform through the variant processor. By default, this is defined as:

```
config.active_storage.variable_content_types = %w(image/png image/gif image/jpeg image/tiff image/bmp image/vnd.adobe.photoshop image/vnd.microsoft.icon image/webp image/avif image/heic image/heif)

#### 3.17.6. `config.active_storage.web_image_content_types`
Accepts an array of strings regarded as web image content types in which variants can be processed without being converted to the fallback PNG format. For example, if you want to use `AVIF` variants in your application you can add `image/avif` to this array.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `%w(image/png image/jpeg image/gif)`  |
| 7.2  | `%w(image/png image/jpeg image/gif image/webp)`  |

#### 3.17.7. `config.active_storage.content_types_to_serve_as_binary`
Accepts an array of strings indicating the content types that Active Storage will always serve as an attachment, rather than inline. By default, this is defined as:

```
config.active_storage.content_types_to_serve_as_binary = %w(text/html image/svg+xml application/postscript application/x-shockwave-flash text/xml application/xml application/xhtml+xml application/mathml+xml text/cache-manifest)

#### 3.17.8. `config.active_storage.content_types_allowed_inline`
Accepts an array of strings indicating the content types that Active Storage allows to serve as inline. By default, this is defined as:

```
config.active_storage.content_types_allowed_inline = %w(image/webp image/avif image/png image/gif image/jpeg image/tiff image/vnd.adobe.photoshop image/vnd.microsoft.icon application/pdf)

#### 3.17.9. `config.active_storage.queues.analysis`
Accepts a symbol indicating the Active Job queue to use for analysis jobs. When this option is `nil`, analysis jobs are sent to the default Active Job queue (see `config.active_job.default_queue_name`).
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| 6.0  | `:active_storage_analysis`  |
| 6.1  | `nil`  |

#### 3.17.10. `config.active_storage.queues.mirror`
Accepts a symbol indicating the Active Job queue to use for direct upload mirroring jobs. When this option is `nil`, mirroring jobs are sent to the default Active Job queue (see `config.active_job.default_queue_name`). The default is `nil`.

#### 3.17.11. `config.active_storage.queues.preview_image`
Accepts a symbol indicating the Active Job queue to use for preprocessing previews of images. When this option is `nil`, jobs are sent to the default Active Job queue (see `config.active_job.default_queue_name`). The default is `nil`.

#### 3.17.12. `config.active_storage.queues.purge`
Accepts a symbol indicating the Active Job queue to use for purge jobs. When this option is `nil`, purge jobs are sent to the default Active Job queue (see `config.active_job.default_queue_name`).
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| 6.0  | `:active_storage_purge`  |
| 6.1  | `nil`  |

#### 3.17.13. `config.active_storage.queues.transform`
Accepts a symbol indicating the Active Job queue to use for preprocessing variants. When this option is `nil`, jobs are sent to the default Active Job queue (see `config.active_job.default_queue_name`). The default is `nil`.

#### 3.17.14. `config.active_storage.logger`
Can be used to set the logger used by Active Storage. Accepts a logger conforming to the interface of Log4r or the default Ruby Logger class.

```
config.active_storage.logger = ActiveSupport::Logger.new(STDOUT)

#### 3.17.15. `config.active_storage.service_urls_expire_in`
Determines the default expiry of URLs generated by:
  * [`ActiveStorage::Blob#service_url_for_direct_upload`](https://api.rubyonrails.org/v8.1.3/classes/ActiveStorage/Blob.html#method-i-service_url_for_direct_upload)

The default is 5 minutes.

#### 3.17.16. `config.active_storage.urls_expire_in`
Determines the default expiry of URLs in the Rails application generated by Active Storage. The default is nil.

#### 3.17.17. `config.active_storage.touch_attachment_records`
Directs ActiveStorage::Attachments to touch its corresponding record when updated. The default is true.

#### 3.17.18. `config.active_storage.routes_prefix`
Can be used to set the route prefix for the routes served by Active Storage. Accepts a string that will be prepended to the generated routes.

```
config.active_storage.routes_prefix = "/files"

```
Copy
The default is `/rails/active_storage`.

#### 3.17.19. `config.active_storage.track_variants`
Determines whether variants are recorded in the database.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 6.1  | `true`  |

#### 3.17.20. `config.active_storage.draw_routes`
Can be used to toggle Active Storage route generation. The default is `true`.

#### 3.17.21. `config.active_storage.resolve_model_to_route`
Can be used to globally change how Active Storage files are delivered.
Allowed values are:
  * `:rails_storage_redirect`: Redirect to signed, short-lived service URLs.
  * `:rails_storage_proxy`: Proxy files by downloading them.

The default is `:rails_storage_redirect`.

#### 3.17.22. `config.active_storage.video_preview_arguments`
Can be used to alter the way ffmpeg generates video preview images.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `"-y -vframes 1 -f image2"`  |
| 7.0  |  `"-vf 'select=eq(n\\,0)+eq(key\\,1)+gt(scene\\,0.015)"` `+ ",loop=loop=-1:size=2,trim=start_frame=1'"` `+ " -frames:v 1 -f image2"`
  1. Select the first video frame, plus keyframes, plus frames that meet the scene change threshold.
  2. Use the first video frame as a fallback when no other frames meet the criteria by looping the first (one or) two selected frames, then dropping the first looped frame.

|

#### 3.17.23. `config.active_storage.multiple_file_field_include_hidden`
In Rails 7.1 and beyond, Active Storage `has_many_attached` relationships will default to _replacing_ the current collection instead of _appending_ to it. Thus to support submitting an _empty_ collection, when `multiple_file_field_include_hidden` is `true`, the [`file_field`](https://api.rubyonrails.org/v8.1.3/classes/ActionView/Helpers/FormBuilder.html#method-i-file_field) helper will render an auxiliary hidden field, similar to the auxiliary field rendered by the [`checkbox`](https://api.rubyonrails.org/v8.1.3/classes/ActionView/Helpers/FormBuilder.html#method-i-checkbox) helper.
The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  |
| --- | --- |
| (original)  | `false`  |
| 7.0  | `true`  |

#### 3.17.24. `config.active_storage.precompile_assets`
Determines whether the Active Storage assets should be added to the asset pipeline precompilation. It has no effect if Sprockets is not used. The default value is `true`.

#### 3.17.25. `config.active_storage.streaming_max_ranges`
Defines how many ranges a byte range request may contain.
`ActiveStorage::Streaming` allows requesting partial resources using HTTP Range Requests, but that feature can be abused for denial of service attacks.
By default only a single range of byte is allowed, which allows for retries and the vast majority of use cases. If you need multiple byte range support, you can increase that setting.
| Starting with version  | The default value is  |
| --- | --- |
| (original)  |

### 3.18. Configuring Action Text

#### 3.18.1. `config.action_text.attachment_tag_name`
Accepts a string for the HTML tag used to wrap attachments. Defaults to `"action-text-attachment"`.

#### 3.18.2. `config.action_text.sanitizer_vendor`
Configures the HTML sanitizer used by Action Text by setting `ActionText::ContentHelper.sanitizer` to an instance of the class returned from the vendor's `.safe_list_sanitizer` method. The default value depends on the `config.load_defaults` target version:
| Starting with version  | The default value is  | Which parses markup as  |
| --- | --- | --- |
| (original)  | `Rails::HTML4::Sanitizer`  | HTML4  |
| 7.1  |  `Rails::HTML5::Sanitizer` (see NOTE)  | HTML5  |
`Rails::HTML5::Sanitizer` is not supported on JRuby, so on JRuby platforms Rails will fall back to `Rails::HTML4::Sanitizer`.

#### 3.18.3. `Regexp.timeout`
See Ruby's documentation for [`Regexp.timeout=`](https://docs.ruby-lang.org/en/master/Regexp.html#method-c-timeout-3D).

### 3.19. Configuring a Database
Just about every Rails application will interact with a database. You can connect to the database by setting an environment variable `ENV['DATABASE_URL']` or by using a configuration file called `config/database.yml`.
Using the `config/database.yml` file you can specify all the information needed to access your database:

```
development:
  adapter: postgresql
  database: blog_development
  pool: 5

```
Copy
This will connect to the database named `blog_development` using the `postgresql` adapter. This same information can be stored in a URL and provided via an environment variable like this:

```
ENV["DATABASE_URL"] # => "postgresql://localhost/blog_development?pool=5"

```
Copy
The `config/database.yml` file contains sections for three different environments in which Rails can run by default:
  * The `development` environment is used on your development/local computer as you interact manually with the application.
  * The `test` environment is used when running automated tests.
  * The `production` environment is used when you deploy your application for the world to use.

If you wish, you can manually specify a URL inside of your `config/database.yml`

```
development:
  url: postgresql://localhost/blog_development?pool=5

```
Copy
The `config/database.yml` file can contain ERB tags `<%= %>`. Anything in the tags will be evaluated as Ruby code. You can use this to pull out data from an environment variable or to perform calculations to generate the needed connection information.
When using a `ENV['DATABASE_URL']` or a `url` key in your `config/database.yml` file, Rails allows mapping the protocol in the URL to a database adapter that can be configured from within the application. This allows the adapter to be configured without modifying the URL set in the deployment environment. See: `config.active_record.protocol_adapters`.
You don't have to update the database configurations manually. If you look at the options of the application generator, you will see that one of the options is named `--database`. This option allows you to choose an adapter from a list of the most used relational databases. You can even run the generator repeatedly: `cd .. && rails new blog --database=mysql`. When you confirm the overwriting of the `config/database.yml` file, your application will be configured for MySQL instead of SQLite. Detailed examples of the common database connections are below.

### 3.20. Connection Preference
Since there are two ways to configure your connection (using `config/database.yml` or using an environment variable) it is important to understand how they can interact.
If you have an empty `config/database.yml` file but your `ENV['DATABASE_URL']` is present, then Rails will connect to the database via your environment variable:

```
$cat config/database.yml

$echo $DATABASE_URL
postgresql://localhost/my_database

```
Copy
If you have a `config/database.yml` but no `ENV['DATABASE_URL']` then this file will be used to connect to your database:

```
$cat config/database.yml
development:
  adapter: postgresql
  database: my_database
  host: localhost

$echo $DATABASE_URL

```
Copy
If you have both `config/database.yml` and `ENV['DATABASE_URL']` set then Rails will merge the configuration together. To better understand this we must see some examples.
When duplicate connection information is provided the environment variable will take precedence:

```
$cat config/database.yml
development:
  adapter: sqlite3
  database: NOT_my_database
  host: localhost

$bin/rails runner 'puts ActiveRecord::Base.configurations.inspect'
#<ActiveRecord::DatabaseConfigurations:0x00007fc8eab02880 @configurations=[
  #<ActiveRecord::DatabaseConfigurations::UrlConfig:0x00007fc8eab020b0
    @env_name="development", @spec_name="primary",
    @config={"adapter"=>"postgresql", "database"=>"my_database", "host"=>"localhost"}
    @url="postgresql://localhost/my_database">
  ]

```
Copy
Here the adapter, host, and database match the information in `ENV['DATABASE_URL']`.
If non-duplicate information is provided you will get all unique values, environment variable still takes precedence in cases of any conflicts.

```
$cat config/database.yml
development:
  adapter: sqlite3
  pool: 5

$bin/rails runner 'puts ActiveRecord::Base.configurations.inspect'
#<ActiveRecord::DatabaseConfigurations:0x00007fc8eab02880 @configurations=[
  #<ActiveRecord::DatabaseConfigurations::UrlConfig:0x00007fc8eab020b0
    @env_name="development", @spec_name="primary",
    @config={"adapter"=>"postgresql", "database"=>"my_database", "host"=>"localhost", "pool"=>5}
    @url="postgresql://localhost/my_database">
  ]

```
Copy
Since pool is not in the `ENV['DATABASE_URL']` provided connection information its information is merged in. Since `adapter` is duplicate, the `ENV['DATABASE_URL']` connection information wins.
The only way to explicitly not use the connection information in `ENV['DATABASE_URL']` is to specify an explicit URL connection using the `"url"` sub key:

```
$cat config/database.yml
development:
  url: sqlite3:NOT_my_database

$bin/rails runner 'puts ActiveRecord::Base.configurations.inspect'
#<ActiveRecord::DatabaseConfigurations:0x00007fc8eab02880 @configurations=[
  #<ActiveRecord::DatabaseConfigurations::UrlConfig:0x00007fc8eab020b0
    @env_name="development", @spec_name="primary",
    @config={"adapter"=>"sqlite3", "database"=>"NOT_my_database"}
    @url="sqlite3:NOT_my_database">
  ]

```
Copy
Here the connection information in `ENV['DATABASE_URL']` is ignored, note the different adapter and database name.
Since it is possible to embed ERB in your `config/database.yml` it is best practice to explicitly show you are using the `ENV['DATABASE_URL']` to connect to your database. This is especially useful in production since you should not commit secrets like your database password into your source control (such as Git).

```
$cat config/database.yml
production:
  url: <%= ENV['DATABASE_URL'] %>

```
Copy
Now the behavior is clear, that we are only using the connection information in `ENV['DATABASE_URL']`.

#### 3.20.1. Configuring an SQLite3 Database
Rails comes with built-in support for [SQLite3](https://www.sqlite.org), which is a lightweight serverless database application. While Rails better configures SQLite for production workloads, a busy production environment may overload SQLite. Rails defaults to using an SQLite database when creating a new project because it is a zero configuration database that just works, but you can always change it later.
Here's the section of the default configuration file (`config/database.yml`) with connection information for the development environment:

```
development:
  adapter: sqlite3
  database: storage/development.sqlite3
  pool: 5
  timeout: 5000

```
Copy
[SQLite extensions](https://sqlite.org/loadext.html) are supported when using `sqlite3` gem v2.4.0 or later by configuring `extensions`:

```
development:
  adapter: sqlite3
  extensions:
    - SQLean::UUID                     # module name responding to `.to_path`
    - .sqlpkg/nalgeon/crypto/crypto.so # or a filesystem path
    - <%= AppExtensions.location %>    # or ruby code returning a path

```
Copy
Many useful features can be added to SQLite through extensions. You may wish to browse the [SQLite extension hub](https://sqlpkg.org/) or use gems like [`sqlpkg-ruby`](https://github.com/fractaledmind/sqlpkg-ruby) and [`sqlean-ruby`](https://github.com/flavorjones/sqlean-ruby) that simplify extension management.
Other configuration options are described in the [SQLite3Adapter documentation](https://api.rubyonrails.org/v8.1.3/classes/ActiveRecord/ConnectionAdapters/SQLite3Adapter.html).

#### 3.20.2. Configuring a MySQL or MariaDB Database
If you choose to use MySQL or MariaDB instead of the shipped SQLite3 database, your `config/database.yml` will look a little different. Here's the development section:

```
development:
  adapter: mysql2
  encoding: utf8mb4
  database: blog_development
  pool: 5
  username: root
  password:
  socket: /tmp/mysql.sock

```
Copy
If your development database has a root user with an empty password, this configuration should work for you. Otherwise, change the username and password in the `development` section as appropriate.
If your MySQL version is 5.5 or 5.6 and want to use the `utf8mb4` character set by default, please configure your MySQL server to support the longer key prefix by enabling `innodb_large_prefix` system variable.
Advisory Locks are enabled by default on MySQL and are used to make database migrations concurrent safe. You can disable advisory locks by setting `advisory_locks` to `false`:

```
production:
  adapter: mysql2
  advisory_locks: false

#### 3.20.3. Configuring a PostgreSQL Database
If you choose to use PostgreSQL, your `config/database.yml` will be customized to use PostgreSQL databases:

```
development:
  adapter: postgresql
  encoding: unicode
  database: blog_development
  pool: 5

```
Copy
By default Active Record uses a database feature called advisory locks. You might need to disable this feature if you're using an external connection pooler like PgBouncer:

```
production:
  adapter: postgresql
  advisory_locks: false

```
Copy
If enabled, Active Record will create up to `1000` prepared statements per database connection by default. To modify this behavior you can set `statement_limit` to a different value:

```
production:
  adapter: postgresql
  statement_limit: 200

```
Copy
The more prepared statements in use: the more memory your database will require. If your PostgreSQL database is hitting memory limits, try lowering `statement_limit` or disabling prepared statements.

#### 3.20.4. Configuring an SQLite3 Database for JRuby Platform
If you choose to use SQLite3 and are using JRuby, your `config/database.yml` will look a little different. Here's the development section:

```
development:
  adapter: jdbcsqlite3
  database: storage/development.sqlite3

#### 3.20.5. Configuring a MySQL or MariaDB Database for JRuby Platform
If you choose to use MySQL or MariaDB and are using JRuby, your `config/database.yml` will look a little different. Here's the development section:

```
development:
  adapter: jdbcmysql
  database: blog_development
  username: root
  password:

#### 3.20.6. Configuring a PostgreSQL Database for JRuby Platform
If you choose to use PostgreSQL and are using JRuby, your `config/database.yml` will look a little different. Here's the development section:

```
development:
  adapter: jdbcpostgresql
  encoding: unicode
  database: blog_development
  username: blog
  password:

```
Copy
Change the username and password in the `development` section as appropriate.

#### 3.20.7. Configuring Metadata Storage
By default Rails will store information about your Rails environment and schema in an internal table named `ar_internal_metadata`.
To turn this off per connection, set `use_metadata_table` in your database configuration. This is useful when working with a shared database and/or database user that cannot create tables.

```
development:
  adapter: postgresql
  use_metadata_table: false

#### 3.20.8. Configuring Retry Behavior
By default, Rails will automatically reconnect to the database server and retry certain queries if something goes wrong. Only safely retryable (idempotent) queries will be retried. The number of retries can be specified in your the database configuration via `connection_retries`, or disabled by setting the value to 0. The default number of retries is 1.

```
development:
  adapter: mysql2
  connection_retries: 3

```
Copy
The database config also allows a `retry_deadline` to be configured. If a `retry_deadline` is configured, an otherwise-retryable query will _not_ be retried if the specified time has elapsed while the query was first tried. For example, a `retry_deadline` of 5 seconds means that if 5 seconds have passed since a query was first attempted, we won't retry the query, even if it is idempotent and there are `connection_retries` left.
This value defaults to nil, meaning that all retryable queries are retried regardless of time elapsed. The value for this config should be specified in seconds.

```
development:
  adapter: mysql2
  retry_deadline: 5 # Stop retrying queries after 5 seconds

#### 3.20.9. Configuring Query Cache
By default, Rails automatically caches the result sets returned by queries. If Rails encounters the same query again for that request or job, it will use the cached result set as opposed to running the query against the database again.
The query cache is stored in memory, and to avoid using too much memory, it automatically evicts the least recently used queries when reaching a threshold. By default the threshold is `100`, but can be configured in the `database.yml`.

```
development:
  adapter: mysql2
  query_cache: 200

```
Copy
To entirely disable query caching, it can be set to `false`

```
development:
  adapter: mysql2
  query_cache: false

### 3.21. Creating Rails Environments
By default Rails ships with three environments: "development", "test", and "production". While these are sufficient for most use cases, there are circumstances when you want more environments.
Imagine you have a server which mirrors the production environment but is only used for testing. Such a server is commonly called a "staging server". To define an environment called "staging" for this server, just create a file called `config/environments/staging.rb`. Since this is a production-like environment, you could copy the contents of `config/environments/production.rb` as a starting point and make the necessary changes from there. It's also possible to require and extend other environment configurations like this:

# config/environments/staging.rb
require_relative "production"

Rails.application.configure do

# Staging overrides
end

```
Copy
That environment is no different than the default ones, start a server with `bin/rails server -e staging`, a console with `bin/rails console -e staging`, `Rails.env.staging?` works, etc.

### 3.22. Deploy to a Subdirectory (relative URL root)
By default Rails expects that your application is running at the root (e.g. `/`). This section explains how to run your application inside a directory.
Let's assume we want to deploy our application to "/app1". Rails needs to know this directory to generate the appropriate routes:

```
config.relative_url_root = "/app1"

```
Copy
alternatively you can set the `RAILS_RELATIVE_URL_ROOT` environment variable.
Rails will now prepend "/app1" when generating links.

#### 3.22.1. Using Passenger
Passenger makes it easy to run your application in a subdirectory. You can find the relevant configuration in the [Passenger manual](https://www.phusionpassenger.com/library/deploy/apache/deploy/ruby/#deploying-an-app-to-a-sub-uri-or-subdirectory).

#### 3.22.2. Using a Reverse Proxy
Deploying your application using a reverse proxy has definite advantages over traditional deploys. They allow you to have more control over your server by layering the components required by your application.
Many modern web servers can be used as a proxy server to balance third-party elements such as caching servers or application servers.
One such application server you can use is [Unicorn](https://bogomips.org/unicorn/) to run behind a reverse proxy.
In this case, you would need to configure the proxy server (NGINX, Apache, etc) to accept connections from your application server (Unicorn). By default Unicorn will listen for TCP connections on port 8080, but you can change the port or configure it to use sockets instead.
You can find more information in the [Unicorn readme](https://bogomips.org/unicorn/README.html) and understand the [philosophy](https://bogomips.org/unicorn/PHILOSOPHY.html) behind it.
Once you've configured the application server, you must proxy requests to it by configuring your web server appropriately. For example your NGINX config may include:

```
upstream application_server {
  server 0.0.0.0:8080;
}

server {
  listen 80;
  server_name localhost;

root /root/path/to/your_app/public;

try_files $uri/index.html $uri.html @app;

location @app {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://application_server;
  }

# some other configuration
}

```
Copy
Be sure to read the [NGINX documentation](https://nginx.org/en/docs/) for the most up-to-date information.

## 4. Rails Environment Settings
Some parts of Rails can also be configured externally by supplying environment variables. The following environment variables are recognized by various parts of Rails:
  * `ENV["RAILS_ENV"]` defines the Rails environment (production, development, test, and so on) that Rails will run under.
  * `ENV["RAILS_RELATIVE_URL_ROOT"]` is used by the routing code to recognize URLs when you [deploy your application to a subdirectory](https://guides.rubyonrails.org/configuring.html#deploy-to-a-subdirectory-relative-url-root).
  * `ENV["RAILS_CACHE_ID"]` and `ENV["RAILS_APP_VERSION"]` are used to generate expanded cache keys in Rails' caching code. This allows you to have multiple separate caches from the same application.

## 5. Using Initializer Files
After loading the framework and any gems in your application, Rails turns to loading initializers. An initializer is any Ruby file stored under `config/initializers` in your application. You can use initializers to hold configuration settings that should be made after all of the frameworks and gems are loaded, such as options to configure settings for these parts.
The files in `config/initializers` (and any subdirectories of `config/initializers`) are sorted and loaded one by one as part of the `load_config_initializers` initializer.
If an initializer has code that relies on code in another initializer, you can combine them into a single initializer instead. This makes the dependencies more explicit, and can help surface new concepts within your application. Rails also supports numbering of initializer file names, but this can lead to file name churn. Explicitly loading initializers with `require` is not recommended, since it will cause the initializer to get loaded twice.
There is no guarantee that your initializers will run after all the gem initializers, so any initialization code that depends on a given gem having been initialized should go into a `config.after_initialize` block.

## 6. Load Hooks
Rails code can often be referenced on load of an application. Rails is responsible for the load order of these frameworks, so when you load frameworks, such as `ActiveRecord::Base`, prematurely you are violating an implicit contract your application has with Rails. Moreover, by loading code such as `ActiveRecord::Base` on boot of your application you are loading entire frameworks which may slow down your boot time and could cause conflicts with load order and boot of your application.
Load and configuration hooks are the API that allow you to hook into this initialization process without violating the load contract with Rails. This will also mitigate boot performance degradation and avoid conflicts.

### 6.1. Avoid Loading Rails Frameworks
Since Ruby is a dynamic language, some code will cause different Rails frameworks to load. Take this snippet for instance:

```
ActiveRecord::Base.include(MyActiveRecordHelper)

```
Copy
This snippet means that when this file is loaded, it will encounter `ActiveRecord::Base`. This encounter causes Ruby to look for the definition of that constant and will require it. This causes the entire Active Record framework to be loaded on boot.
`ActiveSupport.on_load` is a mechanism that can be used to defer the loading of code until it is actually needed. The snippet above can be changed to:

```
ActiveSupport.on_load(:active_record) do
  include MyActiveRecordHelper
end

```
Copy
This new snippet will only include `MyActiveRecordHelper` when `ActiveRecord::Base` is loaded.

### 6.2. When are Hooks called?
In the Rails framework these hooks are called when a specific library is loaded. For example, when `ActionController::Base` is loaded, the `:action_controller_base` hook is called. This means that all `ActiveSupport.on_load` calls with `:action_controller_base` hooks will be called in the context of `ActionController::Base` (that means `self` will be an `ActionController::Base`).

### 6.3. Modifying Code to Use Load Hooks
Modifying code is generally straightforward. If you have a line of code that refers to a Rails framework such as `ActiveRecord::Base` you can wrap that code in a load hook.
**Modifying calls to`include`**

```
Copy
becomes

```
ActiveSupport.on_load(:active_record) do

# self refers to ActiveRecord::Base here,

# so we can call .include
  include MyActiveRecordHelper
end

```
Copy
**Modifying calls to`prepend`**

```
ActionController::Base.prepend(MyActionControllerHelper)

```
ActiveSupport.on_load(:action_controller_base) do

# self refers to ActionController::Base here,

# so we can call .prepend
  prepend MyActionControllerHelper
end

```
Copy
**Modifying calls to class methods**

```
ActiveRecord::Base.include_root_in_json = true

# self refers to ActiveRecord::Base here
  self.include_root_in_json = true
end

### 6.4. Available Load Hooks
These are the load hooks you can use in your own code. To hook into the initialization process of one of the following classes use the available hook.
| Class  | Hook  |
| --- | --- |
| `ActionCable`  | `action_cable`  |
| `ActionCable::Channel::Base`  | `action_cable_channel`  |
| `ActionCable::Connection::Base`  | `action_cable_connection`  |
| `ActionCable::Connection::TestCase`  | `action_cable_connection_test_case`  |
| `ActionController::API`  | `action_controller_api`  |
| `ActionController::API`  | `action_controller`  |
| `ActionController::Base`  | `action_controller_base`  |
| `ActionController::Base`  | `action_controller`  |
| `ActionController::TestCase`  | `action_controller_test_case`  |
| `ActionDispatch::IntegrationTest`  | `action_dispatch_integration_test`  |
| `ActionDispatch::Response`  | `action_dispatch_response`  |
| `ActionDispatch::Request`  | `action_dispatch_request`  |
| `ActionDispatch::SystemTestCase`  | `action_dispatch_system_test_case`  |
| `ActionMailbox::Base`  | `action_mailbox`  |
| `ActionMailbox::InboundEmail`  | `action_mailbox_inbound_email`  |
| `ActionMailbox::Record`  | `action_mailbox_record`  |