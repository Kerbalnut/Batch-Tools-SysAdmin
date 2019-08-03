
# Export System Environment Variables
#[Environment]::SetEnvironmentVariable("TWILIO_ACCOUNT_SID", "your_account_sid", "User")
[Environment]::SetEnvironmentVariable("TWILIO_ACCOUNT_SID", "AC233dffdc2d0f89ca6843bc2186f6cb84", "User")

#[Environment]::SetEnvironmentVariable("TWILIO_AUTH_TOKEN", "your_auth_token", "User")
[Environment]::SetEnvironmentVariable("TWILIO_AUTH_TOKEN", "3270a7694d0da92967f3d1411f7ff3e3", "User")

# Twilio Phone number to send SMS from
[Environment]::SetEnvironmentVariable("TWILIO_NUMBER", "+16028992009", "User")

# Phone number to send SMS to
[Environment]::SetEnvironmentVariable("TWILIO_VERIFIED_CALLERID", "+14804155032", "User")
