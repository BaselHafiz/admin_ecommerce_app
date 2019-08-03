import 'dart:io';

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
  TextEditingController productQuantityController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropdown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropdown = <DropdownMenuItem<String>>[];
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  String _currentCategory, _currentBrand;
  List<String> selectedSizes = <String>[];
  File productImage1, productImage2, productImage3;

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
            buildProductImagesButtonsRow(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 10),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(hintText: 'Enter Product Name'),
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
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Category',
                      style: TextStyle(color: Colors.red, fontSize: 17),
                      textAlign: TextAlign.center),
                ),
                Expanded(
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
                Expanded(
                  child: Text('Brand',
                      style: TextStyle(color: Colors.red, fontSize: 17),
                      textAlign: TextAlign.center),
                ),
                Expanded(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: productQuantityController,
                decoration: InputDecoration(hintText: 'Enter Product Quantity'),
                validator: (String value) {
                  if (value.isEmpty || int.parse(value) <= 0) {
                    return 'Quantity cant be empty or zero';
                  } else if (value.length > 10) {
                    return 'Quantity cant be more than 10 letters';
                  }
                  return null;
                },
              ),
            ),
            Text(
              'Available Sizes',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 17),
            ),
            buildProductAvailableSizesRows(),
            Center(
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  'Add product',
                  style: TextStyle(fontSize: 17),
                ),
                color: Colors.red,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  changeSelectedSize(bool value, String size) {
    setState(() {
      if (value) {
        selectedSizes.add(size);
      } else {
        selectedSizes.remove(size);
      }
    });
  }

  Widget buildProductAvailableSizesRows() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('28'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '28');
                    })),
            Expanded(child: Text('28')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('30'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '30');
                    })),
            Expanded(child: Text('30')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('32'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '32');
                    })),
            Expanded(child: Text('32')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('34'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '34');
                    })),
            Expanded(child: Text('34')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('36'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '36');
                    })),
            Expanded(child: Text('36')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('38'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '38');
                    })),
            Expanded(child: Text('38')),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('40'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '40');
                    })),
            Expanded(child: Text('40')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('42'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '42');
                    })),
            Expanded(child: Text('42')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('44'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '44');
                    })),
            Expanded(child: Text('44')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('46'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '46');
                    })),
            Expanded(child: Text('46')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('48'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '48');
                    })),
            Expanded(child: Text('48')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('50'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, '50');
                    })),
            Expanded(child: Text('50')),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('XS'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, 'XS');
                    })),
            Expanded(child: Text('XS')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('S'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, 'S');
                    })),
            Expanded(child: Text('S')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('M'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, 'M');
                    })),
            Expanded(child: Text('M')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('L'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, 'L');
                    })),
            Expanded(child: Text('L')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('XL'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, 'XL');
                    })),
            Expanded(child: Text('XL')),
            Expanded(
                child: Checkbox(
                    value: selectedSizes.contains('XXL'),
                    onChanged: (bool value) {
                      changeSelectedSize(value, 'XXL');
                    })),
            Expanded(child: Text('XXL')),
          ],
        )
      ],
    );
  }

  Widget buildProductImagesButtonsRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: OutlineButton(
              onPressed: () {
                selectImage(ImagePicker.pickImage(source: ImageSource.gallery));
              },
              borderSide:
                  BorderSide(width: 2.5, color: Colors.grey.withOpacity(0.5)),
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
              borderSide:
                  BorderSide(width: 2.5, color: Colors.grey.withOpacity(0.5)),
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
              borderSide:
                  BorderSide(width: 2.5, color: Colors.grey.withOpacity(0.5)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 40, 14, 40),
                child: Icon(Icons.add, color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void selectImage(Future<File> pickImage) async {
    productImage1 = await pickImage;
  }
}
