import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_livros_2023/pages/profile_page.dart';
import 'package:uuid/uuid.dart';
import '../components/show_password_confirmation.dart';
import '../models/book.dart';
import '../services/auth_service.dart';
import '../services/listin_service.dart';

class DesktopHomePage extends StatefulWidget {
  final User user;
  const DesktopHomePage({super.key, required this.user});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  List<Book> listListins = [];
  ListinService listinService = ListinService();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: (widget.user.photoURL != null)
                    ? NetworkImage(widget.user.photoURL!)
                    : null,
              ),
              accountName: Text(
                (widget.user.displayName != null)
                    ? widget.user.displayName!
                    : "",
              ),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Mudar foto de perfil"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text("Remover conta"),
              onTap: () {
                showPasswordConfirmDialog(context: context, email: "");
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              onTap: () {
                AuthService().logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Biblioteca Virtual"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
          print(listListins.length);
          print('teste');
        },
        child: const Icon(Icons.add),
      ),
      body: (listListins.isEmpty)
          ? const Center(
              child: Text(
                "Nenhum livro cadastrado.\nVamos catalogar o primeiro?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: ListView(
                children: List.generate(
                  listListins.length,
                  (index) {
                    Book model = listListins[index];
                    return Dismissible(
                      key: ValueKey<Book>(model),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 8.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        remove(model);
                      },
                      child: ListTile(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         ProdutoScreen(listin: model),
                          //   ),
                          // );
                        },
                        onLongPress: () {
                          showFormModal(model: model);
                        },
                        leading: const Icon(
                          Icons.list_alt_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          model.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          model.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        // subtitle: Text(model.id),
                      ),
                    );
                  },
                ),
              ),
            ),
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
