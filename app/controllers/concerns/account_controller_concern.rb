# frozen_string_literal: true

module AccountControllerConcern
  extend ActiveSupport::Concern

  FOLLOW_PER_PAGE = 12

  included do
    layout 'public'
    before_action :authenticate_user!
    before_action :set_account
    before_action :check_account_suspension
  end

  private

  def set_account
    @account = Account.find_local!(params[:account_username])
  end

  def check_account_suspension
    gone if @account.suspended?
  end
end
