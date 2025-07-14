
class FeedbackModel {
  final String from;
  final String feedback;
  final bool status;

  FeedbackModel({
    required this.from,
    required this.feedback,
    this.status = true,
  });

  Map<String, dynamic> toJson() => {
        "from": from,
        "feedback": feedback,
        "status": status,
      };
}
