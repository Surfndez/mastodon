# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :set_body_classes
  before_action :set_instance_presenter

  def show
    @tag = Tag.find_by!(name: params[:id].downcase)

    respond_to do |format|
      format.html do
        serializable_resource = ActiveModelSerializers::SerializableResource.new(InitialStatePresenter.new(initial_state_params), serializer: InitialStateSerializer)
        @initial_state_json   = serializable_resource.to_json
      end
    end
  end

  private

  def set_body_classes
    @body_classes = 'tag-body'
  end

  def set_instance_presenter
    @instance_presenter = InstancePresenter.new
  end

  def initial_state_params
    {
      settings: {},
      token: current_session&.token,
    }
  end
end
