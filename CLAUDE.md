# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **pnpm monorepo** using **Turborepo** for build orchestration. The project combines a SvelteKit frontend with a PostgreSQL database, using Kysely as the type-safe SQL query builder. The repository is configured for NixOS/WSL development with flakes enabled.

## Monorepo Structure

- **`apps/dashboard/`** - SvelteKit application using Svelte 4, TypeScript, and Vite
- **`packages/db/`** - Shared database package with Kysely migrations and data access layer

The `db` package is consumed by the dashboard app as a workspace dependency (`"db": "workspace:*"`).

## Development Commands

### Initial Setup
```bash
pnpm install                    # Install all dependencies across workspace
```

### Database Operations
```bash
# In packages/db/
pnpm migrate:up                 # Run Kysely migrations to latest
pnpm typegen                    # Generate TypeScript types from database schema
pnpm check                      # TypeScript type checking

# Environment variable needed:
export CONNECTION_STRING="pgsql://user:pass@localhost:5432/pgsql"
```

### Development Workflow
```bash
# Root commands (use Turbo to run across all packages):
pnpm dev                        # Start all dev servers in watch mode
pnpm build                      # Build all packages and apps
pnpm lint                       # Lint all packages
pnpm check                      # Type-check all packages
pnpm format                     # Format code with Prettier

# Dashboard-specific (in apps/dashboard/):
pnpm dev                        # Start SvelteKit dev server
pnpm build                      # Build for production
pnpm preview                    # Preview production build
pnpm test                       # Run all tests
pnpm test:unit                  # Run Vitest unit tests
pnpm test:integration           # Run Playwright e2e tests
```

### Docker & Infrastructure
```bash
# Local development database:
docker-compose -f docker-compose.local.yml up

# Production stack (PostgreSQL + SvelteKit + Caddy):
docker-compose -f docker-compose.production.yml up

# Database runs on port 5432, SvelteKit on port 8001 (proxied), Caddy on 80/443
```

### Nix Development
The repo uses **direnv** with a Nix flake. The `.envrc` auto-loads the Nix shell environment.

```bash
# If not using direnv, manually enter shell:
nix develop                     # Use flake-based dev environment
```

Nix provides: Node.js 24, PostgreSQL 15, pnpm, tmux, Docker, Caddy, WireGuard tools, GitHub CLI (gh).

## Architecture Notes

### Database Layer (`packages/db/`)

- **Kysely** is used for type-safe database queries (not an ORM)
- Migrations are in `src/migrations/` numbered sequentially (e.g., `0-add-user-table.ts`)
- Database types are auto-generated via `kysely-codegen` - run `pnpm typegen` after schema changes
- Connection string defaults to `pgsql://user:pass@localhost:5432/pgsql` (override with `CONNECTION_STRING` env var)
- Data access layer exports from `src/data-access/index.ts` (currently exposes `auth` module)

**Important**: After changing migrations, always run:
1. `pnpm migrate:up` to apply changes
2. `pnpm typegen` to regenerate types
3. Commit the generated types

### SvelteKit App (`apps/dashboard/`)

- Uses **SvelteKit 1.x** with **Vite 4** and **TypeScript**
- **adapter-node** for production builds (not adapter-auto)
- Sass preprocessing enabled via `svelte-preprocess`
- UI components use **Melt UI** (headless component library)
- Route structure includes grouped routes: `(authed)/dashboard/` for protected pages
- Server-side logic in `+page.server.ts` files (SvelteKit convention)

### Build Pipeline

Turbo handles cross-package dependencies:
- `build` tasks depend on upstream `^build` (builds dependencies first)
- `dev` tasks run in persistent mode without caching
- Outputs cached: `.svelte-kit/`, `build/`

### WireGuard Scripts

The repo includes VPN setup scripts (`setup-wire-guard.sh`, `add-client.sh`, etc.) for server deployment - these are infrastructure utilities, not part of the app logic.

## Package Manager

**pnpm 8.9.0** is required (`packageManager` field enforces this). Node.js >=18 required.

## Testing Strategy

- **Unit tests**: Vitest (run individual tests with `vitest <file>`)
- **E2E tests**: Playwright
- Test configuration in `playwright.config.ts` at root

## CI/CD

GitHub Actions workflow (`.github/workflows/ci.yml`) runs on main branch pushes and PRs:
1. Installs pnpm 8 and Node 20
2. Runs `pnpm build`
3. Runs `pnpm test`

No remote Turbo cache configured currently.

## Environment Variables

Key variables to set:
- `CONNECTION_STRING` - PostgreSQL connection string (used by db package)
- `PASS` - PostgreSQL password (used in docker-compose.production.yml)

## Common Patterns

### Adding a Database Table
1. Create migration in `packages/db/src/migrations/` (increment number)
2. Implement `up()` and `down()` functions
3. Run `pnpm migrate:up` in db package
4. Run `pnpm typegen` to update types
5. Add data access methods in `packages/db/src/data-access/`

### Adding a Dashboard Route
1. Create `+page.svelte` in `apps/dashboard/src/routes/`
2. Add server logic in `+page.server.ts` if needed
3. Import db data access: `import { auth } from 'db'`
4. Use Melt UI for interactive components

### Running Single Package Commands
```bash
# Use pnpm filter to target specific workspace:
pnpm --filter dashboard dev
pnpm --filter db migrate:up
```
