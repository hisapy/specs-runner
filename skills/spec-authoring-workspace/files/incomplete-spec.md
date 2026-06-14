Password Security Requirements

All user passwords must meet minimum security requirements to protect account data.

- Passwords must be at least 8 characters long
- The system should reject common passwords
- Users should be notified when their password is about to expire
- Failed login attempts should be rate-limited

Implementation notes:
This should use the auth library we already have. The password policy should be configurable per environment. Check with the security team about the blocklist of common passwords.

Performance considerations:
Rate limiting should use Redis to persist across server restarts. Password hashing should use bcrypt with a cost factor of at least 12.
