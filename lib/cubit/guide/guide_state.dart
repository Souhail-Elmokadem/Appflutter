import 'package:guidanclyflutter/models/tour_model_receive.dart';

abstract class GuideState {}

class GuideStateInit extends GuideState{}
class GuideStateLoading extends GuideState{}
class GuideStateSuccess extends GuideState{
  List<TourModelReceive> tours;
  GuideStateSuccess(this.tours);
}
class GuideStateFailed extends GuideState{}