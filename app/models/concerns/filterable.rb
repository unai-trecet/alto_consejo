# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  included do
    @filter_scopes ||= []
  end

  class_methods do
    attr_reader :filter_scopes

    def filter_scope(name, *args)
      scope name, *args
      filter_scopes << name
    end

    def filter(filtering_params)
      result = all
      filtering_params.each do |filter_scope, filter_value|
        filter_value = filter_value.reject(&:blank?) if filter_value.is_a?(Array)
        result = result.public_send(filter_scope, filter_value) if filter_value.present?
      end
      result
    end
  end
end
