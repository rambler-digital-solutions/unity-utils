# frozen_string_literal: true

require_relative 'spec/support/ci_formatter'
require_relative 'spec/support/tag_prof'

module Unity
  class Railtie < Rails::Railtie
    railtie_name :unity_utils

    rake_tasks do
      namespace :unity do
        desc 'Run tests'
        task :rspec, %i[options] => :environment do |_t, args|
          system("FPROF=1 TAG_PROF=type bundle exec rspec #{args.options} --require test-prof --format CiFormatter --profile")
        end
      end

      task unity_utils: ['unity:rspec']
    end
  end
end
