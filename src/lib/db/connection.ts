import pg from 'pg';
import { Kysely, PostgresDialect } from 'kysely';
console.log(process.env.CONNECTION_STRING);

const pool = new pg.Pool({
	connectionString: process.env.CONNECTION_STRING || 'pgsql://user:pass@localhost:5432/pgsql'
});

export const db = new Kysely({
	dialect: new PostgresDialect({
		pool
	})
});
