# Facebook Replica

This is an excercise building a clone of some of Facebook's features using Ruby on Rails.
  
## Demo

Herouku link // later.
  
## Features

- **Users**
  - Sign-up / login / logout.
  - Show profile page.
  - Create / update / delete posts.
  - Has many posts.

- **Posts**
  - Create / update / delete.
  - Show in chronological update order.
  - Belongs to a User.

- **Comments**
  - Create / update / delete.

- **Likes**
  - Like / unlike comments and/or posts.

- **Friendships**
  - Send / Accept a friend request.
  - Remove existing friends.
  - Feed with posts from yourself and friends only.

- **Notificaions**
  - Recieve a notification for :
    - Comments on your posts.
    - Likes for your comments / posts.
    - Friendship requests and acceptance.

## Entity Relationship Diagram (ERD)

![alt text](docs/facebook_replica_ERD.jpeg)

## Local Installation

### Requirements

- Ruby '2.6.0'
- Bundler
- Rails 5.2.3
- Postgresql

### Getting Started

Clone the repo and then install the needed gems:

```console
 $ bundle install --without production
```

Migrate the database:

```console
 $ rails db:migrate
```

Populate the database:

```console
 $ rails db:seed
```

You'll be ready to run the app in a local server:

```console
 $ rails server
```

Visit <http://localhost:3000/>
