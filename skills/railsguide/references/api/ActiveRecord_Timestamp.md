# Active Record Timestamp
Active Record automatically timestamps create and update operations if the table has fields named `created_at/created_on` or `updated_at/updated_on`.
Timestamping can be turned off by setting:

```
config.active_record.record_timestamps = false

```

Timestamps are in UTC by default but you can use the local timezone by setting:

```
config.active_record.default_timezone = :local

##  [`Time`](https://api.rubyonrails.org/classes/Time.html) Zone aware attributes
Active Record keeps all the `datetime` and `time` columns timezone aware. By default, these values are stored in the database as UTC and converted back to the current [`Time.zone`](https://api.rubyonrails.org/classes/Time.html#method-c-zone) when pulled from the database.
This feature can be turned off completely by setting:

```
config.active_record.time_zone_aware_attributes = false

You can also specify that only `datetime` columns should be time-zone aware (while `time` should not) by setting:

```
ActiveRecord::Base.time_zone_aware_types = [:datetime]

You can also add database-specific timezone aware types. For example, for PostgreSQL:

```
ActiveRecord::Base.time_zone_aware_types += [:tsrange, :tstzrange]

Finally, you can indicate specific attributes of a model for which time zone conversion should not applied, for instance by setting:

```
class Topic  ActiveRecord::Base
  .skip_time_zone_conversion_for_attributes = [:written_on]