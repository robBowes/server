import pg from 'pg';
import { Kysely, PostgresDialect } from 'kysely';
import type { DB } from 'kysely-codegen';

const pool = new pg.Pool({
	connectionString: process.env.CONNECTION_STRING || 'pgsql://user:pass@localhost:5432/pgsql'
});

// eslint-disable-next-line @typescript-eslint/no-explicit-any
let db: Kysely<DB>;

try {
	db = new Kysely({
		dialect: new PostgresDialect({
			pool
		})
	});
} catch (error) {
	console.error(error);
}

export { db };
