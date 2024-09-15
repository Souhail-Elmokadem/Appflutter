import 'dart:io';

import 'package:guidanclyflutter/models/tour_model_receive.dart';

abstract class TourState {}

class TourStateInitializer extends TourState{}
class TourStateSuccess extends TourState{}
class TourStateGotIt extends TourState{
  final List<TourModelReceive> listTours;

  TourStateGotIt(this.listTours);

}
class TourStateLoading extends TourState{}
class TourStateFailure extends TourState{}
class TourStateEndOfPage extends TourState{}
class TourImagesUpdated extends TourState{
  final List<File> images;

  TourImagesUpdated(this.images);
}
class TourImagesFailedSize extends TourState{
   final String error;

   TourImagesFailedSize(this.error);
}