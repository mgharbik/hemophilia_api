# Patient Injection API

## Overview

This API allows Hemophilia patients to maintain a digital diary of their prophylactic injections and view their treatment adherence score.


## Features

- Create patients with a secure API key
- Add and list injections per patient
- Retrieve adherence score based on expected injection schedule
- Authentication with JWT token
- Tested with RSpec (models, controllers, services)


## Requirements

- Docker and Docker Compose installed


## Setup & Run

1. Clone the repo

   ```bash
   git clone https://github.com/mgharbik/hemophilia_api.git
   cd hemophilia_api

2. Build and start the containers

   ```bash
   docker-compose up --build

3. Setup the database

   ```bash
   docker-compose run --rm api bin/rails db:create db:migrate

4. The API will be accessible at http://localhost:3000

5. Stopping the application

   ```bash
   docker-compose down --volumes --remove-orphans

4. Run all tests

   ```bash
   docker-compose run --rm -e "RAILS_ENV=test" api bundle exec rspec


## API Usage Examples


- Create a patient

   ```bash
   curl -X POST http://localhost:3000/patients -H "Content-Type: application/json" -d '{"treatment_interval_days":3}'

    =>

    {
      "id": 1,
      "treatment_interval_days": 3,
      "token": "<jwt_token_here>"
    }

-  Add an injection

   ```bash
   curl -X POST http://localhost:3000/injections \
    -H "Authorization: Bearer <jwt_token_here>" \
    -H "Content-Type: application/json" \
    -d '{
      "injection": {
        "dose": 5.0,
        "lot_number": "ABC123",
        "drug_name": "Factor VIII",
        "injected_at": "2025-01-01T10:00:00Z"
      }
    }'

    =>

    {
      "id": 1,
      "dose": 5.0,
      "lot_number": :"ABC123",
      "drug_name": "Factor VIII",
      "injected_at": "2025-07-03T15:00:00.000Z"
    }

- List injections

   ```bash
   curl -H "Authorization: Bearer <jwt_token_here>" http://localhost:3000/injections

- Get adherence score

   ```bash
   curl -H "Authorization: Bearer <jwt_token_here>" http://localhost:3000/adherence_score

    =>

    {
      "expected_injections": 11,
      "actual_injections": 11,
      "on_time_injections": 8,
      "adherence_score": 73
    }
