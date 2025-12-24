import 'package:equatable/equatable.dart';
import 'package:invoice_management_flutter_fe/models/product_model.dart';

// ignore: must_be_immutable
class AddProductState extends Equatable {
  List<ProductModel> products = [];
  bool isLoading = false;

  AddProductState copyWith({List<ProductModel>? products, bool? isLoading}) {
    return AddProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  AddProductState({this.products = const [], this.isLoading = false});

  @override
  List<Object> get props => [products, isLoading];
}

class DeleteProductState extends Equatable {
  final bool isLoading;

  const DeleteProductState({this.isLoading = false});

  @override
  List<Object> get props => [isLoading];
}
