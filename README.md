# Lokalise

Lokalise gem is a wrapper around the Lokalise REST API (https://lokalise.co/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lokalise'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lokalise

## Usage
Set `LOKALISE_ACCESS_TOKEN=<your_lokalise_api_access_token>` as
environment variable

```
require 'lokalise'

Lokalise.alive? # to test the conenction

Lokalise.get_projects # to retrieve all projects

Lokalise.get_project_languages(project_id) # to retrieve language
support in the project

# to import keys
Lokalise.import_keys(<project_id>, <path/to/keys_file>, <lang_iso>, options)
eg: options = {
               replace: true,
               fill_empty: false,
               distinguish: false,
               hidden: false,
               tags: ['main release', 'supertag'].to_json,
               replace_breaks: true
              }

# to export keys
# check https://lokalise.co/apidocs#export for export options
# type is the file format to export
# options is a hash and optional.
Lokalise.export_keys(<project_id, <type>, options)

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lokalise.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
