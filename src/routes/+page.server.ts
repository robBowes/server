import type { Actions } from '@sveltejs/kit';

export const actions = {
	async login({ request }) {
		const data = await request.formData();

		console.log(Object.fromEntries(data.entries()));
	}
} satisfies Actions;
