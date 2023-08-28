# UnityUtils

Gem with utilities used by Unity team

# Documentation

- ### Utils:
  - **CiFormatter** - Custom rspec formatter: collapses pending tests and adds some time analytics.

    ```
    rspec --formatter CiFormatter
    ...bash
    Rubric publishing using Muppet::PublishJob
      updating rubric
        enqueues Muppet::PublishJob               | Duration: 0.03981s
    ...
    Groups:
    7.20884s ./spec/services/topics_views_count/update_spec.rb (right after midnight)
    5.45071s ./spec/commands/ugc/approve_topic_spec.rb (approve logic)
    ...
    Single examples:
    5.45071s ./spec/commands/ugc/approve_topic_spec.rb (approve logic / creates a topic)
    4.91609s ./spec/commands/topic/update/reviews_of_published_spec.rb (has correct state value / is expected to be need approval)
    ```

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

  - **UrlFormatter** - Formats url.
    ```ruby
    formatter = ::Unity::Utils::UrlFormatter.new('blog/post/nykotyn-bez-syharet-hde-on-soderzytsia/')
    formatter.trailing_slash(enabled: false).build #=> "blog/post/nykotyn-bez-syharet-hde-on-soderzytsia"
    formatter.params({'erid' => 'test'}).build #=> "blog/post/nykotyn-bez-syharet-hde-on-soderzytsia?erid=test"
    ```

  - **UrlValidator** - Validates url.
    ```ruby
    response = UrlValidator.new('ftp://motor.ru/reports/videoparis.htm').call
    response.valid? #=> false
    response.errors #=> ['Ссылка должна начинаться с http(s)']
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

    - **EntitiesLogDump** - Module for service objects do dump entities.
        ```ruby
          dump_entities(Topic.first, attributes: [:id, :headline]) # => [{ "id" => 1, "headline" => "foo" }, { "id" => 2, "headline" => "bar" }]
          dump_entities(Topic.first(2), attributes: [:id, :headline]) #=> { "id" => 1, "headline" => "foo" }
        ```
        Will work both with ApplicationRecord or Mongoid::Document models.

    - **FlexibleBoolean** - Concern to make easier work with virtual boolean attributes.
        ```ruby
        class MyKlass
          include IsReactable

          flexible_boolean :is_reactable

          attr_reader :is_reactable

          def intiailize(is_reactable)
            @is_reactable = is_reactable
          end
        end
        MyKlass.new(true).is_reactable  # => true
        MyKlass.new(nil).is_reactable   # => false
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
