import 'dart:async';

import 'dart:math';

mixin MeasurementsValidator {
  var measurementForValidator =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 3) {
      sink.add(name);
    } else {
      sink.addError('Invalid Name');
    }
  });

  var capSleeveLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (capLength, sink) {
        print(capLength);
        if (capLength.length != 0) {
          if(!capLength.startsWith("0")){
            if (capLength.contains(".")) {
              double.parse(capLength) <= 99 && capLength.length <= 5
                  ? sink.add(capLength)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(capLength) <= 99 && capLength.length <= 2
                  ? sink.add(capLength)
                  : sink.addError("Incorrect Measurement");
            }
          }else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(capLength);
          // sink.addError('Incorrect');
        }
      });

  var frontNeckValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (frontNeck, sink) {
        if (frontNeck.length != 0 ) {
          if(!frontNeck.startsWith("0")){
            if (frontNeck.contains(".")) {
              double.parse(frontNeck) <= 99 && frontNeck.length <= 5
                  ? sink.add(frontNeck)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(frontNeck) <= 99 && frontNeck.length <= 2
                  ? sink.add(frontNeck)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          // sink.addError('Incorrect');
          sink.add(frontNeck);
        }
      });
  var shoulderLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (shoulderLength, sink) {
        if (shoulderLength.length != 0 ) {
          if(!shoulderLength.startsWith("0")){
            if (shoulderLength.contains(".")) {
              double.parse(shoulderLength) <= 99 && shoulderLength.length <= 5
                  ? sink.add(shoulderLength)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(shoulderLength) <= 99 && shoulderLength.length <= 2
                  ? sink.add(shoulderLength)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(shoulderLength);
          // sink.addError('Incorrect');
        }
      });
  var shortSleeveLengthValidator =
  StreamTransformer<String, String>.fromHandlers(
      handleData: (shortSleeveLength, sink) {
        if (shortSleeveLength.length != 0) {
          if(!shortSleeveLength.startsWith("0")){
            if (shortSleeveLength.contains(".")) {
              double.parse(shortSleeveLength) <= 99 && shortSleeveLength.length <= 5
                  ? sink.add(shortSleeveLength)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(shortSleeveLength) <= 99 && shortSleeveLength.length <= 2
                  ? sink.add(shortSleeveLength)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(shortSleeveLength);
          // sink.addError('Incorrect');
        }
      });
  var bustSizeValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (bustSize, sink) {
        if (bustSize.length != 0 ) {
          if(!bustSize.startsWith("0")){
            if (bustSize.contains(".")) {
              double.parse(bustSize) <= 99 && bustSize.length <= 5
                  ? sink.add(bustSize)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(bustSize) <= 99 && bustSize.length <= 2
                  ? sink.add(bustSize)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(bustSize);
          // sink.addError('Incorrect Measurement');
        }
      });
  var underBustSizeValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (underBustSize, sink) {
        if (underBustSize.length != 0) {
          if(!underBustSize.startsWith("0")){

            if (underBustSize.contains(".")) {
              double.parse(underBustSize) <= 99 && underBustSize.length <= 5
                  ? sink.add(underBustSize)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(underBustSize) <= 99 && underBustSize.length <= 2
                  ? sink.add(underBustSize)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(underBustSize);
          // sink.addError('Incorrect Measurement');
        }
      });
  var sleeveLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (sleeveLength, sink) {
        if (sleeveLength.length != 0 ) {
          if( !sleeveLength.startsWith("0")){
            if (sleeveLength.contains(".")) {
              double.parse(sleeveLength) <= 99 && sleeveLength.length <= 5
                  ? sink.add(sleeveLength)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(sleeveLength) <= 99 && sleeveLength.length <= 2
                  ? sink.add(sleeveLength)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(sleeveLength);
          // sink.addError('Incorrect Measurement');
        }
      });
  var waistValidator =
  StreamTransformer<String, String>.fromHandlers(handleData: (waist, sink) {
    if (waist.length != 0 ) {
      if(!waist.startsWith("0")){
        if (waist.contains(".")) {
          double.parse(waist) <= 99 && waist.length <= 5
              ? sink.add(waist)
              : sink.addError("Incorrect Measurement");
        } else {
          int.parse(waist) <= 99 && waist.length <= 2
              ? sink.add(waist)
              : sink.addError("Incorrect Measurement");
        }
      }
      else{
        sink.addError("Incorrect Measurement");
      }

    } else {
      // sink.addError('Incorrect Measurement');
      sink.add(waist);
    }
  });
  var hipsValidator =
  StreamTransformer<String, String>.fromHandlers(handleData: (hips, sink) {
    if (hips.length != 0) {
      if(!hips.startsWith("0")){
        if (hips.contains(".")) {
          double.parse(hips) <= 99 && hips.length <= 5
              ? sink.add(hips)
              : sink.addError("Incorrect Measurement");
        } else {
          int.parse(hips) <= 99 && hips.length <= 2
              ? sink.add(hips)
              : sink.addError("Incorrect Measurement");
        }
      }
      else{
        sink.addError("Incorrect Measurement");
      }

    } else {
      // sink.addError('Incorrect Measurement');
      sink.add(hips);
    }
  });

  var chestValidator =
  StreamTransformer<String, String>.fromHandlers(handleData: (chest, sink) {
    if (chest.length != 0 ) {

      if(!chest.startsWith("0")){
        if (chest.contains(".")) {
          double.parse(chest) <= 99 && chest.length <= 5
              ? sink.add(chest)
              : sink.addError("Incorrect Measurement");
        } else {
          int.parse(chest) <= 99 && chest.length <= 2
              ? sink.add(chest)
              : sink.addError("Incorrect Measurement");
        }
      }
      else{
        sink.addError("Incorrect Measurement");
      }

    } else {
      sink.add(chest);
      // sink.addError('Incorrect Measurement');
    }
  });

  var backNeckValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (backNeck, sink) {
        if (backNeck.length != 0) {
          if( !backNeck.startsWith("0")){
            if (backNeck.contains(".")) {
              double.parse(backNeck) <= 99 && backNeck.length <= 5
                  ? sink.add(backNeck)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(backNeck) <= 99 && backNeck.length <= 2
                  ? sink.add(backNeck)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(backNeck);
          // sink.addError('Incorrect Measurement');
        }
      });
  var shoulderApexValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (shoulderApex, sink) {
        if (shoulderApex.length != 0 ) {
          if(!shoulderApex.startsWith("0")){
            if (shoulderApex.contains(".")) {
              double.parse(shoulderApex) <= 99 && shoulderApex.length <= 5
                  ? sink.add(shoulderApex)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(shoulderApex) <= 99 && shoulderApex.length <= 2
                  ? sink.add(shoulderApex)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(shoulderApex);
          // sink.addError('Incorrect');
        }
      });
  var backNeckDepthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (backNeckDepth, sink) {
        if (backNeckDepth.length != 0) {
          if(!backNeckDepth.startsWith("0")){
            if (backNeckDepth.contains(".")) {
              double.parse(backNeckDepth) <= 99 && backNeckDepth.length <= 5
                  ? sink.add(backNeckDepth)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(backNeckDepth) <= 99 && backNeckDepth.length <= 2
                  ? sink.add(backNeckDepth)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(backNeckDepth);
          // sink.addError('Incorrect');
        }
      });
  var bicepsValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (biceps, sink) {
        if (biceps.length != 0) {
          if(!biceps.startsWith("0")){

            if (biceps.contains(".")) {
              double.parse(biceps) <= 99 && biceps.length <= 5
                  ? sink.add(biceps)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(biceps) <= 99 && biceps.length <= 2
                  ? sink.add(biceps)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(biceps);
          // sink.addError('Incorrect');
        }
      });
  var elbowRoundValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (elbowRound, sink) {
        if (elbowRound.length != 0) {
          if(!elbowRound.startsWith("0")){
            if (elbowRound.contains(".")) {
              double.parse(elbowRound) <= 99 && elbowRound.length <= 5
                  ? sink.add(elbowRound)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(elbowRound) <= 99 && elbowRound.length <= 2
                  ? sink.add(elbowRound)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(elbowRound);
          // sink.addError('Incorrect Measurement');
        }
      });
  var kneeLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (kneeLength, sink) {
        if (kneeLength.length != 0) {
          if(!kneeLength.startsWith("0")){
            if (kneeLength.contains(".")) {
              double.parse(kneeLength) <= 99 && kneeLength.length <= 5
                  ? sink.add(kneeLength)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(kneeLength) <= 99 && kneeLength.length <= 2
                  ? sink.add(kneeLength)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(kneeLength);
          // sink.addError('Incorrect Measurement Measurement');
        }
      });
  var bottomLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (bottomLength, sink) {
        if (bottomLength.length != 0) {
          if(!bottomLength.startsWith("0")){
            if (bottomLength.contains(".")) {
              double.parse(bottomLength) <= 99 && bottomLength.length <= 5
                  ? sink.add(bottomLength)
                  : sink.addError("Incorrect Measurement");
            } else {
              int.parse(bottomLength) <= 99 && bottomLength.length <= 2
                  ? sink.add(bottomLength)
                  : sink.addError("Incorrect Measurement");
            }
          }
          else{
            sink.addError("Incorrect Measurement");
          }

        } else {
          sink.add(bottomLength);
          // sink.addError('Incorrect Measurement');
        }
      });
}
