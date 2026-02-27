import 'package:flutter/material.dart';
import 'package:users_app_sql/controllers/user_controller.dart';
import 'package:users_app_sql/models/user_model.dart';

class UserFormScreen extends StatefulWidget {
	final User? user;
	const UserFormScreen({Key? key, this.user}) : super(key: key);

	@override
	State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
	final _formKey = GlobalKey<FormState>();
	final UserController _controller = UserController();

	late TextEditingController _nameController;
	late TextEditingController _emailController;
	late TextEditingController _passwordController;

	@override
	void initState() {
		super.initState();
		_nameController = TextEditingController(text: widget.user?.name ?? '');
		_emailController = TextEditingController(text: widget.user?.email ?? '');
		_passwordController = TextEditingController(text: widget.user?.password ?? '');
	}

	@override
	void dispose() {
		_nameController.dispose();
		_emailController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	Future<void> _save() async {
		if (!_formKey.currentState!.validate()) return;
		final user = User(
			id: widget.user?.id,
			name: _nameController.text.trim(),
			email: _emailController.text.trim(),
			password: _passwordController.text.trim(),
		);

		if (widget.user == null) {
			await _controller.addUser(user);
		} else {
			await _controller.updateUser(user);
		}
		if (mounted) Navigator.pop(context, true);
	}

	@override
	Widget build(BuildContext context) {
		final isEdit = widget.user != null;
		return Scaffold(
			appBar: AppBar(title: Text(isEdit ? 'Edit User' : 'Add User')),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Form(
					key: _formKey,
					child: Column(
						children: [
							TextFormField(
								controller: _nameController,
								decoration: const InputDecoration(labelText: 'Name'),
								validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
							),
							const SizedBox(height: 8),
							TextFormField(
								controller: _emailController,
								decoration: const InputDecoration(labelText: 'Email'),
								validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter email' : null,
							),
							const SizedBox(height: 8),
							TextFormField(
								controller: _passwordController,
								decoration: const InputDecoration(labelText: 'Password'),
								obscureText: true,
								validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter password' : null,
							),
							const SizedBox(height: 16),
							ElevatedButton(
								onPressed: _save,
								child: Text(isEdit ? 'Update' : 'Save'),
							),
						],
					),
				),
			),
		);
	}
}

