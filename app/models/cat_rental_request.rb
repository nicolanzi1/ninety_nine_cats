class CatRentalRequest < ApplicationRecord
    STATUS_STATES = %w(PENDING APPROVED DENIED).freeze

    validates :cat_id, :start_date, :end_date, presence: true
    validates :status, inclusion: STATUS_STATES

    belongs_to :cat
    
    after_initialize :assign_pending_status

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

    def does_not_overlap_approved_request
        return if self.deniend?

        unless overlaping_approved_requests.empty?
            errors[:base] <<
                'Request conflicts with existing approved request'
        end
    end
end