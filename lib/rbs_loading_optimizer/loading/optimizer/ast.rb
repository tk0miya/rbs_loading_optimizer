# frozen_string_literal: true

module RBS
  module AST
    module Declarations
      class Base
        # NOTE: Allow to mark resolved to skip resolving process
        attr_accessor :resolved
      end
    end
  end
end
