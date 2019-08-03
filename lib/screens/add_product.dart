import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/category.dart';
import '../db/brand.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropdown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropdown = <DropdownMenuItem<String>>[];
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  String _currentCategory, _currentBrand;

  @override
  void initState() {
    _getCategories();
    _getBrands();
    super.initState();
  }

  void _buildCategoriesDropdown() {
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        categoriesDropdown.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i]['category']),
              value: categories[i]['category'],
            ));
      });
    }
  }

  void _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      _buildCategoriesDropdown();
      _currentCategory = categoriesDropdown[0].value;
    });
  }

  void _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
      brands = data;
      _buildBrandsDropdown();
      _currentBrand = brandsDropdown[0].value;
    });
  }

  void _buildBrandsDropdown() {
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        brandsDropdown.insert(
            0,
            DropdownMenuItem(
              child: Text(brands[i]['brand']),
              value: brands[i]['brand'],
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text('Add Product', style: TextStyle(color: Colors.black)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: OutlineButton(
                      onPressed: () {},
                      borderSide: BorderSide(
                          width: 2.5, color: Colors.grey.withOpacity(0.5)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 40, 14, 40),
                        child: Icon(Icons.add, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: OutlineButton(
                      onPressed: () {},
                      borderSide: BorderSide(
                          width: 2.5, color: Colors.grey.withOpacity(0.5)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 40, 14, 40),
                        child: Icon(Icons.add, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: OutlineButton(
                      onPressed: () {},
                      borderSide: BorderSide(
                          width: 2.5, color: Colors.grey.withOpacity(0.5)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 40, 14, 40),
                        child: Icon(Icons.add, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Enter product name',
              style: TextStyle(color: Colors.red, fontSize: 17),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(hintText: 'Product Name'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Product name cant be empty';
                  } else if (value.length > 10) {
                    return 'Product name cant be more than 10 letters';
                  }
                  return null;
                },
              ),
            ),
            Text('Choose product category',
                style: TextStyle(color: Colors.red, fontSize: 17),
                textAlign: TextAlign.center),
            Center(
              child: DropdownButton(
                value: _currentCategory,
                items: categoriesDropdown,
                onChanged: (String selectedCategory) {
                  setState(() {
                    _currentCategory = selectedCategory;
                  });
                },
              ),
            ),
            Text('Choose product brand',
                style: TextStyle(color: Colors.red, fontSize: 17),
                textAlign: TextAlign.center),
            Center(
              child: DropdownButton(
                value: _currentBrand,
                items: brandsDropdown,
                onChanged: (String selectedBrand) {
                  setState(() {
                    _currentBrand = selectedBrand;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
