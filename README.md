# Chat System API _Backend Challenge_

The system allows the creation of new applications

- Each application will have
  - a token(generated by the system)
  - a name(provided by the client).
- Each application can have many chats.
- Each chat should have a number.
  - The number of the chat should be returned in the chat creation request.
- Each chat contains messages
- Each message have number.
  - The number of the message should be returned in the message creation request.
- The client should never see the ID of any of the entities.
- The client identifies
  - the application by its token and
  - the chat by its number along with the application token.

## Environment

- Mysql 5.7.38
- Ruby 2.6.3
- Rails 5.2.8
- Elasticsearch 7.17.4
- Redis 4.0.9
- Sidekiq 6.5.0

## Start Application

1. Clone repository
   ```bash
        git clone https://github.com/EngHamda/chat-system-api-challenge.git chat_system_api
   ```
2. Install bundles
   ```bash
        cd chat_system_api
        bundle install
   ```
3. Update database username & password in **config/database.yml**
4. Create database
   ```bash
        rake db:create
        rails db:migrate
   ```
5. Make sure services are running

- Ruby on rails server
  ```bash
        rails s
        # http://localhost:3000
  ```
- Elasticsearch service
  ```bash
        sudo systemctl start elasticsearch.service
        # http://localhost:9200
  ```
- Redis service
  ```bash
        sudo systemctl start redis.service
        # http://localhost:9200
  ```
- Sidekiq service
  ```bash
        sidekiq
        #OR
        REDIS_URL="redis://127.0.0.1:6379/12" bundle exec sidekiq -e development -C config/sidekiq.yml
        #OR
        # sidekiq -c 1
  ```

6. Create Index Message
   ```bash
        rake searchkick:reindex CLASS=Message
   ```

## Appilcation endpoints

| Action                                       | Request Type | URI                                                                             |
| -------------------------------------------- | ------------ | ------------------------------------------------------------------------------- |
| _create application_                         | POST         | **/api/v1/applications**                                                        |
| _show application_                           | GET          | **/api/v1/applications/:token**                                                 |
| _update application_                         | PUT          | **/api/v1/applications/:token**                                                 |
|                                              |              |                                                                                 |
| _create chat_                                | POST         | **/api/v1/applications/:application_token/chats**                               |
| _show chat_                                  | GET          | **/api/v1/applications/:application_token/chats/:number**                       |
|                                              |              |                                                                                 |
| _create message_                             | POST         | **/api/v1/applications/:application_token/chats/:chat_number/messages**         |
| _show message_                               | GET          | **/api/v1/applications/:application_token/chats/:chat_number/messages/:number** |
| _update message_                             | PUT          | **/api/v1/applications/:application_token/chats/:chat_number/messages/:number** |
| _search through messages in a specific chat_ | GET          | **/api/v1/applications/:application_token/chats/:number/search**                |

### TODO

1. Using Docker
2. Refactor handle error code
   instead of using if else use ApiExceptions. See [Handle Error Ref.]
3. Log requests and errors in file. See [Log Ref.]
4. Refactor elasticsearch query.
   result should be partially match messages’ bodies for specific chat not for all chats.
5. Refactor JSON response structure according [JSON:API]
6. Get nested JSON response
   Note:I use nested attribute for application model, chats model but don't get nested JSON
7. Using Golang

[//]: # "These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax"
[handle error ref.]: https://www.thegreatcodeadventure.com/rails-api-painless-error-handling-and-rendering-2/
[log ref.]: https://stackify.com/rails-logger-and-rails-logging-best-practices/
[json:api]: https://jsonapi.org/
