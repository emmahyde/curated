# Active Record Autosave Association
[`AutosaveAssociation`](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html) is a module that takes care of automatically saving associated records when their parent is saved. In addition to saving, it also destroys any associated records that were marked for destruction. (See [`mark_for_destruction`](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-mark_for_destruction) and [`marked_for_destruction?`](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-marked_for_destruction-3F)).
Saving of the parent, its associations, and the destruction of marked associations, all happen inside a transaction. This should never leave the database in an inconsistent state.
If validations for any of the associations fail, their error messages will be applied to the parent.
Note that it also means that associations marked for destruction won’t be destroyed directly. They will however still be marked for destruction.
Note that `autosave: false` is not same as not declaring `:autosave`. When the `:autosave` option is not present then new association records are saved but the updated association records are not saved.

## Validation
Child records are validated unless `:validate` is `false`.

## Callbacks
Association with autosave option defines several callbacks on your model (around_save, before_save, after_create, after_update). Please note that callbacks are executed in the order they were defined in model. You should avoid modifying the association content before autosave callbacks are executed. Placing your callbacks after associations is usually a good practice.

### One-to-one Example

```
class Post  ActiveRecord::Base
  has_one :author, autosave:

```

Saving changes to the parent and its associated model can now be performed automatically _and_ atomically:

```
post = Post.()
post.title       # => "The current global position of migrating ducks"
post.author. # => "alloy"

post.title = "On the migration of ducks"
post.author. = "Eloy Duran"

post.save
post.reload
post.title       # => "On the migration of ducks"
post.author. # => "Eloy Duran"

Destroying an associated model, as part of the parent’s save action, is as simple as marking it for destruction:

```
post.author.mark_for_destruction
post.author.marked_for_destruction? # => true

Note that the model is _not_ yet removed from the database:

```
 = post.author.
Author.find_by( ). # => false

post.save
post.reload.author # => nil

Now it _is_ removed from the database:

```
Author.find_by( ). # => true

### One-to-many Example
When `:autosave` is not declared new children are saved when their parent is saved:

```
class Post  ActiveRecord::Base
  has_many :comments # :autosave option is not declared

post = Post.(title: 'ruby rocks')
post.comments.build(body: 'hello world')
post.save # => saves both post and comment

post = Post.create(title: 'ruby rocks')
post.comments.build(body: 'hello world')
post.save # => saves both post and comment

post = Post.create(title: 'ruby rocks')
comment = post.comments.create(body: 'hello world')
comment.body = 'hi everyone'
post.save # => saves post, but not comment

When `:autosave` is true all children are saved, no matter whether they are new records or not:

```
class Post  ActiveRecord::Base
  has_many :comments, autosave:

post = Post.create(title: 'ruby rocks')
comment = post.comments.create(body: 'hello world')
comment.body = 'hi everyone'
post.comments.build(body: "good morning.")
post.save # => saves post and both comments.

Destroying one of the associated models as part of the parent’s save action is as simple as marking it for destruction:

```
post.comments # => [#<Comment id: 1, ...>, #<Comment id: 2, ...]>
post.comments[].mark_for_destruction
post.comments[].marked_for_destruction? # => true
post.comments.length # => 2

```
 = post.comments..
Comment.find_by( ). # => false

post.save
post.reload.comments.length # => 1

```
Comment.find_by( ). # => true

### Caveats
Note that autosave will only trigger for already-persisted association records if the records themselves have been changed. This is to protect against `SystemStackError` caused by circular association validations. The one exception is if a custom validation context is used, in which case the validations will always fire on the associated records.
Methods

A

* autosaving_belongs_to_for?

C

D

* destroyed_by_association,
  * destroyed_by_association=

M

* marked_for_destruction?

R

V

* validating_belongs_to_for?

## Instance Public methods

###  **autosaving_belongs_to_for?**(association) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-autosaving_belongs_to_for-3F)
Source: [show](javascript:toggleSource\('method-i-autosaving_belongs_to_for-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/autosave_association.rb#L284)

# File activerecord/lib/active_record/autosave_association.rb, line 284
def autosaving_belongs_to_for?(association)
  @autosaving_belongs_to_for ||= {}
  @autosaving_belongs_to_for[association]
end
```

###  **changed_for_autosave?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-changed_for_autosave-3F)
Returns whether or not this record has been changed in any way (including whether any of its nested autosave associations are likewise changed)
Source: [show](javascript:toggleSource\('method-i-changed_for_autosave-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/autosave_association.rb#L275)

# File activerecord/lib/active_record/autosave_association.rb, line 275
def changed_for_autosave?
  new_record? || has_changes_to_save? || marked_for_destruction? || nested_records_changed_for_autosave?
end
```

###  **destroyed_by_association**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-destroyed_by_association)
Returns the association for the parent being destroyed.
Used to avoid updating the counter cache unnecessarily.
Source: [show](javascript:toggleSource\('method-i-destroyed_by_association_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/autosave_association.rb#L269)

# File activerecord/lib/active_record/autosave_association.rb, line 269
def destroyed_by_association
  @destroyed_by_association
end
```

###  **destroyed_by_association=**(reflection) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-destroyed_by_association-3D)
Records the association that is being destroyed and destroying this record in the process.
Source: [show](javascript:toggleSource\('method-i-destroyed_by_association-3D_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/autosave_association.rb#L262)

# File activerecord/lib/active_record/autosave_association.rb, line 262
def destroyed_by_association=(reflection)
  @destroyed_by_association = reflection
end
```

###  **mark_for_destruction**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-mark_for_destruction)
Marks this record to be destroyed as part of the parent’s save transaction. This does _not_ actually destroy the record instantly, rather child record will be destroyed when `parent.save` is called.
Only useful if the `:autosave` option on the parent is enabled for this associated model.
Source: [show](javascript:toggleSource\('method-i-mark_for_destruction_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/autosave_association.rb#L249)

# File activerecord/lib/active_record/autosave_association.rb, line 249
def mark_for_destruction
  @marked_for_destruction = true
end
```

###  **marked_for_destruction?**() [Link](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-marked_for_destruction-3F)
Returns whether or not this record will be destroyed as part of the parent’s save transaction.
Only useful if the `:autosave` option on the parent is enabled for this associated model.
Source: [show](javascript:toggleSource\('method-i-marked_for_destruction-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/autosave_association.rb#L256)

# File activerecord/lib/active_record/autosave_association.rb, line 256
def marked_for_destruction?
  @marked_for_destruction
end
```

###  **reload**(options = nil) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-reload)
Reloads the attributes of the object as usual and clears `marked_for_destruction` flag.
Source: [show](javascript:toggleSource\('method-i-reload_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/autosave_association.rb#L238)

# File activerecord/lib/active_record/autosave_association.rb, line 238
def reload(options = nil)
  @marked_for_destruction = false
  @destroyed_by_association = nil
  super
end
```

###  **validating_belongs_to_for?**(association) [Link](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html#method-i-validating_belongs_to_for-3F)
Source: [show](javascript:toggleSource\('method-i-validating_belongs_to_for-3F_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/autosave_association.rb#L279)

# File activerecord/lib/active_record/autosave_association.rb, line 279
def validating_belongs_to_for?(association)
  @validating_belongs_to_for ||= {}
  @validating_belongs_to_for[association]
end
```