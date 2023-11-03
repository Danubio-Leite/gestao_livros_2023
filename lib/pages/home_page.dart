import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_livros_2023/components/CustomHomeButtom.dart';
import 'package:gestao_livros_2023/config/custom_colors.dart';
import 'package:gestao_livros_2023/pages/desktop_home_page.dart';
import 'package:gestao_livros_2023/pages/mobile_home_page.dart';
import 'package:gestao_livros_2023/pages/profile_page.dart';
import 'package:gestao_livros_2023/pages/register_page.dart';
import 'package:gestao_livros_2023/pages/search_page.dart';
import 'package:uuid/uuid.dart';
import '../components/show_password_confirmation.dart';
import '../models/book.dart';
import '../services/auth_service.dart';
import '../services/listin_service.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> listListins = [];
  ListinService listinService = ListinService();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: ((context, snapshot) {
        if (isMobile) {
          return MobileHomePage(
            user: snapshot.data!,
          );
        } else {
          return DesktopHomePage(user: snapshot.data!);
        }
      }),
    );
  }

  showFormModal({Book? model}) {
    // Labels à serem mostradas no Modal
    String labelTitle = "Adicionar Livro";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    // Controlador do campo que receberá o nome do Listin
    TextEditingController titleController = TextEditingController();
    TextEditingController authorController = TextEditingController();

    // Caso esteja editando
    if (model != null) {
      labelTitle = "Editando ${model.title}";
      titleController.text = model.title;
      authorController.text = model.author;
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      context: context,

      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),

          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(labelTitle,
                  style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: titleController,
                decoration:
                    const InputDecoration(label: Text("Título da obra")),
              ),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(label: Text("Autor")),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(labelSkipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Criar um objeto Listin com as infos
                      Book book = Book(
                        id: const Uuid().v1(),
                        title: titleController.text,
                        author: authorController.text,
                      );

                      // Usar id do model
                      if (model != null) {
                        book.id = model.id;
                      }

                      // Salvar no Firestore
                      listinService.adicionarListin(book: book);

                      // Atualizar a lista
                      refresh();

                      print('TEMP');
                      print(listListins);

                      // Fechar o Modal
                      Navigator.pop(context);
                    },
                    child: Text(labelConfirmationButton),
                  ),
                ],
              )
            ],
          ),
        );
      },
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
