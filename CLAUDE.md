# ThreeWeigh - Rails Weight Tracking Application

## Overview
ThreeWeigh is a Rails 8 application for tracking personal weight entries with authentication and data visualization.

## Tech Stack
- Ruby on Rails 8
- Devise for authentication
- Hotwire (Turbo + Stimulus)
- Chart.js (via CDN) for data visualization
- TailwindCSS for styling

## Application Structure

### Models
- `User` - Devise authentication
- `WeightEntry` - belongs_to :user, tracks weight, date, notes

### Controllers
- `DashboardController` - main dashboard with chart
- `WeightEntriesController` - CRUD operations for weight entries

### Key Features
- User authentication with Devise
- Dashboard with weight chart visualization
- Weight entry management (CRUD)
- Responsive design with TailwindCSS

## Development Notes
- Uses importmap-rails for JS bundling
- Chart.js loaded via CDN (switched from importmap due to integrity issues)
- Stimulus controllers for client-side interactions
- Turbo Streams for dynamic updates

## Current Focus
- Refining weight entries index page with full CRUD operations
- Improving user experience for weight entry management

## Commands
- `bin/dev` - Start development server with asset watching
- `rails server` - Start Rails server only