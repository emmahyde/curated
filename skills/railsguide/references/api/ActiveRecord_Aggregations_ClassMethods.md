# Active Record Aggregations
Active Record implements aggregation through a macro-like class method called [`composed_of`](https://api.rubyonrails.org/classes/ActiveRecord/Aggregations/ClassMethods.html#method-i-composed_of) for representing attributes as value objects. It expresses relationships like “Account [is] composed of Money [among other things]” or “Person [is] composed of [an] address”. Each call to the macro adds a description of how the value objects are created from the attributes of the entity object (when the entity is initialized either as a new object or from finding an existing object) and how it can be turned back into attributes (when the entity is saved to the database).

```
class Customer  ActiveRecord::Base
  composed_of :balance, class_name: "Money", mapping: { balance: :amount }
  composed_of :address, mapping: { address_street: :street, address_city: :city }

```

The customer class now has the following methods to manipulate the value objects:
  * `Customer#balance, Customer#balance=(money)`
  * `Customer#address, Customer#address=(address)`

These methods will operate with value objects like the ones described below:

```
class Money
  include Comparable
  attr_reader :amount, :currency
  EXCHANGE_RATES = { "USD_TO_DKK" =>  }

initialize(amount, currency = "USD")
    @amount, @currency = amount, currency

exchange_to(other_currency)
    exchanged_amount = (amount * EXCHANGE_RATES["#{currency}_TO_#{other_currency}"]).floor
    Money.(exchanged_amount, other_currency)

(other_money)
    amount == other_money.amount  currency == other_money.currency

(other_money)
     currency == other_money.currency
      amount <=> other_money.amount

amount <=> other_money.exchange_to(currency).amount

class Address
  attr_reader :street, :city
   initialize(street, city)
    @street, @city = street, city

close_to?(other_address)
    city == other_address.city

(other_address)
    city == other_address.city  street == other_address.street

Now it’s possible to access attributes from the database through the value objects instead. If you choose to name the composition the same as the attribute’s name, it will be the only way to access that attribute. That’s the case with our `balance` attribute. You interact with the value objects just like you would with any other attribute:

```
customer.balance = Money.()     # sets the Money value object and the attribute
customer.balance                     # => Money value object
customer.balance.exchange_to("DKK")  # => Money.new(120, "DKK")
customer.balance  Money.()     # => true
customer.balance == Money.()    # => true
customer.balance  Money.()      # => false

Value objects can also be composed of multiple attributes, such as the case of Address. The order of the mappings will determine the order of the parameters.

```
customer.address_street = "Hyancintvej"
customer.address_city   = "Copenhagen"
customer.address        # => Address.new("Hyancintvej", "Copenhagen")

customer.address = Address.("May Street", "Chicago")
customer.address_street # => "May Street"
customer.address_city   # => "Chicago"

## Writing value objects
Value objects are immutable and interchangeable objects that represent a given value, such as a Money object representing $5. Two Money objects both representing $5 should be equal (through methods such as `==` and `<=>` from Comparable if ranking makes sense). This is unlike entity objects where equality is determined by identity. An entity class such as Customer can easily have two different objects that both have an address on Hyancintvej. Entity identity is determined by object or relational unique identifiers (such as primary keys). Normal [`ActiveRecord::Base`](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) classes are entity objects.
It’s also important to treat the value objects as immutable. Don’t allow the Money object to have its amount changed after creation. Create a new Money object with the new value instead. The `Money#exchange_to` method is an example of this. It returns a new value object instead of changing its own values. Active Record won’t persist value objects that have been changed through means other than the writer method.
The immutable requirement is enforced by Active Record by freezing any object assigned as a value object. Attempting to change it afterwards will result in a `RuntimeError`.
Read more about value objects on [c2.com/cgi/wiki?ValueObject](http://c2.com/cgi/wiki?ValueObject) and on the dangers of not keeping value objects immutable on [c2.com/cgi/wiki?ValueObjectsShouldBeImmutable](http://c2.com/cgi/wiki?ValueObjectsShouldBeImmutable)

## Custom constructors and converters
By default value objects are initialized by calling the `new` constructor of the value class passing each of the mapped attributes, in the order specified by the `:mapping` option, as arguments. If the value class doesn’t support this convention then [`composed_of`](https://api.rubyonrails.org/classes/ActiveRecord/Aggregations/ClassMethods.html#method-i-composed_of) allows a custom constructor to be specified.
When a new value is assigned to the value object, the default assumption is that the new value is an instance of the value class. Specifying a custom converter allows the new value to be automatically converted to an instance of value class if necessary.
For example, the `NetworkResource` model has `network_address` and `cidr_range` attributes that should be aggregated using the `NetAddr::CIDR` value class ([www.rubydoc.info/gems/netaddr/1.5.0/NetAddr/CIDR](https://www.rubydoc.info/gems/netaddr/1.5.0/NetAddr/CIDR)). The constructor for the value class is called `create` and it expects a CIDR address string as a parameter. New values can be assigned to the value object using either another `NetAddr::CIDR` object, a string or an array. The `:constructor` and `:converter` options can be used to meet these requirements:

```
class NetworkResource  ActiveRecord::Base
  composed_of :cidr,
              class_name: 'NetAddr::CIDR',
              mapping: { network_address: :network, cidr_range: :bits },
              allow_nil: ,
              constructor: Proc. { |network_address, cidr_range| NetAddr::CIDR.create("#{network_address}/#{cidr_range}") },
              converter: Proc. { |value| NetAddr::CIDR.create(value.is_a?(Array) ? value.()  value) }

# This calls the :constructor
network_resource = NetworkResource.(network_address: '192.168.0.1', cidr_range: )

# These assignments will both use the :converter
network_resource.cidr = [ '192.168.2.1',  ]
network_resource.cidr = '192.168.0.1/24'

# This assignment won't use the :converter as the value is already an instance of the value class
network_resource.cidr = NetAddr::CIDR.create('192.168.2.1/8')

# Saving and then reloading will use the :constructor on reload
network_resource.save
network_resource.reload

## Finding records by a value object
Once a [`composed_of`](https://api.rubyonrails.org/classes/ActiveRecord/Aggregations/ClassMethods.html#method-i-composed_of) relationship is specified for a model, records can be loaded from the database by specifying an instance of the value object in the conditions hash. The following example finds all customers with `address_street` equal to “May Street” and `address_city` equal to “Chicago”:

```
Customer.where(address: Address.("May Street", "Chicago"))

Methods

C

Included Modules
  * [ ActiveRecord::Aggregations ](https://api.rubyonrails.org/classes/ActiveRecord/Aggregations.html)

## Instance Public methods

###  **composed_of**(part_id, options = {}) [Link](https://api.rubyonrails.org/classes/ActiveRecord/Aggregations/ClassMethods.html#method-i-composed_of)
Adds reader and writer methods for manipulating a value object: `composed_of :address` adds `address` and `address=(new_address)` methods.
Options are:
  * `:class_name` - Specifies the class name of the association. Use it only if that name can’t be inferred from the part id. So `composed_of :address` will by default be linked to the Address class, but if the real class name is `CompanyAddress`, you’ll have to specify it with this option.
  * `:mapping` - Specifies the mapping of entity attributes to attributes of the value object. Each mapping is represented as a key-value pair where the key is the name of the entity attribute and the value is the name of the attribute in the value object. The order in which mappings are defined determines the order in which attributes are sent to the value class constructor. The mapping can be written as a hash or as an array of pairs.
  * `:allow_nil` - Specifies that the value object will not be instantiated when all mapped attributes are `nil`. Setting the value object to `nil` has the effect of writing `nil` to all mapped attributes. This defaults to `false`.
  * `:constructor` - A symbol specifying the name of the constructor method or a Proc that is called to initialize the value object. The constructor is passed all of the mapped attributes, in the order that they are defined in the `:mapping option`, as arguments and uses them to instantiate a `:class_name` object. The default is `:new`.
  * `:converter` - A symbol specifying the name of a class method of `:class_name` or a Proc that is called when a new value is assigned to the value object. The converter is passed the single value that is used in the assignment and is only called if the new value is not an instance of `:class_name`. If `:allow_nil` is set to true, the converter can return `nil` to skip the assignment.

Option examples:

```
composed_of :temperature, mapping: { reading: :celsius }
composed_of :balance, class_name: "Money", mapping: { balance: :amount }
composed_of :address, mapping: { address_street: :street, address_city: :city }
composed_of :address, mapping: [ %w(address_street street), %w(address_city city) ]
composed_of :gps_location
composed_of :gps_location, allow_nil:
composed_of :ip_address,
            class_name: 'IPAddr',
            mapping: {  :to_i },
            constructor: Proc. { || IPAddr.(, Socket::AF_INET) },
            converter: Proc. { || .is_a?(Integer) ? IPAddr.(, Socket::AF_INET)  IPAddr.(.) }

Source: [show](javascript:toggleSource\('method-i-composed_of_source'\)) | [on GitHub](https://github.com/rails/rails/blob/fa8f0812160665bff083a089d2bb2fc1817ea03e/activerecord/lib/active_record/aggregations.rb#L225)

# File activerecord/lib/active_record/aggregations.rb, line 225
def composed_of(part_id, options = {})
  options.assert_valid_keys(:class_name, :mapping, :allow_nil, :constructor, :converter)

unless self  Aggregations
    include Aggregations
  end

name        = part_id.id2name
  class_name  = options[:class_name]  || name.camelize
  mapping     = options[:mapping]     || [ name, name ]
  mapping     = [ mapping ] unless mapping.first.is_a?(Array)
  allow_nil   = options[:allow_nil]   || false
  constructor = options[:constructor] || :new
  converter   = options[:converter]

reader_method(name, class_name, mapping, allow_nil, constructor)
  writer_method(name, class_name, mapping, allow_nil, converter)

reflection = ActiveRecord::Reflection.create(:composed_of, part_id, nil, options, self)
  Reflection.add_aggregate_reflection self, part_id, reflection
end
```