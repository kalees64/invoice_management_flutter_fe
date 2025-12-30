import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_management_flutter_fe/store/products/product_event.dart';
import 'package:invoice_management_flutter_fe/store/products/product_repository.dart';
import 'package:invoice_management_flutter_fe/store/products/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  late final ProductRepository productRepo;

  ProductBloc(this.productRepo) : super(ProductInitialState()) {
    on<LoadProductsEvent>(_getAllProducts);
    on<LoadProductEvent>(_getProduct);
    on<AddProductEvent>(_addProduct);
    on<UpdateProductEvent>(_updateProduct);
    on<DeleteProductEvent>(_deleteProduct);
  }

  Future<void> _getAllProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoadingState());
      final products = await productRepo.getProducts();
      emit(ProductLoadedState(products));
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  Future<void> _getProduct(
    LoadProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoadingState());
      final product = await productRepo.get(event.id);
      emit(ProductLoadedState([product]));
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  Future<void> _addProduct(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoadingState());
      await productRepo.create(event.product.toJson());
      add(LoadProductsEvent());
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  Future<void> _updateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoadingState());
      await productRepo.update(event.id, event.product.toJson());
      add(LoadProductsEvent());
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  Future<void> _deleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoadingState());
      await productRepo.delete(event.id);
      add(LoadProductsEvent());
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }
}
