import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'shuffle_cubit_state.dart';

class ShuffleCubit extends Cubit<ShuffleCubitState> {
  ShuffleCubit() : super(ShuffleCubitInitial());

  void GetShuffle(bool value) => emit(ShuffleCubitState(shuffle: value));
}
