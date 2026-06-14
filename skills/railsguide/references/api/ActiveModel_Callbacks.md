# Active Model Callbacks
Provides an interface for any class to have Active Record like callbacks.
Like the Active Record methods, the callback chain is aborted as soon as one of the methods throws `:abort`.
First, extend [`ActiveModel::Callbacks`](https://api.rubyonrails.org/classes/ActiveModel/Callbacks.html) from the class you are creating:

```
class MyModel
  extend ActiveModel::Callbacks

```

Then define a list of methods that you want callbacks attached to:

```
define_model_callbacks :create, :update

This will provide all three standard callbacks (before, around and after) for both the `:create` and `:update` methods. To implement, you need to wrap the methods you want callbacks on in a block so that the callbacks get a chance to fire:

```
 create
  run_callbacks :create
    # Your create action methods here

Then in your class, you can use the `before_create`, `after_create`, and `around_create` methods, just as you would in an Active Record model.

```
before_create :action_before_create

action_before_create

# Your code here

When defining an around callback remember to yield to the block, otherwise it won’t be executed:

```
around_create :log_status

log_status
   'going to call the block...'
  yield
   'block successfully called.'

You can choose to have only specific callbacks by passing a hash to the [`define_model_callbacks`](https://api.rubyonrails.org/classes/ActiveModel/Callbacks.html#method-i-define_model_callbacks) method.

```
define_model_callbacks :create, only: [:after, :before]

Would only create the `after_create` and `before_create` callback methods in your class.
NOTE: Defining the same callback multiple times will overwrite previous callback definitions.
Methods

D

Included Modules

## Instance Public methods

###  **define_model_callbacks**(*callbacks) [Link](https://api.rubyonrails.org/classes/ActiveModel/Callbacks.html#method-i-define_model_callbacks)
[`define_model_callbacks`](https://api.rubyonrails.org/classes/ActiveModel/Callbacks.html#method-i-define_model_callbacks) accepts the same options `define_callbacks` does, in case you want to overwrite a default. Besides that, it also accepts an `:only` option, where you can choose if you want all types (before, around or after) or just some.

```
define_model_callbacks :initialize, only: :after

Note, the `only: <type>` hash will apply to all callbacks defined on that method call. To get around this you can call the [`define_model_callbacks`](https://api.rubyonrails.org/classes/ActiveModel/Callbacks.html#method-i-define_model_callbacks) method as many times as you need.

```
define_model_callbacks :create,  only: :after
define_model_callbacks :update,  only: :before
define_model_callbacks :destroy, only: :around

Would create `after_create`, `before_update`, and `around_destroy` methods only.
You can pass in a class to before_<type>, after_<type> and around_<type>, in which case the callback will call that class’s <action>_<type> method passing the object that the callback is being called on.

```
class MyModel
  extend ActiveModel::Callbacks
  define_model_callbacks :create

before_create AnotherClass

class AnotherClass
   .before_create(  )
    # obj is the MyModel instance that the callback is being called on

NOTE: `method_name` passed to [`define_model_callbacks`](https://api.rubyonrails.org/classes/ActiveModel/Callbacks.html#method-i-define_model_callbacks) must not end with `!`, `?` or `=`.
Source: [show](javascript:toggleSource\('method-i-define_model_callbacks_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activemodel/lib/active_model/callbacks.rb#L109)

# File activemodel/lib/active_model/callbacks.rb, line 109
def define_model_callbacks(*callbacks)
  options = callbacks.extract_options!
  options = {
    skip_after_callbacks_if_terminated: true,
    scope: [:kind, :name],
    only: [:before, :around, :after]
  }.merge!(options)

types = Array(options.delete(:only))

callbacks.each do |callback|
    define_callbacks(callback, options)

types.each do |type|
      send("_define_#{type}_model_callback", self, callback)
    end
  end
end
```