import 'package:flutter/material.dart';
import 'package:gestao_livros_2023/components/custom_text_field.dart';
import 'package:uuid/uuid.dart';

import '../models/book.dart';
import '../services/listin_service.dart';

class ResgisterPage extends StatefulWidget {
  const ResgisterPage({super.key});

  @override
  State<ResgisterPage> createState() => _ResgisterPageState();
}

class _ResgisterPageState extends State<ResgisterPage> {
  List<Book> listListins = [];
  ListinService listinService = ListinService();

  // @override
  // void initState() {
  //   refresh();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _authorController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adição de Livro'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: size.height,
            width: 500,
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                          icon: Icons.book,
                          label: 'Título',
                          controller: _titleController,
                        ),
                        CustomTextField(
                          icon: Icons.person,
                          label: 'Autor',
                          controller: _authorController,
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
                              print('AAAAA');
                              print(listListins);
                              // Criar um objeto Book com as infos
                              Book book = Book(
                                id: const Uuid().v1(),
                                title: _titleController.text,
                                author: _titleController.text,
                              );

                              // Usar id do model
                              if (book != null) {
                                book.id = book.id;
                              }

                              // Salvar no Firestore
                              listinService.adicionarListin(book: book);

                              // Atualizar a lista
                              refresh();

                              // Fechar o Modal
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cadastrar Livro',
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
            ]),
          ),
        ),
      ),
    );
  }

  refresh() async {
    List<Book> listaListins = await listinService.lerListins();
    setState(() {
      listListins = listaListins;
    });
  }

  void remove(Book model) async {
    await listinService.removerListin(listinId: model.id);
    refresh();
  }
}
