import { fail, type Actions, redirect } from '@sveltejs/kit';
import { auth } from 'db';

export const load = async ({ cookies }) => {
	const sessionId = cookies.get('session_id');

	if (sessionId) {
		const session = await auth.getSession(sessionId);

		if (session) {
			throw redirect(302, '/dashboard');
		}
	}
};

export const actions = {
	async login({ request, cookies }) {
		const data = await request.formData();

		const entries = Object.fromEntries(data.entries());

		if (!entries.email || typeof entries.email !== 'string') {
			return fail(400, { email: 'Email is required' });
		}

		if (!entries.password || typeof entries.password !== 'string') {
			return fail(400, { message: 'Password is required' });
		}

		const user = await auth.validatePassword(entries.email, entries.password);

		if (!user) {
			return fail(401, { message: 'invalid credentials' });
		}

		const session = await auth.createSession(user.id);

		cookies.set('session_id', session.id, {
			httpOnly: true,
			path: '/'
		});

		throw redirect(302, '/dashboard');
	}
} satisfies Actions;
