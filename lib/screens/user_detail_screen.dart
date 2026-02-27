import 'package:flutter/material.dart';
import 'package:users_app_sql/controllers/user_controller.dart';
import 'package:users_app_sql/models/user_model.dart';
import 'user_form_screen.dart';

class UserDetailScreen extends StatelessWidget {
	final User user;
	const UserDetailScreen({Key? key, required this.user}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		final UserController _controller = UserController();

		Future<void> _delete() async {
			if (user.id == null) return;
			final confirmed = await showDialog<bool?>(
				context: context,
				builder: (context) => AlertDialog(
					title: const Text('Confirm'),
					content: const Text('Delete this user?'),
					actions: [
						TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
						TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
					],
				),
			);
			if (confirmed == true) {
				await _controller.deleteUser(user.id!);
				if (context.mounted) Navigator.pop(context, true);
			}
		}

		return Scaffold(
			appBar: AppBar(title: Text(user.name)),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Name: ${user.name}', style: const TextStyle(fontSize: 18)),
						const SizedBox(height: 8),
						Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
						const SizedBox(height: 8),
						Text('Password: ${user.password}', style: const TextStyle(fontSize: 16)),
						const Spacer(),
						Row(
							children: [
								Expanded(
									child: ElevatedButton.icon(
										icon: const Icon(Icons.edit),
										label: const Text('Edit'),
										onPressed: () async {
											final result = await Navigator.push<bool?>(
												context,
												MaterialPageRoute(builder: (_) => UserFormScreen(user: user)),
											);
											if (result == true && context.mounted) Navigator.pop(context, true);
										},
									),
								),
								const SizedBox(width: 8),
								Expanded(
									child: ElevatedButton.icon(
										style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
										icon: const Icon(Icons.delete),
										label: const Text('Delete'),
										onPressed: _delete,
									),
								),
							],
						)
					],
				),
			),
		);
	}
}

