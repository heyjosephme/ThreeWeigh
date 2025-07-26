class WeightEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_weight_entry, only: [ :show, :edit, :update, :destroy ]

  def index
    @weight_entries = current_user.weight_entries.recent
  end

  def show
  end

  def new
    @weight_entry = current_user.weight_entries.build(date: Date.current)
  end

  def create
    @weight_entry = current_user.weight_entries.build(weight_entry_params)

    if @weight_entry.save
      redirect_to dashboard_path, notice: "Weight entry created successfully!"
    else
      redirect_to dashboard_path, alert: @weight_entry.errors.full_messages.join(", ")
    end
  end

  def edit
  end

  def update
    if @weight_entry.update(weight_entry_params)
      redirect_to dashboard_path, notice: "Weight entry updated successfully!"
    else
      redirect_to dashboard_path, alert: @weight_entry.errors.full_messages.join(", ")
    end
  end

  def destroy
    @weight_entry.destroy
    redirect_to dashboard_path, notice: "Weight entry deleted successfully!"
  end

  private

  def set_weight_entry
    @weight_entry = current_user.weight_entries.find(params[:id])
  end

  def weight_entry_params
    params.require(:weight_entry).permit(:weight, :date, :notes)
  end
end
