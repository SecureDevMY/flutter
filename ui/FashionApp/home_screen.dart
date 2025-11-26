import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fashion App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //Get screen height and substract bottom navigation height
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomNavHeight = 60;
    final availableHeight = screenHeight - bottomNavHeight - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Hero Section - New Collections
                    _buildHeroSection(availableHeight),

                    //Grid Section
                    _buildGridSection(availableHeight),
                  ],
                ),
              )
            ),
            //Bottom Navigation
            _buildBottomNavigation(),
          ],
        )
      ),
    );
  }

  Widget _buildHeroSection(double availableHeight) {
    final heroHeight = availableHeight * 0.5;

    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const DetailScreen(title: 'New Collection'),
              )
            );
          },
          child: Stack(
            children: [
              //Background Image
              Image.asset(
                'assets/images/new_collection.png',
                height: heroHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              //Gradient Overlay
              Container(
                height: heroHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                ),
              ),

              //Text
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'New Collection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                )
              )
            ],
          ),
        );
      }
    );
  }

  Widget _buildGridSection(double availableHeight) {
    final gridHeight = availableHeight * 0.5;
    final cellHeight = gridHeight / 2;

    return Builder(
      builder: (BuildContext context) {
        return SizedBox(
          height: gridHeight,
          child: Row(
            children: [
              //Left Column: Summer Sale + Black
              Expanded(
                child: Column(
                  children: [
                    //Summer Sale
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const DetailScreen(title: 'Summer Sale'),
                          )
                        );
                      },
                      child: Container(
                        height: cellHeight,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            'Summer\nSale',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Black
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const DetailScreen(title: 'Black'),
                          )
                        );
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/black.png',
                            height: cellHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: cellHeight,
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 20, bottom: 30),
                            child: Text(
                              'Black',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),

              //Right Column : Men's Hoodies
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const DetailScreen(title: "Men's hoodies"),
                      )
                    );
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/men_hoodies.png',
                        height: gridHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: gridHeight,
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(left: 20, bottom: 30),
                        child: Text(
                          "Men's\nhoodies",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              )
            ],
          ),
        );
      }
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          )
        ]
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ]
      ),
    );
  }
}

//Detail Screen for each category
class DetailScreen extends StatelessWidget {
  final String title;

  const DetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
