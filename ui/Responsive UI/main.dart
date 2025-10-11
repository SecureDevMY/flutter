import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveDemo());
}

class ResponsiveDemo extends StatelessWidget {
  const ResponsiveDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive UI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ResponsiveHomePage(),
    );
  }
}

class ResponsiveHomePage extends StatelessWidget {
  const ResponsiveHomePage({super.key});
  
  //Responsive Logic
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive UI Demo'),
        backgroundColor: Colors.blue,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check screen width to determine layout
          if (constraints.maxWidth > 900) {
            return _buildDesktopLayout();
          } else if (constraints.maxWidth > 600) {
            return _buildTabletLayout();
          } else {
            return _buildMobileLayout();
          }
        }
      ),
    );
  }

  //Mobile Layout (<600px)
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildHeader('Mobile Layout'),
        Expanded(child: _buildMainContent()),
      ],
    );
  }

  //Tablet Layout (600px to 900px)
  Widget _buildTabletLayout() {
    return Column(
      children: [
        _buildHeader('Tablet Layout'),
        Expanded(
          child: Row(
            children: [
              // Collapsed Sidebar
              Container(
                width: 80,
                color: Colors.blue.shade100,
                child: _buildCollapsedSidebar(),
              ),
              // Main Content
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Desktop Layout (>900px)
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar
        Container(
          width: 250,
          color: Colors.blue.shade100,
          child: _buildSidebar(),
        ),
        // Main Content
        Expanded(
          child: Column(
            children: [
              _buildHeader('Desktop Layout'),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildMainContent(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRightPanel(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Reusable components
    Widget _buildHeader(String layoutType) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          Icon(Icons.devices, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Text(
            layoutType,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSidebarItem(Icons.home, 'Home'),
        _buildSidebarItem(Icons.dashboard, 'Dashboard'),
        _buildSidebarItem(Icons.settings, 'Settings'),
        _buildSidebarItem(Icons.person, 'Profile'),
        _buildSidebarItem(Icons.info, 'About'),
      ],
    );
  }

  Widget _buildCollapsedSidebar() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _buildIconButton(Icons.home),
        _buildIconButton(Icons.dashboard),
        _buildIconButton(Icons.settings),
        _buildIconButton(Icons.person),
        _buildIconButton(Icons.info),
      ],
    );
  }

  Widget _buildSidebarItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        onTap: () {},
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: IconButton(
        icon: Icon(icon, color: Colors.blue),
        onPressed: () {},
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.blue.shade300,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Item ${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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

  Widget _buildRightPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard('Total Items', '12', Icons.inventory),
          _buildInfoCard('Active Users', '248', Icons.people),
          _buildInfoCard('Messages', '15', Icons.message),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
