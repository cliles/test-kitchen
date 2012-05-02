
require 'hashr'
require 'test-kitchen/project'
require 'test-kitchen/platform'

module TestKitchen
  module DSL

    module BasicDSL
      def integration_test(name, &block)
        env.project = Project::Ruby.new(name.to_s, &block)
      end

      def platform(name, &block)
        env.platforms[name.to_s] = Platform.new(name, &block)
      end
    end
    module CookbookDSL
      def cookbook(name, &block)
        env.project = Project::Cookbook.new(name.to_s, &block)
      end
    end

    class File
      include BasicDSL
      include CookbookDSL

      attr_reader :env

      def load(path, env)
        @env = env
        begin
          self.instance_eval(::File.read(path))
        rescue SyntaxError
          env.ui.info('Your Kitchenfile could not be loaded. Please check it for errors.', :red)
          raise
        end
      end
    end

  end
end
