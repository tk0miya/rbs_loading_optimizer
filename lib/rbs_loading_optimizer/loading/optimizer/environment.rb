# frozen_string_literal: true

require "rbs"
require "rbs/cli"

module RBS
  class Environment
    class << self
      def from_loader(loader)
        new_loader = cached_loader(loader)
        new.tap do |env|
          # NOTE: memoize the latest modified time to create cache file
          env.modified_time = new_loader.latest_modified_time
          new_loader.load(env:)
        end
      end

      def cached_loader(loader)
        if system_cached?(loader.latest_modified_time)
          fully_cached_loader(loader.latest_modified_time)
        else
          loader
        end
      end

      def fully_cached_loader(latest_modified_time)
        @fully_cached_loader ||= RBS::EnvironmentLoader.new(core_root: nil).tap do |loader|
          loader.latest_modified_time = latest_modified_time
          loader.cached_sources = [system_cache_path]
          loader.add(path: system_cache_path)
        end
      end

      def system_cached?(modified_time)
        system_cache_path.exist? && system_cache_path.mtime == modified_time
      end

      def system_cache_path
        @system_cache_path ||= cached_path("system.rbs")
      end

      def cached_path(filename)
        Pathname(ENV["XDG_CACHE_HOME"] || File.expand_path("~/.cache")).join("rbs", filename)
      end
    end

    attr_accessor :modified_time

    alias original_resolve_type_names resolve_type_names

    def resolve_type_names(only: nil)
      original_resolve_type_names(only:).tap do |resolved_env|
        # NOTE: Write the environment to the cache file
        resolve_env.modified_time = modified_time
        write_cache("system.rbs", resolved_env)
      end
    end

    alias original_resolve_declaration resolve_declaration

    def resolve_declaration(resolver, map, decl, outer:, prefix:)
      # NOTE: skip resolution if the declaration is already resolved (came from cache)
      return decl if decl.resolved

      original_resolve_declaration(resolver, map, decl, outer:, prefix:)
    end

    private

    def write_cache(filename, env)
      cache_path = self.class.cached_path(filename)
      return if cache_path.exist? && cache_path.mtime == env.modified_time

      cache_path.dirname.mkpath
      cache_path.open("wt") do |f|
        RBS::Writer.new(out: f).write(env.declarations)
      end
      cache_path.utime(env.modified_time, env.modified_time)
    end
  end
end
