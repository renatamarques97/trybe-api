# Trybe API

[![Build Status](https://circleci.com/gh/renatamarques97/trybe-api.svg?style=svg)](https://app.circleci.com/pipelines/github/renatamarques97/trybe-api)

### Ruby version
```
2.7.1
```

### Rails version
```
6.1.1
```

### Configuration
```shell
bundle install
yarn install
```

### Database creation
```shell
bundle exec rails db:create
bundle exec rails db:migrate
```

### Initialize postgres
```shell
pg_ctl start
```

### How to run the test suite
```shell
bundle exec rspec
```

### Run the server
```shell
bundle exec rails s
```

See `http://localhost:3000/`

## Documentation

#### POST /users
- Action: ___/registrations#create___
- Required fields:
  - ___email___ (String) - must be unique
  - ___password___ (String)
	- ___displayName___ (String)
- Optional fields:
	- ___image___ (String)
- Request body:
	```json
  {
    "user": {
      "email": "user@email.com",
      "password": 123456,
      "displayName": "User name",
      "image": "http://4.bp.blogspot.com/_YA50adQ-7vQ/S1gfR_6ufpI/AAAAAAAAAAk/1ErJGgRWZDg/S45/brett.png"
    }
  }
  ```
- Expected response: 200
	```json
  "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6OSwiZXhwIjoxNjE1MTY4ODczfQ.qdegHjiMVknZp0bBbdvq0XdwN75sVoWGwH1rtCfCOiY"
	```
- Invalid body:
  ```json
  {
    "email": "user@email.com",
    "password": 123456,
    "displayName": "",
    "image": "http://4.bp.blogspot.com/_YA50adQ-7vQ/S1gfR_6ufpI/AAAAAAAAAAk/1ErJGgRWZDg/S45/brett.png"
  }
  ```
- Expected response: 422
  ```json
  {
    "errors": {
        "email or password": [
            "is invalid"
        ]
    }
  }
  ```

#### GET /users
- Action: ___users#index___
- Header: Authorization => token
- Expected response: 200
	```json
	[
    {
        "id": 1,
        "displayName": "Brett Wiltshire",
        "email": "brett@email.com",
        "image": "http://4.bp.blogspot.com/_YA50adQ-7vQ/S1gfR_6ufpI/AAAAAAAAAAk/1ErJGgRWZDg/S45/brett.png"
    },
    {
        "id": 2,
        "displayName": "Renata",
        "email": "renata@email.com",
        "image": "http://4.bp.blogspot.com/_YA50adQ-7vQ/S1gfR_6ufpI/AAAAAAAAAAk/1ErJGgRWZDg/S45/brett.png"
    },
	]
	```

- Request with invalid or expired token:
  ```json
  {
    "message": "Token invalid or expired"
  }
  ```

#### GET /users/:user_id
- Action: ___users#show___
- Header: Authorization => token
- Expected response: 200
	```json
    {
        "id": 2,
        "displayName": "Renata",
        "email": "renata@email.com",
        "image": "http://4.bp.blogspot.com/_YA50adQ-7vQ/S1gfR_6ufpI/AAAAAAAAAAk/1ErJGgRWZDg/S45/brett.png"
    }
	```

- Request with invalid or expired token:
  ```json
  {
    "message": "Token invalid or expired"
  }
  ```

#### POST /users/sign_in
- Action: ___sessions#create___
- Header: Authorization => token
- Required fields:
	- ___email___ (String)
	- ___password___ (String)
- Request body:
	```json
	{
    "user": {
      "email": "brett@email.com",
      "password": "123456"
	  }
  }
	```
- Expected response: 200
	```json
  "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6OCwiZXhwIjoxNjE1MDkzNTkwfQ.zKhRep1E4USC4Pj1csQYHn-Y9Dy9DjFODpZ2sq8hhlk"
	```

- Request with invalid or expired token:
  ```json
  {
    "message": "Token invalid or expired"
  }
  ```

#### DELETE /users/me
- Action: ___users#destroy___
- Header: Authorization => token
- Expected response: 204
	```json
	```

- Request with invalid or expired token:
  ```json
  {
    "message": "Token invalid or expired"
  }
  ```

#### POST /posts
- Action: ___posts#create___
- Header: Authorization => token
- Required fields:
	- ___title___ (String)
	- ___content___ (String)
- Request body:
	```json
  {
    "title": "post title",
    "content": "content text"
  }
	```
- Expected response: 200
	```json
  {
    "title": "post title",
    "content": "content text",
    "user_id": 1
  }
	```

- Request with invalid or expired token:
  ```json
  {
    "message": "Token invalid or expired"
  }
  ```

#### PUT/PATCH /posts/:post_id
- Action: ___posts#update___
- Header: Authorization => token
- Required fields:
	- ___title___ (String)
   or
  - ___content___ (String)
- Request body:
	```json
	{
	  "post": {
      "title": "edited test"
	  }
  }
	```
- Expected response: 200
	```json
  {
    "title": "edited test",
    "content": "test"
  }
	```

- Request with invalid or expired token:
  ```json
  {
    "message": "Token invalid or expired"
  }
  ```

#### GET /posts/:post_id
- Action: ___posts#show___
- Header: Authorization => token
- Expected response:
	```json
	{
    "id": 3,
    "title": "edited test",
    "content": "test",
    "user_id": 8
  }
	```
- Request with invalid or expired token:
  ```json
  {
    "message": "Token invalid or expired"
  }
  ```

#### DELETE /posts/:post_id
- Action: ___posts#destroy___
- Header: Authorization => token
- Expected response: 204
	```json
	```

- Request with invalid or expired token:
  ```json
  {
    "message": "Token invalid or expired"
  }
  ```

### Author

[Renata Marques](https://www.linkedin.com/in/renata-marques-b27877119/)
