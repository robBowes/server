import { fail, type Actions, redirect } from '@sveltejs/kit';
import { db } from '../lib/db/connection';
import { createHash } from 'node:crypto';

export const load = async () => {
	// const tables = await db.introspection.getTables({ withInternalKyselyTables: true });

	console.log(createHash('sha256').update('This1thing').digest('hex'));
};

export const actions = {
	async login({ request, cookies }) {
		const data = await request.formData();

		const entries = Object.fromEntries(data.entries());

		if (!entries.email) {
			return fail(400, { email: 'Email is required' });
		}

		if (!entries.password || typeof entries.password !== 'string') {
			return fail(400, { message: 'Password is required' });
		}

		const user = await db
			.selectFrom('user')
			.where('email', '=', entries.email)
			.where('password', '=', createHash('sha256').update(entries.password).digest('hex'))
			.selectAll()
			.executeTakeFirst();

		if (!user) {
			return fail(401, { message: 'invalid credentials' });
		}

		const session = await db
			.insertInto('session')
			.values({
				user_id: user.id
			})
			.returningAll()
			.executeTakeFirstOrThrow();

		cookies.set('session_id', session.id, {
			httpOnly: true,
			path: '/'
		});

		throw redirect(302, '/dashboard');
	}
} satisfies Actions;
