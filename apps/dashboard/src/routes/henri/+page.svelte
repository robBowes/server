<script lang="ts">
	let backgroundColour = '#fff';

	function handleClick() {
		backgroundColour = `#${Math.floor(Math.random() * 16777215).toString(16)}`;
	}
</script>

<div class="canvas" style:background-color={backgroundColour} on:click={handleClick} />

<style>
	.canvas {
		width: 100%;
		height: 100vh;
	}
</style>
