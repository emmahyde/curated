# Active Record Suppressor
[`ActiveRecord::Suppressor`](https://api.rubyonrails.org/classes/ActiveRecord/Suppressor.html) prevents the receiver from being saved during a given block.
For example, here’s a pattern of creating notifications when new comments are posted. (The notification may in turn trigger an email, a push notification, or just appear in the UI somewhere):

```
class Comment  ActiveRecord::Base
  belongs_to :commentable, polymorphic:
  after_create -> { Notification.create! comment: ,
    recipients: commentable.recipients }

```

That’s what you want the bulk of the time. New comment creates a new Notification. But there may well be off cases, like copying a commentable and its comments, where you don’t want that. So you’d have a concern something like this:

```
module Copyable
   copy_to(destination)
    Notification.suppress
      # Copy logic that creates new comments that we do not want
      # triggering notifications.

Namespace
  * MODULE [ActiveRecord::Suppressor::ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Suppressor/ClassMethods.html)