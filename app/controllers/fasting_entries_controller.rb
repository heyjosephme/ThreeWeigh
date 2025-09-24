class FastingEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fasting_entry, only: [:show, :edit, :update, :destroy, :complete, :break, :progress]

  def index
    @fasting_entries = current_user.fasting_entries.recent.includes(:user)
    @current_fast = current_user.current_fast
  end

  def show
    # @fasting_entry is already set by before_action :set_fasting_entry
  end

  def progress
    respond_to do |format|
      format.json {
        render json: {
          progress_percentage: @fasting_entry.progress_percentage,
          time_remaining_text: @fasting_entry.time_remaining_text,
          current_duration_text: @fasting_entry.duration_text,
          status: @fasting_entry.status
        }
      }
    end
  end

  def new
    @fasting_entry = current_user.fasting_entries.build
  end

  def create
    @fasting_entry = current_user.fasting_entries.build(fasting_entry_params)

    if @fasting_entry.save
      redirect_to fasting_entries_path, notice: "Fasting entry created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @fasting_entry.update(fasting_entry_params)
      respond_to do |format|
        format.html { redirect_to fasting_entries_path, notice: "Fasting entry updated successfully!" }
        format.turbo_stream {
          flash.now[:notice] = "Fasting entry updated successfully!"
          render turbo_stream: [
            turbo_stream.replace("fasting-entry-#{@fasting_entry.id}", partial: "fasting_entry_row", locals: { fasting_entry: @fasting_entry }),
            turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
          ]
        }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream {
          flash.now[:alert] = @fasting_entry.errors.full_messages.join(", ")
          render turbo_stream: turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
        }
      end
    end
  end

  def destroy
    @fasting_entry.destroy

    respond_to do |format|
      format.html { redirect_to fasting_entries_path, notice: "Fasting entry deleted successfully!" }
      format.turbo_stream {
        flash.now[:notice] = "Fasting entry deleted successfully!"
        render turbo_stream: [
          turbo_stream.remove("fasting-entry-#{@fasting_entry.id}"),
          turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
        ]
      }
    end
  end

  def start_fast
    planned_duration = params[:planned_duration]&.to_i || 16 * 60 # Default 16 hours
    start_time = params[:start_time].present? ? Time.parse(params[:start_time]) : Time.current
    notes = params[:notes]

    begin
      @fasting_entry = FastingEntry.start_fast_with_time!(current_user, planned_duration, start_time, notes)
      @current_fast = current_user.current_fast

      respond_to do |format|
        format.html { redirect_to fasting_entries_path, notice: "Fast started successfully! Good luck!" }
        format.turbo_stream {
          flash.now[:notice] = "Fast started successfully! Good luck!"
          render turbo_stream: [
            turbo_stream.replace("sidebar-start-fast-button", partial: "shared/start_fast_button"),
            turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
          ]
        }
      end
    rescue => e
      respond_to do |format|
        format.html { redirect_to fasting_entries_path, alert: "Failed to start fast: #{e.message}" }
        format.turbo_stream {
          flash.now[:alert] = "Failed to start fast: #{e.message}"
          render turbo_stream: turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
        }
      end
    end
  end

  def complete
    @fasting_entry.complete!

    respond_to do |format|
      format.html { redirect_to fasting_entries_path, notice: "Congratulations! Fast completed successfully!" }
      format.turbo_stream {
        flash.now[:notice] = "Congratulations! Fast completed successfully!"

        # Reload data for updated views
        @fasting_entries = current_user.fasting_entries.recent.includes(:user)
        @current_fast = current_user.current_fast

        render turbo_stream: [
          turbo_stream.replace("current-fast", partial: "current_fast", locals: { current_fast: @current_fast }),
          turbo_stream.replace("fasting-entries-list", partial: "fasting_entries_list", locals: { fasting_entries: @fasting_entries }),
          turbo_stream.replace("stats-summary", partial: "stats_summary", locals: { fasting_entries: @fasting_entries, current_user: current_user }),
          turbo_stream.replace("sidebar-start-fast-button", partial: "shared/start_fast_button"),
          turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
        ]
      }
    end
  end

  def break
    @fasting_entry.break!

    respond_to do |format|
      format.html { redirect_to fasting_entries_path, notice: "Fast ended. Don't worry, you'll do better next time!" }
      format.turbo_stream {
        flash.now[:notice] = "Fast ended. Don't worry, you'll do better next time!"

        # Reload data for updated views
        @fasting_entries = current_user.fasting_entries.recent.includes(:user)
        @current_fast = current_user.current_fast

        render turbo_stream: [
          turbo_stream.replace("current-fast", partial: "current_fast", locals: { current_fast: @current_fast }),
          turbo_stream.replace("fasting-entries-list", partial: "fasting_entries_list", locals: { fasting_entries: @fasting_entries }),
          turbo_stream.replace("stats-summary", partial: "stats_summary", locals: { fasting_entries: @fasting_entries, current_user: current_user }),
          turbo_stream.replace("sidebar-start-fast-button", partial: "shared/start_fast_button"),
          turbo_stream.replace("flash-messages", partial: "shared/flash_messages")
        ]
      }
    end
  end


  private

  def set_fasting_entry
    @fasting_entry = current_user.fasting_entries.find(params[:id])
  end

  def fasting_entry_params
    params.require(:fasting_entry).permit(:start_time, :end_time, :planned_duration, :status, :notes)
  end
end
