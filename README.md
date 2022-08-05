# Tolliver
A long serving Junior Postman Tolliver Groat. With this gem you can create 
notifications based on templates defined by the system administrator and 
send it in a batch with different delivery methods:

- E-mail with SMTP aor Mailgun provider
- SMS with Plivo provider
- Slack
- Whatever custom delivery method

## 1. Installation

Add gem to your Gemfile:

```ruby
gem 'tolliver'
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake tolliver:install:migrations
    $ rake db:migrate

### 1.1. Plivo support

Add gem to your Gemfile:

```ruby
gem 'plivo'
```
### 1.2. Mailgun support

Add gem to your Gemfile:

```ruby
gem 'mailgun-ruby'
```
### 1.3. Slack support

Add gem to your Gemfile:

```ruby
gem 'slack-ruby-client'
````

## 2. Configuration

You can configure module through `config/initializers/tolliver.rb` file:

```ruby
Tolliver.setup do |config|
  config.email_sender = 'no-reply@domain.com'
  config.delivery_methods = [
      :email
  ]
end
```

Available options:

- notification_model
- notification_attachment_model
- notification_delivery_model
- notification_receiver_model
- notification_template_model
- email_sender
- email_sender_name
- email_provider
- email_provider_params
- sms_sender
- sms_provider
- sms_provider_params
- slack_params
- delivery_methods

### 2.1. Plivo support

Set Plivo as SMS provider and add Plivo auth ID and token into Tolliver configuration file:

```ruby
Tolliver.setup do |config|
  ...
  config.sms_provider = :plivo
  config.sms_provider_params = {
    auth_id: 'secret',
    auth_token: 'secret'
  }
end
```

### 2.2. Mailgun support

Set Mailgun as e-mail provider and add Mailgun API key and domain into Tolliver configuration file:

```ruby
Tolliver.setup do |config|
  ...
  config.email_provider = :mailgun
  config.email_provider_params = {
      api_key: 'key-secret',
      domain: 'domain.tld'
  }
end
```
 
## 3. Usage

To enter new notification into the system, just call `notify` method:

```ruby
Tolliver.notify(
  template: :template_ref, 
  params: [
    {key: :key_1, value: :value_1},
    {key: :key_2, value: :value_2}
  ], 
  receivers: [
    {ref: :receiver_1, email: "receiver_1@domain.tld"},
    {ref: :receiver_2, email: "receiver_2@domain.tld"}, 
  ]
)
```
