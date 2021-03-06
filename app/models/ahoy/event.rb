module Ahoy
  class Event < ApplicationRecord
    include Ahoy::Properties

    self.table_name = :ahoy_events

    belongs_to :visit, optional: true

    default_scope { order(time: :desc) }

    # Workaround for Ahoy bug
    def user=(value)
    end
  end
end
