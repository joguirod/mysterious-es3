import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterious_app/controllers/CategoryController.dart';
import 'package:mysterious_app/controllers/GenreController.dart';
import 'package:mysterious_app/controllers/UserController.dart';
import 'package:mysterious_app/models/OrderItem.dart';
import 'package:mysterious_app/models/cart.dart';
import 'package:mysterious_app/models/cartitem.dart';
import 'package:mysterious_app/models/category.dart';
import 'package:mysterious_app/models/genre.dart';
import 'package:mysterious_app/models/product.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/cart_page.dart';
import 'views/login_page.dart';
import 'views/register_page.dart';
import 'views/user_page.dart';
import 'views/purchase_history_page.dart';
import 'views/settings_page.dart';
import 'views/order_details_page.dart';
//import 'screens/catalogo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jewpsxpzwgkzbjghxwes.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impld3BzeHB6d2dremJqZ2h4d2VzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczNDkxNjYsImV4cCI6MjA1MjkyNTE2Nn0.yW_ISgMXvDyugU6PZpniU-LXcvhEFc5ED0IesGKPAk0', 
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
          debugShowCheckedModeBanner: false,
          title: 'E-commerce de Livros',
          theme: theme.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          initialRoute: '/',
          routes: {
            '/': (context) => const MyHomePage(title: 'E-commerce de Livros'),
            '/register': (context) => const RegisterPage(),
            '/user': (context) => const UserPage(),
            '/login': (context) => LoginPage(cart: new Cart(items: [])), 
            '/settings': (context) => const SettingsPage(),
            //'/catalogo': (context) => const CatalogoPage(), // Adicionei a rota do catálogo aqui
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/login') {
              final cart = settings.arguments as Cart;
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
  final CategoryController categoryController = CategoryController();
  final GenreController genreController = GenreController();
  final UserController userController = UserController();
  List<CategoryProduct> categories = [];
  List<CategoryProduct> filteredCategories = [];
  List<Genre> genres = [];
  List<Genre> filteredGenres = [];
  Cart cart = new Cart(items: []);
  int? selectedCategoryId;
  Genre? selectedGenre;
  double? selectedCategoryPrice;
  String? selectedCategoryImageUrl;
  TextEditingController searchController = TextEditingController();
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    categoryController.fetchCategories().then((categories) {
      setState(() {
        this.categories = categories;
        filteredCategories = categories;
      });
    });
    userController.fetchUserName().then((user) {
      setState(() {
        userName = user['username'];
        userEmail = user['email'];
      });
    });
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    filterCategories();
    filterGenres();
  }

  void filterCategories() {
    setState(() {
      filteredCategories = categories.where((category) {
        return category.descricao!.toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  void filterGenres() {
    setState(() {
      filteredGenres = genres.where((genre) {
        return genre.descricao!.toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  void addToCart(Product item, int quantidade) {
    setState(() {
      cart.items.add(new Cartitem(product: item, quantidade: quantidade));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.categoria.descricao} adicionado ao carrinho')),
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
                if (cart.items.isNotEmpty)
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
                        '${cart.items.length}',
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
                          selectedCategoryId = categoria.id_categoria;
                          selectedCategoryPrice = categoria.preco;
                          selectedCategoryImageUrl = categoria.imagem_url;
                          genreController.fetchGenres(categoria.id_categoria).then((genres) {
                            setState(() {
                              this.genres = genres;
                              filteredGenres = genres;
                            });
                          });
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Categoria ${categoria.descricao} selecionada')),
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
                              categoria.imagem_url!,
                              height: 100, 
                              width: 100, 
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categoria.descricao!,
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
                          selectedGenre = genre;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gênero ${genre.descricao} selecionado')),
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
                              genre.imagem_url!,
                              height: 110, 
                              width: 110, 
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              genre.descricao!,
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
                        'Gênero: ${selectedGenre!.descricao}',
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
                        addToCart(
                          Product.namedConstructor(
                            categoria: CategoryProduct.withId(id_categoria: selectedCategoryId!, preco: selectedCategoryPrice!),
                            genero: Genre.withId(id_genero: selectedGenre!.id_genero),
                          ),
                          1,
                        );
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