# frozen_string_literal: true

module RBS
  class EnvironmentLoader
    attr_accessor :resolved, :cached_sources
    attr_writer :latest_modified_time

    def latest_modified_time
      @latest_modified_time ||= begin
        mtimes = []
        each_dir do |source, dir|
          skip_hidden = !source.is_a?(Pathname)
          mtimes << RBS::FileFinder.each_file(dir, skip_hidden:, immediate: true).map { |f| File.mtime(f) }.max
        end
        mtimes.max
      end
    end

    def load(env:)
      loaded = []
      cached = cached_sources || []

      each_signature do |source, path, buffer, decls, dirs|
        decls.each do |decl|
          decl.resolved = cached.include?(source) # NOTE: Mark as resolved if decl is came from cache
          loaded << [decl, path, source]
        end
        env.add_signature(buffer:, directives: dirs, decls:)
      end

      loaded
    end
  end
end
