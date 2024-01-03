import 'package:flutter/material.dart';
import 'product.dart';
import 'search.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _load = false; // used to show products list or progress bar

  void update(bool success) {
    setState(() {
      _load = true; // show product list
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load data')));
      }
    });
  }

  @override
  void initState() {
    // update data when the widget is added to the tree the first time.
    updateProducts(update);
    super.initState();
  }

  // void _navigateToMyOrder() {
  //   // Check if the user is logged in
  //   if (Login.isLoggedIn) {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const MyOrder()),
  //     );
  //   } else {
  //     // Redirect to login page
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) => const Login()),
  //     );
  //   }
  // }

  // void _navigateToProfile() {
  //   // Check if the user is logged in
  //   if (Login.isLoggedIn) {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) => const Menu()),
  //     );
  //   } else {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const Login()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: !_load
                ? null
                : () {
              setState(() {
                _load = false; // show progress bar
                updateProducts(update); // update data asynchronously
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                // open the search product page
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Search()),
                );
              });
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          )
        ],
        title: const Text('Menu'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),

      // load products or progress bar
      body: _load ? const ShowProducts() : const Center(child: CircularProgressIndicator()),
    );
  }
}
