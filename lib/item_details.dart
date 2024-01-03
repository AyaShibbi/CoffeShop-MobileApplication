import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ItemDetailsPage extends StatefulWidget {
  final int itemId;
  final String itemName;
  final double itemPrice;
  final String itemImage;
  final String itemCat;

  const ItemDetailsPage({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.itemImage,
    required this.itemCat,
  });

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  String selectedSize = 'S';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemName),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Large Image (replace Image.network with your image loading mechanism)
          Image.network(
            widget.itemImage,
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          // Item Name
          Text(
            '${widget.itemName}\t${widget.itemCat}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Size Selection (you can replace this with your logic)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSizeButton(context, 'S'),
              _buildSizeButton(context, 'M'),
              _buildSizeButton(context, 'L'),
            ],
          ),
          const SizedBox(height: 10),
          // Total Price (replace with your logic)
          Text(
            'Total Price: \$${_calculateTotalPrice()}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          // Submit Order Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
            ),
            onPressed: () {
              _submitOrder(context, widget.itemId, widget.itemName, widget.itemImage);
            },
            child: const Text('Submit Order'),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeButton(BuildContext context, String size) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
      ),
      onPressed: () {
        setState(() {
          selectedSize = size;
        });
        _updateTotalPrice();
      },
      child: Text(size),
    );
  }

  double _calculateTotalPrice() {
    double totalPrice = widget.itemPrice;
    if (selectedSize == 'M') {
      totalPrice += 1.5;
    } else if (selectedSize == 'L') {
      totalPrice += 2.5;
    }
    return totalPrice;
  }

  void _updateTotalPrice() {
    setState(() {
      // Update the total price based on the selected size
    });
  }

  void _submitOrder(BuildContext context, int itemId, String itemName, String itemImage) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage(
          itemId: itemId,
          itemName: itemName,
          size: selectedSize,
          image: itemImage,
          totalPrice: _calculateTotalPrice(),
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final int itemId;
  final String itemName;
  final String size;
  final String image;
  final double totalPrice;

  const CartPage({
    required this.itemId,
    required this.itemName,
    required this.size,
    required this.image,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('My Order'),
      ),
      body: Center( child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            image,
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text('Item: $itemName', style: TextStyle(fontSize: 24)),
          SizedBox(height: 10),
          Text('Size: $size', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Text('Total Price: \$${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown
            ),
            onPressed: () {
              _submitOrder(context);
            },
            child: Text('Submit Order'),
          ),
        ],
      ),
      ),
    );
  }


  // void _submitOrder(BuildContext context) async {
  //   // Implement logic to submit the order to the database
  //
  //   // Prepare order details
  //   Map<String, dynamic> orderDetails = {
  //     'ID': itemId,
  //     'Name': itemName,
  //     'Size': size,
  //     'totalPrice': totalPrice,
  //   };
  //
  //   try {
  //     // Send a JSON object using http post
  //     final response = await http.post(
  //       Uri.parse('https://ayashibbi-dailydrip.000webhostapp.com/order.php'), // Replace with your actual server URL
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: convert.jsonEncode(orderDetails),
  //     ).timeout(const Duration(seconds: 5));
  //
  //     if (response.statusCode == 200) {
  //       // Order submitted successfully
  //       print('Order submitted successfully');
  //       print(response.body);
  //
  //       // Now you can navigate to a confirmation page or home page
  //       Navigator.of(context).popUntil(ModalRoute.withName('menu.php')); // Pop until reaching the home page
  //     } else {
  //       // Error submitting order
  //       print('Error submitting order: ${response.statusCode}');
  //       print(response.body);
  //       // Handle the error (show a snackbar, display an error message, etc.)
  //     }
  //   } catch (e) {
  //     // Connection error
  //     print('Connection error: $e');
  //     // Handle the connection error (show a snackbar, display an error message, etc.)
  //   }
  // }

  void _submitOrder(BuildContext context) async {
    // Implement logic to submit the order to the database

    // Prepare order details
    Map<String, dynamic> orderDetails = {
      'ID': itemId,
      'Name': itemName,
      'Size': size,
      'totalPrice': totalPrice,
    };

    try {
      // Send a JSON object using http post
      final response = await http.post(
        Uri.parse('https://ayashibbi-dailydrip.000webhostapp.com/order.php'), // Replace with your actual server URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(orderDetails),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Order submitted successfully
        print('Order submitted successfully');
        print(response.body);

        _showSuccessAlert(context);

      } else {
        // Error submitting order
        print('Error submitting order: ${response.statusCode}');
        print(response.body);
        // Handle the error (show a snackbar, display an error message, etc.)
      }
    } catch (e) {
      // Connection error
      print('Connection error: $e');
      // Handle the connection error (show a snackbar, display an error message, etc.)
    }
  }

  void _showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text("It's a great day to get a coffee! ☕"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


