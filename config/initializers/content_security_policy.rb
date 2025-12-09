# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    # Default: only allow resources from same origin and HTTPS
    policy.default_src :self, :https

    # Fonts: allow from same origin, HTTPS, and data URLs
    policy.font_src    :self, :https, :data

    # Images: allow from same origin, HTTPS, and data URLs
    policy.img_src     :self, :https, :data

    # Objects: disallow entirely (Flash, Java applets, etc.)
    policy.object_src  :none

    # Scripts: allow from same origin, HTTPS, and Chart.js CDN
    policy.script_src  :self, :https, "https://cdn.jsdelivr.net"

    # Styles: allow from same origin, HTTPS, and inline styles (for TailwindCSS)
    policy.style_src   :self, :https, :unsafe_inline

    # Connect (AJAX): only to same origin
    policy.connect_src :self

    # Frames: disallow embedding in frames (prevents clickjacking)
    policy.frame_ancestors :none

    # Specify URI for violation reports (optional)
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w(script-src style-src)

  # Report violations without enforcing the policy (uncomment for testing)
  # config.content_security_policy_report_only = true
end
