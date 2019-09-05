# Facebook Replica

  
## Demo
Herouku link // later
  
## Features
  - **User**
    - Sign-up / login / logout
    - Show profile page
    - Create / update / delete posts
    - Has many posts

  - **Post**
    - Create / update / delete
    - Show in chronological update order
    - Belongs to a User

## Local Installation

### Requirements
- Ruby '2.6.0'
- Bundler
- Rails 5.2.3
- Postgresql

### Getting Started

Clone the repo and then install the needed gems:

```console
 bundle install --without production
```

Migrate the database:

```console
 rails db:migrate
```

Populate the database:

```console
 rails db:seed
```

You'll be ready to run the app in a local server:

```console
 rails server
```
Visit http://localhost:3000/

## Authors 

**[Quynh Yen Vo T.](https://github.com/themonster2015)**

**[Nazeh](https://github.com/Nazeh)**
