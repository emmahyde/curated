## 1. What is an Asset Pipeline?
The Rails Asset Pipeline is a library designed for organizing, caching, and serving static assets, such as JavaScript, CSS, and image files. It streamlines and optimizes the management of these assets to enhance the performance and maintainability of the application.
The Rails Asset Pipeline is managed by [**Propshaft**](https://github.com/rails/propshaft). Propshaft is built for an era where transpilation, bundling and compression are less critical for basic applications, thanks to better browser support, faster networks and HTTP/2 capabilities.
Propshaft focuses on essential asset management tasks and leaves more complex tasks, such as JavaScript and CSS bundling and minification, to specialized tools like [`jsbundling-rails`](https://github.com/rails/jsbundling-rails) and [`cssbundling-rails`](https://github.com/rails/cssbundling-rails), which can be added separately to your application. Propshaft focuses on fingerprinting and emphasizes generating digest-based URLs for assets, allowing browsers to cache them, thus minimizing the need for intricate compilation and bundling.
The [Propshaft](https://github.com/rails/propshaft) gem is enabled by default in new applications. If, for some reason, you want to disable it during setup, you can use the `--skip-asset-pipeline` option:

```
$rails new app_name --skip-asset-pipeline

```
Copy
Before Rails 8, the asset pipeline was powered by [Sprockets](https://github.com/rails/sprockets). You can read about the [Sprockets Asset Pipeline](https://guides.rubyonrails.org/v7.2/asset_pipeline.html) in previous versions of the Rails Guides. You can also explore the evolution of asset management techniques to see how the Rails Asset Pipeline has evolved over time.

## 2. Propshaft Features
Propshaft expects that your assets are already in a browser-ready format—like plain CSS, JavaScript, or preprocessed images (like JPEGs or PNGs). Its job is to organize, version, and serve those assets efficiently. In this section, we’ll cover the main features of Propshaft and how they work.

### 2.1. Asset Load Order
With Propshaft, you can control the loading order of dependent files by specifying each file explicitly and organizing them manually or ensuring they are included in the correct sequence within your HTML or layout files. This ensures that dependencies are managed and loaded without relying on automated dependency management tools. Below are some strategies for managing dependencies:
  1. Manually include assets in the correct order:
In your HTML layout (usually `application.html.erb` for Rails apps) you can specify the exact order for loading CSS and JavaScript files by including each file individually in a specific order. For example:

```
<!-- application.html.erb -->
<head>
 <%= stylesheet_link_tag "reset" %>
 <%= stylesheet_link_tag "base" %>
 <%= stylesheet_link_tag "main" %>
</head>
<body>
 <%= javascript_include_tag "utilities" %>
 <%= javascript_include_tag "main" %>
</body>

```
Copy
This is important if, for instance, `main.js` relies on `utilities.js` to be loaded first.
  2. Use Modules in JavaScript (ES6)
If you have dependencies within JavaScript files, ES6 modules can help. By using import statements, you can explicitly control dependencies within JavaScript code. Just make sure your JavaScript files are set up as modules using `<script type="module">` in your HTML:

```
// main.js
import { initUtilities } from "./utilities.js";
import { setupFeature } from "./feature.js";

initUtilities();
setupFeature();

```
Copy
Then in your layout:

```
<script type="module" src="main.js"></script>

```
Copy
This way, you can manage dependencies within JavaScript files without relying on Propshaft to understand them. By importing modules, you can control the order in which files are loaded and ensure dependencies are met.
  3. Combine Files when necessary
If you have several JavaScript or CSS files that must always load together, you can combine them into a single file. For example, you could create a `combined.js` file that imports or copies code from other scripts. Then, just include `combined.js` in your layout to avoid dealing with individual file ordering. This can be useful for files that always load together, like a set of utility functions or a group of styles for a specific component. While this approach can work for small projects or simple use cases, it can become tedious and error-prone for larger applications.
  4. Bundle your JavaScript or CSS using a bundler
If your project requires features like dependency chaining or CSS pre-processing, you may want to consider advanced asset management alongside Propshaft.
Tools like [`jsbundling-rails`](https://github.com/rails/jsbundling-rails) integrates [Bun](https://bun.sh/), [esbuild](https://esbuild.github.io/), [rollup.js](https://rollupjs.org/), or [Webpack](https://webpack.js.org/) into your Rails application, while [`cssbundling-rails`](https://github.com/rails/cssbundling-rails) can be used to process stylesheets that use [Tailwind CSS](https://tailwindcss.com/), [Bootstrap](https://getbootstrap.com/), [Bulma](https://bulma.io/), [PostCSS](https://postcss.org/), or [Dart Sass](https://sass-lang.com/).
These tools complement Propshaft by handling the complex processing, while Propshaft efficiently organizes and serves the final assets.

### 2.2. Asset Organization
Propshaft organizes assets within the `app/assets` directory, which includes subdirectories like `images`, `javascripts`, and `stylesheets`. You can place your JavaScript, CSS, image files, and other assets into these directories, and Propshaft will manage them during the precompilation process.
You can also specify additional asset paths for Propshaft to search by modifying `config.assets.paths` in your `config/initializers/assets.rb` file. For example:

```

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Emoji.images_path

```
Copy
Propshaft will make all assets from the configured paths available for serving. During the precompilation process, Propshaft copies these assets into the `public/assets` directory, ensuring they are ready for production use.
Assets can be referenced through their logical paths using helpers like `asset_path`, `image_tag`, `javascript_include_tag`, and other asset helper tags. After running assets:precompile in production, these logical references are automatically converted into their fingerprinted paths using the `.manifest.json` file.
It is possible to exclude certain directories from this process, you can read more about it in the Fingerprinting section.

### 2.3. Fingerprinting: Versioning with digest-based URLs
In Rails, asset versioning uses fingerprinting to add unique identifiers to asset filenames.
Fingerprinting is a technique that makes the name of a file dependent on its content. A digest of the file's content is generated and appended to the filename. This ensures that when the file content changes, its digest—and consequently its filename—also changes. This mechanism is crucial for caching assets effectively, as the browser will always load the updated version of an asset when its content changes, thereby improving performance. For static or infrequently changed content, this provides an easy way to tell whether two versions of a file are identical, even across different servers or deployment dates.

#### 2.3.1. Asset Digesting
As mentioned in the Asset Organization section, in Propshaft, all assets from the paths configured in `config.assets.paths` are available for serving and will be copied into the `public/assets` directory.
When fingerprinted, an asset filename like `styles.css` is renamed to `styles-a1b2c3d4e5f6.css`. This ensures that if `styles.css` is updated, the filename changes as well, compelling the browser to download the latest version instead of using a potentially outdated cached copy.

#### 2.3.2. Manifest Files
In Propshaft, the `.manifest.json` file is automatically generated during the asset precompilation process. This file maps original asset filenames to their fingerprinted versions, ensuring proper cache invalidation and efficient asset management. Located in the `public/assets` directory, the `.manifest.json` file helps Rails resolve asset paths at runtime, allowing it to reference the correct fingerprinted files.
The `.manifest.json` includes entries for main assets like `application.js` and `application.css` as well as other files, such as images. Here's an example of what the JSON might look like:

```
{
"application.css":"application-6d58c9e6e3b5d4a7c9a8e3.css",
"application.js":"application-2d4b9f6c5a7c8e2b8d9e6.js",
"logo.png":"logo-f3e8c9b2a6e5d4c8.png",
"favicon.ico":"favicon-d6c8e5a9f3b2c7.ico"
}

```
Copy
When a filename is unique and based on its content, HTTP headers can be set to encourage caches everywhere (whether at CDNs, at ISPs, in networking equipment, or in web browsers) to keep their own copy of the content. When the content is updated, the fingerprint will change. This will cause the remote clients to request a new copy of the content. This is generally known as cache busting.

#### 2.3.3. Digested Assets in Views
You can reference digested assets in your views using standard Rails asset helpers like `asset_path`, `image_tag`, `javascript_include_tag`, `stylesheet_link_tag` and others.
For example, in your layout file, you can include a stylesheet like this:

```
<%= stylesheet_link_tag "application", media: "all" %>

```
Copy
If you're using the [`turbo-rails`](https://github.com/hotwired/turbo-rails) gem (which is included by default in Rails), you can include the `data-turbo-track` option. This causes Turbo to check if an asset has been updated and, if so, reload it into the page:

```
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>

```
Copy
You can access images in the `app/assets/images` directory like this:

```
<%= image_tag "rails.png" %>

```
Copy
When the asset pipeline is enabled, Propshaft will serve this file. If a file exists at `public/assets/rails.png`, it will be served by the web server.
Alternatively, if you are using fingerprinted assets (e.g., `rails-f90d8a84c707a8dc923fca1ca1895ae8ed0a09237f6992015fef1e11be77c023.png`), Propshaft will also serve these correctly. The fingerprint is automatically applied during the precompilation process.
Images can be organized into subdirectories, and you can reference them by specifying the directory in the tag:

```
<%= image_tag "icons/rails.png" %>

```
Copy
Finally, you can reference an image in your CSS like:

```
background: url("/bg/pattern.svg");

```
Copy
Propshaft will automatically convert this to:

```
background: url("/assets/bg/pattern-2169cbef.svg");

```
Copy
If you're precompiling your assets (see the Production section), linking to an asset that doesn't exist will raise an exception in the calling page. This includes linking to a blank string. Be careful when using `image_tag` and other helpers with user-supplied data. This ensures that the browser always fetches the correct version of the asset.

#### 2.3.4. Digested Assets in JavaScript
In JavaScript, you need to manually trigger the asset transformation using the `RAILS_ASSET_URL` macro. Here’s an example:

```
export default class extends Controller {
  init() {
    this.img = RAILS_ASSET_URL("/icons/trash.svg");
  }
}

```
Copy
This will transform into:

```
export default class extends Controller {
  init() {
    this.img = "/assets/icons/trash-54g9cbef.svg";
  }
}

```
Copy
This ensures that the correct, digested file is used in your JavaScript code.
If you’re using bundlers like [Webpack](https://webpack.js.org/) or [esbuild](https://esbuild.github.io/), you should let the bundlers handle the digesting process. If Propshaft detects that a file already has a digest in the filename (e.g., `script-2169cbef.js`), it will skip digesting the file again to avoid unnecessary reprocessing.
For managing assets with Import Maps, Propshaft ensures that assets referenced in the import map are appropriately handled and mapped to their digested paths during the precompilation process.

#### 2.3.5. Bypassing the Digest Step
If you need to reference files that refer to each other—like a JavaScript file and its source map—and want to avoid the digesting process, you can pre-digest these files manually. Propshaft recognizes files with the pattern `-[digest].digested.js` as files that have already been digested and will preserve their stable file names.

#### 2.3.6. Excluding Directories from Digestion
You can exclude certain directories from the precompilation and digestion process by adding them to `config.assets.excluded_paths`. This is useful if, for example, you’re using `app/assets/stylesheets` as input to a compiler like [Dart Sass](https://sass-lang.com/), and you don’t want these files to be part of the asset load path.

```
config.assets.excluded_paths = [Rails.root.join("app/assets/stylesheets")]

```
Copy
This will prevent the specified directories from being processed by Propshaft while still allowing them to be part of the precompilation process.

## 3. Working with Propshaft
From Rails 8 onwards, Propshaft is included by default. To use Propshaft, you need to configure it properly and organize your assets in a way that Rails can serve them efficiently.

### 3.1. Setup
Follow these steps for setting up Propshaft in your Rails application:
  1. Create a new Rails application:

```
$rails new app_name

```
Copy
  2. Organize your assets:
Propshaft expects your assets to be in the `app/assets` directory. You can organize your assets into subdirectories like `app/assets/javascripts` for JavaScript files, `app/assets/stylesheets` for CSS files, and `app/assets/images` for images.
For example, you can create a new JavaScript file in `app/assets/javascripts`:

```
// app/assets/javascripts/main.js
console.log("Hello, world!");

```
Copy
and a new CSS file in `app/assets/stylesheets`:

```
/* app/assets/stylesheets/main.css */
body {
  background-color: red;
}

```
Copy
  3. Link assets in your application layout
In your application layout file (usually `app/views/layouts/application.html.erb`), you can include your assets using the `stylesheet_link_tag` and `javascript_include_tag` helpers:

```
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <title>MyApp</title>
    <%= stylesheet_link_tag "main" %>
  </head>
  <body>
    <%= yield %>
    <%= javascript_include_tag "main" %>
  </body>
</html>

```
Copy
This layout includes the `main.css` stylesheet and `main.js` JavaScript file in your application.
  4. Start the Rails server:

```
$bin/rails server

```
Copy
  5. Preview your application:
Open your web browser and navigate to `http://localhost:3000`. You should see your Rails application with the included assets.

### 3.2. Development
Rails and Propshaft are configured differently in development than in production, to allow rapid iteration without manual intervention.

#### 3.2.1. No Caching
In development, Rails is configured to bypass asset caching. This means that when you modify assets (e.g., CSS, JavaScript), Rails will serve the most up-to-date version directly from the file system. There's no need to worry about versioning or file renaming because caching is skipped entirely. Browsers will automatically pull in the latest version each time you reload the page.

#### 3.2.2. Automatic Reloading of Assets
When using Propshaft on its own, it automatically checks for updates to assets like JavaScript, CSS, or images with every request. This means you can edit these files, reload the browser, and instantly see the changes without needing to restart the Rails server.
When using JavaScript bundlers such as [esbuild](https://esbuild.github.io/) or [Webpack](https://webpack.js.org/) alongside Propshaft, the workflow combines both tools effectively:
  * The bundler watches for changes in your JavaScript and CSS files, compiles them into the appropriate build directory, and keeps the files up to date.
  * Propshaft ensures that the latest compiled assets are served to the browser whenever a request is made.

For these setups, running `./bin/dev` starts both the Rails server and the asset bundler's development server.
In either case, Propshaft ensures that changes to your assets are reflected as soon as the browser page is reloaded, without requiring a server restart.

#### 3.2.3. Improving Performance with File Watchers
In development, Propshaft checks if any assets have been updated before each request, using the application's file watcher (by default, `ActiveSupport::FileUpdateChecker`). If you have a large number of assets, you can improve performance by using the `listen` gem and configuring the following setting in `config/environments/development.rb`:

```
config.file_watcher = ActiveSupport::EventedFileUpdateChecker

```
Copy
This will reduce the overhead of checking for file updates and improve performance during development.

### 3.3. Production
In production, Rails serves assets with caching enabled to optimize performance, ensuring that your application can handle high traffic efficiently.

#### 3.3.1. Asset Caching and Versioning in Production
As mentioned in the Fingerprinting section when the file content changes, its digest also changes, thus the browser uses the updated version of the file. Whereas, if the content remains the same, the browser will use the cached version.

#### 3.3.2. Precompiling Assets
In production, precompilation is typically run during deployment to ensure that the latest versions of the assets are served. Propshaft was explicitly not designed to provide full transpiler capabilities. However, it does offer an input -> output compiler setup that by default is used to translate `url(asset)` function calls in CSS to `url(digested-asset)` instead and source mapping comments likewise.
To manually run precompilation you can use the following command:

```
$RAILS_ENV=production rails assets:precompile

```
Copy
After doing this, all assets in the load path will be copied (or compiled when using advanced asset management) in the precompilation step and stamped with a digest hash.
Additionally, you can set `ENV["SECRET_KEY_BASE_DUMMY"]` to trigger the use of a randomly generated `secret_key_base` that’s stored in a temporary file. This is useful when precompiling assets for production as part of a build step that otherwise does not need access to the production secrets.

```
$RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 rails assets:precompile

```
Copy
By default, assets are served from the `/assets` directory.
Running the precompile command in development generates a marker file named `.manifest.json`, which tells the application that it can serve the compiled assets. As a result, any changes you make to your source assets won't be reflected in the browser until the precompiled assets are updated. If your assets stop updating in development mode, the solution is to remove the `.manifest.json` file located in `public/assets/`. You can use the `rails assets:clobber` command to delete all your precompiled assets and the `.manifest.json` file. This will force Rails to recompile the assets on the fly, reflecting the latest changes.
Always ensure that the expected compiled filenames end with `.js` or `.css`.

##### 3.3.2.1. Far-future Expires Header
Precompiled assets exist on the file system and are served directly by your web server. They do not have far-future headers by default, so to get the benefit of fingerprinting you'll have to update your server configuration to add those headers.
For Apache:

# The Expires* directives require the Apache module

# `mod_expires` to be enabled.
Location /assets/

# Use of ETag is discouraged when Last-Modified is present
  Header unset ETag
  FileETag None

# RFC says only cache for 1 year
  ExpiresActive On
  ExpiresDefault "access plus 1 year"
</Location

```
Copy
For NGINX:

```
location ~ ^/assets/ {
  expires 1y;
  add_header Cache-Control public;

add_header ETag "";
}

```
Copy

#### 3.3.3. CDNs
CDN stands for [Content Delivery Network](https://en.wikipedia.org/wiki/Content_delivery_network), they are primarily designed to cache assets all over the world so that when a browser requests the asset, a cached copy will be geographically close to that browser. If you are serving assets directly from your Rails server in production, the best practice is to use a CDN in front of your application.
A common pattern for using a CDN is to set your production application as the "origin" server. This means when a browser requests an asset from the CDN and there is a cache miss, it will instead source the file from your server and then cache it. For example if you are running a Rails application on `example.com` and have a CDN configured at `mycdnsubdomain.fictional-cdn.com`, then when a request is made to `mycdnsubdomain.fictional-cdn.com/assets/smile.png`, the CDN will query your server once at `example.com/assets/smile.png` and cache the request. The next request to the CDN that comes in to the same URL will hit the cached copy. When the CDN can serve an asset directly the request never touches your Rails server. Since the assets from a CDN are geographically closer to the browser, the request is faster, and since your server doesn't need to spend time serving assets, it can focus on serving application code.

##### 3.3.3.1. Set up a CDN to Serve Static Assets
To set up CDN, your application needs to be running in production on the internet at a publicly available URL, for example `example.com`. Next you'll need to sign up for a CDN service from a cloud hosting provider. When you do this you need to configure the "origin" of the CDN to point back at your website `example.com`. Check your provider for documentation on configuring the origin server.
The CDN you provisioned should give you a custom subdomain for your application such as `mycdnsubdomain.fictional-cdn.com` (note fictional-cdn.com is not a valid CDN provider at the time of this writing). Now that you have configured your CDN server, you need to tell browsers to use your CDN to grab assets instead of your Rails server directly. You can do this by configuring Rails to set your CDN as the asset host instead of using a relative path. To set your asset host in Rails, you need to set [`config.asset_host`](https://guides.rubyonrails.org/configuring.html#config-asset-host) in `config/environments/production.rb`:

```
config.asset_host = "mycdnsubdomain.fictional-cdn.com"

```
Copy
You only need to provide the "host", this is the subdomain and root domain, you do not need to specify a protocol or "scheme" such as `http://` or `https://`. When a web page is requested, the protocol in the link to your asset that is generated will match how the webpage is accessed by default.
You can also set this value through an [environment variable](https://en.wikipedia.org/wiki/Environment_variable) to make running a staging copy of your site easier:

```
config.asset_host = ENV["CDN_HOST"]

```
Copy
You would need to set `CDN_HOST` on your server to `mycdnsubdomain .fictional-cdn.com` for this to work.
Once you have configured your server and your CDN, asset paths from helpers such as:

```
<%= asset_path('smile.png') %>

```
Copy
Will be rendered as full CDN URLs like `http://mycdnsubdomain.fictional-cdn.com/assets/smile.png` (digest omitted for readability).
If the CDN has a copy of `smile.png`, it will serve it to the browser, and the origin server won't even know it was requested. If the CDN does not have a copy, it will try to find it at the "origin" `example.com/assets/smile.png`, and then store it for future use.
If you want to serve only some assets from your CDN, you can use custom `:host` option for your asset helper, which overwrites the value set in [`config.action_controller.asset_host`](https://guides.rubyonrails.org/configuring.html#config-action-controller-asset-host).

```
<%= asset_path 'image.png', host: 'mycdnsubdomain.fictional-cdn.com' %>

##### 3.3.3.2. Customize CDN Caching Behavior
A CDN works by caching content. If the CDN has stale or bad content, then it is hurting rather than helping your application. The purpose of this section is to describe general caching behavior of most CDNs. Your specific provider may behave slightly differently.
**CDN Request Caching**
While a CDN is described as being good for caching assets, it actually caches the entire request. This includes the body of the asset as well as any headers. The most important one being `Cache-Control`, which tells the CDN (and web browsers) how to cache contents. This means that if someone requests an asset that does not exist, such as `/assets/i-dont-exist.png`, and your Rails application returns a 404, then your CDN will likely cache the 404 page if a valid `Cache-Control` header is present.
**CDN Header Debugging**
One way to check the headers are cached properly in your CDN is by using [curl](https://explainshell.com/explain?cmd=curl+-I+http%3A%2F%2Fwww.example.com). You can request the headers from both your server and your CDN to verify they are the same:

```
$curl -I http://www.example/assets/application-
d0e099e021c95eb0de3615fd1d8c4d83.css
HTTP/1.1 200 OK
Server: Cowboy
Date: Sun, 24 Aug 2014 20:27:50 GMT
Connection: keep-alive
Last-Modified: Thu, 08 May 2014 01:24:14 GMT
Content-Type: text/css
Cache-Control: public, max-age=2592000
Content-Length: 126560
Via: 1.1 vegur

```
Copy
Versus the CDN copy:

```
$curl -I http://mycdnsubdomain.fictional-cdn.com/application-
d0e099e021c95eb0de3615fd1d8c4d83.css
HTTP/1.1 200 OK Server: Cowboy Last-
Modified: Thu, 08 May 2014 01:24:14 GMT Content-Type: text/css
Cache-Control:
public, max-age=2592000
Via: 1.1 vegur
Content-Length: 126560
Accept-Ranges:
bytes
Date: Sun, 24 Aug 2014 20:28:45 GMT
Via: 1.1 varnish
Age: 885814
Connection: keep-alive
X-Served-By: cache-dfw1828-DFW
X-Cache: HIT
X-Cache-Hits:
68
X-Timer: S1408912125.211638212,VS0,VE0

```
Copy
Check your CDN documentation for any additional information they may provide such as `X-Cache` or for any additional headers they may add.
**CDNs and the Cache-Control Header**
The [`Cache-Control`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control) header describes how a request can be cached. When no CDN is used, a browser will use this information to cache contents. This is very helpful for assets that are not modified so that a browser does not need to re-download a website's CSS or JavaScript on every request. Generally we want our Rails server to tell our CDN (and browser) that the asset is "public". That means any cache can store the request. Also we commonly want to set `max-age` which is how long the cache will store the object before invalidating the cache. The `max-age` value is set to seconds with a maximum possible value of `31536000`, which is one year. You can do this in your Rails application by setting

```
config.public_file_server.headers = {
  "Cache-Control" => "public, max-age=31536000"
}

```
Copy
Now when your application serves an asset in production, the CDN will store the asset for up to a year. Since most CDNs also cache headers of the request, this `Cache-Control` will be passed along to all future browsers seeking this asset. The browser then knows that it can store this asset for a very long time before needing to re-request it.
**CDNs and URL-based Cache Invalidation**
Most CDNs will cache contents of an asset based on the complete URL. This means that a request to

```
http://mycdnsubdomain.fictional-cdn.com/assets/smile-123.png

```
Copy
Will be a completely different cache from

```
http://mycdnsubdomain.fictional-cdn.com/assets/smile.png

```
Copy
If you want to set far future `max-age` in your `Cache-Control` (and you do), then make sure when you change your assets that your cache is invalidated. For example when changing the smiley face in an image from yellow to blue, you want all visitors of your site to get the new blue face. When using a CDN with the Rails asset pipeline `config.assets.digest` is set to true by default so that each asset will have a different file name when it is changed. This way you don't have to ever manually invalidate any items in your cache. By using a different unique asset name instead, your users get the latest asset.

## 4. Sprockets to Propshaft

### 4.1. Evolution of Asset Management Techniques
Within the last few years, the evolution of the web has led to significant changes that have influenced how assets are managed in web applications. These include:
  1. **Browser Support** : Modern browsers have improved support for new features and syntax, reducing the need for transpilation and polyfills.
  2. **HTTP/2** : The introduction of HTTP/2 has made it easier to serve multiple files in parallel, reducing the need for bundling.
  3. **ES6+** : Modern JavaScript syntax (ES6+) is supported by most modern browsers, reducing the need for transpilation.

Therefore, the asset pipeline powered by Propshaft, no longer includes transpilation, bundling, or compression by default. However, fingerprinting still remains an integral part. You can read more about the evolution of asset management techniques and how they directed the change from Sprockets to Propshaft below.

#### 4.1.1. Transpilation ❌
Transpilation involves converting code from one language or format to another.
For example, converting TypeScript to JavaScript.

```
const greet = (name: string): void => {
  console.log(`Hello, ${name}!`);
};

```
Copy
After transpilation, this code becomes:

```
const greet = (name) => {
  console.log(`Hello, ${name}!`);
};

```
Copy
In the past, pre-processors like [Sass](https://sass-lang.com/) and [Less](https://lesscss.org/) were essential for CSS features such as variables and nesting. Today, modern CSS supports these natively, reducing the need for transpilation.

#### 4.1.2. Bundling ❌
Bundling combines multiple files into one to reduce the number of HTTP requests a browser needs to make to render a page.
For example, if your application has three JavaScript files:
  * menu.js
  * cart.js
  * checkout.js

Bundling will merge these into a single application.js file.

```
// app/javascript/application.js
// Contents of menu.js, cart.js, and checkout.js are combined here

```
Copy
This was crucial with HTTP/1.1, which limited 6-8 simultaneous connections per domain. With HTTP/2, browsers fetch multiple files in parallel, making bundling less critical for modern applications.

#### 4.1.3. Compression ❌
Compression encodes files in a more efficient format to reduce their size further when delivered to users. A common technique is [Gzip compression](https://en.wikipedia.org/wiki/Gzip).
For example, a CSS file that's 200KB may compress to just 50KB when Gzipped. Browsers automatically decompress such files upon receipt, saving bandwidth and improving speed.
However, with CDNs automatically compressing assets, the need for manual compression has decreased.

### 4.2. Sprockets vs. Propshaft

#### 4.2.1. Load Order
In Sprockets, you could link files together to ensure they loaded in the correct order. For example, a main JavaScript file that depended on other files would automatically have its dependencies managed by Sprockets, ensuring everything loaded in the right sequence. Propshaft, on the other hand, does not automatically handle these dependencies, and instead lets you manage the asset load order manually.

#### 4.2.2. Versioning
Sprockets simplifies asset fingerprinting by appending a hash to filenames whenever assets are updated, ensuring proper cache invalidation. With Propshaft, you’ll need to handle certain aspects manually. For example, while asset fingerprinting works, you might need to use a bundler or trigger transformations manually for JavaScript files to ensure filenames are updated correctly. Read more about fingerprinting in Propshaft.

#### 4.2.3. Precompilation
Sprockets processed assets that were explicitly included in a bundle. In contrast, Propshaft automatically processes all assets located in the specified paths, including images, stylesheets, JavaScript files, and more, without requiring explicit bundling. Read more about asset digesting.

### 4.3. Migration Steps
Propshaft is intentionally simpler than [Sprockets](https://github.com/rails/sprockets-rails), which may make migrating from Sprockets a fair amount of work. This is especially true if you rely on Sprockets for tasks like transpiling [TypeScript](https://www.typescriptlang.org/) or [Sass](https://sass-lang.com/), or if you're using gems that provide this functionality. In such cases, you'll either need to stop transpiling or switch to a Node.js-based transpiler, such as those provided by [`jsbundling-rails`](https://github.com/rails/jsbundling-rails) or [`cssbundling-rails`](https://github.com/rails/cssbundling-rails). Read more about these in the Advanced Asset Management section.
However, if you're already using a Node-based setup to bundle JavaScript and CSS, Propshaft should integrate smoothly into your workflow. Since you won’t need an additional tool for bundling or transpiling, Propshaft will primarily handle asset digesting and serving.
Some key steps in the migration include:
  1. Remove some gems using the following:

```
bundle remove sprockets
bundle remove sprockets-rails
bundle remove sass-rails

```
Copy
  2. Delete the `config/assets.rb` and `assets/config/manifest.js` files from your project.
  3. If you've already upgraded to Rails 8, then Propshaft is already included in your application. Otherwise, install it using `bundle add propshaft`.
  4. Remove the `config.assets.paths << Rails.root.join('app', 'assets')` line from your `application.rb` file.
  5. Migrate asset helpers by replacing all instances of asset helpers in your CSS files (e.g., `image_url`) with standard `url()` functions, keeping in mind that Propshaft utilizes relative paths. For example, `image_url("logo.png")` may become `url("/logo.png")`.
  6. If you're relying on Sprockets for transpiling, you'll need to switch to a Node-based transpiler like Webpack, esbuild, or Vite. You can use the `jsbundling-rails` and `cssbundling-rails` gems to integrate these tools into your Rails application.

For more information, you can read the [detailed guide on how to migrate from Sprockets to Propshaft](https://github.com/rails/propshaft/blob/main/UPGRADING.md).

## 5. Advanced Asset Management
Over the years, there have been multiple default approaches for handling assets, and as the web evolved, we began to see more JavaScript-heavy applications. In The Rails Doctrine we believe that [The Menu Is Omakase](https://rubyonrails.org/doctrine#omakase), so Propshaft focuses on delivering a production-ready setup with modern browsers by default.
There is no one-size-fits-all solution for the various JavaScript and CSS frameworks and extensions available. However, there are other bundling libraries in the Rails ecosystem that should empower you in cases where the default setup isn't enough.

### 5.1. `jsbundling-rails`
[`jsbundling-rails`](https://github.com/rails/jsbundling-rails) is a gem that integrates modern JavaScript bundlers into your Rails application. It allows you to manage and bundle JavaScript assets with tools like [Bun](https://bun.sh), [esbuild](https://esbuild.github.io/), [rollup.js](https://rollupjs.org/), or [Webpack](https://webpack.js.org/), offering a runtime-dependent approach for developers seeking flexibility and performance.

#### 5.1.1. How `jsbundling-rails` Works
  1. After installation, it sets up your Rails app to use your chosen JavaScript bundler.
  2. It creates a `build` script in your `package.json` file to compile your JavaScript assets.
  3. During development, the `build:watch` script ensures live updates to your assets as you make changes.
  4. In production, the gem ensures that JavaScript is built and included during the precompilation step, reducing manual intervention. It hooks into Rails' `assets:precompile` task to build JavaScript for all entry points during deployment. This integration ensures that your JavaScript is production-ready with minimal configuration.

The gem automatically handles entry-point discovery - identifying the primary JavaScript files to bundle by following Rails conventions, typically looking in directories like `app/javascript/` and configuration. By adhering to Rails conventions, `jsbundling-rails` simplifies the process of integrating complex JavaScript workflows into Rails projects.

#### 5.1.2. When Should You Use It?
`jsbundling-rails` is ideal for Rails applications that:
  * Require modern JavaScript features like ES6+, TypeScript, or JSX.
  * Need to leverage bundler-specific optimizations like tree-shaking, code splitting, or minification.
  * Use `Propshaft` for asset management and need a reliable way to integrate precompiled JavaScript with the broader Rails asset pipeline.
  * Utilize libraries or frameworks that depend on a build step. For example, projects requiring transpilation—such as those using [Babel](https://babeljs.io/), [TypeScript](https://www.typescriptlang.org/), or React JSX—benefit greatly from `jsbundling-rails`. These tools rely on a build step, which the gem seamlessly supports.

By integrating with Rails tools like `Propshaft` and simplifying JavaScript workflows, `jsbundling-rails` allows you to build rich, dynamic front-ends while staying productive and adhering to Rails conventions.

### 5.2. `cssbundling-rails`
[`cssbundling-rails`](https://github.com/rails/cssbundling-rails) integrates modern CSS frameworks and tools into your Rails application. It allows you to bundle and process your stylesheets. Once processed, the resulting CSS is delivered via the Rails asset pipeline.

#### 5.2.1. How `cssbundling-rails` Works
  1. After installation, it sets up your Rails app to use your chosen CSS framework or processor.
  2. It creates a `build:css` script in your `package.json` file to compile your stylesheets.
  3. During development, a `build:css --watch` task ensures live updates to your CSS as you make changes, providing a smooth and responsive workflow.
  4. In production, the gem ensures your stylesheets are compiled and ready for deployment. During the `assets:precompile` step, it installs all `package.json` dependencies via `bun`, `yarn`, `pnpm` or `npm` and runs the `build:css` task to process your stylesheet entry points. The resulting CSS output is then digested by the asset pipeline and copied into the `public/assets` directory, just like other asset pipeline files.

This integration simplifies the process of preparing production-ready styles while ensuring all your CSS is managed and processed efficiently.

#### 5.2.2. When Should You Use It?
`cssbundling-rails` is ideal for Rails applications that:
  * Use CSS frameworks like [Tailwind CSS](https://tailwindcss.com/), [Bootstrap](https://getbootstrap.com/), or [Bulma](https://bulma.io/) that require processing during development or deployment.
  * Need advanced CSS capabilities such as custom preprocessing with [PostCSS](https://postcss.org/) or [Dart Sass](https://sass-lang.com/) plugins.
  * Require seamless integration of processed CSS into the Rails asset pipeline.
  * Benefit from live updates to stylesheets during development with minimal manual intervention.

**NOTE** : Unlike [`dartsass-rails`](https://github.com/rails/dartsass-rails) or [`tailwindcss-rails`](https://github.com/rails/tailwindcss-rails), which use standalone versions of [Dart Sass](https://sass-lang.com/) and [Tailwind CSS](https://tailwindcss.com/), `cssbundling-rails` introduces a Node.js dependency. This makes it a good choice for applications already relying on Node for JavaScript processing with gems like `jsbundling-rails`. However, if you're using [`importmap-rails`](https://github.com/rails/importmap-rails) for JavaScript and prefer to avoid Node.js, standalone alternatives like [`dartsass-rails`](https://github.com/rails/dartsass-rails) or [`tailwindcss-rails`](https://github.com/rails/tailwindcss-rails) offer a simpler setup.
By integrating modern CSS workflows, automating production builds, and leveraging the Rails asset pipeline, `cssbundling-rails` enables developers to efficiently manage and deliver dynamic styles.

### 5.3. `tailwindcss-rails`
[`tailwindcss-rails`](https://github.com/rails/tailwindcss-rails) is a wrapper gem that integrates [Tailwind CSS](https://tailwindcss.com/) into your Rails application. By bundling Tailwind CSS with a [standalone executable](https://tailwindcss.com/blog/standalone-cli), it eliminates the need for Node.js or additional JavaScript dependencies. This makes it a lightweight and efficient solution for styling Rails applications.

#### 5.3.1. How `tailwindcss-rails` Works
  1. When installed, by providing `--css tailwind` to the `rails new` command, the gem generates a `tailwind.config.js` file for customizing your Tailwind setup and a `stylesheets/application.tailwind.css` file for managing your CSS entry points.
  2. Instead of relying on Node.js, the gem uses a precompiled Tailwind CSS binary. This standalone approach allows you to process and compile CSS without adding a JavaScript runtime to your project.
  3. During development, changes to your Tailwind configuration or CSS files are automatically detected and processed. The gem rebuilds your stylesheets and provides a `watch` process to automatically generate Tailwind output in development.
  4. In production, the gem hooks into the `assets:precompile` task. It processes your Tailwind CSS files and generates optimized, production-ready stylesheets, which are then included in the asset pipeline. The output is fingerprinted and cached for efficient delivery.

#### 5.3.2. When Should You Use It?
`tailwindcss-rails` is ideal for Rails applications that:
  * Want to use [Tailwind CSS](https://tailwindcss.com/) without introducing a Node.js dependency or JavaScript build tools.
  * Require a minimal setup for managing utility-first CSS frameworks.
  * Need to take advantage of Tailwind's powerful features like custom themes, variants, and plugins without complex configuration.

The gem works seamlessly with Rails' asset pipeline tools, like Propshaft, ensuring that your CSS is preprocessed, digested, and efficiently served in production environments.

### 5.4. `importmap-rails`
[`importmap-rails`](https://github.com/rails/importmap-rails) enables a Node.js-free approach to managing JavaScript in Rails applications. It leverages modern browser support for [ES Modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) to load JavaScript directly in the browser without requiring bundling or transpilation. This approach aligns with Rails' commitment to simplicity and convention over configuration.

#### 5.4.1. How `importmap-rails` Works
  * After installation, `importmap-rails` configures your Rails app to use `<script type="module">` tags to load JavaScript modules directly in the browser.
  * JavaScript dependencies are managed using the `bin/importmap` command, which pins modules to URLs, typically hosted on CDNs like [jsDelivr](https://www.jsdelivr.com/) that host pre-bundled, browser-ready versions of libraries. This eliminates the need for `node_modules` or a package manager.
  * During development, there’s no bundling step, so updates to your JavaScript are instantly available, streamlining the workflow.
  * In production, the gem integrates with Propshaft to serve JavaScript files as part of the asset pipeline. Propshaft ensures files are digested, cached, and production-ready. Dependencies are versioned, fingerprinted, and efficiently delivered without manual intervention.

**NOTE** : While Propshaft ensures proper asset handling, it does not handle JavaScript processing or transformations — `importmap-rails` assumes your JavaScript is already in a browser-compatible format. This is why it works best for projects that don't require transpiling or bundling.
By eliminating the need for a build step and Node.js, `importmap-rails` simplifies JavaScript management.

#### 5.4.2. When Should You Use It?
`importmap-rails` is ideal for Rails applications that:
  * Do not require complex JavaScript features like transpiling or bundling.
  * Use modern JavaScript without relying on tools like [Babel](https://babeljs.io/).