<script lang="ts">
</script>

<main>
	<nav>
		<ul>
			<li><a href="/dashboard">Home</a></li>
			<li><a href="/dashboard">Settings</a></li>
		</ul>
	</nav>
	<section class="content">
		<!-- <slot /> -->
	</section>
</main>

<style>
	h1 {
		font-size: 2rem;
		font-weight: 500;
		padding: 16px;
	}
	nav {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 16px;
	}

	main {
		display: grid;
		grid-template-columns: minmax(200px, 1fr) 3fr;
		max-width: 1200px;
		margin: 64px auto 0;
	}
</style>
