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
gem "tolliver"
```

Add database migrations to you application (you can modify DB structure accordingly before migrating):

    $ rake tolliver:install:migrations
    $ rake db:migrate

## Configuration

You can configure module through `config/initializers/tolliver.rb` file:

```ruby
Tolliver.setup do |config|
  config.mailer_sender = "no-reply@domain.com"
  config.delivery_kinds = [
      :email
  ]
  config.template_refs = [
      :user_new_password,
  ]
end
```

Available options:

- notification_model
- notification_delivery_model
- notification_receiver_model
- notification_template_model
- people_selector_model
- mailer_sender
- delivery_kinds
- template_refs

## Usage

To enter new notification into the system, just call `notify` method:

```ruby
Tolliver.notify([:sample_notification_ref, param_1, param_2], [receiver_1, receiver_2], options)
```
