import 'package:azaFashions/models/Profile/MeasurementList.dart';
import 'package:azaFashions/repository/ProfileRepo.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:azaFashions/validator/MeasurementsValidator.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class MeasurementBloc extends Object with MeasurementsValidator {
  final _repository = ProfileRepo();
  static String errorMsg="";
  var _measurementListController = BehaviorSubject<MeasurementList>();

  var _measurementFor = BehaviorSubject<String>();
  var _genderController = BehaviorSubject<String>();
  var _capSleeveLengthController = BehaviorSubject<String>();
  var _frontNeckController = BehaviorSubject<String>();
  var _shoulderLengthController = BehaviorSubject<String>();
  var _shortSleeveLengthController = BehaviorSubject<String>();
  var _bustSizeController = BehaviorSubject<String>();
  var _underBustSizeController = BehaviorSubject<String>();
  var _sleeveLengthController = BehaviorSubject<String>();
  var _waistController = BehaviorSubject<String>();
  var _hipsController = BehaviorSubject<String>();
  var _chestController = BehaviorSubject<String>();

  var _backNeckController = BehaviorSubject<String>();
  var _shoulderApexController = BehaviorSubject<String>();
  var _backNeckDepthController = BehaviorSubject<String>();
  var _bicepsController = BehaviorSubject<String>();
  var _elbowRoundController = BehaviorSubject<String>();
  var _kneeLengthController = BehaviorSubject<String>();
  var _bottomLengthController = BehaviorSubject<String>();



  Function(String) get measurementForChanged => _measurementFor.sink.add;

  Function(String) get capSleeveLengthChanged =>
      _capSleeveLengthController.sink.add;

  Function(String) get frontNeckChanged => _frontNeckController.sink.add;

  Function(String) get shoulderLengthChanged =>
      _shoulderLengthController.sink.add;

  Function(String) get shortSleeveLengthChanged =>
      _shortSleeveLengthController.sink.add;

  Function(String) get bustSizeChanged => _bustSizeController.sink.add;

  Function(String) get underBustSizeChanged =>
      _underBustSizeController.sink.add;

  Function(String) get sleeveLengthChanged => _sleeveLengthController.sink.add;

  Function(String) get waistChanged => _waistController.sink.add;

  Function(String) get hipsChanged => _hipsController.sink.add;

  Function(String) get chestChanged => _chestController.sink.add;

  Function(String) get backNeckChanged => _backNeckController.sink.add;

  Function(String) get shoulderApexChanged => _shoulderApexController.sink.add;

  Function(String) get backNeckDepthChanged =>
      _backNeckDepthController.sink.add;

  Function(String) get bicepsChanged => _bicepsController.sink.add;

  Function(String) get elbowChanged => _elbowRoundController.sink.add;

  Function(String) get kneeLengthChanged => _kneeLengthController.sink.add;

  Function(String) get bottomLengthChanged => _bottomLengthController.sink.add;

  Stream<String> get measurementFor =>
      _measurementFor.stream.transform(measurementForValidator);

  Stream<String> get capSleeveLength =>
      _capSleeveLengthController.stream.transform(capSleeveLengthValidator);

  Stream<String> get frontNeck =>
      _frontNeckController.stream.transform(frontNeckValidator);

  Stream<String> get shoulderLength =>
      _shoulderLengthController.stream.transform(shoulderLengthValidator);

  Stream<String> get shortSleeveLength =>
      _shortSleeveLengthController.stream.transform(shortSleeveLengthValidator);

  Stream<String> get bustSize =>
      _bustSizeController.stream.transform(bustSizeValidator);

  Stream<String> get underBustSize =>
      _underBustSizeController.stream.transform(underBustSizeValidator);

  Stream<String> get sleeveLength =>
      _sleeveLengthController.stream.transform(sleeveLengthValidator);

  Stream<String> get waist => _waistController.stream.transform(waistValidator);

  Stream<String> get hips => _hipsController.stream.transform(hipsValidator);

  Stream<String> get chest => _chestController.stream.transform(chestValidator);

  Stream<String> get neck =>
      _backNeckController.stream.transform(backNeckValidator);

  Stream<String> get shoulderApex =>
      _shoulderApexController.stream.transform(shoulderApexValidator);

  Stream<String> get backNeckDepth =>
      _backNeckDepthController.stream.transform(backNeckDepthValidator);

  Stream<String> get biceps =>
      _bicepsController.stream.transform(bicepsValidator);

  Stream<String> get elbowRound =>
      _elbowRoundController.stream.transform(elbowRoundValidator);

  Stream<String> get kneeLength =>
      _kneeLengthController.stream.transform(kneeLengthValidator);

  Stream<String> get bottomLength =>
      _bottomLengthController.stream.transform(bottomLengthValidator);

  Stream<bool> get measurements =>
      Rx.combineLatest2(frontMeasurements, backMeasurements, (a, b) => true);

  Stream<bool> get maleMeasurements => Rx.combineLatest4(
      chest, waist, hips, shoulderLength, (a, b, c, d) => true);

  Stream<bool> get frontMeasurements => Rx.combineLatest9(
      capSleeveLength,
      frontNeck,
      shoulderLength,
      shortSleeveLength,
      bustSize,
      underBustSize,
      sleeveLength,
      waist,
      hips,
          (a, b, c, d, e, f, g, h, i) => true);

  Stream<bool> get backMeasurements => Rx.combineLatest7(
      neck,
      shoulderApex,
      backNeckDepth,
      biceps,
      elbowRound,
      kneeLength,
      bottomLength,
          (a, b, c, d, e, f, g) => true);

  Stream<MeasurementList> get measurementDetails =>
      _measurementListController.stream;

  get cm => null;

  addMeasurement(BuildContext context,String gender,String measurementFor) async {
    MeasurementBloc.errorMsg="";
    if (gender.toLowerCase() == "male") {
      MaleMeasurement maleMeasurement = MaleMeasurement(
          chest: (_chestController.value),
          shoulderLength: (_shoulderLengthController.value),
          waist: (_waistController.value),
          hips: (_hipsController.value));
      if(_chestController.value==null && _shoulderLengthController.value==null  && _waistController.value==null && _hipsController.value==null){
        MeasurementBloc.errorMsg="Error in fields";
        ToastMsg().getFailureMsg(context, "Please enter your measurements");
      }else{
        if(_chestController.value!=null || _shoulderLengthController.value!=null  || _waistController.value!=null || _hipsController.value!=null){
          MeasurementBloc.errorMsg="";
          Measurements measurements = Measurements(
              gender: gender, title: _measurementFor.value!=null?_measurementFor.value:measurementFor, maleMeasurement: maleMeasurement);
          await _repository.addMeasurementRepo(measurements);

        }
        else{
          MeasurementBloc.errorMsg="Error in fields";
          ToastMsg().getFailureMsg(context, "Please enter the measurements");

        }

      }
    } else {
      FrontMeasurements frontMeasurements = new FrontMeasurements(
          capSleeveLength: (_capSleeveLengthController.value),
          frontNeck: (_frontNeckController.value),
          shoulderLength: (_shoulderLengthController.value),
          shortSleeveLength: (_shortSleeveLengthController.value),
          bust: (_bustSizeController.value),
          underBust: (_underBustSizeController.value),
          sleeveLength: (_sleeveLengthController.value),
          waist: (_waistController.value),
          hips: (_hipsController.value));
      BackMeasurements backMeasurements = new BackMeasurements(
          neck: (_backNeckController.value),
          shoulderApex: (_shoulderApexController.value),
          backNeckDepth: (_backNeckDepthController.value),
          bicep: (_bicepsController.value),
          elbowRound: (_elbowRoundController.value),
          kneeLength: (_kneeLengthController.value),
          bottomLength: (_bottomLengthController.value));

      if(_capSleeveLengthController.value==null &&
          _frontNeckController.value==null  &&
          _shoulderLengthController.value==null &&
          _shortSleeveLengthController.value==null &&
          _bustSizeController.value==null &&
          _underBustSizeController.value==null &&
      _sleeveLengthController.value==null &&
      _waistController.value==null &&
          _hipsController.value==null && _backNeckController.value==null &&
          _shoulderApexController.value==null &&_bicepsController.value==null &&
          _backNeckDepthController.value==null && _elbowRoundController.value==null && _kneeLengthController.value==null &&
          _bottomLengthController.value==null ){
        MeasurementBloc.errorMsg="Error in fields";
        ToastMsg().getFailureMsg(context, "Please enter your measurements.");

      }
      else{
        if(_capSleeveLengthController.value!=null ||
            _frontNeckController.value!=null  ||
            _shoulderLengthController.value!=null ||
            _shortSleeveLengthController.value!=null ||
            _bustSizeController.value!=null ||
            _underBustSizeController.value!=null ||
            _sleeveLengthController.value!=null ||
            _waistController.value!=null ||
            _hipsController.value!=null || _backNeckController.value!=null ||
            _shoulderApexController.value!=null ||_bicepsController.value!=null ||
            _backNeckDepthController.value!=null || _elbowRoundController.value!=null || _kneeLengthController.value!=null ||
            _bottomLengthController.value!=null ){

          MeasurementBloc.errorMsg="";
          MeasurementDetails measurementDetails = MeasurementDetails(
              frontBody: frontMeasurements, backBody: backMeasurements);
          Measurements measurements = new Measurements(
              title: _measurementFor.value!=null?_measurementFor.value:measurementFor,
              measurementDetails: measurementDetails,
              gender: gender);
          await _repository.addMeasurementRepo(measurements);

        }
        else{
          MeasurementBloc.errorMsg="Error in fields";
          ToastMsg().getFailureMsg(context, "Please enter your measurements.");

        }

      }

    }
  }

  removeMeasurement(int measurementId) async {
    await _repository.removeMeasurementRepo(measurementId);
  }

  getMeasurements() async {
    clearMeasurementData();
    print("GET MEASUREMENT CALLED");
    MeasurementList measurements = await _repository.getMeasurementsRepo();
    _measurementListController.sink.add(measurements);
  }

  updateMeasurement(String gender, int measurementId, String measurementFor,
      {MaleMeasurement measurement,
        FrontMeasurements fMeasurements,
        BackMeasurements bMeasurements}) async {
    if (gender.toLowerCase() == "male") {
      MaleMeasurement maleMeasurements = new MaleMeasurement(
          chest: _chestController.value != null
              ? (_chestController.value)
              : measurement.chest,
          shoulderLength: _shoulderLengthController.value != null
              ? (_shoulderLengthController.value)
              : measurement.shoulderLength,
          waist: _waistController.value != null
              ? (_waistController.value)
              : measurement.waist,
          hips: _hipsController.value != null
              ? (_hipsController.value)
              : measurement.hips);

      Measurements measurements = Measurements(
        id: measurementId,
        title: _measurementFor.value!=null?_measurementFor.value:measurementFor,
        gender: gender,
        maleMeasurement: maleMeasurements,
      );
      await _repository.updateMeasurementRepo(measurements);
    } else {
      FrontMeasurements frontMeasurements = new FrontMeasurements(
          capSleeveLength: _capSleeveLengthController.value != null
              ? (_capSleeveLengthController.value)
              : fMeasurements.capSleeveLength,
          frontNeck: _frontNeckController.value != null
              ? (_frontNeckController.value)
              : fMeasurements.frontNeck,
          shoulderLength: _shoulderLengthController.value != null
              ? (_shoulderLengthController.value)
              : fMeasurements.shoulderLength,
          shortSleeveLength: _shortSleeveLengthController.value != null
              ? (_shortSleeveLengthController.value)
              : fMeasurements.shortSleeveLength,
          bust: _bustSizeController.value != null
              ? (_bustSizeController.value)
              : fMeasurements.bust,
          underBust: _underBustSizeController.value != null
              ?(_underBustSizeController.value)
              : fMeasurements.underBust,
          sleeveLength: _sleeveLengthController.value != null
              ? (_sleeveLengthController.value)
              : fMeasurements.sleeveLength,
          waist: _waistController.value != null
              ? (_waistController.value)
              : fMeasurements.waist,
          hips: _hipsController.value != null
              ? (_hipsController.value)
              : fMeasurements.hips);
      BackMeasurements backMeasurements = new BackMeasurements(
          neck: _backNeckController.value != null
              ?(_backNeckController.value)
              : bMeasurements.neck,
          shoulderApex: _shoulderApexController.value != null
              ? (_shoulderApexController.value)
              : bMeasurements.shoulderApex,
          backNeckDepth: _backNeckDepthController.value != null
              ? (_backNeckDepthController.value)
              : bMeasurements.backNeckDepth,
          bicep: _bicepsController.value != null
              ? (_bicepsController.value)
              : bMeasurements.bicep,
          elbowRound: _elbowRoundController.value != null
              ? (_elbowRoundController.value)
              : bMeasurements.elbowRound,
          kneeLength: _kneeLengthController.value != null
              ? (_kneeLengthController.value)
              : bMeasurements.kneeLength,
          bottomLength: _bottomLengthController.value != null
              ? (_bottomLengthController.value)
              : bMeasurements.bottomLength);
      MeasurementDetails measurementDetails = MeasurementDetails(
          frontBody: frontMeasurements, backBody: backMeasurements);
      Measurements measurements = new Measurements(
          title: _measurementFor.value!=null?_measurementFor.value:measurementFor,
          id: measurementId,
          measurementDetails: measurementDetails,
          gender: gender);
      await _repository.updateMeasurementRepo(measurements);
    }
  }

  void dispose() {
    _measurementFor?.close();
    _genderController?.close();
    _capSleeveLengthController?.close();
    _frontNeckController?.close();
    _shoulderLengthController?.close();
    _shortSleeveLengthController?.close();
    _bustSizeController?.close();
    _underBustSizeController?.close();
    _sleeveLengthController?.close();
    _waistController?.close();
    _hipsController?.close();
    _chestController?.close();
    _backNeckController?.close();
    _shoulderApexController?.close();
    _backNeckDepthController?.close();
    _bicepsController?.close();
    _elbowRoundController?.close();
    _kneeLengthController?.close();
    _bottomLengthController?.close();


    _measurementFor = BehaviorSubject<String>();
    _genderController = BehaviorSubject<String>();
    _capSleeveLengthController = BehaviorSubject<String>();
    _frontNeckController = BehaviorSubject<String>();
    _shoulderLengthController = BehaviorSubject<String>();
    _shortSleeveLengthController = BehaviorSubject<String>();
    _bustSizeController = BehaviorSubject<String>();
    _underBustSizeController = BehaviorSubject<String>();
    _sleeveLengthController = BehaviorSubject<String>();
    _waistController = BehaviorSubject<String>();
    _hipsController = BehaviorSubject<String>();
    _chestController = BehaviorSubject<String>();

    _backNeckController = BehaviorSubject<String>();
    _shoulderApexController = BehaviorSubject<String>();
    _backNeckDepthController = BehaviorSubject<String>();
    _bicepsController = BehaviorSubject<String>();
    _elbowRoundController = BehaviorSubject<String>();
    _kneeLengthController = BehaviorSubject<String>();
    _bottomLengthController = BehaviorSubject<String>();
  }

  clearMeasurementData(){
    _measurementListController?.close();
    _measurementListController = BehaviorSubject<MeasurementList>();
  }
}

final measurementBloc = MeasurementBloc();
