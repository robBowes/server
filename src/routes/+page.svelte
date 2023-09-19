<script lang="ts">
	import Login from '$lib/components/Login.svelte';
</script>

<Login />

<style>
	:global(*) {
		box-sizing: border-box;
		font-family: 'DM Sans', sans-serif;
	}

	:global(html, body) {
		height: 100%;
	}

	:global(body) {
		margin: 0;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}

	:global(input) {
		border: 1px solid #ccc;
		border-radius: 4px;
		padding: 4px;
	}
</style>
