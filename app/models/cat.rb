# == Schema Information
#
# Table name: cats
#
#  id          :bigint           not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  description :text
#  name        :string           not null
#  sex         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_cats_on_user_id  (user_id)
#
require 'action_view'

class Cat < ApplicationRecord
    include ActionView::Helpers::DateHelper

    CAT_COLORS = %w(black white orange brown).freeze

    validates :birth_date, :color, :name, :sex, :owner, presence: true
    validates :color, inclusion: CAT_COLORS, unless: -> { color.blank? }
    validates :sex, inclusion: %w(M F), if: -> { sex }
    validate :birth_date_in_the_past, if: -> { birth_date }

    has_many :rental_requests,
        class_name: :CatRentalRequest,
        dependent: :destroy

    belongs_to :owner,
        class_name: 'User',
        foreign_key: :user_id

    def age
        time_ago_in_words(birth_date)
    end

    private

    def birth_date_in_the_past
        if birth_date && birth_date > Time.now
            errors[:birth_date] << 'must be in the past'
        end
    end
end
