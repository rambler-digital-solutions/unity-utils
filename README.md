# UnityUtils

Gem with utilities used by Unity team

# Documentation

- ### Utils:
  - **Retrier** - Restarting passed block.
    ```ruby
    Unity::Utils::Retrier.call { 5 / 0 }
    ```

  - **ThreadPool** - Working with multithreading.
    ```ruby
    result = []
    pool = Unity::Utils::ThreadPool.new(50)

    10.times { |n| pool.schedule { result << n * n } }

    pool.run!
    ```

- ### Modules:
    - **CliModeable** - Wrapper over the ruby-progressbar.
        ```ruby
        elements = (1..10).to_a
        @cli_mode  = true

        init_progressbar(elements.count)

        elements.each do |element|
        incr_progressbar

        # do something and look on great progress bar :)
        end
        ```

    - **Loggable** - Wrapper over logger.
        ```ruby
        @log_file = 'some_file.log'
        @logger = Logger.new(@log_file)

        clean_logfile

        begin
            5 / 0
        rescue StandardError => e
            pretty_e = exception_to_array(e)
            logger.error(pretty_e)
        end
        ```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unity-utils'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install unity-utils

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
