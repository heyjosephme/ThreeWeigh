# ViewComponent configuration
Rails.application.config.to_prepare do
  # Ensure ViewComponent can find components in app/components
  ViewComponent::Base.view_component_path = "app/components"
end
