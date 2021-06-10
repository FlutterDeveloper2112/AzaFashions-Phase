import 'dart:async';

mixin CustomizationValidator {


  //Women Validators
  var armHole = StreamTransformer<String, String>.fromHandlers(
      handleData: (capLength, sink) {
        if (capLength.length != 0) {
          if (capLength.contains(".")) {
            double.parse(capLength) <= 99 && capLength.length <= 5
                ? sink.add(capLength)
                : sink.addError("Incorrect");
          } else {
            int.parse(capLength) <= 99 && capLength.length <= 2
                ? sink.add(capLength)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var frontNeckValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (frontNeck, sink) {
        if (frontNeck.length != 0) {
          if (frontNeck.contains(".")) {
            double.parse(frontNeck) <= 99 && frontNeck.length <= 5
                ? sink.add(frontNeck)
                : sink.addError("Incorrect");
          } else {
            int.parse(frontNeck) <= 99 && frontNeck.length <= 2
                ? sink.add(frontNeck)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var shoulderLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (shoulderLength, sink) {
        if (shoulderLength.length != 0) {
          if (shoulderLength.contains(".")) {
            double.parse(shoulderLength) <= 99 && shoulderLength.length <= 5
                ? sink.add(shoulderLength)
                : sink.addError("Incorrect");
          } else {
            int.parse(shoulderLength) <= 99 && shoulderLength.length <= 2
                ? sink.add(shoulderLength)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var yourHeight = StreamTransformer<String, String>.fromHandlers(
      handleData: (shortSleeveLength, sink) {
        if (shortSleeveLength.length != 0) {
          if (shortSleeveLength.contains(".")) {
            double.parse(shortSleeveLength) <= 99 && shortSleeveLength.length <= 5
                ? sink.add(shortSleeveLength)
                : sink.addError("Incorrect");
          } else {
            int.parse(shortSleeveLength) <= 99 && shortSleeveLength.length <= 2
                ? sink.add(shortSleeveLength)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var bustSizeValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (bustSize, sink) {
        if (bustSize.length != 0) {
          if (bustSize.contains(".")) {
            double.parse(bustSize) <= 99 && bustSize.length <= 5
                ? sink.add(bustSize)
                : sink.addError("Incorrect");
          } else {
            int.parse(bustSize) <= 99 && bustSize.length <= 2
                ? sink.add(bustSize)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var kurtaLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (underBustSize, sink) {
        if (underBustSize.length != 0) {
          if (underBustSize.contains(".")) {
            double.parse(underBustSize) <= 99 && underBustSize.length <= 5
                ? sink.add(underBustSize)
                : sink.addError("Incorrect");
          } else {
            int.parse(underBustSize) <= 99 && underBustSize.length <= 2
                ? sink.add(underBustSize)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var sleeveLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (sleeveLength, sink) {
        if (sleeveLength.length != 0) {
          if (sleeveLength.contains(".")) {
            double.parse(sleeveLength) <= 99 && sleeveLength.length <= 5
                ? sink.add(sleeveLength)
                : sink.addError("Incorrect");
          } else {
            int.parse(sleeveLength) <= 99 && sleeveLength.length <= 2
                ? sink.add(sleeveLength)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var waistValidator = StreamTransformer<String, String>.fromHandlers(handleData: (waist, sink) {
    if (waist.length != 0) {
      if (waist.contains(".")) {
        double.parse(waist) <= 99 && waist.length <= 5
            ? sink.add(waist)
            : sink.addError("Incorrect");
      } else {
        int.parse(waist) <= 99 && waist.length <= 2
            ? sink.add(waist)
            : sink.addError("Incorrect");
      }
    } else {
      sink.addError('Incorrect');
    }
  });
  var hipsValidator = StreamTransformer<String, String>.fromHandlers(handleData: (hips, sink) {
    if (hips.length != 0) {
      if (hips.contains(".")) {
        double.parse(hips) <= 99 && hips.length <= 5
            ? sink.add(hips)
            : sink.addError("Incorrect");
      } else {
        int.parse(hips) <= 99 && hips.length <= 2
            ? sink.add(hips)
            : sink.addError("Incorrect");
      }
    } else {
      sink.addError('Incorrect');
    }
  });
  var backNeckDepthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (backNeckDepth, sink) {
        if (backNeckDepth.length != 0) {
          if (backNeckDepth.contains(".")) {
            double.parse(backNeckDepth) <= 99 && backNeckDepth.length <= 5
                ? sink.add(backNeckDepth)
                : sink.addError("Incorrect");
          } else {
            int.parse(backNeckDepth) <= 99 && backNeckDepth.length <= 2
                ? sink.add(backNeckDepth)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var bicepsValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (biceps, sink) {
        if (biceps.length != 0) {
          if (biceps.contains(".")) {
            double.parse(biceps) <= 99 && biceps.length <= 5
                ? sink.add(biceps)
                : sink.addError("Incorrect");
          } else {
            int.parse(biceps) <= 99 && biceps.length <= 2
                ? sink.add(biceps)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var bottomLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (bottomLength, sink) {
        if (bottomLength.length != 0) {
          if (bottomLength.contains(".")) {
            double.parse(bottomLength) <= 99 && bottomLength.length <= 5
                ? sink.add(bottomLength)
                : sink.addError("Incorrect");
          } else {
            int.parse(bottomLength) <= 99 && bottomLength.length <= 2
                ? sink.add(bottomLength)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });



  //Men Validators

  var chestValidator = StreamTransformer<String, String>.fromHandlers(handleData: (chest, sink) {
    if (chest.length != 0) {
      if (chest.contains(".")) {
        double.parse(chest) <= 99 && chest.length <= 5
            ? sink.add(chest)
            : sink.addError("Incorrect");
      } else {
        int.parse(chest) <= 99 && chest.length <= 2
            ? sink.add(chest)
            : sink.addError("Incorrect");
      }
    } else {
      sink.addError('Incorrect');
    }
  });
  var frontShoulderToWaistValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (frontShoulderToWaist, sink) {
        if (frontShoulderToWaist.length != 0) {
          if (frontShoulderToWaist.contains(".")) {
            double.parse(frontShoulderToWaist) <= 99 && frontShoulderToWaist.length <= 5
                ? sink.add(frontShoulderToWaist)
                : sink.addError("Incorrect");
          } else {
            int.parse(frontShoulderToWaist) <= 99 && frontShoulderToWaist.length <= 2
                ? sink.add(frontShoulderToWaist)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var armLengthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (armLengthValidator, sink) {
        if (armLengthValidator.length != 0) {
          if (armLengthValidator.contains(".")) {
            double.parse(armLengthValidator) <= 99 && armLengthValidator.length <= 5
                ? sink.add(armLengthValidator)
                : sink.addError("Incorrect");
          } else {
            int.parse(armLengthValidator) <= 99 && armLengthValidator.length <= 2
                ? sink.add(armLengthValidator)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var crotchDepthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (crotchDepthValidator, sink) {
        if (crotchDepthValidator.length != 0) {
          if (crotchDepthValidator.contains(".")) {
            double.parse(crotchDepthValidator) <= 99 && crotchDepthValidator.length <= 5
                ? sink.add(crotchDepthValidator)
                : sink.addError("Incorrect");
          } else {
            int.parse(crotchDepthValidator) <= 99 && crotchDepthValidator.length <= 2
                ? sink.add(crotchDepthValidator)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect');
        }
      });
  var waistToKneeValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (waistToKnee, sink) {
        if (waistToKnee.length != 0) {
          if (waistToKnee.contains(".")) {
            double.parse(waistToKnee) <= 99 && waistToKnee.length <= 5
                ? sink.add(waistToKnee)
                : sink.addError("Incorrect");
          } else {
            int.parse(waistToKnee) <= 99 && waistToKnee.length <= 2
                ? sink.add(waistToKnee)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect Measurement');
        }
      });

  var kneeLineValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (kneeLineValidator, sink) {
        if (kneeLineValidator.length != 0) {
          if (kneeLineValidator.contains(".")) {
            double.parse(kneeLineValidator) <= 99 && kneeLineValidator.length <= 5
                ? sink.add(kneeLineValidator)
                : sink.addError("Incorrect");
          } else {
            int.parse(kneeLineValidator) <= 99 && kneeLineValidator.length <= 2
                ? sink.add(kneeLineValidator)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect Measurement');
        }
      });
  var neckCircumferenceValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (neckCircumference, sink) {
        if (neckCircumference.length != 0) {
          if (neckCircumference.contains(".")) {
            double.parse(neckCircumference) <= 99 && neckCircumference.length <= 5
                ? sink.add(neckCircumference)
                : sink.addError("Incorrect");
          } else {
            int.parse(neckCircumference) <= 99 && neckCircumference.length <= 2
                ? sink.add(neckCircumference)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect Measurement');
        }
      });
  var napeToWaistValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (napeToWaist, sink) {
        if (napeToWaist.length != 0) {
          if (napeToWaist.contains(".")) {
            double.parse(napeToWaist) <= 99 && napeToWaist.length <= 5
                ? sink.add(napeToWaist)
                : sink.addError("Incorrect");
          } else {
            int.parse(napeToWaist) <= 99 && napeToWaist.length <= 2
                ? sink.add(napeToWaist)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect Measurement');
        }
      });
  var backWidthValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (backWidth, sink) {
        if (backWidth.length != 0) {
          if (backWidth.contains(".")) {
            double.parse(backWidth) <= 99 && backWidth.length <= 5
                ? sink.add(backWidth)
                : sink.addError("Incorrect");
          } else {
            int.parse(backWidth) <= 99 && backWidth.length <= 2
                ? sink.add(backWidth)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect Measurement');
        }
      });
  var topArmCircumferenceValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (topArmCircumference, sink) {
        if (topArmCircumference.length != 0) {
          if (topArmCircumference.contains(".")) {
            double.parse(topArmCircumference) <= 99 && topArmCircumference.length <= 5
                ? sink.add(topArmCircumference)
                : sink.addError("Incorrect");
          } else {
            int.parse(topArmCircumference) <= 99 && topArmCircumference.length <= 2
                ? sink.add(topArmCircumference)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect Measurement');
        }
      });
  var waistToFloorValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (waistToFloor, sink) {
        if (waistToFloor.length != 0) {
          if (waistToFloor.contains(".")) {
            double.parse(waistToFloor) <= 99 && waistToFloor.length <= 5
                ? sink.add(waistToFloor)
                : sink.addError("Incorrect");
          } else {
            int.parse(waistToFloor) <= 99 && waistToFloor.length <= 2
                ? sink.add(waistToFloor)
                : sink.addError("Incorrect");
          }
        } else {
          sink.addError('Incorrect Measurement');
        }
      });
}

// {    "measurement_unit": "inch",
// "category":"men",
// "shoulder":2,
// "chest":4,
// "front_shoulder_to_waist":3,
// "waist":4,
// "arm_length":5,
// "hip":6,
// "crotch_depth":7,
// "waist_to_knee":8,
// "knee_line":9,
// "neck_circumference":1,
// "nape_to_waist":2,
// "back_width":3,
// "top_arm_circumference":2,
// "waist_to_floor":1,
// "comment":"nope",
// "need_help": 1
// }