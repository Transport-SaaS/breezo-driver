import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import '../../../core/utils/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeViewModel, AuthViewModel>(
      builder: (context, homeViewModel, authViewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Breezo Driver'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await authViewModel.logout();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                  }
                },
              ),
            ],
          ),
          body: homeViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(homeViewModel, authViewModel),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: homeViewModel.selectedIndex,
            onTap: homeViewModel.setSelectedIndex,
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(HomeViewModel homeViewModel, AuthViewModel authViewModel) {
    switch (homeViewModel.selectedIndex) {
      case 0:
        return _buildHomeTab(authViewModel);
      case 1:
        return _buildHistoryTab();
      case 2:
        return _buildProfileTab(authViewModel);
      default:
        return _buildHomeTab(authViewModel);
    }
  }

  Widget _buildHomeTab(AuthViewModel authViewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_car,
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome, ${authViewModel.currentUser?.name ?? 'Driver'}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Start a trip
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Text('Start Trip'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return const Center(
      child: Text('Trip History will be displayed here'),
    );
  }

  Widget _buildProfileTab(AuthViewModel authViewModel) {
    final user = authViewModel.currentUser;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: user?.profileImage != null
                  ? NetworkImage(user!.profileImage!)
                  : null,
              child: user?.profileImage == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileItem('Name', user?.name ?? 'N/A'),
                  const Divider(),
                  _buildProfileItem('Email', user?.email ?? 'N/A'),
                  const Divider(),
                  _buildProfileItem('Phone', user?.phone ?? 'N/A'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Edit profile
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}