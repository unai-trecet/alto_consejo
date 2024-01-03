# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include ActionView::RecordIdentifier

  self.abstract_class = true
end
