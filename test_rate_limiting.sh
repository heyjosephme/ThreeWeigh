#!/bin/bash
# Test script for Rails 8 native rate limiting
# Tests login rate limiting (5 attempts per email in 20 minutes)

echo "🧪 Testing Rate Limiting Implementation"
echo "========================================"
echo ""
echo "📝 This will test login rate limiting by making 7 failed login attempts."
echo "   Expected: First 5 attempts return 401 (Unauthorized)"
echo "            Attempts 6-7 return 429 (Too Many Requests)"
echo ""
echo "🚀 Make sure your Rails server is running: bin/dev"
echo ""
read -p "Press Enter to start testing..."

TEST_EMAIL="test@rate-limit.com"
WRONG_PASSWORD="wrongpassword"

echo ""
echo "Testing with email: $TEST_EMAIL"
echo "Expected behavior: Rate limited after 5 attempts"
echo ""

for i in {1..7}; do
  echo "Attempt $i..."

  RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
    -X POST http://localhost:3000/users/sign_in \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "user[email]=$TEST_EMAIL&user[password]=$WRONG_PASSWORD" \
    2>/dev/null)

  HTTP_STATUS=$(echo "$RESPONSE" | grep "HTTP_STATUS" | cut -d':' -f2)

  if [ "$HTTP_STATUS" == "401" ] || [ "$HTTP_STATUS" == "422" ]; then
    echo "  ✅ Status: $HTTP_STATUS (Unauthorized - login failed, rate limit not hit yet)"
  elif [ "$HTTP_STATUS" == "429" ]; then
    echo "  🔴 Status: $HTTP_STATUS (Too Many Requests - RATE LIMITED!)"
  else
    echo "  ❓ Status: $HTTP_STATUS (Unexpected response)"
  fi

  sleep 1
done

echo ""
echo "========================================"
echo "✅ Test Complete!"
echo ""
echo "📊 Expected Results:"
echo "   - Attempts 1-5: HTTP 401/422 (Unauthorized)"
echo "   - Attempts 6-7: HTTP 429 (Too Many Requests) ← RATE LIMITED"
echo ""
echo "🔒 Rate limiting is working if you see 429 status codes!"
echo ""
echo "💡 To reset the rate limit, either:"
echo "   1. Wait 20 minutes"
echo "   2. Restart Rails server (clears cache)"
echo "   3. Use a different email address"
