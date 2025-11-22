require "test_helper"

class RateLimitingTest < ActionDispatch::IntegrationTest
  test "login rate limiting blocks after 5 failed attempts" do
    test_email = "ratelimit-test@example.com"

    # First 5 attempts should fail with 422/302 (wrong password)
    5.times do |i|
      post user_session_path, params: {
        user: { email: test_email, password: "wrongpassword" }
      }

      # Should not be rate limited yet
      assert_not_equal 429, response.status,
        "Attempt #{i + 1} should not be rate limited (got #{response.status})"
    end

    # 6th attempt should be rate limited (429)
    post user_session_path, params: {
      user: { email: test_email, password: "wrongpassword" }
    }

    assert_equal 429, response.status,
      "6th attempt should be rate limited with HTTP 429"
    assert_match /Too Many Requests/i, response.body
  end

  test "signup rate limiting blocks after 5 attempts from same IP" do
    # First 5 signups should be allowed
    5.times do |i|
      post user_registration_path, params: {
        user: {
          email: "user#{i}@ratelimit-test.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }

      # Should not be rate limited yet (may fail validation, but not 429)
      assert_not_equal 429, response.status,
        "Signup #{i + 1} should not be rate limited (got #{response.status})"
    end

    # 6th signup should be rate limited
    post user_registration_path, params: {
      user: {
        email: "user6@ratelimit-test.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }

    assert_equal 429, response.status,
      "6th signup should be rate limited with HTTP 429"
  end

  test "password reset rate limiting blocks after 3 attempts" do
    test_email = "password-reset@example.com"

    # First 3 attempts should be allowed
    3.times do |i|
      post user_password_path, params: {
        user: { email: test_email }
      }

      assert_not_equal 429, response.status,
        "Password reset #{i + 1} should not be rate limited (got #{response.status})"
    end

    # 4th attempt should be rate limited
    post user_password_path, params: {
      user: { email: test_email }
    }

    assert_equal 429, response.status,
      "4th password reset should be rate limited with HTTP 429"
  end
end
