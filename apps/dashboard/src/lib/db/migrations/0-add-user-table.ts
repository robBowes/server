import { sql, type Kysely } from 'kysely';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function up(db: Kysely<any>): Promise<void> {
	//add the uuid extension
	await sql`CREATE EXTENSION IF NOT EXISTS "uuid-ossp"`.execute(db);

	db.schema
		.createTable('user')
		.addColumn('id', 'uuid', (col) => col.primaryKey().defaultTo(sql`uuid_generate_v4()`))
		.addColumn('name', 'text')
		.addColumn('email', 'text', (col) => col.notNull().unique())
		.addColumn('password', 'text')
		.addColumn('created_at', 'timestamp')
		.addColumn('updated_at', 'timestamp')
		.addColumn('deleted_at', 'timestamp')
		.execute();
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function down(db: Kysely<any>): Promise<void> {
	//drop the uuid extension
	await sql`DROP EXTENSION IF EXISTS "uuid-ossp"`.execute(db);

	db.schema.dropTable('user').execute();
}
