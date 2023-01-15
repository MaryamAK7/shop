import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageURlController = TextEditingController();
  var _editedProduct = Product(null, '', '', 0.0, '');
  final _form = GlobalKey<FormState>();
  var isLoading = false;
  var _initProduct = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  @override
  void initState() {
    _imageURlController.addListener(imageListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context)
            .findById(productId as String);
        _initProduct = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
        };
        _imageURlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  void imageListener() {
    if ((!_imageURlController.text.startsWith('http') &&
            !_imageURlController.text.startsWith('https')) ||
        (!_imageURlController.text.endsWith('.png') &&
            !_imageURlController.text.endsWith('.jpg') &&
            !_imageURlController.text.endsWith('.jpeg'))) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _imageURlController.removeListener(imageListener);
    _imageURlController.dispose();
    super.dispose();
  }

  void _formSaved() async {
    final bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
      setState(() {
        isLoading = true;
      });
    if (_editedProduct.id == null) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Product Added!'),
          duration: Duration(seconds: 2),
        ));
        Navigator.of(context).pop();
      } catch (error) {
        errorDialog();
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .editProduct(_editedProduct.id!, _editedProduct);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Product edited!'),
          duration: Duration(seconds: 2),
        ));
        Navigator.of(context).pop();
      } catch (error) {
        errorDialog();
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void errorDialog() {
    showDialog(
        context: context,
        builder: ((ctx) {
          return AlertDialog(
            title: const Text('Error', style: TextStyle(color: Colors.black)),
            content: const Text('Something went wrong. Please try again!'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'))
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                _formSaved();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initProduct['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              _editedProduct.id,
                              newValue!,
                              _editedProduct.description,
                              _editedProduct.price,
                              _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initProduct['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              _editedProduct.id,
                              _editedProduct.title,
                              _editedProduct.description,
                              double.parse(newValue!),
                              _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initProduct['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                              _editedProduct.id,
                              _editedProduct.title,
                              newValue!,
                              _editedProduct.price,
                              _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: _imageURlController.text.isNotEmpty
                                ? Image.network(_imageURlController.text)
                                : const Text('Enter a URL'),
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.url,
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              textInputAction: TextInputAction.done,
                              controller: _imageURlController,
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                    _editedProduct.id,
                                    _editedProduct.title,
                                    _editedProduct.description,
                                    _editedProduct.price,
                                    newValue!,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid image URL';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                _formSaved();
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            _formSaved();
                          },
                          child: const Text('Save'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
