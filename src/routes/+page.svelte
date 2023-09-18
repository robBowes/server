<h1>Welcome</h1>

<form method="post" action="?/login">
	<input type="hidden" name="_csrf" value="todo" />
	<div>
		<label for="username">Username</label>
		<input type="text" id="username" name="username" required />
	</div>

	<div>
		<label for="password">Password</label>
		<input type="password" id="password" name="password" required />
	</div>

	<button type="submit">Login</button>
</form>
