import 'package:equatable/equatable.dart';
import 'package:invoice_management_flutter_fe/models/product_model.dart';

class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {}

class LoadProductEvent extends ProductEvent {
  final String id;

  LoadProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddProductEvent extends ProductEvent {
  final ProductModel product;

  AddProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProductEvent extends ProductEvent {
  final String id;
  final ProductModel product;

  UpdateProductEvent(this.id, this.product);

  @override
  List<Object?> get props => [id, product];
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}
