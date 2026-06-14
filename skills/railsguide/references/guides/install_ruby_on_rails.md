## 1. Choose Your Operating System
Follow the section for the operating system you use:

Any commands prefaced with a dollar sign `$` should be run in the terminal.

### 1.1. Install Ruby on macOS
You'll need macOS Catalina 10.15 or newer to follow these instructions.
For macOS, you'll need Xcode Command Line Tools and Homebrew to install dependencies needed to compile Ruby.
Open Terminal and run the following commands:

```

# Install Xcode Command Line Tools
$xcode-select --install

# Install Homebrew and dependencies
$/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
$echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
$source ~/.zshrc
$brew install openssl@3 libyaml gmp rust

# Install Mise version manager
$curl https://mise.run | sh
$echo 'eval "$(~/.local/bin/mise activate)"' >> ~/.zshrc
$source ~/.zshrc

# Install Ruby globally with Mise
$mise use -g ruby@3

```
Copy

### 1.2. Install Ruby on Ubuntu
You'll need Ubuntu Jammy 22.04 or newer to follow these instructions.
Open Terminal and run the following commands:

# Install dependencies with apt
$sudo apt update
$sudo apt install build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev git

# Install Mise version manager
$curl https://mise.run | sh
$echo 'eval "$(~/.local/bin/mise activate)"' >> ~/.bashrc
$source ~/.bashrc

### 1.3. Install Ruby on Windows
The Windows Subsystem for Linux (WSL) will provide the best experience for Ruby on Rails development on Windows. It runs Ubuntu inside of Windows which allows you to work in an environment that is close to what your servers will run in production.
You will need Windows 11 or Windows 10 version 2004 and higher (Build 19041 and higher).
Open PowerShell or Windows Command Prompt and run:

```
$wsl --install --distribution Ubuntu-24.04

```
Copy
You may need to reboot during the installation process.
Once installed, you can open Ubuntu from the Start menu. Enter a username and password for your Ubuntu user when prompted.
Then run the following commands:

# Install dependencies with apt
$sudo apt update
$sudo apt install build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev

# Install Mise version manager
$curl https://mise.run | sh
$echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
$source ~/.bashrc

## 2. Verifying Your Ruby Install
Once Ruby is installed, you can verify it works by running:

```
$ruby --version
ruby 3.3.6

## 3. Installing Rails
A "gem" in Ruby is a self-contained package of a library or Ruby program. We can use Ruby's `gem` command to install the latest version of Rails and its dependencies from [RubyGems.org](https://rubygems.org).
Run the following command to install the latest Rails and make it available in your terminal:

```
$gem install rails

```
Copy
To verify that Rails is installed correctly, run the following and you should see a version number printed out:

```
$rails --version
Rails 8.0.0

```
Copy
If the `rails` command is not found, try restarting your terminal.
You're ready to [Get Started with Rails](https://guides.rubyonrails.org/getting_started.html)!