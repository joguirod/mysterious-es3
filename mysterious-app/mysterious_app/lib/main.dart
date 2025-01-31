import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/cart_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/user_page.dart';
import 'screens/purchase_history_page.dart';
import 'screens/settings_page.dart';
import 'screens/order_details_page.dart';
//import 'screens/catalogo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Supabase.initialize(
    url: 'https://localizaaicomedia.supabase.co',
    anonKey: 'soalegria.inc', 
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        return MaterialApp(
          title: 'E-commerce de Livros',
          theme: theme.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          initialRoute: '/',
          routes: {
            '/': (context) => const MyHomePage(title: 'E-commerce de Livros'),
            '/register': (context) => const RegisterPage(),
            '/user': (context) => const UserPage(),
            '/login': (context) => LoginPage(cart: []), 
            '/settings': (context) => const SettingsPage(),
            //'/catalogo': (context) => const CatalogoPage(), // Adicionei a rota do catálogo aqui
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/login') {
              final cart = settings.arguments as List<Map<String, dynamic>>;
              return MaterialPageRoute(
                builder: (context) {
                  return LoginPage(cart: cart);
                },
              );
            }
            return null;
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> categoriaproduto = [];
  List<Map<String, dynamic>> genero = [];
  List<Map<String, dynamic>> filteredCategories = [];
  List<Map<String, dynamic>> filteredGenres = [];
  List<Map<String, dynamic>> cart = [];
  int? selectedCategoryId;
  String? selectedGenre;
  double? selectedCategoryPrice;
  String? selectedCategoryImageUrl;
  TextEditingController searchController = TextEditingController();
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchUserName();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (selectedCategoryId == null) {
      filterCategories();
    } else if (selectedGenre == null) {
      filterGenres();
    }
  }

  void filterCategories() {
    setState(() {
      filteredCategories = categoriaproduto
          .where((category) =>
              category['descricao']!.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void filterGenres() {
    setState(() {
      filteredGenres = genero
          .where((genre) =>
              genre['descricao']!.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchCategories() async {
    final categoryResponse = await Supabase.instance.client
        .from('categoriaproduto')
        .select('id_categoria, descricao, preco, imagem_url') 
        .execute();

    if (categoryResponse.error == null) {
      setState(() {
        categoriaproduto = (categoryResponse.data as List)
            .map((e) => {
                  'id_categoria': e['id_categoria'] as int,
                  'descricao': e['descricao'] as String,
                  'imagem_url': e['imagem_url'] as String, 
                  'preco': e['preco']
                })
            .toList();
        filteredCategories = categoriaproduto;
      });
    } else {
      print('Category fetch error: ${categoryResponse.error?.message}');
      print('Category fetch response: ${categoryResponse.data}');
    }
  }

  Future<void> fetchGenres(int categoryId) async {
    final genreResponse = await Supabase.instance.client
        .from('genero')
        .select('descricao, imagem_url') 
        .eq('id_categoria', categoryId) 
        .limit(10)
        .execute();

    if (genreResponse.error == null) {
      setState(() {
        genero = (genreResponse.data as List)
            .map((e) => {
                  'descricao': e['descricao'] as String,
                  'imagem_url': e['imagem_url'] as String 
                })
            .toList();
        filteredGenres = genero;
      });
    } else {
      print('Genre fetch error: ${genreResponse.error?.message}');
      print('Genre fetch response: ${genreResponse.data}');
    }
  }

  Future<void> fetchUserName() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final userId = session.user!.id;
      final response = await Supabase.instance.client
          .from('mysterioususer')
          .select('username, email')
          .eq('id_mysterious_user', userId)
          .single()
          .execute();

      if (response.error == null && response.data != null) {
        setState(() {
          userName = response.data['username'];
          userEmail = response.data['email'];
        });
      } else {
        print('Erro ao buscar nome do usuário: ${response.error?.message}');
      }
    }
  }

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['descricao']} adicionado ao carrinho')),
    );
  }

  void _logout() {
    Supabase.instance.client.auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToUserPage() {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      Navigator.pushNamed(context, '/user');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(8.0),
                  suffixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
                    ).then((_) {
                      setState(() {
                        selectedCategoryId = null;
                        selectedCategoryPrice = null;
                        selectedGenre = null;
                        selectedCategoryImageUrl = null;
                        filteredGenres = [];
                      });
                    });
                  },
                ),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cart.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
              accountName: Text(userName ?? 'BEM VINDO(A)'),
              accountEmail: Text(userEmail ?? ''),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: _navigateToUserPage,
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Catálogo'),
              onTap: () {
                Navigator.pushNamed(context, '/catalogo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Compras'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PurchaseHistoryPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: _logout,
              textColor: Colors.red,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (selectedCategoryId == null) ...[
              const Text(
                'Categorias:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 8.0, 
                    mainAxisSpacing: 8.0, 
                  ),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final categoria = filteredCategories[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryId = categoria['id_categoria'];
                          selectedCategoryPrice = categoria['preco'];
                          selectedCategoryImageUrl = categoria['imagem_url'];
                          fetchGenres(categoria['id_categoria']);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Categoria ${categoria['descricao']} selecionada')),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800], 
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              categoria['imagem_url']!,
                              height: 100, 
                              width: 100, 
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categoria['descricao']!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else if (selectedGenre == null) ...[
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        selectedCategoryId = null;
                        selectedCategoryPrice = null;
                        selectedCategoryImageUrl = null;
                        searchController.clear();
                        filteredGenres = [];
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Voltando para categorias')),
                      );
                    },
                  ),
                  const Text(
                    'Gêneros:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 8.0, 
                    mainAxisSpacing: 8.0, 
                  ),
                  itemCount: filteredGenres.length,
                  itemBuilder: (context, index) {
                    final genre = filteredGenres[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGenre = genre['descricao'];
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gênero ${genre['descricao']} selecionado')),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800], 
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              genre['imagem_url']!,
                              height: 110, 
                              width: 110, 
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              genre['descricao']!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        selectedGenre = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Voltando para gêneros')),
                      );
                    },
                  ),
                  const Text(
                    'Detalhes do Produto:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      selectedCategoryImageUrl!,
                      height: 200, 
                      width: 200, 
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gênero: $selectedGenre',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preço: $selectedCategoryPrice',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        addToCart({
                          'produto_id': selectedGenre, 
                          'categoria_id': selectedCategoryId, 
                          'quantidade': 1,
                          'preco': selectedCategoryPrice,
                          'imagem_url': selectedCategoryImageUrl, 
                        });
                      },
                      child: const Text('Adicionar ao Carrinho'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}