# RbsLoadingOptimizer

This gem optimize the loading of RBS types 1.5 times faster using cache.

This gem modifies RBS::Environment and RBS::EnvironmentLoader to read and write cache
files on loading type information automatically.
As a result, RBS loading in some tools will become fast automatically.

On my PC, the loading time of RBS becomes about 1.5 times faster (3.18s -> 2.09s).

Note: The loading time will become slow about 1.3 times after some RBS files changed (3.18s -> 4.02s).

## Installation

Add this gem to your Gemfile and go `bundle install`.

```
group :development do
  gem 'rbs_loading_optimizer
end
```

## Usage

Nothing to do. Enjoy your development with typing!

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also
run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then put
a git tag (ex. `git tag v1.0.0`) and push it to the GitHub.  Then GitHub Actions
will release a new package to [rubygems.org](https://rubygems.org) automatically.
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tk0miya/rbs_loading_optimizer.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [code of conduct](https://github.com/tk0miya/rbs_loading_optimizer/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RbsLoadingOptimizer project's codebases, issue trackers is expected
to follow the [code of conduct](https://github.com/tk0miya/rbs_loading_optimizer/blob/main/CODE_OF_CONDUCT.md).
