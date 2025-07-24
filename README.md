# Weight Tracker & Intermittent Fasting App

A modern Ruby on Rails 8 web application for tracking weight progress and managing intermittent fasting schedules. Built with Hotwire for real-time updates and a responsive user experience.

## 🚀 Features

### Weight Tracking

- **Daily Weight Logging**: Record your weight with optional notes
- **Progress Visualization**: Interactive charts showing weight trends over time
- **Goal Setting**: Set and track weight loss/gain goals
- **Historical Data**: View complete weight history with filtering options

### Intermittent Fasting

- **Multiple Fasting Modes**: 16:8, 18:6, 20:4, 14:10, 24h, 36h, 48h, 72h
- **Real-time Timer**: Live countdown during active fasting sessions
- **Fasting Analytics**: Track fasting streaks and effectiveness
- **Custom Schedules**: Create personalized fasting routines
- **Progress Tracking**: Monitor fasting goals and achievements

### Dashboard & Analytics

- **Real-time Updates**: Live fasting timer and progress indicators
- **Weight-Fasting Correlation**: Analyze how fasting affects your weight
- **Progress Charts**: Visual representation of your journey
- **Weekly/Monthly Summaries**: Track trends and patterns

## 🛠 Tech Stack

- **Backend**: Ruby on Rails 8
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus) + Tailwind CSS
- **Components**: ViewComponent
- **Charts**: Chart.js
- **Real-time**: ActionCable (WebSockets)
- **Authentication**: Rails 8 built-in authentication

## 📋 Prerequisites

- Ruby 3.3.0 or higher
- Rails 8.0.0
- PostgreSQL 12+
- Node.js 18+ (for asset compilation)

## 🔧 Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/weight-tracker.git
   cd weight-tracker
   ```

2. **Install dependencies**

   ```bash
   # Install Ruby gems
   bundle install

   # Install JavaScript packages
   npm install
   ```

3. **Database setup**

   ```bash
   # Create and migrate database
   rails db:create
   rails db:migrate

   # Optional: Load sample data
   rails db:seed
   ```

4. **Start the application**

   ```bash
   # Start Rails server
   rails server

   # In another terminal, start CSS build process
   rails tailwindcss:watch
   ```

5. **Visit the application**
   Open your browser and navigate to `http://localhost:3000`

## 🗄 Database Schema

### Core Models

**Users**

- Email and password authentication
- Profile information and preferences

**WeightEntry**

```ruby
weight: decimal (precision: 5, scale: 2)
notes: text
user: references
created_at: datetime
```

**FastingEntry**

```ruby
start_time: datetime
end_time: datetime
fasting_type: string  # "16:8", "18:6", "24h", etc.
status: string        # "active", "completed", "cancelled"
notes: text
user: references
```

**FastingGoal**

```ruby
goal_type: string
target_frequency: integer
current_streak: integer
longest_streak: integer
user: references
```

## 🎯 Key Features Implementation

### Real-time Fasting Timer

```javascript
// Stimulus Controller
export default class extends Controller {
  connect() {
    this.updateTimer();
    this.timer = setInterval(() => this.updateTimer(), 1000);
  }

  updateTimer() {
    // Calculate and display remaining fasting time
  }
}
```

### Weight Tracking with Charts

- Chart.js integration via Stimulus controllers
- Real-time data updates via Turbo Streams
- Responsive design for mobile and desktop

### Goal Setting System

- Flexible goal types (weight targets, fasting frequency)
- Progress tracking with visual indicators
- Achievement notifications

## 🧪 Testing

```bash
# Run the test suite
bundle exec rspec

# Run with coverage
bundle exec rspec --format documentation
```

## 🚢 Deployment

The app is configured for deployment on modern hosting platforms:

- **Heroku**: Includes `Procfile` and database configuration
- **Railway**: Ready for one-click deployment
- **Docker**: Containerized setup available

## 📱 Mobile Support

- Fully responsive design with Tailwind CSS
- Touch-friendly interface for mobile devices
- Progressive Web App (PWA) capabilities
- Offline data viewing (coming soon)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Roadmap

- [ ] Mobile app (React Native)
- [ ] Apple Health / Google Fit integration
- [ ] Social features (sharing progress)
- [ ] Meal planning integration
- [ ] Advanced analytics and insights
- [ ] Multi-language support

## 🐛 Known Issues

- Email notifications require additional SMTP configuration
- Chart animations may be slow on older devices
- iOS Safari WebSocket reconnection needs improvement

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/weight-tracker/issues) page
2. Create a new issue with detailed information
3. Contact the maintainers

---

**Built with ❤️ using Ruby on Rails 8 and modern web technologies**
