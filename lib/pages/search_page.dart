import 'package:flutter/material.dart';
import 'package:gestao_livros_2023/components/custom_white_buttom.dart';
import 'package:gestao_livros_2023/pages/register_page.dart';
import 'package:uuid/uuid.dart';
import '../models/book.dart';
import '../services/listin_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Book> listListins = [];
  ListinService listinService = ListinService();

  @override
  void initState() {
    print('teste init');
    print(listListins);
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              refresh();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showFormModal();
      }),
      body: (listListins!.isEmpty)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Nenhuma livro cadastro ainda.\nVamos cadastrar o primeiro?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                CustomWhiteButton(
                    label: 'Adicionar livro',
                    onpressed: () {
                      listListins = Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResgisterPage(),
                        ),
                      ) as List<Book>;
                    })
              ],
            )
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: ListView(
                children: List.generate(
                  listListins.length,
                  (index) {
                    Book book = listListins[index];
                    return Dismissible(
                      key: ValueKey<Book>(book),
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
                        remove(book);
                      },
                      child: ListTile(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         ProdutoScreen(book: model),
                          //   ),
                          // );
                        },
                        onLongPress: () {
                          // showFormModal(book: book);
                        },
                        leading: const Icon(Icons.list_alt_rounded),
                        title: Text(book.title),
                        subtitle: Text(book.title),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  showFormModal({Book? book}) {
    // Labels à serem mostradas no Modal
    String labelTitle = "Adicionar Book";
    String labelConfirmationButton = "Salvar";
    String labelSkipButton = "Cancelar";

    // Controlador do campo que receberá o nome do Book
    TextEditingController nameController = TextEditingController();
    TextEditingController authorController = TextEditingController();

    // Caso esteja editando
    if (book != null) {
      labelTitle = "Editando ${book.title}";
      nameController.text = book.title;
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
                controller: nameController,
                decoration: const InputDecoration(label: Text("Nome do Book")),
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
                      // Criar um objeto Book com as infos
                      Book book = Book(
                        id: const Uuid().v1(),
                        title: nameController.text,
                        author: nameController.text,
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
    print('AAAAAAAAAAAAAA');
  }

  void remove(Book model) async {
    await listinService.removerListin(listinId: model.id);
    refresh();
  }
}
