Raised when an object assigned to an association has an incorrect type.

```
class Ticket  ActiveRecord::Base
  has_many :patches

class Patch  ActiveRecord::Base
  belongs_to :ticket

# Comments are not patches, this assignment raises AssociationTypeMismatch.
@ticket.patches << Comment.(content: "Please attach tests to your patch.")

```