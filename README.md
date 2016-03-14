# Fetch and process multi

Fetches data from the cache, using the given `ids` and `ids_to_keys_proc`.

If there is data in the cache with the given keys, then that data is returned.

Otherwise, the supplied block is called for ids for which there was no
data, and the result will be written to the cache and returned
as ids -> values hash.

Ids can be any even composite identifiers.

Options are passed to the underlying cache implementation.

Returns hash of id -> value of passed ids.

```ruby
def ids_to_keys(ids)
  ids.each_with_object({}) do |id, memo|
    memo[id] = "key_base/id_#{id}"
  end
end

cache.write("key_for_1", "value_for_1")

cache.fetch_and_process_multi(ids_to_keys([1, 2]) do |uncached_ids|
  uncached_ids.each_with_object({}) do |id, memo|
    memo[id] = "fallback_value_for_#{id}"
  end
end

# => { 1 => "value_for_1", 2 => "fallback_value_for_2" }
```

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'fetch-process-multi'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install fetch-process-multi
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
[https://github.com/vinted/fetch-process-multi](https://github.com/vinted/fetch-process-multi).

