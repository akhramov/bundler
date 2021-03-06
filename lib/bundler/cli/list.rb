# frozen_string_literal: true

module Bundler
  class CLI::List
    def initialize(options)
      @options = options
    end

    def run
      specs = Bundler.load.specs.reject {|s| s.name == "bundler" }.sort_by(&:name)

      raise InvalidOption, "The `--name-only` and `--paths` options cannot be used together" if @options["name-only"] && @options["paths"]
      return specs.each {|s| Bundler.ui.info s.name } if @options["name-only"]
      return specs.each {|s| Bundler.ui.info s.full_gem_path } if @options["paths"]

      return Bundler.ui.info "No gems in the Gemfile" if specs.empty?
      Bundler.ui.info "Gems included by the bundle:"
      specs.each do |s|
        Bundler.ui.info "  * #{s.name} (#{s.version}#{s.git_version})"
      end

      Bundler.ui.info "Use `bundle info` to print more detailed information about a gem"
    end
  end
end
