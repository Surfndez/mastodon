# frozen_string_literal: true

class StreamEntriesController < ApplicationController
  include Authorization
  include SignatureVerification

  layout 'public'

  before_action :set_account
  before_action :set_stream_entry
  before_action :check_account_suspension

  private

  def set_account
    @account = Account.find_local!(params[:account_username])
  end

  def set_stream_entry
    @stream_entry = @account.stream_entries.where(activity_type: 'Status').find(params[:id])
    @type         = @stream_entry.activity_type.downcase

    raise ActiveRecord::RecordNotFound if @stream_entry.activity.nil?
    authorize @stream_entry.activity, :show? if @stream_entry.hidden?
  rescue Mastodon::NotPermittedError
    # Reraise in order to get a 404
    raise ActiveRecord::RecordNotFound
  end

  def check_account_suspension
    gone if @account.suspended?
  end
end
