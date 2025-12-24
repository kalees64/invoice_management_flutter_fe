import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_management_flutter_fe/models/product_model.dart';
import 'package:invoice_management_flutter_fe/store/products/product_event.dart';
import 'package:invoice_management_flutter_fe/store/products/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, AddProductState> {
  ProductBloc() : super(AddProductState()) {
    on<AddProductEvent>(_onAddProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  void _onAddProduct(AddProductEvent event, Emitter<AddProductState> emit) {
    final currentProducts = List<ProductModel>.from(state.products);

    // Generate next product ID based on length
    final newId =
        'PRD${(currentProducts.length + 1).toString().padLeft(3, '0')}';

    // Create product with generated ID
    final newProduct = event.product.copyWith(id: newId);

    currentProducts.add(newProduct);

    emit(state.copyWith(products: currentProducts));
  }

  void _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<AddProductState> emit,
  ) {
    final currentProducts = List<ProductModel>.from(state.products);
    currentProducts.removeWhere((product) => product.id == event.productId);
    emit(state.copyWith(products: currentProducts));
  }
}
