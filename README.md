# Mentionable

Discovery mentions from ActiveRecord column.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mentionable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mentionable

## Usage

`app/models/comment.rb`:

```ruby
class Comment
  mentionable_as :body #, on_mention: :after_mention, regexp: /@\w+/

  def after_mention(mentions)
    p mentions # Send notification if you want.
  end
end
```

```sh
% rails runner "Comment.create(body: '@nobunaga @hideyosi Hi guys.')"
["@nobunaga", "@hideyosi"]
```

### Utility methods

```ruby
comment = Comment.create(body: '@nobunaga @hideyosi Hi guys.')
comment.mentions # => ["@nobunaga", "@hideyosi"]
comment.new_mentions? # => true

comment.update(body: '@nobunaga @hideyosi @ieyasu Hi guys.')
comment.mentions # => ["@nobunaga", "@hideyosi", "@ieyasu"]
comment.mentions_ware # => ["@nobunaga", "@hideyosi"]
comment.new_mentions # => ["@ieyasu"]
comment.new_mentions? # => true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/komagata/mentionable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/komagata/mentionable/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mentionable project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/komagata/mentionable/blob/master/CODE_OF_CONDUCT.md).
