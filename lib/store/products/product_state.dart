import 'package:equatable/equatable.dart';

class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<dynamic> products;

  ProductLoadedState(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductErrorState extends ProductState {
  final String error;

  ProductErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
