import 'package:azaFashions/models/ProductDetail/CustomizationModel.dart';
import 'package:azaFashions/models/Profile/MeasurementList.dart';
import 'package:azaFashions/repository/ProductDetailRepo.dart';
import 'package:azaFashions/validator/CustomizationValidator.dart';
import 'package:rxdart/rxdart.dart';

class CustomizationBloc extends Object with CustomizationValidator {
  final _repository = ProductDetailRepo();
  final _measurementListController = PublishSubject<MeasurementList>();

  //common fields
  final _shoulderLengthController = BehaviorSubject<String>();
  final _waistController = BehaviorSubject<String>();
  final _hipsController = BehaviorSubject<String>();

  //Mens Measurement
  final _chestController = BehaviorSubject<String>();
  final _frontShoulderToWaist = BehaviorSubject<String>();
  final _armLengthController = BehaviorSubject<String>();
  final _crotchDepthController = BehaviorSubject<String>();
  final _waistToKneeController = BehaviorSubject<String>();
  final _kneeLineController = BehaviorSubject<String>();
  final _neckCircumferenceController = BehaviorSubject<String>();
  final _napeToWaistController = BehaviorSubject<String>();
  final _backWidthController = BehaviorSubject<String>();
  final _topArmCircumferenceController = BehaviorSubject<String>();
  final _waistToFloorController = BehaviorSubject<String>();

  //Women Measurement
  final _armHoleController = BehaviorSubject<String>();
  final _bustSizeController = BehaviorSubject<String>();

  final _sleeveLengthController = BehaviorSubject<String>();
  final _bicepsController = BehaviorSubject<String>();
  final _yourHeightController = BehaviorSubject<String>();
  final _frontNeckController = BehaviorSubject<String>();
  final _backNeckDepthController = BehaviorSubject<String>();
  final _kurtaLengthController = BehaviorSubject<String>();
  final _bottomLengthController = BehaviorSubject<String>();

  //Women Functions
  Function(String) get armHoleChanged => _armHoleController.sink.add;

  Function(String) get frontNeckChanged => _frontNeckController.sink.add;

  Function(String) get shoulderLengthChanged =>
      _shoulderLengthController.sink.add;

  Function(String) get yourHeightChanged => _yourHeightController.sink.add;

  Function(String) get bustSizeChanged => _bustSizeController.sink.add;

  Function(String) get sleeveLengthChanged => _sleeveLengthController.sink.add;

  Function(String) get waistChanged => _waistController.sink.add;

  Function(String) get hipsChanged => _hipsController.sink.add;

  Function(String) get kurtaLengthChanged => _kurtaLengthController.sink.add;

  Function(String) get backNeckDepthChanged =>
      _backNeckDepthController.sink.add;

  Function(String) get bicepsChanged => _bicepsController.sink.add;

  Function(String) get bottomLengthChanged => _bottomLengthController.sink.add;

  // Men Functions
  Function(String) get chestChanged => _chestController.sink.add;

  Function(String) get frontShoulderToWaistChanged =>
      _frontShoulderToWaist.sink.add;

  Function(String) get armLengthChanged => _armLengthController.sink.add;

  Function(String) get crotchDepthChanged => _crotchDepthController.sink.add;

  Function(String) get waistToKneeChanged => _waistToKneeController.sink.add;

  Function(String) get kneeLineChanged => _kneeLineController.sink.add;

  Function(String) get neckCircumferenceChanged =>
      _neckCircumferenceController.sink.add;

  Function(String) get napeToWaistChanged => _napeToWaistController.sink.add;

  Function(String) get backWidthChanged => _backWidthController.sink.add;

  Function(String) get topArmCircumferenceChanged =>
      _topArmCircumferenceController.sink.add;

  Function(String) get waistToFloorChanged => _waistToFloorController.sink.add;

  //Women Streams
  Stream<String> get armHoleLength =>
      _armHoleController.stream.transform(armHole);

  Stream<String> get frontNeck =>
      _frontNeckController.stream.transform(frontNeckValidator);

  Stream<String> get shoulderLength =>
      _shoulderLengthController.stream.transform(shoulderLengthValidator);

  Stream<String> get yourHeightLength =>
      _yourHeightController.stream.transform(yourHeight);

  Stream<String> get bustSize =>
      _bustSizeController.stream.transform(bustSizeValidator);

  Stream<String> get sleeveLength =>
      _sleeveLengthController.stream.transform(sleeveLengthValidator);

  Stream<String> get waist => _waistController.stream.transform(waistValidator);

  Stream<String> get hips => _hipsController.stream.transform(hipsValidator);

  Stream<String> get kurtaLength =>
      _kurtaLengthController.stream.transform(kurtaLengthValidator);

  Stream<String> get backNeckDepth =>
      _backNeckDepthController.stream.transform(backNeckDepthValidator);

  Stream<String> get biceps =>
      _bicepsController.stream.transform(bicepsValidator);

  Stream<String> get bottomLength =>
      _bottomLengthController.stream.transform(bottomLengthValidator);

  //Men Streams
  Stream<String> get chest => _chestController.stream.transform(chestValidator);

  Stream<String> get frontShoulderToWaist =>
      _frontShoulderToWaist.stream.transform(frontShoulderToWaistValidator);

  Stream<String> get armLength =>
      _armLengthController.stream.transform(armLengthValidator);

  Stream<String> get crotchDepth =>
      _crotchDepthController.stream.transform(crotchDepthValidator);

  Stream<String> get waistToKnee =>
      _waistToKneeController.stream.transform(waistToKneeValidator);

  Stream<String> get kneeLine =>
      _kneeLineController.stream.transform(kneeLineValidator);

  Stream<String> get neckCircumference =>
      _neckCircumferenceController.stream.transform(neckCircumferenceValidator);

  Stream<String> get napeToWaist =>
      _napeToWaistController.stream.transform(napeToWaistValidator);

  Stream<String> get backWidth =>
      _backWidthController.stream.transform(backWidthValidator);

  Stream<String> get topArmCircumference =>
      _topArmCircumferenceController.stream
          .transform(topArmCircumferenceValidator);

  Stream<String> get waistToFloor =>
      _waistToFloorController.stream.transform(waistToFloorValidator);

  Stream<bool> get measurements =>
      Rx.combineLatest2(womenMeasurements, womenMeasurement2, (a, b) => true);

  Stream<bool> get menMeasurements1 => Rx.combineLatest9(
      shoulderLength,
      chest,
      frontShoulderToWaist,
      waist,
      armLength,
      hips,
      crotchDepth,
      waistToKnee,
      kneeLine,
          (a, b, c, d, e, f, g, h, i) => true);

  Stream<bool> get menMeasurements2 => Rx.combineLatest5(
      neckCircumference,
      napeToWaist,
      backWidth,
      topArmCircumference,
      waistToFloor,
          (a, b, c, d, e) => true);

  Stream<bool> get menMeasurements =>
      Rx.combineLatest2(menMeasurements1, menMeasurements2, (a, b) => true);

  Stream<bool> get womenMeasurements => Rx.combineLatest8(
      shoulderLength,
      armHoleLength,
      bustSize,
      frontNeck,
      waist,
      hips,
      sleeveLength,
      biceps,
          (a, b, c, d, e, f, g, h) => true);

  Stream<bool> get womenMeasurement2 => Rx.combineLatest4(yourHeightLength,
      backNeckDepth, bottomLength, kurtaLength, (a, b, c, d) => true);

  Stream<MeasurementList> get measurementDetails =>
      _measurementListController.stream;

  // addMeasurement(String type, String comments, String category, int productId,
  //     bool agree) async {
  //   if (category == "Women") {
  //     CustomizationModelWomen model = CustomizationModelWomen(
  //         type: type,
  //         category: category,
  //         shoulderLength: (_shoulderLengthController.value),
  //         armHole: double.parse(_armHoleController.value),
  //         bust: double.parse(_bustSizeController.value),
  //         waist: double.parse(_waistController.value),
  //         hips: double.parse(_hipsController.value),
  //         sleeveLength: double.parse(_sleeveLengthController.value),
  //         biceps: double.parse(_bicepsController.value),
  //         yourHeight: double.parse(_yourHeightController.value),
  //         frontNeckDepth: double.parse(_frontNeckController.value),
  //         backNeckDepth: double.parse(_backNeckDepthController.value),
  //         kurtaLength: double.parse(_kurtaLengthController.value),
  //         bottomLength: double.parse(_bottomLengthController.value),
  //         comments: comments,
  //         agree: agree ? 1 : 0);
  //     Map<String, dynamic> body = {
  //       "measurement_unit": model.type.toLowerCase(),
  //       "category": model.category.toLowerCase(),
  //       "shoulder": model.shoulderLength,
  //       "arm_hole": model.armHole,
  //       "bust": model.bust,
  //       "waist": model.waist,
  //       "hips": model.hips,
  //       "sleeve_length": model.sleeveLength,
  //       "bicep": model.biceps,
  //       "height": model.yourHeight,
  //       "front_neck_depth": model.frontNeckDepth,
  //       "back_neck_depth": model.backNeckDepth,
  //       "kurta_length": model.kurtaLength,
  //       "bottom_length": model.bottomLength,
  //       "comment": model.comments,
  //       "need_help": model.agree
  //     };
  //     await _repository.customization(body, productId);
  //   } else {
  //     CustomizationModelMen modelMen = CustomizationModelMen(
  //         type: type,
  //         category: category,
  //         shoulder: double.parse(_shoulderLengthController.value),
  //         chest: double.parse(_chestController.value),
  //         armLength: double.parse(_armLengthController.value),
  //         waist: double.parse(_waistController.value),
  //         hip: double.parse(_hipsController.value),
  //         crotchDepth: double.parse(_crotchDepthController.value),
  //         frontShoulderToWaist: double.parse(_frontShoulderToWaist.value),
  //         kneeLine: double.parse(_kneeLineController.value),
  //         neckCircumference: double.parse(_neckCircumferenceController.value),
  //         napeToWaist: double.parse(_napeToWaistController.value),
  //         topArmCircumference:
  //         double.parse(_topArmCircumferenceController.value),
  //         waistToKnee: double.parse(_waistToKneeController.value),
  //         backWidth: double.parse(_backWidthController.value),
  //         waistToFloor: double.parse(_waistToFloorController.value),
  //         comment: comments,
  //         needHelp: agree ? 1 : 0);
  //     Map<String, dynamic> bodyMen = {
  //       "measurement_unit": modelMen.type.toLowerCase(),
  //       "category": modelMen.category.toLowerCase(),
  //       "shoulder": modelMen.shoulder,
  //       "chest": modelMen.chest,
  //       "front_shoulder_to_waist": modelMen.frontShoulderToWaist,
  //       "waist": modelMen.waist,
  //       "arm_length": modelMen.armLength,
  //       "hip": modelMen.hip,
  //       "crotch_depth": modelMen.crotchDepth,
  //       "waist_to_knee": modelMen.waistToKnee,
  //       "knee_line": modelMen.kneeLine,
  //       "neck_circumference": modelMen.neckCircumference,
  //       "nape_to_waist": modelMen.napeToWaist,
  //       "back_width": modelMen.backWidth,
  //       "top_arm_circumference": modelMen.topArmCircumference,
  //       "waist_to_floor": modelMen.waistToFloor,
  //       "comment": modelMen.comment,
  //       "need_help": modelMen.needHelp,
  //     };
  //     await _repository.customization(bodyMen, productId);
  //   }
  // }

  void dispose() {
    _armHoleController?.close();
    _frontNeckController?.close();
    _shoulderLengthController?.close();
    _yourHeightController?.close();
    _bustSizeController?.close();

    _sleeveLengthController?.close();
    _waistController?.close();
    _hipsController?.close();
    _kurtaLengthController?.close();

    _backNeckDepthController?.close();
    _bicepsController?.close();

    _bottomLengthController?.close();
    _measurementListController?.close();

    _chestController?.close();
    _frontShoulderToWaist?.close();
    _armLengthController?.close();
    _crotchDepthController?.close();
    _waistToKneeController?.close();
    _kneeLineController?.close();
    _neckCircumferenceController?.close();
    _napeToWaistController?.close();
    _backWidthController?.close();
    _topArmCircumferenceController?.close();
    _waistToFloorController?.close();
  }
}

final customizationBloc = CustomizationBloc();
