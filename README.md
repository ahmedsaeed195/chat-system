# README

## Table of Contents

- [Introduction](#introduction)
- [Application info](#application-info)
- [System Dependencies](#system-dependencies)
- [Getting Started](#getting-started)
- [API Endpoints](#api-endpoints)

## Introduction

This is a chat system that has the ability to create multiple applications, each application has the ability to create multiple chat rooms and store messages for each room.

## Application info

ruby version: `2.6.10` <br/>
rails version: `5.2.8`

A list of all of the application dependencies can be found inside `Gemfile`

## System Dependencies

This app got some system dependencies in order to run properly:

1. Node.js (rails requirement)
2. Yarn (rails requirement)
3. MySQL (main DB)
4. Elasticsearch (for message search query)

## Getting started

### 1. Docker

Just run:

```
docker-compose up
```

and the server should be up and running on port `3000`

### 2. No Docker

After cloning the application, simply run:

```
bundle install
```

This command will make sure to install the dependencies in the `Gemfile` to get the ready.

Next you need to make sure that MySQL and Elasticsearch are workig and set the database using:

```
rails db:create //to create the database
rails db:migrate //to run the migrations
```

Finally run :

```
rails server
```

this will instantly run the servers on a default port of 3000 if everything is fine. <br/>

## API Endpoints

Rails cli has a really useful tool to see all the available routes in the app, simply run :

```
rails routes
```

and a list of all avaible routes will be displayed.

Currently the API is split into 3 nested routes:

1. [Application](#application)
2. [Chat](#chat)
3. [Message](#message)

### Application:

| Method   | URL                   | Body           | Description                                   |
| -------- | --------------------- | -------------- | --------------------------------------------- |
| `Get`    | `/application`        | none           | retrieve a list of all available applications |
| `Get`    | `/application/:token` | none           | retrieve an application by its token          |
| `Post`   | `/application`        | `name`: string | create a new application                      |
| `Put`    | `/application/:token` | `name`: string | edit an application's name                    |
| `Delete` | `/application/:token` | none           | delete an application                         |

### Chat:

This route is nested inside the application route, so all chat endpoints must be preceded with the application route, for example: `/application/:application_token/chat`

| Method   | URL         | Body                                         | Description                                 |
| -------- | ----------- | -------------------------------------------- | ------------------------------------------- |
| `Get`    | `/chat`     | none                                         | retrieve a list of all available chats      |
| `Get`    | `/chat/:no` | none                                         | retrieve an chat by its number              |
| `Post`   | `/chat`     | none                                         | create a new chat                           |
| `Put`    | `/chat/:no` | `number`: integer, <br/> `app_token`: string | edit an chat's number or parent application |
| `Delete` | `/chat/:no` | none                                         | delete a chat                               |

### Message:

This route is nested inside the chat route, so all message endpoints must be preceded with the chat route, for example: `/application/:application_token/chat/:chat_no/message`

| Method   | URL                        | Body                                      | Description                                              |
| -------- | -------------------------- | ----------------------------------------- | -------------------------------------------------------- |
| `Get`    | `/message`                 | none                                      | retrieve a list of all available messages                |
| `Get`    | `/message/:message_no`     | none                                      | retrieve a messages by its number                        |
| `Get`    | `/message/search?content=` | none                                      | retrieve a list all messages that match the search query |
| `Post`   | `/message`                 | `sender`: string, <br/> `content`: string | create a new message                                     |
| `Put`    | `/message/:message_no`     | `content`: string                         | edit a message's content                                 |
| `Delete` | `/message/:message_no`     | none                                      | delete a message                                         |
