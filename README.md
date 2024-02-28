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

- ### Rake tasks:
  - **unity:rspec** - rspec with custom report format: collapses pending tests and adds some analytics.

    ```bash
    bundle exec rake unity:rspec
    bundle exec rake unity:rspec\['spec/queries'\]
    bundle exec rake unity:rspec\['spec/{jobs\,services}/'\]
    bundle exec rake unity:rspec\['spec/ --exclude-pattern "spec/{models\,requests}/**/*_spec.rb"'\]
    ...
    [TEST PROF INFO] TagProf report for type

      type          time          total   %total    %time     avg

      query         00:27.908     134     15.14     37.51     00:00.208
      service       00:15.849     167     18.87     21.31     00:00.094
      ...

    Top 10 slowest examples (10.23 seconds, 13.7% of total time):
      Api::V2::RssGeneratorJob generate for topic1 double generating does not duplicate data
        1.32 seconds ./spec/jobs/api/v2/rss_generator_job_spec.rb:39
      Exports::V2::BaseQuery behaves like queries/exports/v2/postponed when site is postponed is expected to contain
        1.2 seconds ./spec/support/shared_examples/queries/exports/v2/postponed_example.rb:28
      ...

    Top 10 slowest example groups:
      Exports::V2::Indexnow::TopicsQuery
        0.89632 seconds average (5.38 seconds / 6 examples) ./spec/queries/exports/v2/indexnow/topics_query_spec.rb:5
      Exports::V2::RssAggregation
        0.70154 seconds average (5.61 seconds / 8 examples) ./spec/services/exports/rss_aggregation_spec.rb:5
      ...

    Finished in 1 minute 14.71 seconds (files took 7.29 seconds to load)
    885 examples, 0 failures, 31 pending

    Randomized with seed 6856

    [TEST PROF INFO] Factories usage

      Total: 1624
      Total top-level: 1298
      Total time: 00:54.568 (out of 01:16.029)
      Total uniq factories: 12

        total   top-level     total time      time per call     top-level time      name

        521         521       8.9882s         0.0173s           8.9882s             v2_topic
        394         394       17.5059s        0.0444s           17.5059s            v2_push_topic
        ...
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
