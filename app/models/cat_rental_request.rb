# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :bigint           not null, primary key
#  end_date   :date             not null
#  start_date :date             not null
#  status     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cat_id     :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_cat_rental_requests_on_cat_id   (cat_id)
#  index_cat_rental_requests_on_user_id  (user_id)
#
class CatRentalRequest < ApplicationRecord
    STATUS_STATES = %w(PENDING APPROVED DENIED).freeze

    after_initialize :assign_pending_status

    validates :start_date, :end_date, :status, presence: true
    validates :status, inclusion: STATUS_STATES
    validate :start_must_come_before_end
    validate :does_not_overlap_approved_request

    belongs_to :cat
    belongs_to :user

    def approve!
        raise 'not pending' unless self.status == 'PENDING'
        transaction do
            self.status = 'APPROVED'
            self.save!
            overlaping_pending_requests.each do |req|
                req.update!(status: 'DENIED')
            end
        end
    end

    def approved?
        self.status == 'APPROVED'
    end

    def denied?
        self.status == 'DENIED'
    end

    def deny!
        self.status = 'DENIED'
        self.save!
    end

    def pending?
        self.status =='PENDING'
    end

    private

    def assign_pending_status
        self.status ||= 'PENDING'
    end

    def overlaping_requests
        CatRentalRequest
            .where.not(id: self.id)
            .where(cat_id: cat_id)
            .where.not('start_date > :end_date OR end_date < :start_date',
                       start_date: start_date, end_date: end_date)
    end

    def overlaping_approved_requests
        overlaping_requests.where('status = \'APPROVED\'')
    end

    def overlaping_pending_requests
        overlaping_requests.where('status = \'PENDING\'')
    end

    def does_not_overlap_approved_request
        return if self.denied?

        unless overlaping_approved_requests.empty?
            errors[:base] <<
                'Request conflicts with existing approved request'
        end
    end

    def start_must_come_before_end
        errors[:start_date] << 'must specify a start date' unless start_date
        errors[:end_date] << 'must come after start date' unless end_date
        errors[:start_date] << 'must come before end date' if start_date > end_date
    end
end
