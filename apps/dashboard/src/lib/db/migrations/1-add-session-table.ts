import { sql, type Kysely } from 'kysely';

// adds a session table to track user sessions

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function up(db: Kysely<any>): Promise<void> {
	db.schema
		.createTable('session')
		.addColumn('id', 'uuid', (col) => col.primaryKey().defaultTo(sql`uuid_generate_v4()`))
		.addColumn('user_id', 'uuid', (col) => col.references('user.id').notNull())
		.addColumn('created_at', 'timestamp')
		.addColumn('updated_at', 'timestamp')
		.addColumn('deleted_at', 'timestamp')
		.execute();
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export async function down(db: Kysely<any>): Promise<void> {
	db.schema.dropTable('session').execute();
}
