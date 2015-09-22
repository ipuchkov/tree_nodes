# README

## Redis

Для работы сервиса необходим redis-server

### [Инструкция по установке для Linux](http://redis.io/topics/quickstart)
### [Инструкция по установке для Mac](http://jasdeep.ca/2012/05/installing-redis-on-mac-os-x/)


## Инструкция по запуску

```ruby
bundle install
rake db:create db:migrate db:seed
bundle exec rails s
```
