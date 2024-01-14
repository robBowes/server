<script lang="ts">
	import { createLabel, melt } from '@melt-ui/svelte';

	const {
		elements: { root }
	} = createLabel();

	export let name: string;
	export let label: string;
	export let type: 'text' | 'password' = 'text';
	export let error: string | undefined = undefined;
</script>

<div class="wrapper">
	{#if type === 'password'}
		<label for={name} use:melt={$root}>{label}</label>
		<input type="password" id={name} {name} />
	{:else}
		<label for={name} use:melt={$root}>{label}</label>
		<input type="text" id={name} {name} />
	{/if}

	<div class="error" class:visible={!!error}>
		{error}
	</div>
</div>

<style>
	.wrapper {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
	}
	label {
		display: block;
		margin-bottom: 4px;
	}

	.error {
		color: red;
		font-size: 12px;
		height: 12px;
		visibility: hidden;
	}

	.error.visible {
		visibility: visible;
	}
</style>
