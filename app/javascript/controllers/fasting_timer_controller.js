import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="fasting-timer"
export default class extends Controller {
  static targets = ["currentDuration", "timeRemaining", "progressBar", "progressPercentage"];
  static values = { 
    startTime: String, 
    plannedDuration: Number, // in minutes
    id: Number 
  };

  connect() {
    console.log("FastingTimerController connected for fast", this.idValue);
    this.lastElapsedMinutes = -1; // Initialize to force first update
    this.startTimer();
  }

  disconnect() {
    this.stopTimer();
  }

  startTimer() {
    // Update immediately
    this.updateTimer();
    
    // Then update every second
    this.timer = setInterval(() => {
      this.updateTimer();
    }, 1000);
  }

  stopTimer() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  updateTimer() {
    const now = new Date();
    const startTime = new Date(this.startTimeValue);
    const elapsedMs = now - startTime;
    const elapsedMinutes = Math.floor(elapsedMs / (1000 * 60));

    // Only update if minute has actually changed (performance optimization)
    if (elapsedMinutes === this.lastElapsedMinutes) {
      return;
    }
    this.lastElapsedMinutes = elapsedMinutes;

    // Batch DOM updates in requestAnimationFrame for better performance
    requestAnimationFrame(() => {
      this.updateCurrentDuration(elapsedMinutes);
      this.updateTimeRemaining(elapsedMinutes);
      this.updateProgress(elapsedMinutes);
    });
  }

  updateCurrentDuration(elapsedMinutes) {
    const hours = Math.floor(elapsedMinutes / 60);
    const minutes = elapsedMinutes % 60;
    
    let durationText;
    if (hours > 0) {
      durationText = `${hours}h ${minutes}m`;
    } else {
      durationText = `${minutes}m`;
    }
    
    if (this.hasCurrentDurationTarget) {
      this.currentDurationTarget.textContent = durationText;
    }
  }

  updateTimeRemaining(elapsedMinutes) {
    const remainingMinutes = Math.max(0, this.plannedDurationValue - elapsedMinutes);
    
    let remainingText;
    if (remainingMinutes <= 0) {
      remainingText = "Goal reached! 🎉";
    } else {
      const hours = Math.floor(remainingMinutes / 60);
      const minutes = remainingMinutes % 60;
      
      if (hours > 0) {
        remainingText = `${hours}h ${minutes}m remaining`;
      } else {
        remainingText = `${minutes}m remaining`;
      }
    }
    
    if (this.hasTimeRemainingTarget) {
      this.timeRemainingTarget.textContent = remainingText;
    }
  }

  updateProgress(elapsedMinutes) {
    const progressPercentage = Math.min(100, (elapsedMinutes / this.plannedDurationValue) * 100);
    const roundedProgress = Math.round(progressPercentage * 10) / 10; // Round to 1 decimal
    
    // Update progress bar
    if (this.hasProgressBarTarget) {
      this.progressBarTarget.style.width = `${progressPercentage}%`;
      
      // Change color when goal is reached
      if (progressPercentage >= 100) {
        this.progressBarTarget.className = this.progressBarTarget.className.replace(
          'from-blue-500 to-indigo-600',
          'from-green-500 to-emerald-600'
        );
      }
    }
    
    // Update progress percentage text
    if (this.hasProgressPercentageTarget) {
      this.progressPercentageTarget.textContent = `${roundedProgress}%`;
    }
  }

  // Format minutes to human readable duration
  formatDuration(minutes) {
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    
    if (hours > 0) {
      return `${hours}h ${mins}m`;
    } else {
      return `${mins}m`;
    }
  }

  // Helper method to calculate elapsed time
  getElapsedMinutes() {
    const now = new Date();
    const startTime = new Date(this.startTimeValue);
    const elapsedMs = now - startTime;
    return Math.floor(elapsedMs / (1000 * 60));
  }
}