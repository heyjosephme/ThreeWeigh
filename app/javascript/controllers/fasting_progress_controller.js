import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["progressBar", "percentage", "timeRemaining"]
  static values = {
    fastingEntryId: Number,
    updateInterval: { type: Number, default: 60000 } // 1 minute
  }

  connect() {
    this.startProgressUpdates()
  }

  disconnect() {
    this.stopProgressUpdates()
  }

  startProgressUpdates() {
    if (this.hasFastingEntryIdValue) {
      this.updateProgress()
      this.progressTimer = setInterval(() => {
        this.updateProgress()
      }, this.updateIntervalValue)
    }
  }

  stopProgressUpdates() {
    if (this.progressTimer) {
      clearInterval(this.progressTimer)
      this.progressTimer = null
    }
  }

  async updateProgress() {
    if (!this.hasFastingEntryIdValue) return

    try {
      const response = await fetch(`/fasting_entries/${this.fastingEntryIdValue}/progress`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (response.ok) {
        const data = await response.json()
        this.updateUI(data)
      }
    } catch (error) {
      console.error('Failed to update fasting progress:', error)
    }
  }

  updateUI(data) {
    // Update progress bar width
    if (this.hasProgressBarTarget) {
      this.progressBarTarget.style.width = `${Math.min(data.progress_percentage, 100)}%`
    }

    // Update percentage text
    if (this.hasPercentageTarget) {
      this.percentageTarget.textContent = `${Math.round(data.progress_percentage)}%`
    }

    // Update time remaining text
    if (this.hasTimeRemainingTarget) {
      this.timeRemainingTarget.textContent = data.time_remaining_text
    }

    // Update sidebar button via Turbo Stream if needed
    if (data.sidebar_button_html) {
      const sidebarButton = document.getElementById('sidebar-start-fast-button')
      if (sidebarButton) {
        sidebarButton.innerHTML = data.sidebar_button_html
      }
    }
  }
}