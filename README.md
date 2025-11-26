# Rails API Template

A modern Rails 8.1 API template with PostgreSQL, RSpec testing, and Docker support.

## Prerequisites

- Ruby 3.2.2
- Docker and Docker Compose (optional)

### Verify Requirements

Before getting started, run the verification script to check if all requirements are met:

```bash
bin/verify
```

This script will check for:
- Ruby version 3.2.2
- Bundler installation
- Docker and Docker Compose (optional)
- PostgreSQL (optional if using Docker)

## Getting Started

### Using Docker

1. **Start the services**
   ```bash
   docker-compose up -d
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup the database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the Rails server**
   ```bash
   rails server
   ```

The API will be available at `http://localhost:3000`

**Database Management UI**: Adminer is available at `http://localhost:8080`
- System: PostgreSQL
- Server: db
- Username: postgres
- Password: postgres
- Database: inventory

## Docker Commands

### Start services
```bash
docker-compose up --build
```

### Stop services
```bash
docker-compose down
```

### Remove all containers and volumes
```bash
docker-compose down -v
```

## Database Commands

### Create database
```bash
rails db:create
```

### Run migrations
```bash
rails db:migrate
```

### Rollback last migration
```bash
rails db:rollback
```

### Seed database
```bash
rails db:seed
```

### Reset database (drop, create, migrate, seed)
```bash
rails db:reset
```

### Drop database
```bash
rails db:drop
```

## Testing with RSpec

### Run all tests
```bash
bundle exec rspec
```

### Run specific test file
```bash
bundle exec rspec spec/models/user_spec.rb
```

### Run specific test
```bash
bundle exec rspec spec/models/user_spec.rb:10
```

### Run tests with documentation format
```bash
bundle exec rspec --format documentation
```

### Generate test coverage report
```bash
COVERAGE=true bundle exec rspec
```

## Rails Console

### Open console
```bash
rails console
```

### Open console in sandbox mode (rollback changes on exit)
```bash
rails console --sandbox
```

## Routes

### List all routes
```bash
rails routes
```

### Search for specific routes
```bash
rails routes | grep users
```


## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_HOST` | Database host | localhost |
| `DB_PORT` | Database port | 5432 |
| `DB_USERNAME` | Database username | postgres |
| `DB_PASSWORD` | Database password | postgres |
| `DB_NAME` | Database name | inventory |
| `RAILS_MAX_THREADS` | Max database connections | 5 |

## Project Structure

```
.
├── app/              # Application code (models, controllers, etc.)
├── config/           # Configuration files
├── db/               # Database migrations and seeds
├── spec/             # RSpec tests
├── docker-compose.yml # Docker services configuration
├── Dockerfile        # Production Docker image
└── Gemfile           # Ruby dependencies
```
