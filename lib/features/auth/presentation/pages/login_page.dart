import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'تسجيل الدخول',
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  validator: (v) => (v == null || v.isEmpty) ? 'البريد مطلوب' : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  validator: (v) => (v == null || v.isEmpty) ? 'كلمة المرور مطلوبة' : null,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: loading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(_emailController.text, _passwordController.text);
                          }
                        },
                  child: loading ? const CircularProgressIndicator() : const Text('دخول'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
