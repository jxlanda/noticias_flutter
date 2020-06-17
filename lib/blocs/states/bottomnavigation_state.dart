import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();

  @override
  List<Object> get props => [];
}

class CurrentIndexChanged extends BottomNavigationState {
  final int currentIndex;

  CurrentIndexChanged({@required this.currentIndex});

  @override
  String toString() => 'CurrentIndexChanged to $currentIndex';

  @override
  List<Object> get props => [currentIndex];
}

class PageLoading extends BottomNavigationState {
  @override
  String toString() => 'PageLoading';
}

class FirstPageLoaded extends BottomNavigationState {
  final int number;

  const FirstPageLoaded({@required this.number});

  @override
  String toString() => 'FirstPageLoaded with number: $number';
  
  @override
  List<Object> get props => [number];
}

class SecondPageLoaded extends BottomNavigationState {
  final String text;

  const SecondPageLoaded({@required this.text});

  @override
  String toString() => 'SecondPageLoaded with text: $text';
  @override
  List<Object> get props => [text];
}



class ThirdPageLoaded extends BottomNavigationState {
  final String text;

  const ThirdPageLoaded({@required this.text});

  @override
  String toString() => 'ThirdPageLoaded with text: $text';
  @override
  List<Object> get props => [text];
}