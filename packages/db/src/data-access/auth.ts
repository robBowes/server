import type { Kysely } from 'kysely';
import type { DB } from 'kysely-codegen';
import { createHash } from 'node:crypto';

export class Auth {
	private db: Kysely<DB>;
	constructor(db: Kysely<DB>) {
		this.db = db;
	}

	public async getSession(sessionId: string) {
		return this.db.selectFrom('session').where('id', '=', sessionId).selectAll().executeTakeFirst();
	}

	public async validatePassword(email: string, password: string) {
		return this.db
			.selectFrom('user')
			.where('email', '=', email)
			.where('password', '=', createHash('sha256').update(password).digest('hex'))
			.selectAll()
			.executeTakeFirst();
	}

	public async createSession(userId: string) {
		return this.db
			.insertInto('session')
			.values({
				user_id: userId
			})
			.returningAll()
			.executeTakeFirstOrThrow();
	}
}
