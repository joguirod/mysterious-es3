import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'screens/cart_page.dart';
import 'screens/profile_page.dart';
import 'screens/notifications_page.dart';
import 'screens/settings_page.dart';
import 'screens/login_page.dart';
import 'screens/payment_page.dart';
import 'authentication.dart';
import 'theme_dark.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<AuthNotifier>(create: (_) => AuthNotifier()),
      ],
      child: BookStoreApp(),
    ),
  );
}

class BookStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, AuthNotifier>(
      builder: (context, themeNotifier, authNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mysterious',
          theme: themeNotifier.darkTheme ? ThemeData.dark() : ThemeData.light(),
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> books = [
    {
      "title": "Dom Quixote",
      "author": "Miguel de Cervantes",
      "price": "39.90",
      "image": "https://images-na.ssl-images-amazon.com/images/I/81eB+7+CkUL.jpg",
    },
    {
      "title": "1984",
      "author": "George Orwell",
      "price": "29.90",
      "image": "https://images-na.ssl-images-amazon.com/images/I/71kxa1-0mfL.jpg",
    },
    {
      "title": "O Senhor dos Anéis",
      "author": "J.R.R. Tolkien",
      "price": "59.90",
      "image": "https://images-na.ssl-images-amazon.com/images/I/91b0C2YNSrL.jpg",
    },
    {
      "title": "O Pequeno Príncipe",
      "author": "Antoine de Saint-Exupéry",
      "price": "19.90",
      "image": "https://images-na.ssl-images-amazon.com/images/I/81OthjkJBuL.jpg",
    },
  ];

  List<Map<String, String>> cartItems = [];
  List<String> notifications = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _addToCart(Map<String, String> book) {
    setState(() {
      cartItems.add(book);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${book["title"]} adicionado ao carrinho!')),
    );
    _showNotification(book["title"]!);
  }

  Future<void> _showNotification(String bookTitle) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Livro Adicionado',
      '$bookTitle foi adicionado ao carrinho.',
      platformChannelSpecifics,
      payload: 'item x',
    );

    setState(() {
      notifications.add('$bookTitle foi adicionado ao carrinho.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.grey),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: "Buscar livros...",
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cartItems),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(authNotifier.userImage),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Olá, ${authNotifier.userName}!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                if (authNotifier.isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notificações'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage(notifications: notifications)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Histórico de Compras'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Histórico de compras selecionado.")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Meu Pedido'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Seus pedidos serão exibidos aqui.")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.login, color: Colors.blue),
              title: Text('Login', style: TextStyle(color: Colors.blue)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () {
                authNotifier.logout();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Você saiu da conta!")),
                );
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailsPage(book: book, addToCart: _addToCart),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.network(book["image"]!, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          book["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Autor: ${book["author"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "R\$ ${book["price"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  final Map<String, String> book;
  final Function(Map<String, String>) addToCart;

  BookDetailsPage({required this.book, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book["title"]!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                book["image"]!,
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 16),
            Text(
              book["title"]!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Autor: ${book["author"]}"),
            SizedBox(height: 8),
            Text(
              "Preço: R\$ ${book["price"]}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                addToCart(book);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Livro adicionado ao carrinho!")),
                );
              },
              child: Text("Adicionar ao Carrinho"),
            ),
          ],
        ),
      ),
    );
  }
}