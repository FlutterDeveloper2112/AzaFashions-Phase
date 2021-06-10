
class ResponseMessage{
String error="",success;

ResponseMessage({this.error,this.success});

ResponseMessage.withError(String errorMessage) {
    error = errorMessage;
  }
ResponseMessage.withSuccess(String successMessage) {
    this.success = successMessage;
  }

}
