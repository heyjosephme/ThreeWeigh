import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    start: String,
    duration: Number // duration in minutes
  }

  connect() {
    this.lastProgressPercentage = -1; // Initialize to force first update
    this.updateButtonState()
    this.timer = setInterval(() => {
      this.updateButtonState()
    }, 30000) // Update every 30 seconds
  }

  disconnect() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  updateButtonState() {
    const button = this.element
    const now = new Date()
    const startTime = new Date(this.startValue)
    const elapsedMinutes = Math.floor((now - startTime) / (1000 * 60))
    const progressPercentage = Math.min((elapsedMinutes / this.durationValue) * 100, 100)

    // Only update if progress has changed (performance optimization)
    if (progressPercentage === this.lastProgressPercentage) {
      return;
    }
    this.lastProgressPercentage = progressPercentage;

    // Batch DOM updates for better performance
    requestAnimationFrame(() => {
      this.updateButtonUI(button, progressPercentage, elapsedMinutes);
    });
  }

  updateButtonUI(button, progressPercentage, elapsedMinutes) {
    // Update button text based on progress
    const buttonText = button.querySelector('.button-text')
    const buttonIcon = button.querySelector('svg')

    if (progressPercentage >= 100) {
      // Goal achieved - enable button with celebration styling
      button.disabled = false
      button.classList.remove('opacity-50', 'cursor-not-allowed', 'bg-green-600')
      button.classList.add('bg-green-500', 'hover:bg-green-600', 'animate-pulse')

      if (buttonText) {
        buttonText.textContent = '🎉 Complete Fast - Goal Achieved!'
      }
    } else {
      // Goal not reached - keep disabled but show progress
      button.disabled = true
      button.classList.add('opacity-50', 'cursor-not-allowed')
      button.classList.remove('bg-green-500', 'animate-pulse', 'hover:bg-green-600')

      if (buttonText) {
        const remaining = this.durationValue - elapsedMinutes
        const hoursRemaining = Math.floor(remaining / 60)
        const minutesRemaining = remaining % 60
        const timeText = hoursRemaining > 0 ? `${hoursRemaining}h ${minutesRemaining}m` : `${minutesRemaining}m`
        buttonText.textContent = `Complete Fast (${Math.round(progressPercentage)}% - ${timeText} to go)`
      }
    }
  }
}