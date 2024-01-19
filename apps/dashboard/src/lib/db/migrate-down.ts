import * as path from 'path';
import pg from 'pg';
import { promises as fs } from 'fs';
import { Kysely, Migrator, PostgresDialect, FileMigrationProvider } from 'kysely';

const pool = new pg.Pool({
	connectionString: process.env.CONNECTION_STRING || 'pgsql://user:pass@localhost:5432/pgsql'
});

const __dirname = path.dirname(new URL(import.meta.url).pathname);

async function migrateToLatest() {
	const db = new Kysely<unknown>({
		dialect: new PostgresDialect({
			pool
		})
	});

	const migrator = new Migrator({
		db,
		provider: new FileMigrationProvider({
			fs,
			path,
			// This needs to be an absolute path.
			migrationFolder: path.join(__dirname, 'migrations')
		})
	});

	const { error, results } = await migrator.migrateDown();

	results?.forEach((it) => {
		if (it.status === 'Success') {
			console.log(`migration "${it.migrationName}" was executed successfully`);
		} else if (it.status === 'Error') {
			console.error(`failed to execute migration "${it.migrationName}"`);
		}
	});

	if (error) {
		console.error('failed to migrate');
		console.error(error);
		process.exit(1);
	}

	await db.destroy();
}

migrateToLatest();
