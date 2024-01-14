import { db } from '$lib/db/connection';
import { redirect } from '@sveltejs/kit';

export const load = async ({ cookies }) => {
	const session_id = cookies.get('session_id');

	if (!session_id) {
		throw redirect(302, '/');
	}
	const session = await db
		.selectFrom('session')
		.where('id', '=', session_id)
		.selectAll()
		.executeTakeFirst();

	if (!session) {
		throw redirect(302, '/');
	}

	return { session };
};
