import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'item_details.dart';

const String _baseURL = 'ayashibbi-dailydrip.000webhostapp.com';

class Item {
  int _id;
  String _name;
  double _price;
  String _image;
  String _category;

  Item(this._id, this._name, this._price, this._image, this._category);

  @override
  String toString() {
    return 'PID: $_id Name: $_name Price: \$$_price Image: $_image Category: $_category';
  }
}

List<Item> _items = [];

void updateProducts(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getProducts.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    _items.clear();

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);

      for (var row in jsonResponse) {
        Item p = Item(
          int.parse(row['ID']),
          row['Name'],
          double.parse(row['Price']),
          row['Image'],
          row['category'],
        );
        _items.add(p);
      }
      update(true);
    }
  } catch (e) {
    update(false);
  }
}

void searchProduct(Function(String text) update, String name) async {
  try {
    final url = Uri.https(_baseURL, 'searchProduct.php', {'Name': '$name'});
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse.isNotEmpty) {
        var row = jsonResponse[0];
        Item p = Item(
          int.parse(row['ID']),
          row['Name'],
          double.parse(row['Price']),
          row['Image'],
          row['category'],
        );
        update(p.toString());
      } else {
        update('No items found');
      }
    } else {
      update('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    update("Can't load data");
  }
}

class ShowProducts extends StatelessWidget {
  const ShowProducts({super.key});

  @override
  Widget build(BuildContext context) {
    void _showItemDetails(int itemId, String itemName, double itemPrice, String itemImage, String itemCat) {

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ItemDetailsPage(
                itemId: itemId,
                itemName: itemName,
                itemPrice: itemPrice,
                itemImage: itemImage,
                itemCat: itemCat,
              ),
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showItemDetails(_items[index]._id, _items[index]._name, _items[index]._price, _items[index]._image, _items[index]._category);
            },
            child: Container(
              color: Colors.brown[50],
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.network(
                    _items[index]._image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10, width: 50),
                  Text(_items[index]._name),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
