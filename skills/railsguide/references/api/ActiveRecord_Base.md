# Active Record
Active Record objects don’t specify their attributes directly, but rather infer them from the table definition with which they’re linked. Adding, removing, and changing attributes and their type is done directly in the database. Any change is instantly reflected in the Active Record objects. The mapping that binds a given Active Record class to a certain database table will happen automatically in most common cases, but can be overwritten for the uncommon ones.
See the mapping rules in table_name and the full example in [files/activerecord/README_rdoc.html](https://api.rubyonrails.org/files/activerecord/README_rdoc.html) for more insight.

## Creation
Active Records accept constructor parameters either in a hash or as a block. The hash method is especially useful when you’re receiving the data from somewhere else, like an HTTP request. It works like this:

```
user = User.(name: "David", occupation: "Code Artist")
user. # => "David"

```

You can also use block initialization:

```
user = User.  ||
  . = "David"
  .occupation = "Code Artist"

And of course you can just create a bare object and specify the attributes after the fact:

```
user = User.
user. = "David"
user.occupation = "Code Artist"

## Conditions
Conditions can either be specified as a string, array, or hash representing the WHERE-part of an SQL statement. The array form is to be used when the condition input is tainted and requires sanitization. The string form can be used for statements that don’t involve tainted data. The hash form works much like the array form, except only equality and range is possible. Examples:

```
class User  ActiveRecord::Base
   .authenticate_unsafely(user_name, password)
    where("user_name = '#{user_name}' AND password = '#{password}'").first

.authenticate_safely(user_name, password)
    where("user_name = ? AND password = ?", user_name, password).first

.authenticate_safely_simply(user_name, password)
    where(user_name: user_name, password: password).first

The `authenticate_unsafely` method inserts the parameters directly into the query and is thus susceptible to SQL-injection attacks if the `user_name` and `password` parameters come directly from an HTTP request. The `authenticate_safely` and `authenticate_safely_simply` both will sanitize the `user_name` and `password` before inserting them in the query, which will ensure that an attacker can’t escape the query and fake the login (or worse).
When using multiple parameters in the conditions, it can easily become hard to read exactly what the fourth or fifth question mark is supposed to represent. In those cases, you can resort to named bind variables instead. That’s done by replacing the question marks with symbols and supplying a hash with values for the matching symbol keys:

```
Company.where(
  "id = :id AND name = :name AND division = :division AND created_at > :accounting_date",
  {  , name: "37signals", division: "First", accounting_date: '2005-01-01' }
).first

Similarly, a simple hash without a statement will generate conditions based on equality with the SQL AND operator. For instance:

```
Student.where(first_name: "Harvey", status: )
Student.where(params[:student])

A range may be used in the hash to use the SQL BETWEEN operator:

```
Student.where(grade: ..)

An array may be used in the hash to use the SQL IN operator:

```
Student.where(grade: [,,])

When joining tables, nested hashes or keys written in the form ‘table_name.column_name’ can be used to qualify the table name of a particular condition. For instance:

```
Student.joins(:schools).where(schools: { category: 'public' })
Student.joins(:schools).where('schools.category' => 'public' )

## Overwriting default accessors
All column values are automatically available through basic accessors on the Active Record object, but sometimes you want to specialize this behavior. This can be done by overwriting the default accessors (using the same name as the attribute) and calling `super` to actually change things.

```
class Song  ActiveRecord::Base

# Uses an integer of seconds to hold the length of the song

length=(minutes)
    super(minutes. * )

length
    super /

## Attribute query methods
In addition to the basic accessors, query methods are also automatically available on the Active Record object. Query methods allow you to test whether an attribute value is present. Additionally, when dealing with numeric values, a query method will return false if the value is zero.
For example, an Active Record User with the `name` attribute has a `name?` method that you can call to determine whether the user has a name:

```
user = User.(name: "David")
user.name? # => true

anonymous = User.(name: )
anonymous.name? # => false

Query methods will also respect any overrides of default accessors:

```
class

# Has admin boolean column
   admin
    false

user.update(admin: )

user.read_attribute(:admin)  # => true, gets the column value
user[:admin] # => true, also gets the column value

user.admin   # => false, due to the getter override
user.admin?  # => false, due to the getter override

## Accessing attributes before they have been typecasted
Sometimes you want to be able to read the raw attribute data without having the column-determined typecast run its course first. That can be done by using the `<attribute>_before_type_cast` accessors that all attributes have. For example, if your Account model has a `balance` attribute, you can call `account.balance_before_type_cast` or `account.id_before_type_cast`.
This is especially useful in validation situations where the user might supply a string for an integer field and you want to display the original string back in an error message. Accessing the attribute normally would typecast the string to 0, which isn’t what you want.

## Dynamic attribute-based finders
Dynamic attribute-based finders are a mildly deprecated way of getting (and/or creating) objects by simple queries without turning to SQL. They work by appending the name of an attribute to `find_by_` like `Person.find_by_user_name`. Instead of writing `Person.find_by(user_name: user_name)`, you can use `Person.find_by_user_name(user_name)`.
It’s possible to add an exclamation point (!) on the end of the dynamic finders to get them to raise an [`ActiveRecord::RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) error if they do not return any records, like `Person.find_by_last_name!`.
It’s also possible to use multiple attributes in the same `find_by_` by separating them with “ _and_ ”.

```
Person.find_by(user_name: user_name, password: password)
Person.find_by_user_name_and_password(user_name, password) # with dynamic finder

It’s even possible to call these dynamic finder methods on relations and named scopes.

```
Payment.order("created_on").find_by_amount()

## Saving arrays, hashes, and other non-mappable objects in text columns
Active Record can serialize any object in text columns using YAML. To do so, you must specify this with a call to the class method [serialize](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization/ClassMethods.html#method-i-serialize). This makes it possible to store arrays, hashes, and other non-mappable objects without doing any additional work.

```
class User  ActiveRecord::Base
  serialize :preferences

user = User.create(preferences: { "background" => "black", "display" => large })
User.(user.).preferences # => { "background" => "black", "display" => large }

You can also specify a class option as the second parameter that’ll raise an exception if a serialized object is retrieved as a descendant of a class not in the hierarchy.

```
class User  ActiveRecord::Base
  serialize :preferences, Hash

user = User.create(preferences: %w( one two three ))
User.(user.).preferences    # raises SerializationTypeMismatch

When you specify a class option, the default value for that attribute will be a new instance of that class.

```
class User  ActiveRecord::Base
  serialize :preferences, OpenStruct

user = User.
user.preferences.theme_color = "red"

## Single table inheritance
Active Record allows inheritance by storing the name of the class in a column that is named “type” by default. See [`ActiveRecord::Inheritance`](https://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html) for more details.

## Connection to multiple databases in different models
Connections are usually created through [ActiveRecord::Base.establish_connection](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-establish_connection) and retrieved by ActiveRecord::Base.lease_connection. All classes inheriting from [`ActiveRecord::Base`](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) will use this connection. But you can also set a class-specific connection. For example, if Course is an [`ActiveRecord::Base`](https://api.rubyonrails.org/classes/ActiveRecord/Base.html), but resides in a different database, you can just say `Course.establish_connection` and Course and all of its subclasses will use this connection instead.
This feature is implemented by keeping a connection pool in [`ActiveRecord::Base`](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) that is a hash indexed by the class. If a connection is requested, the [ActiveRecord::Base.retrieve_connection](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-retrieve_connection) method will go up the class-hierarchy until a connection is found in the connection pool.

## Exceptions
  * [`ActiveRecordError`](https://api.rubyonrails.org/classes/ActiveRecord/ActiveRecordError.html) - Generic error class and superclass of all other errors raised by Active Record.
  * [`AdapterNotSpecified`](https://api.rubyonrails.org/classes/ActiveRecord/AdapterNotSpecified.html) - The configuration hash used in [ActiveRecord::Base.establish_connection](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-establish_connection) didn’t include an `:adapter` key.
  * [`AdapterNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/AdapterNotFound.html) - The `:adapter` key used in [ActiveRecord::Base.establish_connection](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-establish_connection) specified a non-existent adapter (or a bad spelling of an existing one).
  * [`AssociationTypeMismatch`](https://api.rubyonrails.org/classes/ActiveRecord/AssociationTypeMismatch.html) - The object assigned to the association wasn’t of the type specified in the association definition.
  * [`AttributeAssignmentError`](https://api.rubyonrails.org/classes/ActiveRecord/AttributeAssignmentError.html) - An error occurred while doing a mass assignment through the [ActiveRecord::Base#attributes=](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-attributes-3D) method. You can inspect the `attribute` property of the exception object to determine which attribute triggered the error.
  * [`ConnectionNotEstablished`](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionNotEstablished.html) - No connection has been established. Use [ActiveRecord::Base.establish_connection](https://api.rubyonrails.org/classes/ActiveRecord/ConnectionHandling.html#method-i-establish_connection) before querying.
  * [`MultiparameterAssignmentErrors`](https://api.rubyonrails.org/classes/ActiveRecord/MultiparameterAssignmentErrors.html) - Collection of errors that occurred during a mass assignment using the [ActiveRecord::Base#attributes=](https://api.rubyonrails.org/classes/ActiveModel/AttributeAssignment.html#method-i-attributes-3D) method. The `errors` property of this exception contains an array of [`AttributeAssignmentError`](https://api.rubyonrails.org/classes/ActiveRecord/AttributeAssignmentError.html) objects that should be inspected to determine which attributes triggered the errors.
  * [`RecordInvalid`](https://api.rubyonrails.org/classes/ActiveRecord/RecordInvalid.html) - raised by [ActiveRecord::Base#save!](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save-21) and [ActiveRecord::Base.create!](https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-create-21) when the record is invalid.
  * [`RecordNotFound`](https://api.rubyonrails.org/classes/ActiveRecord/RecordNotFound.html) - No record responded to the [ActiveRecord::Base.find](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-find) method. Either the row with the given ID doesn’t exist or the row didn’t meet the additional restrictions. Some [ActiveRecord::Base.find](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-find) calls do not raise this exception to signal nothing was found, please check its documentation for further details.
  * [`SerializationTypeMismatch`](https://api.rubyonrails.org/classes/ActiveRecord/SerializationTypeMismatch.html) - The serialized object wasn’t of the class specified as the second parameter.
  * [`StatementInvalid`](https://api.rubyonrails.org/classes/ActiveRecord/StatementInvalid.html) - The database server rejected the SQL statement. The precise error is added in the message.

**Note** : The attributes listed are class-level attributes (accessible from both the class and instance level). So it’s possible to assign a logger to the class through `Base.logger=` which will then be used by all instances in the current object space.
Included Modules
  * [ ActiveRecord::Persistence ](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html)
  * [ ActiveRecord::ReadonlyAttributes ](https://api.rubyonrails.org/classes/ActiveRecord/ReadonlyAttributes.html)
  * [ ActiveRecord::ModelSchema ](https://api.rubyonrails.org/classes/ActiveRecord/ModelSchema.html)
  * [ ActiveRecord::Inheritance ](https://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html)
  * [ ActiveRecord::Sanitization ](https://api.rubyonrails.org/classes/ActiveRecord/Sanitization.html)
  * [ ActiveRecord::AttributeAssignment ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeAssignment.html)
  * [ ActiveRecord::Integration ](https://api.rubyonrails.org/classes/ActiveRecord/Integration.html)
  * [ ActiveRecord::Validations ](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html)
  * [ ActiveRecord::CounterCache ](https://api.rubyonrails.org/classes/ActiveRecord/CounterCache.html)
  * [ ActiveRecord::Locking::Optimistic ](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html)
  * [ ActiveRecord::Locking::Pessimistic ](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html)
  * [ ActiveRecord::Encryption::EncryptableRecord ](https://api.rubyonrails.org/classes/ActiveRecord/Encryption/EncryptableRecord.html)
  * [ ActiveRecord::AttributeMethods ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods.html)
  * [ ActiveRecord::Associations ](https://api.rubyonrails.org/classes/ActiveRecord/Associations.html)
  * [ ActiveRecord::SecurePassword ](https://api.rubyonrails.org/classes/ActiveRecord/SecurePassword.html)
  * [ ActiveRecord::AutosaveAssociation ](https://api.rubyonrails.org/classes/ActiveRecord/AutosaveAssociation.html)
  * [ ActiveRecord::NestedAttributes ](https://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes.html)
  * [ ActiveRecord::Transactions ](https://api.rubyonrails.org/classes/ActiveRecord/Transactions.html)
  * [ ActiveRecord::AttributeMethods::Serialization ](https://api.rubyonrails.org/classes/ActiveRecord/AttributeMethods/Serialization.html)
  * [ ActiveRecord::SecureToken ](https://api.rubyonrails.org/classes/ActiveRecord/SecureToken.html)
  * [ ActiveRecord::Marshalling::Methods ](https://api.rubyonrails.org/classes/ActiveRecord/Marshalling/Methods.html)