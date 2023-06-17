import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'repeat_cubit_state.dart';

class RepeatCubit extends Cubit<RepeatCubitState> {
  RepeatCubit() : super(RepeatCubitInitial());

  void getRepeatCubit(bool value) => emit(RepeatCubitState(repeat: value));
}
