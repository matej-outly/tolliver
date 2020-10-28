# Tolliver
A long serving Junior Postman Tolliver Groat. With this gem you can create 
notifications based on templates defined by the system administrator and 
send it in a batch with different delivery methods:

- E-mail
- SMS
- Whatever custom delivery method

## Installation

Add gem to your Gemfile:

```ruby
gem 'tolliver'
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake tolliver:install:migrations
    $ rake db:migrate

## Configuration

You can configure module through `config/initializers/tolliver.rb` file:

```ruby
Tolliver.setup do |config|
  config.mailer_sender = 'no-reply@domain.com'
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
- sms_sender
- sms_provider
- sms_provider_params
- delivery_methods

## Usage

To enter new notification into the system, just call `notify` method:

```ruby
Tolliver.notify(
  template: :template_ref, 
  params: [
    {key: :key_1, value: :value_1},
    {key: :key_2, value: :value_2}
  ], 
  receivers: [
    {ref: :receiver_1, contact: "receiver_1@domain.tld"},
    {ref: :receiver_2, contact: "receiver_2@domain.tld"}, 
  ]
)
```
