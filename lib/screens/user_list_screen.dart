import 'package:flutter/material.dart';
import 'package:users_app_sql/controllers/user_controller.dart';
import 'package:users_app_sql/models/user_model.dart';
import 'user_form_screen.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
	const UserListScreen({Key? key}) : super(key: key);

	@override
	State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
	final UserController _controller = UserController();
	late Future<List<User>> _usersFuture;

	@override
	void initState() {
		super.initState();
		_loadUsers();
	}

	void _loadUsers() {
		setState(() {
			_usersFuture = _controller.getAllUsers();
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Colors.purple,
				elevation: 0,
				title: const Text('Lista de usuarios'),
				centerTitle: true,
			),
			body: FutureBuilder<List<User>>(
				future: _usersFuture,
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return const Center(child: CircularProgressIndicator());
					}
					if (snapshot.hasError) {
						return Center(child: Text('Error: \\${snapshot.error}'));
					}
					final users = snapshot.data ?? [];
					if (users.isEmpty) {
						return Center(
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: const [
									Icon(Icons.person_off, size: 48, color: Colors.grey),
									SizedBox(height: 8),
									Text('No hay usuarios', style: TextStyle(color: Colors.grey)),
								],
							),
						);
					}
					return ListView.builder(
						itemCount: users.length,
						itemBuilder: (context, index) {
							final user = users[index];
							return ListTile(
								title: Text(user.name),
								subtitle: Text(user.email),
								onTap: () async {
									final result = await Navigator.push<bool?>(
										context,
										MaterialPageRoute(
											builder: (_) => UserDetailScreen(user: user),
										),
									);
									if (result == true) _loadUsers();
								},
								trailing: IconButton(
									icon: const Icon(Icons.edit),
									onPressed: () async {
										final result = await Navigator.push<bool?>(
											context,
											MaterialPageRoute(
												builder: (_) => UserFormScreen(user: user),
											),
										);
										if (result == true) _loadUsers();
									},
								),
							);
						},
					);
				},
			),
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.add),
				onPressed: () async {
					final result = await Navigator.push<bool?>(
						context,
						MaterialPageRoute(builder: (_) => const UserFormScreen()),
					);
					if (result == true) _loadUsers();
				},
			),
		);
	}
}

