import { auth } from 'db';
import { redirect } from '@sveltejs/kit';

export const load = async ({ cookies }) => {
	const sessionId = cookies.get('session_id');

	if (!sessionId) {
		throw redirect(302, '/');
	}
	const session = await auth.getSession(sessionId);

	if (!session) {
		throw redirect(302, '/');
	}

	return { session };
};
