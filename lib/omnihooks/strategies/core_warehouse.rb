require 'omnihooks'
require 'active_support/core_ext/hash/conversions'
require "active_support/core_ext/hash/indifferent_access"
require 'active_support/core_ext/object/blank'

module OmniHooks
  module Strategies
    class CoreWarehouse
      include OmniHooks::Strategy
      option :name, 'core-warehouse'

      event do
        owner = request.params['owner']
        raise ArgumentError.new "Query parameter 'owner' must be included" if owner.blank?
        ActiveSupport::HashWithIndifferentAccess.new({ 
          owner: owner,
          event: raw_info
        })
      end

      event_type do
        raw_info_as_hash.keys.first
      end

      private

      def raw_info
        @raw_info ||= request.body.read
      end

      def raw_info_as_hash
        Hash.from_xml(raw_info)
      end
    end
  end
end