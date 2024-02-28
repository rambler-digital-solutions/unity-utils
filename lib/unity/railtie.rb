# frozen_string_literal: true

module Unity
  class Railtie < Rails::Railtie
    railtie_name :unity_utils

    rake_tasks do
      namespace :unity do
        desc 'Run tests'
        task :rspec, %i[options] => :environment do |_t, args|
          system("FPROF=1 TAG_PROF=type bundle exec rspec #{args.options} " \
                 '--require test-prof ' \
                 '--require unity-utils ' \
                 '--format CiFormatter ' \
                 '--profile')
        end
      end

      task unity_utils: ['unity:rspec']
    end
  end
end
