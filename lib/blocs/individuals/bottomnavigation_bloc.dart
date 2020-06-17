import 'package:news/blocs/blocs.dart';
import 'package:news/repositories/repositories.dart';
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  final FirstPageRepository firstPageRepository;
  final SecondPageRepository secondPageRepository;
  final ThirdPageRepository thirdPageRepository;
  int currentIndex = 0;

  BottomNavigationBloc(
      {this.firstPageRepository,
      this.secondPageRepository,
      this.thirdPageRepository})
      : assert(firstPageRepository != null),
        assert(secondPageRepository != null),
        assert(thirdPageRepository != null);

  @override
  BottomNavigationState get initialState => PageLoading();

  @override
  Stream<BottomNavigationState> mapEventToState(
      BottomNavigationEvent event) async* {
    if (event is AppStarted) {
      this.add(PageTapped(index: this.currentIndex));
    }
    if (event is PageTapped) {
      this.currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: this.currentIndex);
      yield PageLoading();

      if (this.currentIndex == 0) {
        print("Exclusivo de stack");
      }
      if (this.currentIndex == 1) {
        int data = await _getFirstPageData();
        yield FirstPageLoaded(number: data);
      }
      if (this.currentIndex == 2) {
        String data = await _getSecondPageData();
        yield SecondPageLoaded(text: data);
      }
      if (this.currentIndex == 3) {
        String data = await _getThirdPageData();
        yield ThirdPageLoaded(text: data);
      }
    }
  }



  Future<int> _getFirstPageData() async {
    int data = firstPageRepository.data;
    if (data == null) {
      await firstPageRepository.fetchData();
      data = firstPageRepository.data;
    }
    return data;
  }

  Future<String> _getSecondPageData() async {
    String data = secondPageRepository.data;
    if (data == null) {
      await secondPageRepository.fetchData();
      data = secondPageRepository.data;
    }
    return data;
  }

  Future<String> _getThirdPageData() async {
    String data = thirdPageRepository.data;
    if (data == null) {
      await thirdPageRepository.fetchData();
      data = thirdPageRepository.data;
    }
    return data;
  }
}
