import type { Actions } from '@sveltejs/kit';
import { db } from '../lib/db/connection';

export const load = async () => {
	const tables = await db.introspection.getTables({ withInternalKyselyTables: true });

	console.log(tables);
};

export const actions = {
	async login({ request }) {
		const data = await request.formData();

		console.log(Object.fromEntries(data.entries()));
	}
} satisfies Actions;
