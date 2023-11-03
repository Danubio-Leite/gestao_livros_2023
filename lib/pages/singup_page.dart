import 'package:flutter/material.dart';
import 'package:gestao_livros_2023/components/show_snackbar.dart';
import 'package:gestao_livros_2023/pages/home_page.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../components/custom_text_field.dart';
import '../config/custom_colors.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final phoneFormatter = MaskTextInputFormatter(
    mask: '## # ####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _cpfController = TextEditingController();
    final size = MediaQuery.of(context).size;

    AuthService _authService = AuthService();

    return Scaffold(
      backgroundColor: CustomColors.blue,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: size.height,
            width: 500,
            child: Stack(
              children: [
                Column(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Cadastro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),

                    // Formulario
                    Container(
                      height: 600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 40,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(45),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            icon: Icons.email,
                            label: 'Email',
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            icon: Icons.lock,
                            label: 'Senha',
                            isSecret: true,
                          ),
                          CustomTextField(
                            controller: _nameController,
                            icon: Icons.person,
                            label: 'Nome',
                          ),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () {
                                String email = _emailController.text;
                                String password = _passwordController.text;
                                String name = _nameController.text;

                                _authService
                                    .userRegister(
                                  email: email,
                                  password: password,
                                  name: name,
                                )
                                    .then(
                                  (String? error) {
                                    if (error != null) {
                                      showSnackBar(
                                          context: context, message: error);
                                    } else {
                                      showSnackBar(
                                          context: context,
                                          message:
                                              'Usuário Cadastrado com Sucesso!',
                                          isError: false);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Placeholder(),
                                        ),
                                      );
                                    }
                                  },
                                );

                                //Navigator.pop(context);
                              },
                              child: const Text(
                                'Cadastrar usuário',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: SafeArea(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
