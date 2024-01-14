<script lang="ts">
	import { enhance } from '$app/forms';
	import Input from './Input.svelte';

	export let form: import('../../routes/$types').ActionData;
</script>

<div class="left-side">
	<h1>Welcome</h1>
</div>

<form method="post" action="?/login" use:enhance>
	<input type="hidden" name="_csrf" value="todo" />
	<div class="login-fields">
		<Input name="email" label="Login:" error={form?.email} />
		<Input name="password" label="Password:" type="password" />
	</div>

	<button type="submit">Login</button>
</form>

<style>
	form {
		display: flex;
		flex-direction: column;
		align-items: center;
	}
	.login-fields {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8px;
		margin-bottom: 32px;
	}
</style>
