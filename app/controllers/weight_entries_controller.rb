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
      respond_to do |format|
        format.html { redirect_to weight_entries_path, notice: "Weight entry updated successfully!" }
        format.turbo_stream {
          flash.now[:notice] = "Weight entry updated successfully!"
          render turbo_stream: [
            turbo_stream.replace("weight-entry-#{@weight_entry.id}", partial: "weight_entry_row", locals: { weight_entry: @weight_entry }),
            turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
          ]
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to weight_entries_path, alert: @weight_entry.errors.full_messages.join(", ") }
        format.turbo_stream {
          flash.now[:alert] = @weight_entry.errors.full_messages.join(", ")
          render turbo_stream: turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
        }
      end
    end
  end

  def destroy
    @weight_entry.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_path, notice: "Weight entry deleted successfully!" }
      format.turbo_stream {
        flash.now[:notice] = "Weight entry deleted successfully!"
        render turbo_stream: [
          turbo_stream.remove("weight-entry-#{@weight_entry.id}"),
          turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
        ]
      }
    end
  end

  private

  def set_weight_entry
    @weight_entry = current_user.weight_entries.find(params[:id])
  end

  def weight_entry_params
    params.require(:weight_entry).permit(:weight, :date, :notes)
  end
end
