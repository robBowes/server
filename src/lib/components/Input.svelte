<script lang="ts">
	import { createLabel, melt } from '@melt-ui/svelte';

	const {
		elements: { root }
	} = createLabel();

	export let name: string;
	export let label: string;
	export let type: 'text' | 'password' = 'text';
</script>

{#if type === 'password'}
	<div class="wrapper">
		<label for={name} use:melt={$root}>{label}</label>
		<input type="password" id={name} />
	</div>
{:else}
	<div class="wrapper">
		<label for={name} use:melt={$root}>{label}</label>
		<input type="text" id={name} />
	</div>
{/if}

<style>
	.wrapper {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
	}
</style>
