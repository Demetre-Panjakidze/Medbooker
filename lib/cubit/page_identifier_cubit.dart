import 'package:bloc/bloc.dart';

part 'page_identifier_state.dart';

class PageIdentifierCubit extends Cubit<PageIdentifierState> {
  PageIdentifierCubit()
      : super(const PageIdentifierState(pageName: 'Dashboard'));

  void pageChange({required String page}) {
    emit(PageIdentifierState(pageName: page));
  }
}
